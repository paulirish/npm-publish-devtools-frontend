#!/bin/bash

set -x

publish_script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
frontend_path="$HOME/code/pristine/devtools-frontend-pristine"
chromium_src_path="$HOME/chromium-tot/src"


cd $frontend_path || exit 1


# get the chromium commit hash
firstlog=$(git log --no-color HEAD~1..HEAD)
commit_hash=$(printf "%s" "$firstlog" | grep "Cr-Mirrored-Commit" | grep -E -o ': (\w+)'| grep -E -o '(\w+)')
# get the chromium rev (e.g. 373466)
commit_position=$(printf "%s" "$firstlog" | grep "Cr-Original-Commit-Position" | grep -E -o '#(\d+)' | grep -E -o '\d+')

# verify we have a real number
re='^[0-9]+$'
if ! [[ $commit_position =~ $re ]] ; then
   echo "error: Not a number" >&2; exit 1
fi


# get the SupportedCSSProperties.js & InspectorBackendCommands.js files for this specific commit
cd "$chromium_src_path" || exit 1
git fetch origin master
git checkout "$commit_hash"
GYP_DEFINES=disable_nacl=1 gclient sync --delete_unversioned_trees --reset --jobs=70 --nohooks
ninja -C "$chromium_src_path/out/Default/" supported_css_properties frontend_protocol_sources aria_properties || exit 1

res_path="$chromium_src_path/out/Default/resources/inspector"
cp "$res_path/InspectorBackendCommands.js" "$frontend_path/front_end/" || exit 1
cp "$res_path/SupportedCSSProperties.js" "$frontend_path/front_end/" || exit 1
cp "$res_path/accessibility/ARIAProperties.js" "$frontend_path/front_end/accessibility/" || exit 1

git checkout -f origin/master || exit 1
cd $frontend_path || exit 1

# The InspectorBackendCommands & SupportedCSSProperties files are not added to the git repo, as the github only has original sources.
# They are only included in the published npm package


# bump and publish
if npm version --no-git-tag-version "1.0.$commit_position"; then
  npm publish
fi

# revert the version bump in package.json
git reset --hard
# delete backend/css files to be extra safe
git clean -f

