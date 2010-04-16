/* My Library Toolbar Widget
   Requires DOM, Text and Event modules
   Requires Widgets add-on
   Optionally uses Class */

var API, global = this;
if (API && API.areFeatures && API.areFeatures('getEBTN', 'getChildren', 'getElementText', 'checkControl', 'emptyNode', 'attachListener')) {
	(function() {
		var api = API;
		var isHostMethod = api.isHostMethod;
		var createElement = api.createElement, getEBTN = api.getEBTN, getChildren = api.getChildren;
		var isControlChecked = api.isControlChecked, isControlDisabled = api.isControlDisabled, isControlPressed = api.isControlPressed, callInContext = api.callInContext;
		var setControlRole = api.setControlRole, checkControl = api.checkControl, disableControl = api.disableControl, pressControl = api.pressControl;
		var attachListener = api.attachListener, detachListener = api.detachListener, cancelDefault = api.cancelDefault, cancelPropagation = api.cancelPropagation, getEventTarget = api.getEventTarget, getEventTargetRelated = api.getEventTargetRelated;
		var emptyNode = api.emptyNode, getElementNodeName = api.getElementNodeName, getElementParentElement = api.getElementParentElement, getElementDocument = api.getElementDocument, getElementText = api.getElementText;
		var toArray = api.toArray;
		var getToolbarButtons;

		var enhanceButton = function(el) {
			if (setControlRole) {
				setControlRole(el, 'button');
			}
			if (isControlChecked(el)) {
				checkControl(el);
			}
			if (isControlPressed(el)) {
				pressControl(el);
			}
			if (isControlDisabled(el)) {
				disableControl(el);
			}
			if (API.makeElementUnselectable) {
				API.makeElementUnselectable(el);
			}
		};

		// TODO: Delegate anchor clicks

		var anchorClick = function(e) {
			return cancelDefault(e);
		};

		var anchorFocusFactory = function(fn, context) {
			return function(e) {
				if (callInContext(fn, context, this, getEventTargetRelated(e)) === false) {
					if (isHostMethod(this, 'blur')) {
						this.blur();
					}
					return cancelDefault(e);
				}
			};
		};

		var appendButtonAnchor = function(div, caption, doc) {
			var a = createElement('a', doc);
			if (a) {
				if (caption) {
					a.appendChild(doc.createTextNode(caption));
				} else if (API.addClass) {
					API.addClass(div, 'nocaption');
				}
				a.tabIndex = 0;
				a.href= '#';
				emptyNode(div);
				div.appendChild(a);
			}
			return a;
		};

		var attachAnchorListeners = function(a, div, onfocus, context) {
			attachListener(a, 'click', anchorClick, div);
			if (onfocus) {
				attachListener(a, 'focus', anchorFocusFactory(onfocus, context || API), div);
			}
		};

		var enhanceToolbar = function(el, options, doc) {
			if (!doc) {
				doc = getElementDocument(el);
			}

			if (doc && isHostMethod(doc, 'createTextNode')) {
				if (setControlRole) {
					setControlRole(el, 'toolbar');
				}
				var divs = getChildren(el);
				for (var i = divs.length; i--;) {
					var div = divs[i];
					var a, anchors = getEBTN('a', div);
					if (!anchors.length) {
						var caption = getElementText(div);
						if (caption) {
							a = appendButtonAnchor(div, caption, doc);
						}
					} else {
						a = anchors[0];
					}
					attachAnchorListeners(a, div, options.onfocus, options.callbackContext);
					enhanceButton(div);
				}

				attachListener(el, 'mousedown', function(e) {
					var el = getEventTarget(e);

					if (getElementNodeName(el) == 'a') {
						el = getElementParentElement(el);
					}
					if (getElementParentElement(el) == this && !isControlDisabled(el)) {
						pressControl(el);
					}
				});

				attachListener(el, 'mouseup', function(e) {
					var el = getEventTarget(e);

					if (getElementNodeName(el) == 'a') {
						el = getElementParentElement(el);
					}
					if (getElementParentElement(el) == this && !isControlDisabled(el)) {
						pressControl(el, false);
					}
				});

				attachListener(el, 'click', function(e) {
					var i, divs, result, el = getEventTarget(e), elRelated;

					if (options.radio) {
						var buttons = getToolbarButtons(this);
						for (i = buttons.length; i--;) {
							if (isControlChecked(buttons[i])) {
								elRelated = buttons[i];
							}
						}
					}

					if (getElementNodeName(el) == 'a') {
						el = getElementParentElement(el);
					}
					if (el != this && !isControlDisabled(el)) {
						if (el && options.onclick) {
							result = callInContext(options.onclick, options.callbackContext || API, this, el, elRelated);
						}
						if (result !== false) {
							if (options.radio) {
								divs = getChildren(this);

								for (i = divs.length; i--;) {
									var div = divs[i];
									if (div != el) {
										checkControl(div, false);
									}
								}							
								if (el) {
									checkControl(el);
								}
							}
						}
						return cancelDefault(e);
					}					
				});

				var oncustomize = options.oncustomize;

				if (oncustomize) {
					attachListener(el, 'dblclick', function(e) {
						var el = getEventTarget(e);

						if (el == this) {
							callInContext(oncustomize, options.callbackContext || API, this);

							return cancelDefault(e);
						}
					});

				}

				el = divs = null;
			}
		};

		api.enhanceToolbar = enhanceToolbar;

		var cancelDrag = function(e) {
			return cancelPropagation(e);
		};

		api.attachDocumentReadyListener(function() {
		var api = global.API, attachDragToControl = api.attachDragToControl, detachDragFromControl = api.detachDragFromControl;
		if (attachDragToControl) {
			api.attachDragToToolbar = function(el, elHandle, options) {
				attachDragToControl(el, elHandle);
				var divs = getChildren(el);
				for (var i = divs.length; i--;) {
                                  attachListener(divs[i], 'mousedown', cancelDrag);
                                }
			};
			api.detachDragFromToolbar = function(el, elHandle) {
				detachDragFromControl(el, elHandle);
				var divs = getChildren(el);
				for (var i = divs.length; i--;) {
                                  detachListener(divs[i], 'mousedown', cancelDrag);
                                }
			};
		}
		api = null;
		});

		var addToolbarButton;

		if (createElement && createElement('div')) {
			api.addToolbarButton = addToolbarButton = function(el, options, doc) {
				if (!doc) {
					doc = global.document;
				}
				var elButton = createElement('div', doc);
				elButton.className = options.className || 'button';
				var a = appendButtonAnchor(elButton, options.text || '', doc);
				attachAnchorListeners(a, elButton, options.onfocus, options.callbackContext);

				if (options.title) {
					elButton.title = options.title;
				}
				if (options.id) {
					elButton.id = options.id;
				}
				enhanceButton(elButton);
				el.appendChild(elButton);
				return elButton;
			};

			api.removeToolbarButton = function(el, elButton) {
				el.removeChild(elButton);
			};

			api.createToolbar = function(options, doc) {
				if (!doc) {
					doc = global.document;
				}
				if (!options) {
					options = {};
				}
				var el = createElement(options.tagName || 'div', doc);
				el.className = options.className || 'toolbar';
				if (options.id) {
					el.id = options.id;
				}
				var buttons = options.buttons;
				if (buttons) {
					var l = buttons.length;
					for (var i = 0; i < l; i++) {
						addToolbarButton(el, buttons[i], doc);
					}
				}
				enhanceToolbar(el, options, doc);
				return el;
			};

			api.getToolbarButtons = getToolbarButtons = function(el) {
				return getChildren(el);
			};
		}
		api = null;
	})();
}