#!/usr/bin/env python3
import re

import xml.etree.ElementTree as etree

from datetime import datetime, timedelta

from xeplib import load_xepinfos, Status


def get_deferred(accepted):
    now = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
    threshold = now.replace(year=now.year - 1)

    for number, info in sorted(accepted.items()):
        if info["status"] == Status.EXPERIMENTAL and "last_revision" in info:
            last_update = info["last_revision"]["date"]
            if last_update <= threshold:
                yield info


EXPERIMENTAL_STATUS = "<status>Experimental</status>"
DEFERRED_STATUS = "<status>Deferred</status>"
REVISION_RE = re.compile(r"\s+<revision>")
REVISION_TEMPLATE = """
  <revision>
    <version>{version}</version>
    <date>{now:%Y-%m-%d}</date>
    <initials>XEP Editor ({initials})</initials>
    <remark>Defer due to lack of activity.</remark>
  </revision>"""


def defer_xep(number, last_version, initials):
    filename = "xep-{:04d}.xml".format(number)
    with open(filename, "r") as f:
        xep_text = f.read()

    if EXPERIMENTAL_STATUS not in xep_text:
        raise ValueError("cannot find experimental status in XEP text")

    # this is so incredibly evil ...
    xep_text = xep_text.replace(EXPERIMENTAL_STATUS, DEFERRED_STATUS, 1)
    revision_match = REVISION_RE.search(xep_text)

    version = last_version.split(".")
    if len(version) == 1:
        version.append("1")
    else:
        version[1] = str(int(version[1]) + 1)
        del version[2:]

    xep_text = (
        xep_text[:revision_match.start()] +
        REVISION_TEMPLATE.format(
            now=datetime.utcnow(),
            version=".".join(version),
            initials=initials,
        ) + xep_text[revision_match.start():]
    )

    with open(filename, "w") as f:
        f.write(xep_text)
        f.flush()


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Show the XEPs which need to be changed to deferred."
    )

    parser.add_argument(
        "-l", "--xeplist",
        type=argparse.FileType("rb"),
        default=None,
        help="XEP list to use (defaults to ./build/xeplist.xml)"
    )

    parser.add_argument(
        "-v", "--verbose",
        help="Print additional metadata for deferred XEPs",
        action="store_true",
        default=False,
    )

    parser.add_argument(
        "-m", "--modify",
        default=False,
        metavar="INITIALS",
        help="Modify the to-be-deferred XEPs in-place and use the given "
        "INITIALS in the remarks."
    )

    args = parser.parse_args()

    if args.xeplist is None:
        args.xeplist = open("./build/xeplist.xml", "rb")

    with args.xeplist as f:
        tree = etree.parse(f)

    accepted, _ = load_xepinfos(tree)
    deferred = list(get_deferred(accepted))

    for deferred_info in deferred:
        if args.modify:
            defer_xep(deferred_info["number"],
                      deferred_info["last_revision"]["version"],
                      args.modify)

        if args.verbose:
            print(
                "XEP-{info[number]:04d}: {info[title]} "
                "(last update {info[last_revision][date]:%Y-%m-%d})".format(
                    info=deferred_info
                )
            )
        else:
            print(deferred_info["number"])


if __name__ == "__main__":
    main()
