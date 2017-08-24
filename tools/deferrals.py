#!/usr/bin/env python3
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
        "-m", "--modify",
        action="store_true",
        default=False,
        help="Modify the XEP files in-place."
    )

    args = parser.parse_args()

    if args.xeplist is None:
        args.xeplist = open("./build/xeplist.xml", "rb")

    with args.xeplist as f:
        tree = etree.parse(f)

    accepted, _ = load_xepinfos(tree)
    deferred = list(get_deferred(accepted))

    for deferred_info in deferred:
        print(deferred_info["number"])


if __name__ == "__main__":
    main()
