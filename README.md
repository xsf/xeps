[![Docker Build Status](https://img.shields.io/docker/build/xmppxsf/xeps.svg)](https://hub.docker.com/r/xmppxsf/xeps/)

XMPP Extension Protocols (XEPs)
=========

This repository is used to manage work on XMPP Extension Protocols
(XEPs), which are the specifications produced by the XMPP Standards
Foundation (XSF). See http://xmpp.org/ for details. The rendered
documents can be found here:

https://xmpp.org/extensions/

Please use this repository to raise issues and submit pull requests:

https://github.com/xsf/xeps/issues
https://github.com/xsf/xeps/pulls

For in-depth technical discussion, please post to the standards@xmpp.org
email list:

http://mail.jabber.org/mailman/listinfo/standards

To submit a new proposal for consideration as a XEP, please read this
page:

https://xmpp.org/about/standards-process.html#submitting-a-xep

[XEP-0001: XMPP Extension Protocols](https://xmpp.org/extensions/xep-0001.html)
defines the standards process followed by the XMPP Standards Foundation.

Building XEPs
-------------

To build a single XEP as HTML simply run:

    make xep-xxxx.html

To build PDFs, you'll need to install [TeXML](http://getfo.org/texml/) (probably
in a Python 2 virtual environment).
You can then build PDFs with:

    make xep-xxxx.pdf

To change the output directory, set the variable `OUTDIR`, eg.

    OUTDIR=/tmp/xeps make all

For more information try `make help`.

Using Docker
------------

A full set of HTML and PDFs can be generated inside a docker container, with no
dependencies on the host other than Docker itself, and served by nginx in the
container. To build the template `make docker`, to run it `make testdocker`
(serves on http://localhost:3080), and to stop/delete it afterwards `make
stopdocker`


Gardening
---------

For new PRs, anyone with permission may perform gardening tasks.
The [Go wiki] sumarizes "gardening" as:

> the background maintenance tasks done to keep the project healthy & growing &
> nice looking.

In this repo, gardening is mostly triaging issues.
An issue is considered triaged when an editor has been assigned to it.
Untriaged issues that are in need of attention can be found using the following
filter: [`is:open is:pr no:assignee`]

To triage new issues or PRs:

- Is the issue a duplicate? Close it (referencing the original issue).
- Is the issue a question and not an issue? Close it, pointing them at the
  mailing list or chat room.
- Is the PR a new ProtoXEP? Add the "[ProtoXEP]" label and ensure that the
  file is in the "inbox/" tree and does not start with "xep-" (if not, leave a
  comment asking for it to be moved).
- Is the issue a specific change to an existing XEP or a few XEPs (eg. not
  whitespace changes to many XEPs, use your judgement)? Make sure the title
  starts with "XEP-XXXX:" or "XEP-XXXX, XEP-YYYY:".
- Finally, assign an editor (pick one at random, or pick the one with the least
  issues already assigned to them; we may re-assign it later so don't feel bad).
  The list of active editors can be found here:
  https://xmpp.org/about/xsf/editor-team


Editor
======

The XMPP Extensions Editor (or, for short, XEP Editor) manages the XMPP
extensions process as defined in XMPP Extension Protocols ([XEP-0001]).
In addition, the XEP Editor functions as the XMPP Registrar as defined in XMPP
Registrar Function ([XEP-0053]).
Read those documents first, since this README focuses on mechanics instead of
philosophy or policy.


All PRs
-------

For all PRs, start by ensuring that the IP release has been signed and that CI
has run and no issues were detected before merging.


New ProtoXEPs
-------------

- Make sure the protoxep is in the `inbox/` tree and has a name that does not
  start with "xep-" (you may change this or ask the author to change it).
- Make sure the version is `0.0.1` and the status is `ProtoXEP` (you may fix
  this or ask the author to fix it).
- You may want to build the protoxep locally and ensure the HTML and PDF look
  okay.
- Create a card for the protoxep on the [Council Trello] under "Proposed
  Agendums".
- Attach the PR to the card, and comment on the PR with a link to the card,
  thanking the author for their submission and letting them know that their XEP
  will be voted on within the next two weeks.
- Merge the PR and add a link to the generated protoxep (does this happen
  automatically yet?) to the card so that council can read it.
- Wait for the XEP to appear on xmpp.org and then log into the webserver, change
  directories to `/home/xsf/xmpp-hg/extensions`, perform an `hg pull && hg
  update` (yes, that's right) and run `inxep.py name approvingbody` (eg.
  `./inxep.py pars council`).
- If the council forgets and doesn't vote on the protoxep, pester them until
  they do.
- If the council rejects the XEP, you're done (leave the XEP in the inbox and
  inform the author of the councils decision).
  Otherwise, see "Promoting a ProtoXEP".


Promoting a ProtoXEP
--------------------

- Once the council approves a ProtoXEP, move it out of the inbox and into the
  root, assigning it the next available number in the XEP series.
- Modify the `<number/>` element in the XML file to match.
- Set the version to `0.1` and the initials to `XEP Editor: xyz` (replacing
  "xyz" with your own initials).
- Remove the `<interim/>` element from the XML file if it is included.
- Set the status to `Experimental`.
- Add a reference to the XEP in `xep.ent`.
- Archive the first version of the XEP (TODO: this process is currently
  changing; add a description when the dust has settled).
- Wait for the XEP to be published then log into the webserver and run
  `announce.py` (TODO: Add an example here).


Promoting XEPs
--------------

Ensure that the following sections exist (if not, ask the author to add them
before promoting the XEP):

- Security Considerations
- IANA Considerations
- XMPP Registrar Considerations
- XML Schema (for protocol specifications)

You can also refer to `xep-template.xml` for a recommended list of sections and
whether or not they are required.
For a helpful graph of how XEP promotion works, see [XEP-0001].

[XEP-0001]: https://xmpp.org/extensions/xep-0001.html
[XEP-0053]: https://xmpp.org/extensions/xep-0053.html
[Editor Trello]: https://trello.com/b/gwcOFnCr
[Council Trello]: https://trello.com/b/ww7zWMlI
[Needs Council]: https://github.com/xsf/xeps/labels/Needs%20Council
[ProtoXEP]: https://github.com/xsf/xeps/labels/ProtoXEP
[Go wiki]: https://golang.org/wiki/Gardening
[`is:open is:pr no:assignee`]: https://github.com/xsf/xeps/pulls?utf8=%E2%9C%93&q=is%3Aopen%20is%3Apr%20no%3Aassignee%20

[modeline]: # ( vim: set fenc=utf-8 ff=unix spell spl=en textwidth=80: )
