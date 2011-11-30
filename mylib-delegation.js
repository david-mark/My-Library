/*
   My Library Delegation add-on

*/

var API, Q, E, D, global = this;

if (API && API.attachListener && API.getElementDocument && Function.prototype.call) {
  (function() {
    var isDescendant = API.isDescendant;
    var attachListener = API.attachListener, getEventTarget = API.getEventTarget, getEventTargetRelated = API.getEventTargetRelated, getElementDocument = API.getElementDocument;
    var createQueryDelegate, createQueryDelegates, getQueryContext, qPrototype, testFactory;

    var bindDelegationTest = function(fn, fnTest, thisObject) {
      return function(e, el) {
        var targets;

        if ((!fnTest || (targets = fnTest(e, el)))) {
          fn.call(thisObject || el, e, targets || {
            currentTarget: el,
            target: getEventTarget(e), 
            relatedTarget: getEventTargetRelated(e)
          });
        }
      };
    };

    function createDelegate(fn, fnDelegate, options) {
      var fnTest = options.test;
      var thisObject = options.context;

      var boundDelegationTest = bindDelegationTest(fn, fnTest, thisObject);

      return function(e) {
        var elTarget = getEventTarget(e);
        var el = fnDelegate.call(thisObject || elTarget, e, elTarget);
        if (el) {
          boundDelegationTest(e, el);
        }
      };
    }

    function attachDelegate(el, fn, fnDelegate, options) {
      attachListener(el, createDelegate(fn, fnDelegate, options));
    }

    if (E && E.prototype) {
      E.prototype.delegate = function(fn, fnDelegate, fnTest, thisObject) {
        attachDelegate(this.element(), fn, fnDelegate, fnTest, thisObject);
      };
    }

    if (Q && Q.prototype) {
      qPrototype = Q.prototype;
    }

    if (qPrototype && qPrototype.some && qPrototype.filter) {
      testFactory = function(el, thisObject) {
        return function(e, elTarget) {
          var filteredEls = thisObject.filter(function(el) {
            return isDescendant(el, elTarget);
          });
          if (filteredEls.length) {
            return filteredEls[0];
          }
        };
      };

      getQueryContext = function(thisObject) {
        var els = thisObject.elements(), el = els[0];
        return el ? getElementDocument(el) : global.document;
      };

      createQueryDelegate = function(fnDelegator, fnTest) {
        return function(fn, thisObject) {
          var context = this.context();

          if (!context) {
            context = getQueryContext(this);
          }

          fnDelegator(context, fn, testFactory(context, this), thisObject);
        };
      };

      createQueryDelegates = function(fnDelegator, fnTest) {
        return function(fnIn, fnOut, thisObject) {
          var context = this.context();

          if (!context) {
            context = getQueryContext(this);
          }

          fnDelegator(context, fnIn, fnOut, testFactory(context, this), thisObject);
        };
      };
    }
    
    // TODO: Replace Q's 'on' and 'off' methods

    API.createDelegate = createDelegate;
    API.attachDelegate = attachDelegate;
    API.bindDelegationTest = bindDelegationTest;
    API.createQueryDelegate = createQueryDelegate;
    API.createQueryDelegates = createQueryDelegates;
  })();
}
