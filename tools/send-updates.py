#!/usr/bin/env python3
import configparser
import getpass
import itertools
import email.message
import os
import smtplib
import sys
import textwrap

from datetime import datetime

import xml.etree.ElementTree as etree

from xeplib import Status, Action, load_xepinfos


DESCRIPTION = """\
Send email updates for XEP changes based on the difference between two \
xeplist files."""

EPILOG = """\
Configuration file contents:

[smtp]
host=<smtp server to send through>
port=587
user=<optional: user name to authenticate with>
password=<optional: password to authn. with>
from=<address to send from>

If user is omitted, anonymous mail sending is attempted.

If options are missing from the configuration file and the standard input and \
standard output are a terminal, the script interactively asks for the option \
values. If no terminal is connected, the script exits with an error instead."""


XEP_URL_PREFIX = "https://xmpp.org/extensions/"


MAIL_PROTO_TEMPLATE = """\
The XMPP Extensions Editor has received a proposal for a new XEP.

Title: {info[title]}
Abstract:
{info[abstract]}

URL: {url}

The {approver} will decide in the next two weeks whether to accept this \
proposal as an official XEP."""


SUBJECT_PROTO_TEMPLATE = "Proposed XMPP Extension: {info[title]}"


MAIL_NONPROTO_TEMPLATE = """\
Version {info[last_revision][version]} of XEP-{info[number]:04d} \
({info[title]}) has been released.

Abstract:
{info[abstract]}

Changelog:
{changelog}

URL: {url}"""


MAIL_DEFER_TEMPLATE = """\
XEP-{info[number]:04d} ({info[title]}) has been Deferred because of inactivity.

Abstract:
{info[abstract]}

URL: {url}

If and when a new revision of this XEP is published, its status will be \
changed back to Experimental.
"""


SUBJECT_NONPROTO_TEMPLATE = \
    "{action.value}: XEP-{info[number]:04d} ({info[title]})"


def dummy_info(number):
    return {
        "status": None,
        "accepted": False,
        "number": number,
    }


def diff_infos(old, new):
    if old["status"] != new["status"]:
        if new["status"] == Status.PROTO:
            return Action.PROTO
        elif old["status"] is None:
            return Action.NEW
        else:
            return Action.fromstatus(new["status"])

    old_version = old.get("last_revision", {}).get("version")
    new_version = new.get("last_revision", {}).get("version")

    if old_version != new_version:
        return Action.UPDATE

    return None


def wraptext(text):
    return "\n".join(
        itertools.chain(
            *[textwrap.wrap(line) if line else [line] for line in text.split("\n")]
        )
    )


def make_proto_mail(info):
    kwargs = {
        "info": info,
        "approver": info["approver"],
        "url": "{}inbox/{}.html".format(
            XEP_URL_PREFIX,
            info["protoname"],
        ),
    }

    mail = email.message.EmailMessage()
    mail["Subject"] = SUBJECT_PROTO_TEMPLATE.format(**kwargs)
    mail["XSF-XEP-Action"] = "PROTO"
    mail["XSF-XEP-Title"] = info["title"]
    mail["XSF-XEP-Type"] = info["type"]
    mail["XSF-XEP-Status"] = info["status"].value
    mail["XSF-XEP-Url"] = kwargs["url"]
    mail["XSF-XEP-Approver"] = kwargs["approver"]
    mail.set_content(
        wraptext(MAIL_PROTO_TEMPLATE.format(**kwargs)),
        "plain",
        "utf-8",
    )

    return mail


def make_nonproto_mail(action, info):
    last_revision = info.get("last_revision")
    changelog = "(see in-document revision history)"
    if last_revision is not None:
        remark = last_revision.get("remark")
        initials = last_revision.get("initials")
        if remark and initials:
            changelog = "{} ({})".format(remark, initials)

    kwargs = {
        "info": info,
        "changelog": changelog,
        "action": action,
        "url": "{}xep-{:04d}.html".format(
            XEP_URL_PREFIX,
            info["number"],
        ),
    }

    body_template = MAIL_NONPROTO_TEMPLATE
    if action == Action.DEFER:
        body_template = MAIL_DEFER_TEMPLATE

    mail = email.message.EmailMessage()
    mail["Subject"] = SUBJECT_NONPROTO_TEMPLATE.format(**kwargs)
    mail["XSF-XEP-Action"] = action.value
    mail["XSF-XEP-Title"] = info["title"]
    mail["XSF-XEP-Type"] = info["type"]
    mail["XSF-XEP-Status"] = info["status"].value
    mail["XSF-XEP-Number"] = "{:04d}".format(info["number"])
    mail["XSF-XEP-Url"] = kwargs["url"]
    mail.set_content(
        wraptext(body_template.format(**kwargs)),
        "plain",
        "utf-8",
    )

    return mail


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


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description=wraptext(DESCRIPTION),
        epilog=wraptext(EPILOG),
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    parser.add_argument(
        "-c", "--config",
        metavar="FILE",
        type=argparse.FileType("r"),
        help="Configuration file",
    )
    parser.add_argument(
        "-y",
        dest="ask_confirmation",
        default=True,
        action="store_false",
        help="'I trust this script to do the right thing and send emails"
        "without asking for confirmation.'"
    )
    parser.add_argument(
        "--no-proto",
        dest="process_proto",
        default=True,
        action="store_false",
        help="Disable processing of ProtoXEPs.",
    )
    parser.add_argument(
        "-n", "--dry-run",
        dest="dry_run",
        action="store_true",
        default=False,
        help="Instead of sending emails, print them to stdout (implies -y)",
    )

    parser.add_argument(
        "old",
        type=argparse.FileType("rb"),
        help="Old xep-infos XML file",
    )
    parser.add_argument(
        "new",
        type=argparse.FileType("rb"),
        help="New xep-infos XML file",
    )

    parser.add_argument(
        "to",
        nargs="+",
        help="The mail addresses to send the update mails to."
    )

    args = parser.parse_args()

    can_be_interactive = (
        os.isatty(sys.stdin.fileno()) and
        os.isatty(sys.stdout.fileno())
    )

    if args.dry_run:
        args.ask_confirmation = False

    if args.ask_confirmation and not can_be_interactive:
        print("Cannot ask for confirmation (stdio is not a TTY), but -y is",
              "not given either. Aborting.", sep="\n", file=sys.stderr)
        sys.exit(2)

    config = configparser.ConfigParser()
    if args.config is not None:
        config.read_file(args.config)

    with args.old as f:
        tree = etree.parse(f)
    old_accepted, old_proto = load_xepinfos(tree)

    with args.new as f:
        tree = etree.parse(f)
    new_accepted, new_proto = load_xepinfos(tree)

    old_xeps = set(old_accepted.keys())
    new_xeps = set(new_accepted.keys())

    common_xeps = old_xeps & new_xeps
    added_xeps = new_xeps - old_xeps

    added_protos = set(new_proto.keys()) - set(old_proto.keys())

    updates = []

    for common_xep in common_xeps:
        old_info = old_accepted[common_xep]
        new_info = new_accepted[common_xep]

        action = diff_infos(old_info, new_info)
        if action is not None:
            updates.append((common_xep, action, new_info))

    for added_xep in added_xeps:
        old_info = dummy_info(added_xep)
        new_info = new_accepted[common_xep]

        action = diff_infos(old_info, new_info)
        if action is not None:
            updates.append((added_xep, action, new_info))

    if args.process_proto:
        for added_proto in added_protos:
            old_info = dummy_info('xxxx')
            new_info = new_proto[added_proto]

            action = diff_infos(old_info, new_info)
            if action is not None:
                updates.append((added_proto, action, new_info))

    if args.dry_run:
        smtpconn = make_fake_smtpconn()
    else:
        if can_be_interactive:
            interactively_extend_smtp_config(config)

        try:
            smtpconn = make_smtpconn(config)
        except (configparser.NoSectionError,
                configparser.NoOptionError) as exc:
            print("Missing configuration: {}".format(exc),
                  file=sys.stderr)
            print("(cannot ask for configuration on stdio because it is "
                  "not a TTY)", file=sys.stderr)
            sys.exit(3)

    try:
        for id_, action, info in updates:
            if action == Action.PROTO:
                mail = make_proto_mail(info)
            else:
                mail = make_nonproto_mail(action, info)
            mail["Date"] = datetime.utcnow()
            mail["From"] = config.get("smtp", "from")
            mail["To"] = args.to

            if args.ask_confirmation:
                print()
                print("---8<---")
                print(mail.as_string())
                print("--->8---")
                print()
                choice = choose(
                    "Send this email? [y]es, [n]o, [a]bort: ",
                    "yna",
                    eof="a",
                )

                if choice == "n":
                    continue
                elif choice == "a":
                    print("Exiting on user request.", file=sys.stderr)
                    sys.exit(4)

            smtpconn.send_message(mail)
    finally:
        smtpconn.close()


if __name__ == "__main__":
    main()
