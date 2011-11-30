/*

   My Library Activation add-on

   Usage:

     API.attachActivationListeners(el, fnIn, fnOut, thisObject);
     API.attachFocusChangeListeners(el, fnFocus, fnBlur, thisObject);
     API.attachRolloverListeners(el, fnIn, fnOut, thisObject);

   Arguments:

     el (DOM node) - Node to attach listeners
     fnIn/fnFocus (function) - Callback for focus in, focus or mouse in descendant
     fnOut/fnBlur (function) - Callback for focus out, blur or mouse out of descendant
     thisObject (object) - Sets the - this - object for the callbacks (optional)

   Usage:

     API.delegateActivation(el, fnIn, fnOut, fnDelegate, thisObject);
     API.delegateFocusChange(el, fnFocus, fnBlur, fnDelegate, thisObject);
     API.delegateRollover(el, fnIn, fnOut, fnDelegate, thisObject);

   Arguments:

     el (DOM node) - Node to attach listeners
     fnIn/fnFocus (function) - Callback for focus in, focus or mouse in descendant
     fnOut/fnBlur (function) - Callback for focus out, blur or mouse out of descendant
     fnDelegate (function) - Callback to determine the target's delegator
     thisObject (object) - Sets the - this - object for the callbacks (optional)

   Callbacks:

     fnIn/fnOut/fnFocus/fnBlur(e, listeners)

       The event object (e) is of no use in activation callbacks.
       The - listeners - argument is an object with these properties:-

         target - The element that fired the event
         currentTarget - The element attached to the listeners (also - this - unless overridden by thisObject argument)
         relatedTarget - Related element (set for activation/rollover events only)

     fnDelegate(e, elTarget)

       The - e - argument is the event object.
       The - elTarget - argument is the element that fired the event (also - this - unless overridden by thisObject argument)

       Delegation callbacks normally return a reference to an element containing the target.
       
   Requirements:

     Events module
     Delegation add-on

   Examples:

     http://www.cinsoft.net/mylib-activation.html
*/

var API, Q, E, global = this;

if (API && API.areFeatures('attachListener', 'createDelegate') && API.isHostMethod(global.document, 'createElement') && Function.prototype.call) {
  (function() {
    var attachActivationListeners, attachFocusChangeListeners, attachRolloverListeners, attachEnterLeaveListeners;
    var delegateActivation, delegateFocusChange, delegateRollover;
    var bindDelegationTest = API.bindDelegationTest, createDelegate = API.createDelegate, createQueryDelegates = API.createQueryDelegates;
    var attachFocusListeners, attachMouseListeners;
    var attachListener = API.attachListener, isEventSupported = API.isEventSupported;
    var getEventTarget = API.getEventTarget, getEventTargetRelated = API.getEventTargetRelated;
    var isDescendant = API.isDescendant;
    var activationTest, attacherFactory;
    var el = global.document.createElement('input');

    function ancestorTest(e, el, target, relatedTarget) {
        if (!target) {
          target = getEventTarget(e);
          relatedTarget = getEventTargetRelated(e);
        }
        var isAncestorOfRelatedTarget = relatedTarget && el != relatedTarget && isDescendant(el, relatedTarget);
        var isAncestorOfTarget = target && el != target && isDescendant(el, target);
        if ((isAncestorOfRelatedTarget && isAncestorOfTarget) || (relatedTarget == el && isAncestorOfTarget || target == el && isAncestorOfRelatedTarget)) {
          return false;
        }

        return {
          target: target,
          currentTarget: el,
          relatedTarget: relatedTarget
        };
    }

    attacherFactory = function(fnAttacher, fnTest) {
      return function(el, fnIn, fnOut, thisObject) {
        var fnInWrapped = bindDelegationTest(fnIn, fnTest, thisObject);
        var fnOutWrapped = bindDelegationTest(fnOut, fnTest, thisObject);

        fnAttacher(el, function(e) {
          return fnInWrapped(e, el);
        }, function(e) {
          return fnOutWrapped(e, el);
        });
      };
    };

    if (isEventSupported('activate', el)) {
      activationTest = function(e, el) {
        var target = getEventTarget(e);
        var relatedTarget = getEventTargetRelated(e);

	  if (!relatedTarget) {
	    relatedTarget = (!e.fromElement && e.toElement) || (!e.toElement && e.fromElement);
	  }

        return ancestorTest(e, el, target, relatedTarget);
      };

      attachFocusListeners = function(el, fnIn, fnOut) {
        attachListener(el, 'activate', fnIn);
        attachListener(el, 'deactivate', fnOut);
      };

      attachFocusChangeListeners = function(el, fnFocus, fnBlur, thisObject) {
        attachListener(el, 'activate', fnFocus, thisObject);
        attachListener(el, 'deactivate', fnBlur, thisObject);
      };

      attachActivationListeners = attacherFactory(attachFocusListeners, activationTest);

    } else if (API.isHostMethod(global.document, 'addEventListener')) {

      // Activation handling sticks out like a sore thumb in standards-based browsers as there is no standard way
      // to get the related target (e.g. the blurred element on focus)

      var activationDelegations = [], documentFocusListenerAttached, elLastFocused, elLastBlurred;

      var documentFocusListener = function(e) {
        var elTarget = getEventTarget(e);
        var eventType = e.type;
        
        for (var i = activationDelegations.length; i--;) {
          var activationDelegation = activationDelegations[i];
          var el = activationDelegation.el, fnDelegate = activationDelegation.fnDelegate;

          if (elTarget.nodeType == 1) {
          if (eventType == 'blur' && elLastFocused && isDescendant(activationDelegation.el, elLastFocused) || eventType == 'focus' && isDescendant(activationDelegation.el, elTarget)) {

            if (fnDelegate) {
              el = fnDelegate.call(activationDelegation.context || elTarget, e, elTarget);
            }

            if (el) {
              var thisObject = activationDelegation.context || el;

              if (eventType == 'blur') {
                global.setTimeout((function(el, activationDelegation, thisObject) {
                  return function() {
                    if (elLastFocused === elTarget || ancestorTest(e, el, elLastFocused, elTarget)) {
                      activationDelegation.fnOut.call(thisObject, e, {
                        currentTarget: el,
                        target: elTarget,
                        relatedTarget: elLastFocused
                      });
                    }
                      
                    if (elLastFocused === elTarget) {
                      elLastFocused = null;
                    }                      
                  };
                })(el, activationDelegation, thisObject), 1);
              }
    
              if (eventType == 'focus') {
                if (!elLastBlurred || !elLastFocused || ancestorTest(e, el, elTarget, elLastFocused)) {
                    
                  activationDelegation.fnIn.call(thisObject, e, {
                    currentTarget: activationDelegation.el,
                    target: elTarget,
                    relatedTarget: elLastFocused
                  });                    
                }
              }
              }
            }
          }
        }

        if (eventType == 'focus') {
          elLastFocused = elTarget;
        } else {
          elLastBlurred = elTarget;
        }
      };

      attachFocusChangeListeners = function(el, fnFocus, fnBlur, thisObject) {
        el.addEventListener('focus', function(e) {
          return fnFocus.call(thisObject || el, e);
        }, true);
        el.addEventListener('blur', function(e) {
          return fnBlur.call(thisObject || el, e);
        }, true);
      };

      var attachDocumentFocusListeners = function() {
          document.addEventListener('focus', documentFocusListener, true);
          document.addEventListener('blur', documentFocusListener, true);
          documentFocusListenerAttached = true;
      };

      attachFocusListeners = attachActivationListeners = function(el, fnIn, fnOut, thisObject) {
        if (!documentFocusListenerAttached) {
          attachDocumentFocusListeners();
        }

        activationDelegations[activationDelegations.length] = {
          el: el,
          fnIn: fnIn,
          fnOut: fnOut,
          context: thisObject
        };
      };

      delegateActivation = function(el, fnIn, fnOut, fnDelegate, thisObject) {
        if (!documentFocusListenerAttached) {
          attachDocumentFocusListeners();
        }

        activationDelegations[activationDelegations.length] = {
          el: el,
          fnIn: fnIn,
          fnOut: fnOut,
          fnDelegate: fnDelegate,
          context: thisObject
        };
      };
    }

    API.attachActivationListeners = attachActivationListeners;

    API.attachFocusChangeListeners = attachFocusChangeListeners;

    attachMouseListeners = function(el, fnIn, fnOut) {
      attachListener(el, 'mouseover', fnIn);
      attachListener(el, 'mouseout', fnOut);
    };

    if (isEventSupported('mouseenter', el)) {
      attachEnterLeaveListeners = function(el, fnIn, fnOut) {
        attachListener(el, 'mouseenter', fnIn);
        attachListener(el, 'mouseleave', fnOut);
      };

      attachRolloverListeners = attacherFactory(attachEnterLeaveListeners, function(e, el) {
        return {
          target: getEventTarget(e),
          currentTarget: el,
          relatedTarget: getEventTargetRelated(e)
        };
      });
    } else {
      attachRolloverListeners = attacherFactory(attachMouseListeners, ancestorTest);  
    }

    API.attachRolloverListeners = attachRolloverListeners;  

    // Delegation
    
    // TODO: Move this function to delegation.js and add single function version

    var delegationFactory = function(fnAttach, fnTest) {
      return function(el, fnIn, fnOut, fnDelegate, thisObject) {
        var fnInWrapped = createDelegate(fnIn, fnDelegate, {
          test: fnTest,
          context: thisObject
        });
        var fnOutWrapped = createDelegate(fnOut, fnDelegate, {
          test: fnTest,
          context: thisObject
        });

        fnAttach(el, fnInWrapped, fnOutWrapped, thisObject);
      };
    };

    if (attachActivationListeners) {
      if (!delegateActivation) {
        delegateActivation = delegationFactory(attachFocusListeners, activationTest);
      }
      API.delegateActivation = delegateActivation;
      delegateFocusChange = API.delegateFocusChange = delegationFactory(attachFocusChangeListeners);
    }

    delegateRollover = API.delegateRollover = delegationFactory(attachMouseListeners, ancestorTest);

    // Augment wrapper object constructor prototypes

    var ePrototype = E && E.prototype, qPrototype = Q && Q.prototype;

    if (ePrototype) {
      if (attachActivationListeners) {
        ePrototype.onActivate = function(fnIn, fnOut, thisObject) {
          attachActivationListeners(this.element(), fnIn, fnOut, thisObject);
        };
        ePrototype.onFocusChange = function(fnFocus, fnBlur, thisObject) {
          attachFocusChangeListeners(this.element(), fnFocus, fnBlur, thisObject);
        };
      }
      ePrototype.onRoll = function(fnIn, fnOut, thisObject) {
        attachRolloverListeners(this.element(), fnIn, fnOut, thisObject);
      };
    }

    if (createQueryDelegates) {
      if (attachActivationListeners) {
        qPrototype.onActivate = createQueryDelegates(delegateActivation);
        qPrototype.onFocusChange = createQueryDelegates(delegateFocusChange);
      }
      qPrototype.onRoll = createQueryDelegates(delegateRollover);
    }

    el = null;
  })();
}
