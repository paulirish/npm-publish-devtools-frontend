# Chrome DevTools frontend

This package contains the client-side of the developer tools built into Blink, which is part of Chromium (which is, in turn, distributed as Chrome).

It's not (yet) a proper module, but rather a pure mirror of [what's in the Chromium repo](https://chromium.googlesource.com/chromium/src/+/master/third_party/WebKit/Source/devtools/front_end/). You're quite welcome to consume it, but unfortunately we're not yet ready to embrace CJS or ES6 modules, so it may require some effort. :)

The version number of this npm package (e.g. `1.0.373466`) refers to the Chromium commit position of latest frontend git commit. It's incremented with every Chromium commit, however this package is updated ~daily.

### More
* DevTools documentation: [devtools.chrome.com](https://devtools.chrome.com)
* Chrome DevTools mailing list: [groups.google.com/forum/google-chrome-developer-tools](https://groups.google.com/forum/#!forum/google-chrome-developer-tools)
* Contributing to DevTools: [bit.ly/devtools-contribution-guide](http://bit.ly/devtools-contribution-guide)
* [Debugger protocol docs](https://developer.chrome.com/devtools/docs/debugger-protocol) and [Chrome Debugging Protocol Viewer](http://chromedevtools.github.io/debugger-protocol-viewer/)
  * [chrome-remote-interface](https://github.com/cyrus-and/chrome-remote-interface), recommended lib for interfacing with the debugging protocol
  * [crmux](https://github.com/sidorares/crmux) multiplexes protocol connections
