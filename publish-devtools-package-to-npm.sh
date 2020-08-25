#!/bin/bash

#####
# find the commits that roll standalone devtools into chromium.
######

set -ex -o pipefail

publish_script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
standalone_frontend_path="$HOME/code/pristine/devtools-frontend-pristine"
chromium_src_path="$HOME/chromium-tot/src"

cd "$chromium_src_path"
git fetch origin
git checkout -f origin/master

# find the most recent roll
chromium_recent_roll_hash=$(git log --grep=devtools -n1 --pretty="format:%H" -- DEPS)

# look at the roll range (of the standalone repo) and get the most recent commit of the two.
#     e.g.: "Roll DevTools Frontend from af6416cd74c8 to 038b9b33775b (1 revision)" 
# use a lookbehind \K to only output what's after it. https://unix.stackexchange.com/a/13472
standalone_commit_hash=$(git log $chromium_recent_roll_hash -n1 --pretty="format:%s" | ggrep --o -P 'from [a-f0-9]{7,} to \K([a-f0-9]{7,})')

# get the chromium rev (e.g. 373466) from the commit message body
chromium_commit_position=$(git log $chromium_recent_roll_hash -n1 --pretty="format:%b"  | grep "Cr-Commit-Position" | head -n1 | grep -E -o '#(\d+)' | grep -E -o '\d+')

chromium_commit_hash=$chromium_recent_roll_hash


# verify we have a real number
re='^[0-9]+$'
if ! [[ $chromium_commit_position =~ $re ]] ; then
   echo "error: Not a number" >&2; exit 1
fi

# UPDATE: the SupportedCSSProperties.js & InspectorBackendCommands.js files are now in front_end generated. (we used to have to build them, but now, no extra work required!)

################################
# back to standalone repo      #
################################

cd $standalone_frontend_path
# revert the version bump in package.json
git reset --hard
# delete backend/css files to be clean. (the -x is neccessary since these files are .gitignored these days)
git clean -fdx
git fetch origin master
git checkout "$standalone_commit_hash"


# bump and publish
if npm version --no-git-tag-version "1.0.$chromium_commit_position"; then
  npm publish
fi


# and repeat so our pristine folder has no changes.
git reset --hard
git clean -fdx


