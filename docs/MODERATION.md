# Moderation

## Discussions

Technical discussions SHOULD NOT happen in the xeps repository. If you see a
discussion evolve into technical (as opposed to editorial) matters, do the
following:

1. Lock the conversation.
2. Copy the technical discussion parts into an email to standards@. My
    preferred format for this would be something along the lines of:

        Subject: [insert PR title here, or something more appropriate]

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
