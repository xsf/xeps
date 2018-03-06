#!/usr/bin/env python3
import html
import xml.etree.ElementTree as etree

from xeplib import load_xepinfos


def main():
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-l", "--xeplist",
        type=argparse.FileType("r"),
        default=None,
    )
    parser.add_argument(
        "xeps",
        metavar="NUM",
        type=int,
        nargs="+",
    )

    args = parser.parse_args()

    if args.xeplist is None:
        args.xeplist = open("build/xeplist.xml", "r")

    with args.xeplist as f:
        tree = etree.parse(f)

    accepted, _ = load_xepinfos(tree)

    for num in args.xeps:
        info = accepted[num]
        print(
            """<!ENTITY xep{number:04d} "<span class='ref'>"""
            """<link url='{url}'>{title} (XEP-{number:04d})</link></span> """
            """<note>XEP-{number:04d}: {title} &lt;<link url='{url}'>"""
            """{url}</link>&gt;.</note>" >""".format(
                title=html.escape(info["title"]),
                number=num,
                url="https://xmpp.org/extensions/xep-{:04d}.html".format(
                    num,
                )
            )
        )

if __name__ == "__main__":
    main()
