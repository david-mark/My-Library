// My Library document ready simulation
// Include just before the closing body tag

if (this.API && typeof(this.API.documentReady) == 'function' && typeof(this.API.documentReadyListener) == 'function' && typeof(this.document) != 'undefined') {
  (function() {
    var fn, html, global = this;

    if (typeof(this.API.htmlElement) == 'function') {
      html = this.API.htmlElement();
      if (html && typeof html.innerHTML != 'string') { html = null; } 
    }

    this.API.waitForParse = function() {
      if (html && html.innerHTML.toLowerCase().indexOf('</body>') == -1) {
        global.setTimeout(fn, 10);
      }
      else {
        this.documentReadyListener();
      }
    };

    // Guard against IE "Operation Aborted" bug
    // This is critical for applications that manipulate children of the body element.

    /*@cc_on
    fn = function() { this.API.waitForParse(); };
    fn.toString = function() { return 'this.API.waitForParse();'; };
    this.setTimeout(fn, 10);
    return;
    @*/
    var interval, reReady, doc = this.document;
    if (typeof(doc.readyState) == 'string') {
      reReady = new RegExp('^(loaded|complete)$', 'i');
      interval = this.setInterval(function() {
        if (this.API.documentReady()) {
          this.clearInterval(interval);
        }
        else {
          if (reReady.test(doc.readyState)) {
            this.clearInterval(interval);
            this.API.documentReadyListener();
          }
        }
      }, 10);
    }
  })();
}