[![Docker Build Status](https://img.shields.io/docker/build/xmppxsf/xeps.svg)](https://hub.docker.com/r/xmppxsf/xeps/)
[![Build Status](https://img.shields.io/travis/xsf/xeps.svg)](https://travis-ci.org/xsf/xeps)

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


Gardening (Issue triaging by non-editors)
-----------------------------------------

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


Triaging a PR
-------------

If the PR is not touching a XEP, this guide does not apply. If the PR touches
multiple XEPs, go through the steps for each XEP and exit at the first which
applies.

1. Is the PR a ProtoXEP?

    1. Does the PR touch existing XEPs? Close as [invalid] and ask the Opener
        to split the two things.

    2. Add the [ProtoXEP] and [Ready to Merge] labels.
    3. Stop.

1. Are the changes *for all XEPs* purely editorial?

    1. Add the [Editorial Change] and [Ready to Merge] labels.
    2. Stop.

2. Is the XEP **not** in Experimental state?

    (Changes to Non—Experimental XEPs need approval by the approving body as
    defined in the XEP file itself.)

    1. Add the [Needs Council]/[Needs Board] label.
    2. Put the PR in the [Council Tracking] project.
    3. (Optionally, continue here with submitting the PR to Council via Trello
        and move it right to the "On the agenda" column.)
    4. Stop.

2. Is the XEP in Experimental state and the PR opener is not an author of the
   XEP?

    1. If the issue has not been discussed on the standards list *or* if
       the authors have not been involved in the discussion:

        1. Make sure the standards@ discussion (if it exists) is linked in the
           PR.
        2. Add the [Needs Author] label.
        3. Put the PR in the [Author Tracking] project in the
           "Not explicitly pinged" bin.
        4. Stop.

3. Mark the PR as [Ready to Merge].


Council Tracking
----------------

The [Council Tracking] project is used to track a PR through the Council
approval process. The following columns are used:

* On agenda: The PR has been added to the council trello and is awaiting
  handling by Council.
* Voting in progress: The PR has been discussed by council, but not everyone
    has voted yet. Aside from exceptional circumstances, a PR can only reside
    for at most two weeks in this column.

    Note that council voting is veto-based and if someone did not vote, consent
    is assumed. So a PR is rejected *iff* at least one person from council
    explicitly voted against it.

    When moving a PR into this column, make a comment on the PR which contains
    the following information:

    - The date at which the voting period started.
    - Link to the respective meeting minutes.
    - The date at which the voting period has ended or will end at latest.
    - Possibly additional notes from the minutes, for example:

        - "There will be additional discussion on standards@" (bonus points if
            you add a link once the thread starts).
        - "Two people will vote on-list after further consideration."

* Done: The PR went through voting, but has not been merged yet. The
    [Needs Council] label must be removed.

    Add a comment with the result of the votes, possibly including links to
    meeting minutes which contained the votes and on-list votes by the
    respective council members.

    If the PR was not vetoed, the [Ready to merge] label should be added.
    Otherwise, the PR should be closed.

    In any case, the PR can be removed from [Council Tracking] now.

If a card awaits triaging, add it to the [Council Trello] in the first column
*under* the "Find Minutes taker". Put the PR in the "On agenda" column (in the
[Council Tracking], not the [Council Trello]).


Author Tracking
---------------

This is less formal and more a tool for the editors to keep track of at which
stage of escalation we are when getting in contact with the Authors. The
columns should be self-explaining.

Use your gut feeling on how long you wait for an authors reaction, but giving
them at least a week on each stage seems reasonable.

When an author replies and a discussion starts, move the PR to "Discussion in
progress" and remember to check back once in a while if the discussion
resolved.


Discussions
-----------

Technical discussions SHOULD NOT happen in the xeps repository. If you see a
discussion evolve into technical (as opposed to editorial) matters, do the
following (I haven’t tried that myself yet, so feel especially free to improve
the process):

1. Lock the conversation.
2. Copy the technical discussion parts into an email to standards@. My
    preferred format for this would be something along the lines of:

        Subject: XEP-1234: [insert PR subject here, or something more appropriate]

        There was some discussion on the xeps repository an XEP-1234, which got
        technical. I moved this discussion to standards@ so that the whole
        community is aware of the issue and can participate.

        @user1 wrote:
        > quote user1 here ...

        @user2 wrote:
        > quote user2 here ...

    Remove clearly editorial discussion and mark the removal with ``[…]``.

3. Add the [Needs List Discussion] label to the PR and link the standards@
    thread you just created. Remove other labels (such as [Needs Author]).

4. Monitor the thread; when the discussion is resolved, the PR opener will
    usually prepare an update. Unlock the conversation to allow editorial
    discussion to continue, if needed. Remove the [Needs List Discussion] label
    and re-triage the PR as described above.

    **Note:** The locking is mostly used here as a tool to avoid a race
    condition, not to exclude people from participating. (It would be
    unfortunate if you had to add more comments to your already-sent email.)
    Feel free to unlock at some point during the list discussion when you’re
    sure that all participants have taken note of the move.


General notes on making changes
-------------------------------

This section has some hints on the python scripts which help you doing the
more tedious tasks of sending emails and properly archiving XEPs.

*Before* you start working on merging a Pull Request:

* Ideally, you have the [xep-attic] repository cloned next to the xeps
    repository.

* Before starting to prepare a merge and push, ensure that you have the XEP
    metadata up-to-date locally:

        $ make build/xeplist.xml

* Make a copy of the metadata:

        $ cp build/xeplist.xml tools/old-xeplist.xml

    (avoid putting random XML files in the xeps root directory, the build
    tooling might mistake them as XEPs; so we put it somewhere else.)

*While* you’re working on a Pull Request:

* Use the lokal docker build to ensure that everything is syntactically
    correct. The process is described above in "Using Docker".

When you have *merged* the Pull Request and the change went through to the
webserver (see also the [Docker Build] to track the build progress):

* Send out the emails. First ensure that the new metadata is up-to-date:

        $ make build/xeplist.xml

    Check that the emails which will be sent are correct (the ``--dry-run``
    switch prevents the tool from actually sending emails):

        $ ./tools/send-updates.py --dry-run tools/old-xeplist.xml build/xeplist.xml standards@xmpp.org

    (See also the ``--help`` output for more information.)

    Once you’ve verified that the correct emails will be sent, actually send
    them using (note the missing ``--dry-run`` flag):

        $ ./tools/send-updates.py tools/old-xeplist.xml build/xeplist.xml standards@xmpp.org

    A few tips:

    1. You can also test-send them to your own address by replacing
       ``standards@xmpp.org`` with your own address.
    2. To avoid having to enter your email account details every time, use a
        configuration file. Invoke the tool with ``--help`` for more
        information and ask [jonasw]/[@horazont] if things are still unclear.

    If the tool misbehaves, pester [jonasw]/[@horazont] about it.

* Don’t forget to archive the new versions of the XEPs. If you have the
    [xep-attic] cloned next to the xeps repository, you can simply run:

        $ ./tools/archive.py tools/old-xeplist.xml build/xeplist.xml

    Otherwise, you will have to explicitly give the path to the attic:

        $ ./tools/archive.py --attic /path/to/xep-attic/content/ tools/old-xeplist.xml build/xeplist.xml

    (note that the path must point to the ``content`` subdirectory of the
    [xep-attic].)

    Don’t forget to commit & push the changes to [xep-attic].


New ProtoXEPs
-------------

- Make sure the protoxep is in the `inbox/` tree and has a name that does not
  start with "xep-" (you may change this or ask the author to change it).
- Make sure the version is `0.0.1` and the status is `ProtoXEP` (you may fix
  this or ask the author to fix it).
- You may want to build the protoxep locally and ensure the HTML and PDF look
  okay.
- Merge the PR as described in "Merging a PR". Once the email has been sent,
    continue here.
- Create a card for the protoxep on the [Council Trello] under "Proposed
  Agendums" and add the PR to the [Council Tracking].
- Attach the PR to the card and link the generated HTML.
- Comment on the PR with a link to the card, thanking the author for their
    submission and letting them know that their XEP will be voted on within the
    next two weeks.
- If the council forgets and doesn't vote on the protoxep, pester them until
  they do.
- If the council rejects the XEP, you're done (leave the XEP in the inbox and
    inform the author of the councils decision). Otherwise, see
    "Promoting a ProtoXEP".


Promoting a ProtoXEP
--------------------

- It is easiest to start a new branch, in case you screw something up on the
    way.
- Once the council approves a ProtoXEP, *copy* it out of the inbox and into the
  root, assigning it the next available number in the XEP series.
- Modify the `<number/>` element in the XML file to match.
- Set the version to `0.1` and the initials to `XEP Editor: xyz` (replacing
  "xyz" with your own initials).
- Remove the `<interim/>` element from the XML file if it is included.
- Set the status to `Experimental`.
- Add a reference to the XEP in `xep.ent`.
- Make a commit.
- Treat your branch as you would treat a [Ready to Merge] PR in "Merging a PR".
    (you don’t need to create another branch though.)


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


Merging a PR
------------

Before Merging a PR, read the "General notes on making changes" section.

When you get to the point that the PR is [Ready to Merge], do the following:

1. Create a new branch off master called ``feature/xep-1234`` (if the PR
    touches multiple XEPs, I call it ``feature/xep-0678,xep-0789``).

2. Merge all [Ready to Merge] PRs which affect the XEP(s) into that branch.

3. Resolve conflicts.

4. If the PRs introduced multiple revision blocks, squash it down to a single
    revision block. Set "XEP Editor (initials)" as author of the revision block
    and add the initials of the original PR authors to the changelog entries.
    (If that doesn’t make sense to you, you’ll find plenty examples in the
    XEPs.)

5. Ensure that everything builds by performing a full docker build (see above).

    (Once the docker build reaches the point where the XEPs are built, you can
    switch branches and work on another PR.)

6. If the build passes, check that the generated files look sane by running the
    docker container.

7. Merge the PR into master. If you are working on independent changes to
    multiple XEPs, you can merge them all in one go.

8. If you merged multiple things into master, re-do the docker build check.

9. Push.

10. Go back to "General notes on making changes".



[XEP-0001]: https://xmpp.org/extensions/xep-0001.html
[XEP-0053]: https://xmpp.org/extensions/xep-0053.html
[Editor Trello]: https://trello.com/b/gwcOFnCr
[Council Trello]: https://trello.com/b/ww7zWMlI
[Needs Council]: https://github.com/xsf/xeps/labels/Needs%20Council
[Needs Board]: https://github.com/xsf/xeps/labels/Needs%20Board
[ProtoXEP]: https://github.com/xsf/xeps/labels/ProtoXEP
[Go wiki]: https://golang.org/wiki/Gardening
[`is:open is:pr no:assignee`]: https://github.com/xsf/xeps/pulls?utf8=%E2%9C%93&q=is%3Aopen%20is%3Apr%20no%3Aassignee%20
[Needs Author]: https://github.com/xsf/xeps/labels/Needs%20Author
[Ready to Merge]: https://github.com/xsf/xeps/labels/Ready%20to%20Merge
[Council Tracking]: https://github.com/xsf/xeps/projects/1
[Author Tracking]: https://github.com/xsf/xeps/projects/2
[Needs List Discussion]: https://github.com/xsf/xeps/labels/Needs%20List%20Discussion
[Editorial Change]: https://github.com/xsf/xeps/labels/Editorial%20Change
[xep-attic]: https://github.com/xsf/xep-attic
[Docker Build]: https://hub.docker.com/r/xmppxsf/xeps/builds/
[@horazont]: https://github.com/horazont/
[jonasw]: https://wiki.xmpp.org/web/User:Jwi

[modeline]: # ( vim: set fenc=utf-8 ff=unix spell spl=en textwidth=80: )
