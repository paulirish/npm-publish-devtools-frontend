// technique for grabbing protocol.json of any particular debugging protocol host
// https://github.com/cyrus-and/chrome-remote-interface/issues/10

fetch("http://localhost:9222/json/version")
  .then( resp => resp.json() )
  .then( function(obj){
    // eg: "WebKit-Version": "537.36 (@31978e66f0c2ae00926292b37ce61bb19827836c)"
    var ver = obj["WebKit-Version"];
    var match = ver.match(/\s\(@(\b[0-9a-f]{5,40}\b)/);
    var hash = match[1];
    return hash;
  })
  .then( hash => {
    // the blink/chromium repo merge changed file locations. https://goo.gl/JztV1A
    var url = (hash <= 202666) ?
      `http://src.chromium.org/blink/trunk/Source/devtools/protocol.json?p=${ hash }` :
      `https://chromium.googlesource.com/chromium/src/+/${ hash }/third_party/WebKit/Source/devtools/protocol.json?format=TEXT`;
    return fetch(url);
  })
  .then( resp =>  { return resp.text() })
  .then( function(txt){
    try {
      // googlesource response is base64 encoded
      var protocol = atob(txt);
    } catch (e) {
      var protocol = txt;
    }
    return Promise.resolve(JSON.parse(protocol));
  })
  .then( protocolObj => console.log(protocolObj) )
