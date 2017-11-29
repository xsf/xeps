#!/usr/bin/env python3
import pathlib
import shutil
import subprocess
import sys

import xml.etree.ElementTree as etree

from datetime import datetime, timedelta

from xeplib import load_xepinfos, Status


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Show the XEPs which need to be changed to deferred."
    )

    parser.add_argument(
        "old",
        type=argparse.FileType("rb"),
        help="Old XEP list"
    )

    parser.add_argument(
        "new",
        type=argparse.FileType("rb"),
        help="New XEP list"
    )

    parser.add_argument(
        "-d", "--xeps-dir",
        type=pathlib.Path,
        default=pathlib.Path.cwd() / "build",
        help="Path to the built XEPs (defaults to ./build)"
    )

    parser.add_argument(
        "-a", "--attic",
        type=pathlib.Path,
        default=pathlib.Path.cwd() / '../xep-attic/content/',
        help="Path to the attic (defaults to ../xep-attic/content/)"
    )

    args = parser.parse_args()

    with args.old as f:
        old_tree = etree.parse(f)

    old_accepted, _ = load_xepinfos(old_tree)

    with args.new as f:
        new_tree = etree.parse(f)

    new_accepted, _ = load_xepinfos(new_tree)

    changed = False

    for xep, new_info in new_accepted.items():
        old_version = old_accepted.get(xep, {}).get("last_revision", {}).get(
            "version"
        )
        new_version = new_info["last_revision"]["version"]

        if old_version == new_version:
            continue

        curr_file = args.xeps_dir / "xep-{:04d}.html".format(xep)
        attic_file = args.attic / "xep-{:04d}-{}.html".format(xep, new_version)

        print("XEP-{:04d}:".format(xep), old_version, "->", new_version)

        subprocess.check_call(["make", "build/xep-{:04d}.html".format(xep)])

        shutil.copy(str(curr_file), str(attic_file))
        changed = True

    if changed:
        print(
            "{}: do not forget to commit & push the attic!".format(
                sys.argv[0]
            ),
            file=sys.stderr
        )
    else:
        print("{}: nothing to do".format(sys.argv[0]),
              file=sys.stderr)


if __name__ == "__main__":
    main()
