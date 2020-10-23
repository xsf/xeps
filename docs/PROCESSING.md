# Processing a PR

## General notes on making changes

This section has some hints on the python scripts which help you doing the
more tedious tasks of sending emails and properly archiving XEPs.

### Before you start working on merging a Pull Request

* Ideally, you have the [xep-attic] repository cloned next to the xeps
    repository.

* Before starting to prepare a merge and push, ensure that you have the XEP
    metadata up-to-date locally:

        $ make build/xeplist.xml

* Make a copy of the metadata:

        $ cp build/xeplist.xml tools/old-xeplist.xml

    (avoid putting random XML files in the xeps root directory, the build
    tooling might mistake them as XEPs; so we put it somewhere else.)

### While you’re working on a Pull Request

* Use the local docker build to ensure that everything is syntactically
    correct. The process is described above in "Using Docker".

### After merging the Pull Request

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
        information and ask [jonas’]/[@horazont] if things are still unclear.

    If the tool misbehaves, pester [jonas’]/[@horazont] about it.

* Don’t forget to archive the new versions of the XEPs. If you have the
    [xep-attic] cloned next to the xeps repository, you can simply run:

        $ ./tools/archive.py tools/old-xeplist.xml build/xeplist.xml

    Otherwise, you will have to explicitly give the path to the attic:

        $ ./tools/archive.py --attic /path/to/xep-attic/content/ tools/old-xeplist.xml build/xeplist.xml

    (note that the path must point to the ``content`` subdirectory of the
    [xep-attic].)

    Don’t forget to commit & push the changes to [xep-attic].


## New ProtoXEPs

- Make sure the protoxep is in the `inbox/` tree and has a name that does not
  start with "xep-" (you may change this or ask the author to change it).
- Make sure the version is `0.0.1` and the status is `ProtoXEP` (you may fix
  this or ask the author to fix it).
- You may want to build the protoxep locally and ensure the HTML and PDF look
  okay.
- Merge the PR as described in "Merging a PR". Once the email has been sent,
    continue here.
- Create a card for the protoxep on the [Council Trello] under "Proposed
  Agendums".
- Attach the PR to the card and link the generated HTML.
- Comment on the PR with a link to the card, thanking the author for their
    submission and letting them know that their XEP will be voted on within the
    next two weeks.
- If the council forgets and doesn't vote on the protoxep, pester them until
  they do.
- If the council rejects the XEP, you're done (leave the XEP in the inbox and
    inform the author of the councils decision). Otherwise, see
    "Promoting a ProtoXEP".


## Promoting a ProtoXEP to Experimental

- It is easiest to start a new branch, in case you screw something up on the way.
- Once the council approves a ProtoXEP, *copy* it out of the inbox and into the
  root, assigning it the next available number in the XEP series.
- Modify the `<number/>` element in the XML file to match.
- Set the version to `0.1` and the initials to `XEP Editor: xyz` (replacing "xyz" with your own initials).
- Remove the `<interim/>` element from the XML file if it is included.
- Set the status to `Experimental`.
- Add a reference to the XEP in `xep.ent`.
- Make a commit.
- Treat your branch as you would treat a [Ready to Merge] PR in "Merging a PR".
    (you don’t need to create another branch though.)


## Promoting XEPs beyond Experimental

Ensure that the following sections exist (if not, ask the author to add them
before promoting the XEP):

- Security Considerations
- IANA Considerations
- XMPP Registrar Considerations
- XML Schema (for protocol specifications)

You can also refer to `xep-template.xml` for a recommended list of sections and
whether or not they are required.
For a helpful graph of how XEP promotion works, see [XEP-0001].


## Deferring XEPs

Before Deferring XEPs, read the "General notes on making changes" section.

XEPs get deferred after 12 months of inactivity. There is a tool which handles
that process automatically, if it is invoked regularly.

First of all, you need an up-to-date ``xeplist.xml``:

    make build/xeplist.xml

To get a list of XEPs which need to be deferred (without changing anything),
run:

    ./tools/deferrals.py -v

To apply the deferrals, make a new feature branch and execute:

    ./tools/deferrals.py -m 'initials'

where you replace ``initials`` with your editor initials so that it is obvious
who made the change (those initials will be used in the revision block).

This will modify the XEPs in-place. It uses heuristics for incrementing the
version number, finding and inserting the revision block as well as changing
the status. Yes, it involves regular expressions (because we don’t want to
fully re-write the XML to keep the diffs minimal). It is thus vital that you
**use `git diff` to ensure that the changes are sane**. If the changes
are sane, make a commit and merge to master as described in "Merging a PR",
in accordance with the "General notes on making changes".


## Merging a PR

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
[Ready to Merge]: https://github.com/xsf/xeps/labels/Ready%20to%20Merge
[Council Trello]: https://trello.com/b/ww7zWMlI
[xep-attic]: https://github.com/xsf/xep-attic
[Docker Build]: https://hub.docker.com/r/xmppxsf/xeps/builds/
[@horazont]: https://github.com/horazont/
[jonas’]: https://wiki.xmpp.org/web/User:Jwi
