#!/usr/bin/env python3

# Run this on its own (in the root of the xeps repo checkout) to iterate
# over open PRs triaging them. It's a wrapper around the `gh` github command
# and the triage.sh script, checking out each PR (as requested) in
# a distinct worktree, and binning it afterwards.
#
# Supply a single parameter of a GitHub PR number to only look at that PR.
#
# I make no claim about the quality of the Python involved, this was a quick
# hack for my (Kev's) benefit.

import subprocess
import sys

class PR:
    def __init__(self, line):
        s = line.split('\t')
        self.number = s[0]
        self.title = s[1]
        self.branch = s[2]
        self.state = s[3]

    def __str__(self):
        return f'PR#{self.number}({self.branch}): {self.title}'


def exec(command) -> str:
    process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    (stdout, stderr) = process.communicate()
    exit_code = process.wait()
    if exit_code == 0:
        return stdout.decode()
    return ""


def exec_with_err(command, cwd=None) -> str:
    process = subprocess.Popen(
        command, stdout=subprocess.PIPE, shell=True, cwd=cwd)
    (stdout, stderr) = process.communicate()
    exit_code = process.wait()
    return stdout.decode() + ('\n' + stderr.decode() if stderr else "")


def open_prs() -> list[str]:
    lines = exec("gh pr list -R xsf/xeps --limit=100").splitlines()
    prs = []
    for line in lines:
        prs.append(PR(line))
    return prs


exec("git fetch")
prs = open_prs()
print(f'{len(prs)} PRs')
for pr in prs:
    if len(sys.argv) > 1 and pr.number != sys.argv[1]:
        continue
    if pr.state != 'OPEN':
        print(f"Skipping PR in state {pr.state}:\n{pr}")
        continue
    print(pr)
    choice = 'invalid'
    while choice != 'c' and choice != '':
        choice = input("Check labels (c), Open on GitHub (o) or skip (enter):")
        if choice == 'o':
            exec(f'gh pr view -w -R xsf/xeps {pr.number}')
    if choice == '':
        continue
    worktree_path = f'pr-worktree/{pr.number}'
    exec(f'git fetch origin +refs/pull/{pr.number}/merge')
    exec(f'git worktree add {worktree_path} FETCH_HEAD')
    triage = exec_with_err(f'../../tools/triage.sh "{pr.title}"', worktree_path)
    print(triage)
    print(f'Worktree checked out in {worktree_path}')
    input('Enter to remove worktree and continue')
    exec(f'git worktree remove {worktree_path}')
