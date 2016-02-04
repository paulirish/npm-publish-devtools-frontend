#!/bin/bash

publish_script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
frontend_path="$HOME/code/devtools-standalone"

cp package.json $frontend_path
cd $frontend_path

# get the chromium incremental commit position (e.g. 373466)
commit_position=$(git log --no-color HEAD~1..HEAD | grep "Cr-Original-Commit-Position" | grep -E -o '#(\d+)' | grep -E -o '\d+')

npm version "1.0.$commit_position"
npm publish


