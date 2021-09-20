#!/bin/bash

#exit 0;
# THIS IS DEPRECATED 
# repo is now synced with copybara


set -x

frontend_path="$HOME/code/pristine/devtools-frontend-pristine"

# old_blink (deprecated)	https://chromium.googlesource.com/chromium/src/third_party/blink/renderer/devtools/
# origin					https://chromium.googlesource.com/devtools/devtools-frontend
# github					git@github.com:ChromeDevTools/devtools-frontend.git

# TODO: the GH repo still uses master
cd $frontend_path && git reset --hard && git checkout main && git pull origin main && git push github master

