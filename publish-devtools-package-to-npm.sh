#!/bin/bash


set -ex -o pipefail

standalone_frontend_path="$HOME/code/pristine/devtools-frontend-pristine"
cd $standalone_frontend_path

git fetch origin
git checkout -f origin/main
git reset --hard
git clean -fdx

# Find most recent roll of chromium INTO devtools-frontend standalone.
#   NOTE: this isn't exactly the same as when frontend was rolled into chromium. But.. it shouldn't make a huge difference for these purposes.. :)
#   A previous version of this script did the more involved lookup, but it involved a chromium checkout, which is a pain.
# Specifically extract the chromim rev (e.g. 373466) from the DEPS file
chromium_commit_position=$(cat DEPS | grep chromium_linux | head -n1 | grep -o -E "\d+")

# verify we have a real number
re='^[0-9]+$'
if ! [[ $chromium_commit_position =~ $re ]] ; then
   echo "error: Not a number" >&2; exit 1
fi


git fetch origin main

echo "ready to publish: 1.0.$chromium_commit_position"

# bump and publish
if npm version --no-git-tag-version "1.0.$chromium_commit_position"; then
  npm publish
fi


# and repeat so our package.json has no version change
git reset --hard
git clean -fdx
