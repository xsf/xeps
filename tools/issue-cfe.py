#!/usr/bin/env python3
import configparser
import email.message
import os
import sys

from datetime import datetime, timedelta

import xml.etree.ElementTree as etree

from xeplib import (
    Status, load_xepinfos, choose,
    make_fake_smtpconn,
    interactively_extend_smtp_config,
    make_smtpconn,
    wraptext,
)


XEP_URL_PREFIX = "https://xmpp.org/extensions/"

SUBJECT_TEMPLATE = "Call for Experience: XEP-{info[number]:04d}: {info[title]}"

MAIL_TEMPLATE = """\
The XEP Editor would like to Call for Experience with XEP-{info[number]:04d} \
before presenting it to the {info[approver]} for advancing it to Final status.


During the Call for Experience, please answer the following questions:

1. What software has XEP-{info[number]:04d} implemented? Please note that the \
protocol must be implemented in at least two separate codebases (at least one \
of which must be free or open-source software) in order to advance from Draft \
to Final.

2. Have developers experienced any problems with the protocol as defined in \
XEP-{info[number]:04d}? If so, please describe the problems and, if possible, \
suggested solutions.

3. Is the text of XEP-{info[number]:04d} clear and unambiguous? Are more \
examples needed? Is the conformance language (MAY/SHOULD/MUST) appropriate? \
Have developers found the text confusing at all? Please describe any \
suggestions you have for improving the text.

If you have any comments about advancing XEP-{info[number]:04d} from Draft \
to Final, please provide them by the close of business on {enddate}. After \
the Call for Experience, this XEP might undergo revisions to address feedback \
received, after which it will be presented to the XMPP Council for voting to \
a status of Final.


You can review the specification here:

{url}

Please send all feedback to the standards@xmpp.org discussion list.
"""


def make_mail(info, enddate):
    kwargs = {
        "info": info,
        "url": "{}xep-{:04d}.html".format(
            XEP_URL_PREFIX,
            info["number"],
        ),
        "enddate": enddate
    }

    mail = email.message.EmailMessage()
    mail["Subject"] = SUBJECT_TEMPLATE.format(**kwargs)
    mail["XSF-XEP-Action"] = "CFE"
    mail["XSF-XEP-Title"] = info["title"]
    mail["XSF-XEP-Type"] = info["type"]
    mail["XSF-XEP-Status"] = info["status"].value
    mail["XSF-XEP-Url"] = kwargs["url"]
    mail["XSF-XEP-Approver"] = info["approver"]
    mail.set_content(
        wraptext(MAIL_TEMPLATE.format(**kwargs)),
        "plain",
        "utf-8",
    )

    return mail


def main():
    import argparse

    parser = argparse.ArgumentParser()

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
        "-n", "--dry-run",
        dest="dry_run",
        action="store_true",
        default=False,
        help="Instead of sending emails, print them to stdout (implies -y)",
    )

    parser.add_argument(
        "--duration", "-d",
        metavar="DAYS",
        default=14,
        help="Duration of the CFE in days (default and at least: 14)",
        type=int,
    )

    parser.add_argument(
        "--xeplist",
        default=None,
        type=argparse.FileType("r")
    )

    parser.add_argument(
        "-x", "--xep",
        type=int,
        dest="xeps",
        action="append",
        default=[],
        help="XEP(s) to issue a CFE for"
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

    if not args.xeps:
        print("nothing to do (use -x/--xep)", file=sys.stderr)
        sys.exit(1)

    if args.duration < 14:
        print("duration must be at least 14", file=sys.stderr)
        sys.exit(1)

    enddate = (datetime.utcnow() + timedelta(days=args.duration)).date()

    if args.dry_run:
        args.ask_confirmation = False

    if args.ask_confirmation and not can_be_interactive:
        print("Cannot ask for confirmation (stdio is not a TTY), but -y is",
              "not given either. Aborting.", sep="\n", file=sys.stderr)
        sys.exit(2)

    config = configparser.ConfigParser()
    if args.config is not None:
        config.read_file(args.config)

    if args.xeplist is None:
        args.xeplist = open("build/xeplist.xml", "rb")

    with args.xeplist as f:
        tree = etree.parse(f)
    accepted, _ = load_xepinfos(tree)

    matched_xeps = []
    has_error = False
    for num in args.xeps:
        try:
            info = accepted[num]
        except KeyError:
            print("no such xep: {}".format(num), file=sys.stderr)
            has_error = True
            continue

        if info["status"] != Status.DRAFT:
            print("XEP-{:04d} is in {}, but must be Draft".format(
                num,
                info["status"].value,
            ))
            has_error = True
            continue

        matched_xeps.append(info)

    if has_error:
        sys.exit(1)

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
        for info in matched_xeps:
            mail = make_mail(info, enddate)
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
