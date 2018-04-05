#!/usr/bin/python3
import csv
import sys

import xml.etree.ElementTree as etree

from xeplib import load_xepinfos


def main():
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-l", "--xeplist",
        type=argparse.FileType("rb"),
        default=None,
        help="XEP list to use (defaults to ./build/xeplist.xml)"
    )

    parser.add_argument(
        "-d", "--dialect",
        default="unix",
    )

    parser.add_argument(
        "outfile",
    )

    args = parser.parse_args()

    if args.xeplist is None:
        args.xeplist = open("./build/xeplist.xml", "rb")

    with args.xeplist as f:
        tree = etree.parse(f)

    accepted, _ = load_xepinfos(tree)

    with open(args.outfile, "w") as f:
        writer = csv.writer(f, args.dialect)
        for number, info in sorted(accepted.items()):
            writer.writerow([
                number,
                info["title"],
                info["status"].value,
                info["last_revision"]["date"].date(),
                info["last_revision"]["version"],
            ])


if __name__ == "__main__":
    main()
