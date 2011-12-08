// My Library Touch add-on
// Uses mousedown/mousemove/mouseup to provide a basic simulation for non-touch browsers
// Passes the event as the first argument and a reference to the listening element as the second and followed by
// the page position (array) and time stamps (object)
// TODO: Consolidate last three arguments in a single object
// NOTE: Ignore event.target as it is inconsistent between touch and non-touch
// Test page at http://www.cinsoft.net/mylib-touch.html

// Also note that this is just a first draft and is largely untested!
// Use at your own risk.

var API;

if (API && API.attachListener && Function.prototype.call) {
    (function () {
        var attachListener = API.attachListener, detachListener = API.detachListener;
        var touchEventType, initialTarget, tapEventType, timeStamps = {};

        var attachTouchListeners = function (el, fnStart, fnMove, fnEnd, thisObject) {
            var listeners = {
                touchstart: fnStart,
                touchmove: fnMove,
                touchend: fnEnd
            };

            var fnWrapped = function (e) {

                // TODO: Make sure this is the right touch (store and check identifier)

                var touch = e.changedTouches[0], pos = [touch.pageY, touch.pageX], type = e.type;
                if (type == 'touchstart') {
                    initialTarget = API.getEventTarget(e);
                }
                if (type == 'touchmove') {
                    timeStamps.previousMove = timeStamps.touchmove;
                }

                timeStamps[type] = +(new Date());

                listeners[type].call(thisObject || el, e, el, pos, timeStamps, initialTarget);

                if (type == 'touchend') {
                    delete timeStamps.touchstart;
                    delete timeStamps.touchmove;
                }
            };

            attachListener(el, 'touchstart', fnWrapped, thisObject);
            attachListener(el, 'touchmove', fnWrapped, thisObject);
            attachListener(el, 'touchend', fnWrapped, thisObject);
        };

        var attachMouseListeners = function (el, fnStart, fnMove, fnEnd, thisObject, touched) {
            var doc = API.getElementDocument(el);

            var fnStartWrapped = function (e) {
                touched = true;
                initialTarget = API.getEventTarget(e);
                delete timeStamps.touchend;
                timeStamps.touchstart = +(new Date());
                fnStart.call(thisObject || el, e, el, API.getMousePosition(e), timeStamps, initialTarget);
            };

            var fnMoveWrapped = function (e) {
                if (touched) {
                    delete timeStamps.touchstart;
                    timeStamps.previousMove = timeStamps.touchmove;
                    timeStamps.touchmove = +(new Date());
                    fnMove.call(thisObject || el, e, el, API.getMousePosition(e), timeStamps, initialTarget);
                }
            };

            var fnEndWrapped = function (e) {
                if (touched) {
                    timeStamps.touchend = +(new Date());
                    delete timeStamps.touchstart;
                    delete timeStamps.touchmove;
                    touched = false;
                    fnEnd.call(thisObject || el, e, el, API.getMousePosition(e), timeStamps, initialTarget);
                }
            };

            // TODO: Use one pair of mousemove/up listeners for all

            attachListener(el, 'mousedown', fnStartWrapped, thisObject);
            attachListener(doc, 'mousemove', fnMoveWrapped, thisObject);
            attachListener(doc, 'mouseup', fnEndWrapped, thisObject);
        };

        var touchDownListener = function (el, fnStart, fnMove, fnEnd, thisObject) {
            var fnWrapped;

            return (fnWrapped = function (e) {
                var type = e.type;
                initialTarget = API.getEventTarget(e);
                detachListener(el, 'touchstart', fnWrapped);
                detachListener(el, 'mousedown', fnWrapped);
                delete timeStamps.touchend;
                timeStamps.touchstart = +(new Date());
                fnStart.call(thisObject || el, e, el, API.getMousePosition(e), timeStamps, initialTarget);

                if (!type.indexOf('mouse')) {
                    touchEventType = 'mouse';
                    attachTouchListeners = attachMouseListeners;
                } else {
                    touchEventType = 'touch';
                }
                attachTouchListeners(el, fnStart, fnMove, fnEnd, thisObject, true);
            });
        };

        API.attachTouchListeners = function (el, fnStart, fnMove, fnEnd, thisObject) {
            var fnWrapped;
            if (typeof touchEventType == 'undefined') {
                fnWrapped = touchDownListener(el, fnStart, fnMove, fnEnd, thisObject);
                attachListener(el, 'touchstart', fnWrapped, thisObject);
                attachListener(el, 'mousedown', fnWrapped, thisObject);
            } else {
                attachTouchListeners(el, fnStart, fnMove, fnEnd, thisObject);
            }
        };

        var tapListener = function (el, fn, thisObject) {
            var fnWrapped;

            return (fnWrapped = function (e) {
                var type = e.type;
                detachListener(el, 'tap', fnWrapped);
                detachListener(el, 'click', fnWrapped);

                fn.call(thisObject || el, e);

                if (!type.indexOf('tap')) {
                    tapEventType = 'tap';
                } else {
                    tapEventType = 'click';
                }

                attachListener(el, tapEventType, fn);
            });
        };


        API.attachTapListener = function (el, fn, thisObject) {
            var fnWrapped;
            if (typeof tapEventType == 'undefined') {
                fnWrapped = tapListener(el, fn, thisObject);
                attachListener(el, 'tap', fnWrapped, thisObject);
                attachListener(el, 'click', fnWrapped, thisObject);
            } else {
                attachListener(el, tapEventType, fn, thisObject);
            }
        };
    })();
}