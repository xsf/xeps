#!/usr/bin/env python3
import pathlib
import xml.dom.minidom

import xml.etree.ElementTree as etree

from xeplib import (
    minidom_find_child,
    minidom_find_header,
    minidom_get_text,
    minidom_children,
)


DESCRIPTION = """\
Extract a list of XEPs with metadata from the xeps repository."""

EPILOG = """"""


def open_xml(f):
    return xml.dom.minidom.parse(f)


def extract_xep_metadata(document):
    header = minidom_find_header(document)

    latest_revision = minidom_find_child(header, "revision")
    if latest_revision is not None:
        last_revision_version = minidom_get_text(
            minidom_find_child(latest_revision, "version")
        )
        last_revision_date = minidom_get_text(
            minidom_find_child(latest_revision, "date")
        )
        remark_el = minidom_find_child(latest_revision, "remark")
        last_revision_remark = None
        if remark_el is not None:
            remark_children = minidom_children(remark_el)
            if len(remark_children) == 1 and remark_children[0].tagName == "p":
                last_revision_remark = minidom_get_text(remark_children[0])

        if last_revision_remark is not None:
            initials_el = minidom_find_child(latest_revision, "initials")
            last_revision_initials = initials_el and minidom_get_text(
                initials_el
            )
        else:
            last_revision_initials = None
    else:
        last_revision_version = None
        last_revision_date = None
        last_revision_remark = None
        last_revision_initials = None

    status = minidom_get_text(minidom_find_child(header, "status"))
    type_ = minidom_get_text(minidom_find_child(header, "type"))
    abstract = " ".join(minidom_get_text(
        minidom_find_child(header, "abstract")
    ).split())
    sig_el = minidom_find_child(header, "sig")
    if sig_el is None:
        sig = None
    else:
        sig = minidom_get_text(sig_el)
    shortname = minidom_get_text(minidom_find_child(header, "shortname"))
    if shortname.replace("-", " ").replace("_", " ").lower() in [
            "not yet assigned", "n/a", "none", "to be assigned",
            "to be issued"]:
        shortname = None
    title = minidom_get_text(minidom_find_child(header, "title"))

    approver_el = minidom_find_child(header, "approver")
    if approver_el is not None:
        approver = minidom_get_text(approver_el)
    else:
        approver = "Board" if type_ == "Procedural" else "Council"

    return {
        "last_revision": {
            "version": last_revision_version,
            "date": last_revision_date,
            "initials": last_revision_initials,
            "remark": last_revision_remark,
        },
        "status": status,
        "type": type_,
        "sig": sig,
        "abstract": abstract,
        "shortname": shortname,
        "title": title,
        "approver": approver,
    }


def text_element(tag, text):
    el = etree.Element(tag)
    el.text = text
    return el


def make_metadata_element(number, metadata, accepted, *, protoname=None):
    result = etree.Element("xep")
    result.append(text_element("number", number))
    result.append(text_element("title", metadata["title"]))
    result.append(text_element("abstract", metadata["abstract"]))
    result.append(text_element("type", metadata["type"]))
    result.append(text_element("status", metadata["status"]))
    result.append(text_element("approver", metadata["approver"]))

    if metadata["shortname"] is not None:
        result.append(text_element("shortname", metadata["shortname"]))

    if metadata["last_revision"]["version"] is not None:
        last_revision = metadata["last_revision"]
        revision_el = etree.Element("last-revision")
        revision_el.append(text_element("date", last_revision["date"]))
        revision_el.append(text_element("version", last_revision["version"]))
        if last_revision["initials"]:
            revision_el.append(text_element("initials",
                                            last_revision["initials"]))
        if last_revision["remark"]:
            revision_el.append(text_element("remark",
                                            last_revision["remark"]))
        result.append(revision_el)

    if metadata["sig"] is not None:
        result.append(
            text_element("sig", metadata["sig"])
        )

    if accepted:
        result.set("accepted", "true")
    else:
        result.set("accepted", "false")

    if protoname is not None:
        result.append(text_element("proto-name", protoname))

    return result


def main():
    import argparse
    import sys

    parser = argparse.ArgumentParser(
        description=DESCRIPTION,
        epilog=EPILOG,
    )
    parser.add_argument(
        "xepdir",
        nargs="?",
        type=pathlib.Path,
        default=pathlib.Path.cwd(),
        help="Directory where the XEP XMLs are. Defaults to current directory."
    )

    args = parser.parse_args()

    tree = etree.Element("xep-infos")

    for xepfile in args.xepdir.glob("xep-*.xml"):
        number = xepfile.name.split("-", 1)[1].split(".", 1)[0]
        try:
            number = str(int(number))
        except ValueError:
            continue

        with xepfile.open("rb") as f:
            parsed = open_xml(f)

        tree.append(make_metadata_element(
            number,
            extract_xep_metadata(parsed),
            True,
        ))

    for xepfile in (args.xepdir / "inbox").glob("*.xml"):
        protoname = xepfile.name.rsplit(".", 1)[0]

        with xepfile.open("rb") as f:
            parsed = open_xml(f)

        tree.append(make_metadata_element(
            "xxxx",
            extract_xep_metadata(parsed),
            False,
            protoname=protoname
        ))

    sys.stdout.buffer.raw.write(etree.tostring(tree))


if __name__ == "__main__":
    main()
