#!/bin/bash

frontend_path="$HOME/code/devtools-standalone"

# origin	https://chromium.googlesource.com/chromium/src/third_party/WebKit/Source/devtools
# github	git@github.com:ChromeDevTools/devtools-frontend.git

cd $frontend_path && git pull origin master && git push github master

