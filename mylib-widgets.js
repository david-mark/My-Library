/* My Library Widgets add-on
   Enhanced by Set Attribute and/or Style modules and Class modules */

var API, global = this;

if (API) {
	(function() {
		var api = API, setAttribute = api.setAttribute, getAttribute = api.getAttribute, removeAttribute = api.removeAttribute, addClass = api.addClass, removeClass = api.removeClass, hasClass = api.hasClass, elementUniqueId = api.elementUniqueId;
		var setControlState, getControlState, setWaiProperty, getWaiProperty, controlStates = {};
		var setStateFactory, isStateFactory;

		var convertControlState = function(value) {
			if (/^(true|false)$/.test(value)) {
				return value == 'true';
			}
			return value;
		};

		if (setAttribute) {
			api.getControlRole = function(el, role) {
				return getAttribute(el, 'role');
			};

			api.setControlRole = function(el, role) {
				setAttribute(el, 'role', role);
			};

			api.getWaiProperty = getWaiProperty = function(el, name) {
				return getAttribute(el, 'aria-' + name);
			};

			api.setWaiProperty = setWaiProperty = function(el, name, value) {
				setAttribute(el, 'aria-' + name, value);
			};

			setControlState = function(el, name, state) {
				setWaiProperty(el, name, state.toString());
			};

			getControlState = function(el, name) {				
				return convertControlState(getWaiProperty(el, name));
			};

			api.removeWaiProperty = function(el, name) {
				removeAttribute(el, 'aria-' + name);
			};
		} else {			
			setControlState = function(el, name, state) {
				if (!controlStates[name]) {
					controlStates[name] = {};
				}
				controlStates[name][elementUniqueId(el)] = state.toString();
			};
			
			getControlState = function(el, name) {
				if (!controlStates[name]) {
					controlStates[name] = {};
				}
				return convertControlState(controlStates[name][elementUniqueId(el)]);
			};			
		}

		api.setControlState = setControlState;
		api.getControlState = getControlState;

		if (addClass || setControlState) {
			setStateFactory = function(name) {
				var re = new RegExp('\\s+\\(' + name + '\\)');

				return function(el, b) {
					if (typeof b == 'undefined') {
						b = true;
					}
					if (addClass) {
						if (b) {
							addClass(el, name);
						} else {
							removeClass(el, name);
						}
					}
					if (setControlState) {
						setControlState(el, name, b);
					}

					if (typeof el.title == 'string' && el.title) {
						el.title = el.title.replace(re, '');

						if (b) {
							el.title += ' (' + name + ')';
						}
					}
				};
			};

			isStateFactory = function(name) {
				return function(el) {
					if (hasClass) {
						return hasClass(el, name);
					}
					return getControlState(el, name);
				};
			};

			api.disableControl = setStateFactory('disabled');
			api.pressControl = setStateFactory('pressed');
			api.checkControl = setStateFactory('checked');
			api.selectControl = setStateFactory('selected');

			api.isControlDisabled = isStateFactory('disabled');
			api.isControlPressed = isStateFactory('pressed');
			api.isControlChecked = isStateFactory('checked');
			api.isControlSelected = isStateFactory('selected');
		}

		var callInContext;

		if (Function.prototype.call) {
			callInContext = function(fn, o, arg1, arg2, arg3) {
				return fn.call(o, arg1, arg2, arg3);
			};
		} else {
			callInContext = function(fn, o, arg1, arg2, arg3) {
				o._mylibWidgetCallTemp = fn;
				var result = o._mylibWidgetCallTemp(arg1, arg2, arg3);
				delete o._mylibWidgetCallTemp;
				return result;
			};
		}

		api.callInContext = callInContext;

		if (api.attachDocumentReadyListener) {

		api.attachDocumentReadyListener(function() {
			var showControl, api = API;

			var setStyle = api.setStyle, findProprietaryStyle = api.findProprietaryStyle, showElement = api.showElement, transitionStyle, transitionPropertyStyle, transitionDurationStyle, userSelectStyle, makeElementUnselectable;

			if (findProprietaryStyle) {
				userSelectStyle = findProprietaryStyle('userSelect');				
			}

			if (userSelectStyle && setStyle) {
				makeElementUnselectable = function(el, b) {
					if (typeof b == 'undefined') {
						b = true;
					}
					setStyle(el, userSelectStyle, b ? 'none' : '');
				};
			} else if (setAttribute && (typeof global.document.expando == 'undefined' || global.document.expando)) {
				makeElementUnselectable = function(el, b) {
					if (typeof b == 'undefined') {
						b = true;
					}
					setAttribute(el, 'unselectable', b ? 'on' : 'off');
				};
			}

			API.makeElementUnselectable = makeElementUnselectable;

			if (showElement) {
				if (findProprietaryStyle && (transitionStyle = findProprietaryStyle('transition'))) {
					transitionPropertyStyle = transitionStyle + 'Property';
					transitionDurationStyle = transitionStyle + 'Duration';
				
					showControl = function(el, b, options, callback) {
						if (!options) {
							options = {};
						}
						var keyClassName = options.keyClassName;
						var useCSSTransitions = options.useCSSTransitions;
						var onDone = options.ondone || callback;

						if (transitionStyle) {
							if (typeof useCSSTransitions == 'undefined') {
								useCSSTransitions = !!options.effects;
							}
						}
						if (useCSSTransitions) {
							el.style[transitionDurationStyle] = ((options.duration || 0) / 1000) + 's';
						} else {
							//el.style[transitionDurationStyle] = '0s';
							useCSSTransitions = false;
						}
						if (b || typeof b == 'undefined') {
							el.style.visibility = 'hidden';
						}

						if (addClass) {
							if (useCSSTransitions) {
								removeClass(el, 'animated');
								if (keyClassName) {
									removeClass(el, keyClassName);
								}
								addClass(el, 'animated');
							} else {
								if (hasClass(el, 'animated')) {
									removeClass(el, 'animated');
									if (transitionDurationStyle) {
										el.style[transitionDurationStyle] = '0s';
									}
								}
							}
						}
						if (useCSSTransitions && keyClassName) {
							addClass(el, keyClassName);
						}
						global.setTimeout(function() {
							showElement(el, b, { removeOnHide:true, effects : useCSSTransitions ? null : options.effects, duration:options.duration, ease:options.ease, fps:options.fps }, function() { if (useCSSTransitions && removeClass) { removeClass(el, 'animated'); } if (onDone) { onDone(el, b); } });
							setControlState(el, 'hidden', b);
							if (onDone && !showElement.async) {
								onDone(el, b);
							}
						}, 1);
						
					};
				} else {
					showControl = function(el, b, options, callback) {
						showElement(el, b, options, callback);						
						setControlState(el, 'hidden', b);
					};
				}
				showControl.async = showElement.async;
			}

			api.showControl = showControl;

			var attachDrag = api.attachDrag, detachDrag = api.detachDrag;

			if (attachDrag) {
				var controlDragStartFactory = function(el, callback, context) {
					return function() {
						if (addClass) {
							addClass(el, 'dragging');
							if (callback) {
								callInContext(callback, context, el);
							}
						}
					};
				};

				var controlDropFactory = function(el, callback, context) {
					return function() {
						if (removeClass) {
							removeClass(el, 'dragging');
						}
						if (callback) {
							callInContext(callback, context, el);
						}
					};
				};

				api.attachDragToControl = function(el, elHandle, options) {
					attachDrag(el, elHandle, {
						ghost:false,
						ondragstart:controlDragStartFactory(el, options.ondragstart, options.callbackContext || API),
						ondrop:controlDropFactory(el, options.ondragstart, options.callbackContext || API)
					});
				};
				api.detachDragFromControl = function(el, elHandle) {
					detachDrag(el, elHandle);
				};
			}
			api = null;
		});
		}

		api = null;

	})();
}