#!/bin/bash

#####
# find the commits that roll standalone devtools into chromium.
# get the generated files from the roll commit
# copy them back into standalone at the most recent commit of the roll range
######

set -ex -o pipefail

publish_script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
standalone_frontend_path="$HOME/code/pristine/devtools-frontend-pristine"
chromium_src_path="$HOME/chromium-tot/src"

cd "$chromium_src_path"
git fetch origin
git checkout -f origin/master

# find the most recent roll
chromium_recent_roll_hash=$(git log --grep="third_party/devtools-frontend" -n1 --pretty="format:%H")

# look at the roll range (of the standalone repo) and get the most recent commit of the two. 
# use a lookbehind \K to only output what's after it. https://unix.stackexchange.com/a/13472
standalone_commit_hash=$(git log $chromium_recent_roll_hash -n1 --pretty="format:%s" | ggrep --o -P '[a-f0-9]{7,}..\K([a-f0-9]{7,})')

# get the chromium rev (e.g. 373466) from the commit message body
chromium_commit_position=$(git log $chromium_recent_roll_hash -n1 --pretty="format:%b"  | grep "Cr-Commit-Position" | head -n1 | grep -E -o '#(\d+)' | grep -E -o '\d+')

chromium_commit_hash=$chromium_recent_roll_hash


# verify we have a real number
re='^[0-9]+$'
if ! [[ $chromium_commit_position =~ $re ]] ; then
   echo "error: Not a number" >&2; exit 1
fi

# get the SupportedCSSProperties.js & InspectorBackendCommands.js files for this specific commit
git checkout "$chromium_commit_hash"
GYP_DEFINES=disable_nacl=1 gclient sync --delete_unversioned_trees --reset --jobs=70
ninja -C "$chromium_src_path/out/Default/" supported_css_properties frontend_protocol_sources aria_properties

chromium_res_path="$chromium_src_path/out/Default/resources/inspector"
cp "$chromium_res_path/InspectorBackendCommands.js" 		"$standalone_frontend_path/front_end/"
cp "$chromium_res_path/SupportedCSSProperties.js" 			"$standalone_frontend_path/front_end/"
cp "$chromium_res_path/accessibility/ARIAProperties.js" 	"$standalone_frontend_path/front_end/accessibility/"


################################
# back to standalone repo      #
################################

cd $standalone_frontend_path
git fetch origin master
git checkout "$standalone_commit_hash"


# The InspectorBackendCommands & SupportedCSSProperties files are only included in the published npm package, but wiped out afterwards.

# bump and publish
if npm version --no-git-tag-version "1.0.$chromium_commit_position"; then
  npm publish
fi

# revert the version bump in package.json
git reset --hard
# delete backend/css files to be clean. (the -x is neccessary since these files are .gitignored these days)
git clean -fdx


