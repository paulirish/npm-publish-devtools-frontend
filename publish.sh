#!/bin/bash

publish_script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
frontend_path="$HOME/code/devtools-standalone"


cp $publish_script_path/src/package.json $frontend_path
cp $publish_script_path/src/readme.md $frontend_path

cd $frontend_path

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
rm ./package.json
rm ./readme.md
# rm ./npm-debug.log
