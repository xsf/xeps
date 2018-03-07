import configparser
import enum
import getpass
import itertools
import smtplib
import textwrap

import xml.dom.minidom

from datetime import datetime


class Status(enum.Enum):
    PROTO = 'ProtoXEP'
    EXPERIMENTAL = 'Experimental'
    PROPOSED = 'Proposed'
    DRAFT = 'Draft'
    ACTIVE = 'Active'
    FINAL = 'Final'
    RETRACTED = 'Retracted'
    OBSOLETE = 'Obsolete'
    DEFERRED = 'Deferred'
    REJECTED = 'Rejected'
    DEPRECATED = 'Deprecated'

    @classmethod
    def fromstr(cls, s):
        if s == "Proto" or s.lower() == "protoxep":
            s = "ProtoXEP"
        return cls(s)


class Action(enum.Enum):
    PROTO = "Proposed XMPP Extension"
    NEW = "NEW"
    DRAFT = "DRAFT"
    ACTIVE = "ACTIVE"
    FINAL = "FINAL"
    RETRACT = "RETRACTED"
    OBSOLETE = "OBSOLETED"
    DEFER = "DEFERRED"
    UPDATE = "UPDATED"
    DEPRECATE = "DEPRECATED"
    LAST_CALL = "LAST CALL"
    REJECT = "REJECT"

    @classmethod
    def fromstatus(cls, status):
        return {
            Status.EXPERIMENTAL: cls.NEW,
            Status.DRAFT: cls.DRAFT,
            Status.ACTIVE: cls.ACTIVE,
            Status.FINAL: cls.FINAL,
            Status.RETRACTED: cls.RETRACT,
            Status.OBSOLETE: cls.OBSOLETE,
            Status.DEPRECATED: cls.DEPRECATE,
            Status.DEFERRED: cls.DEFER,
            Status.PROPOSED: cls.LAST_CALL,
            Status.REJECTED: cls.REJECT,
        }[status]


def load_xepinfo(el):
    accepted = el.get("accepted").lower() == "true"

    info = {
        "title": el.find("title").text,
        "abstract": el.find("abstract").text,
        "type": el.find("type").text,
        "status": Status.fromstr(el.find("status").text),
        "approver": el.find("approver").text,
        "accepted": accepted,
    }

    last_revision_el = el.find("last-revision")
    if last_revision_el is not None:
        last_revision = {
            "version": last_revision_el.find("version").text,
            "date": datetime.strptime(
                last_revision_el.find("date").text,
                "%Y-%m-%d",
            ),
            "initials": None,
            "remark": None,
        }

        initials_el = last_revision_el.find("initials")
        if initials_el is not None:
            last_revision["initials"] = initials_el.text

        remark_el = last_revision_el.find("remark")
        if remark_el is not None:
            last_revision["remark"] = remark_el.text

        info["last_revision"] = last_revision

    last_call_el = el.find("lastcall")
    if last_call_el is not None:
        info["last_call"] = last_call_el.text

    sig = el.find("sig")
    if sig is not None:
        info["sig"] = sig.text

    if accepted:
        info["number"] = int(el.find("number").text)
    else:
        info["protoname"] = el.find("proto-name").text

    return info


def load_xepinfos(tree):
    accepted, protos = {}, {}
    for info_el in tree.getroot():
        info = load_xepinfo(info_el)
        if info["accepted"]:
            accepted[info["number"]] = info
        else:
            protos[info["protoname"]] = info

    return accepted, protos


def minidom_find_child(elem, child_tag):
    for child in elem.childNodes:
        if hasattr(child, "tagName") and child.tagName == child_tag:
            return child
    return None


def minidom_find_header(document):
    header = minidom_find_child(document.documentElement, "header")
    if header is None:
        raise ValueError("cannot find <header/>")
    return header


def minidom_get_text(elem):
    return "".join(
        child.nodeValue
        for child in elem.childNodes
        if isinstance(child, (xml.dom.minidom.Text,
                              xml.dom.minidom.CDATASection))
    )


def minidom_children(elem):
    return [
        child for child in elem.childNodes
        if isinstance(child, (xml.dom.minidom.Element))
    ]


def choose(prompt, options, *,
           eof=EOFError,
           keyboard_interrupt=KeyboardInterrupt):
    while True:
        try:
            choice = input(prompt).strip()
        except EOFError:
            if eof is EOFError:
                raise
            return eof
        except KeyboardInterrupt:
            if keyboard_interrupt is KeyboardInterrupt:
                raise
            return keyboard_interrupt

        if choice not in options:
            print("invalid choice. please enter one of: {}".format(
                ", ".join(map(str, options))
            ))
            continue

        return choice


def get_or_ask(config, section, name, prompt):
    try:
        return config.get(section, name)
    except (configparser.NoSectionError,
            configparser.NoOptionError):
        return input(prompt)


def interactively_extend_smtp_config(config):
    try:
        host = config.get("smtp", "host")
    except (configparser.NoSectionError,
            configparser.NoOptionError):
        host = input("SMTP server: ").strip()
        port = int(input("SMTP port (blank for 587): ").strip() or "587")
        user = input(
            "SMTP user (leave blank for anon): "
        ).strip() or None
        if user:
            password = getpass.getpass()
        else:
            password = None
    else:
        port = config.getint("smtp", "port", fallback=587)
        user = config.get("smtp", "user", fallback=None)
        password = config.get("smtp", "password", fallback=None)

    try:
        from_ = config.get("smtp", "from")
    except (configparser.NoSectionError,
            configparser.NoOptionError):
        from_ = input("From address: ").strip()

    if not config.has_section("smtp"):
        config.add_section("smtp")
    config.set("smtp", "host", host)
    config.set("smtp", "port", str(port))
    if user:
        config.set("smtp", "user", user)
        if password is None:
            password = getpass.getpass()
        config.set("smtp", "password", password)
    config.set("smtp", "from", from_)


def make_smtpconn(config):
    host = config.get("smtp", "host")
    port = config.getint("smtp", "port")
    user = config.get("smtp", "user", fallback=None)
    password = config.get("smtp", "password", fallback=None)

    conn = smtplib.SMTP(host, port)
    conn.starttls()
    if user is not None:
        conn.login(user, password)

    return conn


def make_fake_smtpconn():
    class Fake:
        def send_message(self, mail):
            print("---8<---")
            print(mail.as_string())
            print("--->8---")

        def close(self):
            pass

    return Fake()


def wraptext(text):
    return "\n".join(
        itertools.chain(
            *[textwrap.wrap(line) if line else [line] for line in text.split("\n")]
        )
    )
