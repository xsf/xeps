# Triaging a PR

## Dramatis Personae

- Author: Generally the author of the PR or MR.
- XEP Author: The Author of the XEP.
- Approving Body: Either the XMPP Council or the XSF Board. Which of those two
  can be determined by looking at the `<approver/>` tag of the respective XEP.
- Processing Editor: The Editor which ultimately merges a PR to master.

## Labels

### Approval categories

- [Needs Council]: The changes need approval by the XMPP Council.
- [Needs Board]: The changes need approval by the XSF Board.
- [Needs Author]: The changes need approval by the XEP Author.
- [Needs List Discussion]: The changes need more discussion on the standards@
  (or, in rare cases, members@) mailing lists; in general, there should be a
  link to a mailing list thread in those PRs.
- [Editorial Change]: The changes do not need approval by anyone except the
  Editor.

### Process categories

- [ProtoXEP]: The PR adds a new XEP to the inbox.
- [Ready to Merge]: The PR can be worked on by a Processing Editor. Note that
  this does **not** imply that no further changes are needed.
- [Needs Version Block]: A version block needs to be added or modified before
  the changes can enter master.
- [Needs Editor Action]: The Processing Editor needs to do something while
  merging the PR, aside of or in addition to modifying a version block.
- [invalid]: The changes cannot be processed as-is at all; the PR is closed
  without merge and without being handed to an approver.

## Process

### A General Note

Some of the cases where the below process suggests to ask the Author to do
something can also be handled by the Processing Editor. If it is realistic
that the workload for the Editors would be reduced by handling the task
themselves, use the [Needs Editor Action] label an an explanatory comment
instead.

### "Flowchart"

If the PR is not touching a XEP, this guide does not apply.

1. Is the PR a ProtoXEP?

    1. Does the PR touch existing XEPs? Close as [invalid] and ask the Author
        to split the two things.

    2. Validate that the `<type/>` makes sense for the content (consult
       [XEP-0001] if necessary). If it does not make sense, either add a
       comment to let the Processing Editor know (adding the
       [Needs Editor Action] label) or ask the Author to correct the problem.
    3. Add the [ProtoXEP] and [Ready to Merge] labels.
    4. Make sure the title of the PR is `XEP-XXXX: Title of the new XEP`.
    5. Stop.

2. Sanity checks

    1. Ensure that all XEPs are mentioned in the title as `XEP-XXXX`. E.g. `XEP-0084, XEP-0123: something`.
    2. Continue.

3. Are the changes *for all XEPs* purely editorial?

    Editorial changes are changes which do not touch normative language and
    which do not change the meaning of the text. When in doubt, treat as
    non-Editorial.

    1. Add the [Editorial Change] and [Ready to Merge] labels.
    2. If the PR does not add a revision block, add the [Needs Version Block]
       label.
    3. If the PR adds a revision block and does not only bump the patch-level
       (third) version number part, add the [Needs Version Block] label and a
       comment explaining the situation.
    4. Stop.

4. Does the PR touch more than one XEP?

    In general, we want to avoid PRs which touch multiple XEPs or which do
    multiple non-Editorial changes at once. This is because the approving body
    may disagree with part of the PR, which causes extra work.

    Suggest the author to split the PR for that reason, unless it seems
    realistic or obvious that the changes need to be done together to make
    sense (an example is updating multiple XEPs which belong together, such
    as the MIX family).

4. Is the XEP **not** in Experimental or Deferred state?

    Changes to Non—Experimental or non-Deferred XEPs need approval by the
    approving body as defined in the XEP file itself.

    1. Add the [Needs Council]/[Needs Board] label. To know which, check the
       `<approver/>` of the XEPs. If the touched XEPs have different approvers
       go back to the previous step and closely examine if the PR should not
       be split; it is very likely that it should be split in this situation.
       If so, tag as [invalid] and inform the author, asking them to do a
       split.
    2. **For Council:** Send an email to the council chair and/or announce the
       PR in [The Council Room].
       **For Board:** Send an email to info@xmpp.org and/or talk directly to
       Board members.
    3. If the PR does not add a revision block, add the [Needs Version Block]
       label.
    4. If the PR adds a revision block and does not bump the minor-level
       (second) version number part, add the [Needs Version Block] label and a
       comment explaining the situation for the next Editor (the Author does
       not need to do anything here).
    6. Stop.

5. Is the XEP in Experimental or Deferred state and the PR opener is not an
   author of the XEP?

    Changes to Experimental XEPs are approved by the XEP Authors themselves.
    If the PR touches multiple XEPs and the XEP Authors do not overlap, ask
    the Author to split the PR.

    1. If the PR does not a revision block, add the [Needs Version Block]
       label.
    2. If the PR adds a revision block and does not bump the minor-level
       (second) version number part, add the [Needs Version Block] label and a
       comment explaining the situation for the Processing Editor.
    3. If the XEP is in Deferred state and the changes are not purely editorial,
       add a note to move the XEP to Experimental state and mark the PR as
       [Needs Editor Action].
    4. If the issue has not been discussed on the standards list *or* if
       the XEP Author has not been involved in the discussion *or* the
       XEP Author has not explicitly ACKed the PR:

        1. Make sure the standards@ discussion (if it exists) is linked in the
           PR.
        2. Add the [Needs Author] label.
        3. Try to make the XEP Author aware of the change. If you do not know
           a GitHub handle of the XEP Author, use the contact info available
           for each author in either the XEP or in xep.ent.
        4. Stop.

    5. Otherwise, mark the PR as [Ready to Merge], linking the XEP Author’s
       approval for documentation purposes.

6. Mark the PR as [Ready to Merge].

[ProtoXEP]: https://github.com/xsf/xeps/labels/ProtoXEP
[Ready to Merge]: https://github.com/xsf/xeps/labels/Ready%20to%20Merge
[Needs Author]: https://github.com/xsf/xeps/labels/Needs%20Author
[Needs List Discussion]: https://github.com/xsf/xeps/labels/Needs%20List%20Discussion
[Needs Version Block]: https://github.com/xsf/xeps/labels/Needs%20Version%20Block
[Needs Editor Action]: https://github.com/xsf/xeps/labels/Needs%20Editor%20Action
[Editorial Change]: https://github.com/xsf/xeps/labels/Editorial%20Change
[Needs Council]: https://github.com/xsf/xeps/labels/Needs%20Council
[Needs Board]: https://github.com/xsf/xeps/labels/Needs%20Board
[invalid]: https://github.com/xsf/xeps/labels/invalid
