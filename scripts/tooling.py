#!/usr/bin/env python3

# coding=utf-8
#
# This file is derived from Hypothesis, which may be found at
# https://github.com/HypothesisWorks/hypothesis
#
# Specifically, it is a modified version of code in the tooling directory:
# https://github.com/HypothesisWorks/hypothesis/blob/54966e04d972800db558d76b076f9119e05e977d/tooling/src/hypothesistooling
#
# Most of this work is copyright (C) 2013-2017 David R. MacIver
# (david@drmaciver.com), but it contains contributions by others. See
# CONTRIBUTING.rst for a full list of people who may hold copyright, and
# consult the git log if you need to determine who owns an individual
# contribution.
#
# This Source Code Form is subject to the terms of the Mozilla Public License,
# v. 2.0. If a copy of the MPL was not distributed with this file, You can
# obtain one at http://mozilla.org/MPL/2.0/.
#
# END HEADER

from __future__ import division, print_function, absolute_import

import os
import re
import sys
import subprocess
from datetime import datetime, timedelta


GIT_BRANCH = os.environ["BUILDKITE_BRANCH"]
REPO_URL = os.environ["BUILDKITE_REPO"]


def git(*args):
    return subprocess.check_output(("git",) + args).decode("utf8").strip()


def setup_git():
    git('config', 'user.name', 'Buildkite on behalf of Wellcome Collection')
    git('config', 'user.email', 'wellcomedigitalplatform@wellcome.ac.uk')

    try:
        git('remote', 'add', 'ssh-origin', REPO_URL)
    except subprocess.CalledProcessError:
        print("Could not add ssh-origin (maybe already exists?)")


def tags():
    """
    Returns a list of all tags in the repo.
    """
    git("fetch", "--tags")
    all_tags = git("tag").splitlines()

    assert len(set(all_tags)) == len(all_tags)

    return set(all_tags)


def latest_version():
    """
    Returns the latest version, as specified by the Git tags.
    """
    versions = []

    for t in tags():
        assert t == t.strip()
        parts = t.split(".")
        assert len(parts) == 3, t
        parts[0] = parts[0].lstrip("v")
        v = tuple(map(int, parts))

        versions.append((v, t))

    _, latest = max(versions)

    assert latest in tags()
    return latest


__version__ = latest_version()
__version_info__ = [int(i) for i in __version__.lstrip("v").split(".")]


ROOT = (
    subprocess.check_output(["git", "rev-parse", "--show-toplevel"])
    .decode("ascii")
    .strip()
)


def hash_for_name(name):
    return subprocess.check_output(["git", "rev-parse", name]).decode("ascii").strip()


def is_ancestor(a, b):
    check = subprocess.call(["git", "merge-base", "--is-ancestor", a, b])
    assert 0 <= check <= 1
    return check == 0


CHANGELOG_FILE = os.path.join(ROOT, "CHANGELOG.md")


def changelog():
    with open(CHANGELOG_FILE) as i:
        return i.read()


def has_source_changes(version=None):
    if version is None:
        version = latest_version()

    tf_files = [f for f in modified_files() if f.strip().endswith(".tf")]
    return len(tf_files) != 0


def create_tag_and_push():
    assert __version__ not in tags()

    setup_git()

    git('tag', __version__)

    subprocess.check_call(['git', 'push', 'ssh-origin', 'HEAD:main'])
    subprocess.check_call(['git', 'push', 'ssh-origin', '--tags'])


def modified_files():
    files = set()
    for command in [
        ["git", "diff", "--name-only", "--diff-filter=d", latest_version(), "HEAD"],
        ["git", "diff", "--name-only"],
    ]:
        diff_output = subprocess.check_output(command).decode("ascii")
        for l in diff_output.split("\n"):
            filepath = l.strip()
            if filepath:
                assert os.path.exists(filepath)
                files.add(filepath)
    return files


RELEASE_FILE = os.path.join(ROOT, "RELEASE.md")


def has_release():
    return os.path.exists(RELEASE_FILE)


CHANGELOG_HEADER = re.compile(r"^## v\d+\.\d+\.\d+ - \d\d\d\d-\d\d-\d\d$")
RELEASE_TYPE = re.compile(r"^RELEASE_TYPE: +(major|minor|patch)")


MAJOR = "major"
MINOR = "minor"
PATCH = "patch"

VALID_RELEASE_TYPES = (MAJOR, MINOR, PATCH)


def parse_release_file():
    with open(RELEASE_FILE) as i:
        release_contents = i.read()

    release_lines = release_contents.split("\n")

    m = RELEASE_TYPE.match(release_lines[0])
    if m is not None:
        release_type = m.group(1)
        if release_type not in VALID_RELEASE_TYPES:
            print("Unrecognised release type %r" % (release_type,))
            sys.exit(1)
        del release_lines[0]
        release_contents = "\n".join(release_lines).strip()
    else:
        print(
            "RELEASE.md does not start by specifying release type. The first "
            "line of the file should be RELEASE_TYPE: followed by one of "
            "major, minor, or patch, to specify the type of release that "
            "this is (i.e. which version number to increment). Instead the "
            "first line was %r" % (release_lines[0],)
        )
        sys.exit(1)

    return release_type, release_contents


def update_changelog_and_version():
    global __version_info__
    global __version__

    with open(CHANGELOG_FILE) as i:
        contents = i.read()
    assert "\r" not in contents
    lines = contents.split("\n")
    assert contents == "\n".join(lines)
    for i, l in enumerate(lines):
        if CHANGELOG_HEADER.match(l):
            beginning = "\n".join(lines[:i])
            rest = "\n".join(lines[i:])
            assert "\n".join((beginning, rest)) == contents
            break

    release_type, release_contents = parse_release_file()

    new_version = list(__version_info__)
    bump = VALID_RELEASE_TYPES.index(release_type)
    new_version[bump] += 1
    for i in range(bump + 1, len(new_version)):
        new_version[i] = 0
    new_version = tuple(new_version)
    new_version_string = "v" + ".".join(map(str, new_version))

    now = datetime.utcnow()

    date = max([d.strftime("%Y-%m-%d") for d in (now, now + timedelta(hours=1))])

    heading_for_new_version = "## " + " - ".join((new_version_string, date))

    new_changelog_parts = [
        beginning.strip(),
        "",
        heading_for_new_version,
        "",
        release_contents,
        "",
        rest,
    ]

    __version__ = new_version_string
    __version_info__ = [int(i) for i in __version__.lstrip("v").split(".")]

    with open(CHANGELOG_FILE, "w") as o:
        o.write("\n".join(new_changelog_parts))


def update_for_pending_release():
    git("config", "user.name", "Buildkite on behalf of Wellcome")
    git("config", "user.email", "wellcomedigitalplatform@wellcome.ac.uk")

    update_changelog_and_version()

    git("rm", RELEASE_FILE)
    git("add", CHANGELOG_FILE)

    git("commit", "-m", "Bump version to %s and update changelog\n\n[skip ci]" % (__version__,))


def changed_files(*args):
    """
    Returns a set of changed files in a given commit range.

    :param commit_range: Arguments to pass to ``git diff``.
    """
    files = set()
    command = ["git", "diff", "--name-only"] + list(args)
    diff_output = subprocess.check_output(command).decode("ascii")
    for line in diff_output.splitlines():
        filepath = line.strip()
        if filepath:
            files.add(filepath)
    return files


def autoformat():
    subprocess.check_call(["terraform", "fmt", "-recursive"])

    if changed_files():
        print("*** There were changes from formatting, creating a commit", flush=True)

        setup_git()

        git("add", "--verbose", "--all")
        git("commit", "-m", "Apply auto-formatting rules")
        git("push", "ssh-origin", "HEAD:%s" % GIT_BRANCH)

        sys.exit(1)
    else:
        print("*** There were no changes from auto-formatting", flush=True)


def check_release_file():
    if has_source_changes():
        if not has_release():
            print(
                "There are source changes but no RELEASE.md. Please create "
                "one to describe your changes."
            )
            sys.exit(1)
        parse_release_file()


def release():
    last_release = latest_version()

    print(
        "Latest version: %s" % last_release
    )

    HEAD = hash_for_name("HEAD")
    MAIN = hash_for_name("origin/main")
    print("Current head:", HEAD)
    print("Current main:", MAIN)

    on_main = is_ancestor(HEAD, MAIN)

    if has_release():
        print("Updating changelog and version")
        update_for_pending_release()
    else:
        print("Not deploying due to no release")
        sys.exit(0)

    if not on_main:
        print("Not deploying due to not being on main")
        sys.exit(0)

    print("Release seems good. Pushing to GitHub now.")

    create_tag_and_push()


if __name__ == "__main__":
    try:
        command = sys.argv[1]
    except IndexError:
        sys.exit("Usage: %s <COMMAND>" % __file__)

    if command == "autoformat":
        check_release_file()
        autoformat()
    elif command == "release":
        release()
    else:
        sys.exit("Unrecognised command: %s" % command)
