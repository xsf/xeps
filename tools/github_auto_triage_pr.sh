#!/bin/bash

# this should enforce as much of docs/TRIAGING.md as possible, run in top directory of xeps repo

# usage: triage.sh $pr_number
# the last two will be HEAD and `git merge-base $pr_commit master` by default if not sent in

# for testing you can:
# git fetch origin +refs/pull/1254/merge
# git checkout FETCH_HEAD
# and only send in pr_title

# test cases:
# multiple xeps changed: git checkout 58cec1b6fb30ccc3b44c9dff34b94f53e958c1ac; ./tools/triage.sh 'XEP-0072, XEP-0096, XEP-0214: fix xmlns in sipub examples' 58cec1b6fb30ccc3b44c9dff34b94f53e958c1ac e4d3f721c2cf9fc7ed42c3428d098b2b3be3c8ed
# protoxep: git fetch origin +refs/pull/1254/merge; git checkout FETCH_HEAD; ./tools/triage.sh "ProtoXEP: Stream Limits Advertisement"
# one xep changed: git fetch origin +refs/pull/1249/merge; git checkout FETCH_HEAD; ./tools/triage.sh 'XEP-0444: bla'

set -euo pipefail

pr_number="$1"
shift
pr_title="$(gh pr view "$pr_number" --json title -q .title)"

pr_commit="$(gh pr view "$pr_number" --json headRefOid -q .headRefOid)"
merge_base="$(git merge-base "$pr_commit" "$(gh pr view "$pr_number" --json baseRefName -q .baseRefName)")"

xpath() {
    set -euo pipefail
    xmllint --nonet --noent --xpath "$2" "$1" --nowarning --dtdvalid xep.dtd
}

add_tag() {
    gh pr edit "$pr_number" --add-label "$1"
}

files_changed="$(git --no-pager diff --name-only "$pr_commit" "$merge_base")"

set +e
protoxep="$(echo "$files_changed" | grep -E '^inbox/[^.]+.xml$')"
num_protoxeps=$(echo "$protoxep" | grep -v '^$' | wc -l)

xeps_changed="$(echo "$files_changed" | grep -E '^xep-[0-9]{4}.xml$')"
xep_likes_changed="$(echo "$files_changed" | grep -E '^xep-[^.]+.xml$')"
num_xeps_changed=$(echo "$xeps_changed" | grep -v '^$' | wc -l)
set -e

if [ $num_protoxeps -ge 1 ]
then
    if [ $num_xeps_changed -ne 0 ]
    then
        echo "cannot change xeps and add ProtoXEP in 1 PR"
        exit 1
    fi
    # we are dealing with a protoxep here
    add_tag "ProtoXEP"
    if [ $num_protoxeps -ne 1 ]
    then
        echo "multiple ProtoXEPs cannot be created in 1 PR"
        exit 1
    fi
    expected_title="ProtoXEP: $(xpath "$protoxep" '/xep/header/title/text()')"
    if [ "$pr_title" != "$expected_title" ]
    then
        echo "expected title '$expected_title' got title '$pr_title'"
        exit 1
    fi
    add_tag "Ready to Merge"
    echo "manual: be sure type '$(xpath "$protoxep" '/xep/header/type/text()')' is appropriate for XEP content"
    exit 0
fi

# we are *not* dealing with a protoxep here
if [ "$xeps_changed" != "$xep_likes_changed" ]
then
    echo "xep files created/changed but named incorrectly: $(echo "$xep_likes_changed" | tr '\n' ' ')"
    exit 1
fi

if [ $num_xeps_changed -eq 0 ]
then
    # some tag for this? tooling changes?
    echo "manual: no XEPs changed"
    exit 0
fi

if [ $num_xeps_changed -gt 1 ]
then
    echo "multiple XEPs changed"
    exit 1
fi

all_approvers=""
# a super approver can approve this entire PR, because they are author on all XEPs touched
super_approvers=""
for xep in $xeps_changed
do
    xep_num="XEP-$(echo "$xep" | grep -Eo '[0-9]{4}')"
    if ! echo "$pr_title" | grep "$xep_num" &>/dev/null
    then
        echo "title did not include '$xep_num'"
        exit 1
    fi

    status="$(xpath "$xep" '/xep/header/status/text()')"
    approvers=""
    if echo "$status" | grep -E '^(Experimental|Deferred)$' &>/dev/null
    then
        # Experimental or Deferred
        if [ "$status" == 'Deferred' ]
        then
            add_tag "Needs Editor Action"
            echo "move $xep_num status to Experimental before or with merge"
            exit 1
        fi

        approvers="$(xpath "$xep" '/xep/header/author/email/text()' | sort -u)"
    else
        # *not* Experimental or Deferred
        approvers="$(xpath "$xep" '/xep/header/approver/text()' 2>/dev/null || echo 'Unknown')"
    fi

    echo "info: $xep_num status '$status' needs approvers: '$(echo "$approvers" | tr '\n' ' ' | xargs)'"

    new_all_approvers="$(echo -e "$all_approvers\n$approvers" | sort -u)"
    if [ "$all_approvers" != "$new_all_approvers" ]
    then
        # this isn't technically a problem if they all have an approver in common, ie super_approvers is non-empty, suppress warning?
        if [ "$all_approvers" != "" ]
        then
            echo "multiple XEPs modified with different approvers"
            super_approvers="$(comm -12 <(echo "$super_approvers") <(echo "$approvers") | sort -u)"
            exit 1
        else
            super_approvers="$new_all_approvers"
        fi
        all_approvers="$new_all_approvers"
    fi

    # check revision block added and minor version bump
    versions="$(xpath "$xep" '/xep/header/revision/version/text()')"
    latest_num_versions="$(echo "$versions" | wc -l)"
    latest_version="$(echo "$versions" | head -n1)"
    # this git-cat-file usage assumes no entities etc are ever removed from xep.ent etc, this should be true
    # but if it ever isn't, then we'll have to check out the entire repo as of $merge_base to do that
    versions="$(git cat-file -p "$merge_base:./$xep" | xpath - '/xep/header/revision/version/text()')"
    merge_base_num_versions="$(echo "$versions" | wc -l)"
    merge_base_version="$(echo "$versions" | head -n1)"
    if [ $latest_num_versions -gt $merge_base_num_versions ]
    then
        if ! echo "$latest_version" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' &>/dev/null
        then
            echo "version is not semver format: '$latest_version'"
            exit 1
        fi
        if [ "$latest_version" == "$merge_base_version" ]
        then
            add_tag "Needs Version Block"
            # todo: anyone have a fancy way to check semver is higher in $latest_version ?
            # beware we have funky non-semver versions
            # for xep in xep-*.xml; do xpath "$xep" '/xep/header/revision/version/text()'; done | sort -u > xep_versions.txt
        fi
    else
        add_tag "Needs Version Block"
    fi
done

if [ "$super_approvers" != "" ]
then
    pr_authors="$(git --no-pager log --format="%aE" "$merge_base".."$pr_commit" | sort -u)"
    pr_authors_super_approvers="$(comm -12 <(echo "$super_approvers") <(echo "$pr_authors") | sort -u)"
    if [ "$pr_authors_super_approvers" != "" ]
    then
        echo "info: entire PR can be approved by one of the commit authors: '$(echo "$pr_authors" | tr '\n' ' ' | xargs)'"
    fi
    echo "info: entire PR can be approved by: '$(echo "$super_approvers" | tr '\n' ' ' | xargs)'"
fi

if echo "$all_approvers" | grep '^Council$' &>/dev/null
then
    add_tag "Needs Council"
fi

if echo "$all_approvers" | grep '^Board$' &>/dev/null
then
    add_tag "Needs Board"
fi

if echo "$all_approvers" | grep '^Unknown$' &>/dev/null
then
    echo "approver is unknown, perhaps old XEP that needs fixed?"
    exit 1
fi

if echo "$all_approvers" | grep '@' &>/dev/null
then
    add_tag "Needs Author"
fi

echo "manual: if only editorial changes, may not need approval"
