#!/bin/bash


set -euxo pipefail

standalone_frontend_path="$HOME/code/pristine/devtools-frontend-pristine"
cd $standalone_frontend_path

git fetch origin
git checkout -f origin/main
git reset --hard
git clean -fdx


# this is the chrome-for-testing version string, eg 131.0.6752.0
chrome_version=$(cat DEPS | grep "'chrome'" | head -n1 | egrep -o "\d+\.\d+\.\d+\.\d+")


# Find most recent roll of chromium INTO devtools-frontend standalone.
#   NOTE: this isn't exactly the same as when frontend was rolled into chromium. But.. it shouldn't make a huge difference for these purposes.. :)
chromium_commit_position=$(curl "https://chromiumdash.appspot.com/fetch_releases?platform=Mac" | jq --arg chrome_version "$chrome_version" '.[] | select(.version == $chrome_version).chromium_main_branch_position')

# verify we have a real number
re='^[0-9]+$'
if ! [[ $chromium_commit_position =~ $re ]] ; then
   echo "error: Not a number" >&2; exit 1
fi


## TODO: at this point it'd be easier to publish with the chrome version but.. 
# i dont see how to get the FULL chrome version string into an npm compatible version string, without problems or unexpected hyphens:
#    ❯ npm version 130.0.3467.1
#    v130.0.346-7.1
#    
#    ❯ npm version 1.130.0.3467.1
#    npm ERR! Invalid version: 1.130.0.3467.1
#    
#    ❯ npm version 1.0.130.0.3467.1
#    v1.0.13-0.0.3467.1
#    
#    ❯ npm version 1.0.0.130.0.3467.1
#    npm ERR! Invalid version: 1.0.0.130.0.3467.1

git fetch origin main

echo "ready to publish: 1.0.$chromium_commit_position"

# bump and publish
if npm version --no-git-tag-version "1.0.$chromium_commit_position"; then
  npm publish --registry "https://registry.npmjs.org/"
fi


# and repeat so our package.json has no version change
git reset --hard
git clean -fdx
