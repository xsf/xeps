#!/bin/bash
set -euo pipefail
state_dir=state
old_xeplist="$state_dir/old-xeplist.xml"
new_xeplist="build/xeplist.xml"
mkdir -p "$state_dir"

function update_state() {
    cp "$new_xeplist" "$old_xeplist"
}

if [ ! -f "$old_xeplist" ]; then
    printf '%q does not exist; assuming this is the first run!' "$old_xeplist" >&2
    update_state
    exit 0
fi

chmod 0600 "$ATTIC_ID_RSA"
export GIT_SSH_COMMAND="ssh -i \"\$ATTIC_ID_RSA\" -o StrictHostKeyChecking=no"
git clone git@gitlab.com:xsf/xep-attic
python3 tools/archive.py -a xep-attic/content/ --no-build "$old_xeplist" "$new_xeplist"
pushd xep-attic
git add content
git update-index --refresh
if ! git diff-index --quiet HEAD --; then
    git config user.name "$GIT_AUTHOR_NAME"
    git config user.email "$GIT_AUTHOR_EMAIL"
    git commit \
        -m "Automated XEP build ${CI_JOB_ID}" \
        -m "Job-URL: ${CI_JOB_URL}"
    git push
fi
popd
update_state
