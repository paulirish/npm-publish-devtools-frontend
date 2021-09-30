#!/bin/bash

# there was an attempt to sync this with copybara but it failed, so this script is still used.

set -x

frontend_path="$HOME/code/pristine/devtools-frontend-pristine"

# old_blink (deprecated)	https://chromium.googlesource.com/chromium/src/third_party/blink/renderer/devtools/
# origin					https://chromium.googlesource.com/devtools/devtools-frontend
# github					git@github.com:ChromeDevTools/devtools-frontend.git

# as of sept 2021, we push to github on both master and main
cd $frontend_path && git reset --hard && git fetch origin && git fetch github && \
  git checkout main && git pull origin main && git push github main && git push github main:master

