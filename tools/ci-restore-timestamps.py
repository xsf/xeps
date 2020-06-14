#!/usr/bin/python3
import os
import pathlib
import subprocess
import time


def parse_timestamp_line(s: str):
    author_ts, committer_ts = s.split(" ", 1)
    return max(int(author_ts), int(committer_ts))


def restore_commit_timestamps(basedir: pathlib.Path):
    env = dict(os.environ)
    env["LANG"] = "C.UTF-8"
    # NOTE: the build image is still only on Python 3.4 because texml and stuff
    # so we cannot use encoding= here and have to do decoding ourselves.
    proc = subprocess.Popen(
        [
            "git", "log", "--pretty=%at %ct", "--name-status",
        ],
        stdout=subprocess.PIPE,
        env=env,
    )

    seen = set()
    last_timestamp = None
    for line in proc.stdout:
        if not line:
            continue
        if not line.endswith(b"\n"):
            raise ValueError("line not terminated")
        line = line[:-1].decode("utf-8")
        if not line:
            continue

        try:
            timestamp = parse_timestamp_line(line)
        except ValueError:
            pass
        else:
            last_timestamp = timestamp
            continue

        _, filename = line.split("\t", 1)
        if filename in seen:
            continue
        seen.add(filename)
        filepath = basedir / filename
        try:
            os.utime(str(filepath), (last_timestamp, last_timestamp))
        except FileNotFoundError:
            pass


def main():
    basedir = pathlib.Path.cwd()

    t0 = time.monotonic()
    try:
        restore_commit_timestamps(basedir)
    finally:
        t1 = time.monotonic()
        print("timestamp restoration took {:.2f}s".format(t1-t0))

    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main() or 0)
