#!/usr/bin/env python3
import pathlib
import re
import shutil
import subprocess
import sys

import xml.etree.ElementTree as etree

from datetime import datetime, timedelta

from xeplib import load_xepinfos, Status, choose


DEFAULT_XEPLIST_PATH = "./build/xeplist.xml"
XEP_FILENAME_RE = re.compile(r"xep-(\d+)\.xml")


def get_deferred(accepted):
    now = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
    threshold = now.replace(year=now.year - 1)

    for number, info in sorted(accepted.items()):
        if info["status"] == Status.EXPERIMENTAL and "last_revision" in info:
            last_update = info["last_revision"]["date"]
            if last_update <= threshold:
                yield info


BLANK_NUMBER = re.compile("<number>[xX]{4}</number>")
PROTOXEP_STATUS = "<status>ProtoXEP</status>"
EXPERIMENTAL_STATUS = "<status>Experimental</status>"
REVISION_RE = re.compile(r"\s+<revision>")
REVISION_TEMPLATE = """
  <revision>
    <version>{version}</version>
    <date>{now:%Y-%m-%d}</date>
    <initials>XEP Editor ({initials})</initials>
    <remark>Accepted by vote of {approving_body} on {date}.</remark>
  </revision>"""


def accept_xep(number, last_version,
               initials,
               approving_body,
               votedate):
    filename = "xep-{:04d}.xml".format(number)
    with open(filename, "r") as f:
        xep_text = f.read()

    if PROTOXEP_STATUS not in xep_text:
        raise ValueError("cannot find experimental status in XEP text")

    # this is so incredibly evil ...
    xep_text = xep_text.replace(PROTOXEP_STATUS, EXPERIMENTAL_STATUS, 1)
    xep_text, n = BLANK_NUMBER.subn("<number>{:04d}</number>".format(number),
                                    xep_text,
                                    1)
    if n == 0:
        raise ValueError("cannot find number placeholder in XEP text")
    revision_match = REVISION_RE.search(xep_text)

    version = last_version.split(".")
    if len(version) == 1:
        version.append("1")
    else:
        version[1] = str(int(version[1]) + 1)
        del version[2:]
    version.append("0")

    xep_text = (
        xep_text[:revision_match.start()] +
        REVISION_TEMPLATE.format(
            now=datetime.utcnow(),
            version=".".join(version),
            initials=initials,
            date=votedate,
            approving_body=approving_body,
        ) + xep_text[revision_match.start():]
    )

    with open(filename, "w") as f:
        f.write(xep_text)
        f.flush()


def isodate(s):
    return datetime.strptime(s, "%Y-%m-%d")


def get_next_xep_number(accepted):
    return max(accepted.keys()) + 1


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Accept an inbox XEP."
    )

    parser.add_argument(
        "-l", "--xeplist",
        type=argparse.FileType("rb"),
        default=None,
        help="XEP list to use (defaults to {})".format(DEFAULT_XEPLIST_PATH)
    )

    parser.add_argument(
        "-y", "--yes",
        dest="ask",
        action="store_false",
        help="Assume default answer to all questions.",
        default=True,
    )

    parser.add_argument(
        "-f", "--force",
        dest="force",
        action="store_true",
        default=False,
        help="Force acceptance even if suspicious.",
    )

    parser.add_argument(
        "-c", "--commit",
        default=False,
        action="store_true",
        help="Make a git commit",
    )

    parser.add_argument(
        "item",
        help="Inbox name"
    )

    parser.add_argument(
        "votedate",
        type=isodate,
        help="The date of the vote, in ISO format (%Y-%m-%d)."
    )

    parser.add_argument(
        "initials",
        help="Your editor initials"
    )

    args = parser.parse_args()

    if args.item.endswith(".xml"):
        # strip the path
        p = pathlib.Path(args.item)
        args.item = p.parts[-1].rsplit(".")[0]

    if args.xeplist is None:
        args.xeplist = open(DEFAULT_XEPLIST_PATH, "rb")

    if args.xeplist is not None:
        with args.xeplist as f:
            tree = etree.parse(f)
        accepted, inbox = load_xepinfos(tree)

    try:
        xepinfo = inbox[args.item]
    except KeyError:
        print("no such inbox xep: {!r}".format(args.item), file=sys.stderr)
        print("maybe run make build/xeplist.xml first?", file=sys.stderr)
        sys.exit(1)

    new_number = get_next_xep_number(accepted)

    new_filename = pathlib.Path(".") / "xep-{:04d}.xml".format(new_number)
    inbox_path = pathlib.Path("inbox") / "{}.xml".format(args.item)
    if new_filename.exists():
        raise FileExistsError(
            "Internal error: XEP file does already exist! ({})".format(
                new_filename
            )
        )
    if not inbox_path.exists():
        print("inbox file does not exist or is not readable: {}".format(
            inbox_path
        ))

    if args.ask:
        print("I am going to accept:")
        print()
        print("  Title: {!r}".format(xepinfo["title"]))
        print("  Abstract: {!r}".format(xepinfo["abstract"]))
        print("  Last Revision: {} ({})".format(
            xepinfo["last_revision"]["date"].date(),
            xepinfo["last_revision"]["version"],
        ))
        print()
        print("as new XEP-{:04d}.".format(new_number))
        print()
        choice = choose("Is this correct? [y]es, [n]o: ", "yn", eof="n")
        if choice != "y":
            print("aborted at user request")
            sys.exit(2)

    shutil.copy(str(inbox_path), str(new_filename))

    accept_xep(new_number,
               xepinfo["last_revision"]["version"],
               args.initials,
               xepinfo["approver"],
               args.votedate.date())

    if args.commit:
        subprocess.check_call([
            "git", "reset", "HEAD", ".",
        ])
        subprocess.check_call([
            "git", "add", new_filename.parts[-1],
        ])
        if args.ask:
            flags = ["-ve"]
        else:
            flags = []
        subprocess.check_call(
            [
                "git", "commit", "-m", "Accept {} as XEP-{:04}".format(
                    inbox_path,
                    new_number,
                )
            ] + flags
        )


if __name__ == "__main__":
    main()
