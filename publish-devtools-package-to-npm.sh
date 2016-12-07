#!/bin/bash

publish_script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
frontend_path="$HOME/code/devtools-frontend-pristine"

cd $frontend_path

# the gyp files cause big problems
cp package.json package.json.bak.dontupload


# get the chromium incremental commit position (e.g. 373466)
commit_position=$(git log --no-color HEAD~1..HEAD | grep "Cr-Original-Commit-Position" | grep -E -o '#(\d+)' | grep -E -o '\d+')

# verify we have a real number
re='^[0-9]+$'
if ! [[ $commit_position =~ $re ]] ; then
   echo "error: Not a number" >&2; exit 1
fi

# bump and publish
if npm version --no-git-tag-version "1.0.$commit_position"
then npm publish
fi

# clean up non-repo stuff
mv package.json.bak.dontupload package.json

# keeping these around won't conflict actually.
# rm ./.npmignore
# # rm ./npm-debug.log
