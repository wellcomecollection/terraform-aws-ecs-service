#!/usr/bin/env python

import datetime as dt
import os
import re
import sys

RELEASE_TYPE = re.compile(r"^RELEASE_TYPE: +(major|minor|patch)")
VALID_RELEASE_TYPES = ('major', 'minor', 'patch')

CHANGELOG_HEADER = re.compile(r"^## v\d+\.\d+\.\d+ - \d\d\d\d-\d\d-\d\d$")


def get_new_version_tag(latest_version: str, release_type: str):
    version_info = [int(i) for i in latest_version.lstrip('v').split('.')]

    bump = VALID_RELEASE_TYPES.index(release_type)
    version_info[bump] += 1
    for i in range(bump + 1, len(version_info)):
        version_info[i] = 0
    return 'v' + '.'.join(map(str, version_info))


def _get_changelog_version_heading(new_version_tag: str):
    date = dt.datetime.utcnow().strftime('%Y-%m-%d')
    return f'## {new_version_tag} - {date}'


def update_changelog(release_contents: str, new_version_tag: str):
    with open(CHANGELOG_FILE) as f:
        changelog_contents = f.read()

    assert '\r' not in changelog_contents
    lines = changelog_contents.split('\n')
    assert changelog_contents == '\n'.join(lines)

    for i, line in enumerate(lines):
        if CHANGELOG_HEADER.match(line):
            beginning = '\n'.join(lines[:i])
            rest = '\n'.join(lines[i:])
            assert '\n'.join((beginning, rest)) == changelog_contents
            break

    new_version_heading = _get_changelog_version_heading(new_version_tag)

    new_changelog_parts = [
        beginning.strip(),
        new_version_heading,
        release_contents,
        rest
    ]

    with open(CHANGELOG_FILE, 'w') as f:
        f.write('\n\n'.join(new_changelog_parts))

def parse_release_file():
    """
    Parses the release file, returning a tuple (release_type, release_contents)
    """
    with open(RELEASE_FILE) as i:
        release_contents = i.read()

    release_lines = release_contents.split('\n')

    m = RELEASE_TYPE.match(release_lines[0])
    if m is not None:
        release_type = m.group(1)
        if release_type not in VALID_RELEASE_TYPES:
            print('Unrecognised release type %r' % (release_type,))
            sys.exit(1)
        del release_lines[0]
        release_contents = '\n'.join(release_lines).strip()
    else:
        print(
            'RELEASE.md does not start by specifying release type. The first '
            'line of the file should be RELEASE_TYPE: followed by one of '
            'major, minor, or patch, to specify the type of release that '
            'this is (i.e. which version number to increment). Instead the '
            'first line was %r' % (release_lines[0],)
        )
        sys.exit(1)

    return release_type, release_contents


def create_release():
    latest_version_tag = sys.argv[1]

    release_type, release_contents = parse_release_file()
    new_version_tag = get_new_version_tag(latest_version_tag, release_type)

    update_changelog(release_contents, new_version_tag)

if __name__ == '__main__':
    ROOT = sys.argv[2]
    CHANGELOG_FILE = os.path.join(ROOT, 'CHANGELOG.md')
    RELEASE_FILE = os.path.join(ROOT, 'RELEASE.md')

    create_release()