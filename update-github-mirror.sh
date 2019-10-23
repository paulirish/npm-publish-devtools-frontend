#!/bin/bash

set -x

frontend_path="$HOME/code/pristine/devtools-frontend-pristine"

# old_blink (deprecated)	https://chromium.googlesource.com/chromium/src/third_party/blink/renderer/devtools/
# origin					https://chromium.googlesource.com/devtools/devtools-frontend
# github					git@github.com:ChromeDevTools/devtools-frontend.git

cd $frontend_path && git pull origin master && git push github master

