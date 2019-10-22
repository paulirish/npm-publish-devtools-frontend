#!/bin/bash

set -x

frontend_path="$HOME/code/pristine/devtools-frontend-pristine"

# origin (deprecated)	https://chromium.googlesource.com/chromium/src/third_party/blink/renderer/devtools/
# newstandalone			https://chromium.googlesource.com/devtools/devtools-frontend (fetch)
# github				git@github.com:ChromeDevTools/devtools-frontend.git

cd $frontend_path && git pull newstandalone master && git push github master

