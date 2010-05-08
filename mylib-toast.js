/* My Library Toast Widget
   Requires DOM module
   Requires Widgets add-on
   Optionally uses Class */

var API, global = this;
if (API && API.areFeatures && API.areFeatures('createElement', 'attachDocumentReadyListener', 'getElementDocument')) {
	API.attachDocumentReadyListener(function() {
		var i, api = API, getBodyElement = api.getBodyElement, showControl = api.showControl, cornerControl = api.cornerControl, createElement = api.createElement, getElementDocument = api.getElementDocument;
		var attachListener = api.attachListener, callInContext = api.callInContext, getWorkspaceRectangle = api.getWorkspaceRectangle, getDocumentWindow = api.getDocumentWindow, playEventSound = api.playEventSound;
		var addToast, arrangeToast, arrangeToasts, enhanceToast, findToast, getToastOffset, positions = ['topleft', 'topright', 'bottomleft', 'bottomright'];
		var body = getBodyElement();

		var toaster = {};

		var populateToaster = function(toaster) {
			for (i = positions.length; i--;) {
				toaster[positions[i]] = [];
			}
			return toaster;
		};

		populateToaster(toaster);

		var getWindowDocument = function(win) {
			var doc;

			if (!win || win == global) {
				doc = global.document;
			} else {
				doc = win.document;
			}
			return doc;
		};

		var addedResizeListener, addResizeListener = function(doc) {
			API.attachWindowListener('resize', function() {
				arrangeToasts(null, doc);
			});
		};

		var getDocumentToaster = function(doc) {
			if (!doc || doc == global.document) {
				if (!addedResizeListener) {
					addResizeListener(global.document);
					addedResizeListener = true;
				}
				return toaster;
			} else {
				if (!doc.toaster && (typeof doc.expando == 'undefined' || doc.expando)) {
					addResizeListener(doc);
					doc.toaster = populateToaster({});					
				}
				return doc.toaster;
			}
		};

		if (!body || typeof body.offsetWidth != 'number') {
			return;
		}		

		getToastOffset = function(position, el, doc) {
			var offset = 0, offsetW = 0, toast = getDocumentToaster(doc)[position], r = getWorkspaceRectangle(doc), viewportHeight = r[2], largestWidth = 0;
			var isTop = position.indexOf('top') != -1;
			var isRight = position.indexOf('right') != -1;

			for (var i = toast.length; i--;) {
				var toastSlice = toast[i];
				if (toastSlice.element) {
					offset += (isTop ? 1 : -1) * toastSlice.element.offsetHeight;
				} else if (toastSlice.arranging) {
					offset += (isTop ? 1 : -1) * toastSlice.arranging;
				}
				if (toastSlice.element && toastSlice.element.offsetWidth > largestWidth) {
					largestWidth = toastSlice.element.offsetWidth;
				}
				if (Math.abs(offset) + el.offsetHeight > viewportHeight) {
					offsetW += (isRight ? -1 : 1) * largestWidth;
					offset = largestWidth = 0;
				}
			}
			return [offset, offsetW];
		};

		findToast = function(el, doc) {
			var foundOne, result;

			for (var i = positions.length; i--;) {
				foundOne = false;
				var toast = getDocumentToaster(doc)[positions[i]];
				for (var j = 0, l = toast.length; j < l; j++) {
					var o = toast[j];
					if (o.element) {
						if (o.element == el) {
							result = toast[j];
						}
						foundOne = true;
					} else if (o.arranging) {
						foundOne = true;
					}
				}
				if (!foundOne) {
					toaster[positions[i]] = [];
				}
			}
			return result;
		};

		addToast = function(el, position, doc) {
			var toast = getDocumentToaster(doc)[position];

			return (toast[toast.length] = { element:el, position:position });
		};

		arrangeToast = function(position, options, doc) {
			var offset = 0, offsetW = 0, toast = getDocumentToaster(doc)[position], r = getWorkspaceRectangle(doc), viewportHeight = r[2], largestWidth = 0;
			var isTop = position.indexOf('top') != -1;
			var isRight = position.indexOf('right') != -1;

			// TODO: Remove this on next core update (positionElement will cancel effect without duration)
			options = options || { duration:1 };

			for (var i = 0, l = toast.length; i < l; i++) {
				if (toast[i].element) {
					var toastOffset = (isTop ? 1 : -1) * toast[i].element.offsetHeight;
					if (Math.abs(offset + toastOffset) > viewportHeight) {
						offsetW += (isRight ?  -1 : 1) * largestWidth;
						offset = largestWidth = 0;
						options.offset = [offset, offsetW];
					} else {
						options.offset = [offset, offsetW];
					}
					offset += toastOffset;
					toast[i].destination = cornerControl(toast[i].element, position, options);
					if (toast[i].element.offsetWidth > largestWidth) {
						largestWidth = toast[i].element.offsetWidth;
					}
				} else if (toast[i].arranging) {
					offset += (isTop ? 1 : -1) * toast[i].arranging;
				}
			}
		};

		arrangeToasts = function(options, doc) {
			for (var i = positions.length; i--;) {
				arrangeToast(positions[i], options, doc);
			}
		};

		if (body && attachListener && API.isHostMethod(body, 'appendChild') && cornerControl && showControl) {
			api.arrangeToast = arrangeToast;
			api.arrangeToasts = arrangeToasts;

                        api.enhanceToast = enhanceToast = function(el, options, win) {
				var shown, doc = win ? getWindowDocument(win) : getElementDocument(el), body = getBodyElement(doc);
				if (!win && getDocumentWindow) {
					win = getDocumentWindow(doc);
				}

				if (!win) {
					return null;
				}

				if (!options) {
					options = {};
				}

				var position = options.position;

				if (position) {
					position = position.toLowerCase().replace(/ /, '');
				} else {
					position = 'bottomleft';
				}

				if (body) {
					var toast = findToast(el, doc);
					if (toast) {
						global.clearTimeout(toast.timer);
					}

					el.style.position = 'absolute';
					el.style.visibility = 'hidden';
					el.className = options.className || 'toast panel';
					if (position.indexOf('top') != -1) {
						el.className += ' top';
					}
					body.appendChild(el);
					var showOptions = { duration: options.duration, effects:options.effects, fps:options.fps, ease:options.ease, removeOnHide:true, useCSSTransitions:false };
					if (showOptions.effects && API.effects && (showOptions.effects == API.effects.slide || showOptions.effects == API.effects.drop) && !options.effectParams) {
						showOptions.effectParams = { side:position.indexOf('top') == -1 ? 'top' : 'bottom' };
					} else if (showOptions.effects && API.effects && showOptions.effects == API.effects.fold && !options.effectParams) {
						showOptions.effectParams = { axes:1 };
					} else {
						showOptions.effectParams = options.effectParams;
					}
					var offset = getToastOffset(position, el, doc);
					var offsetWidth = el.offsetWidth;

					cornerControl(el, position, { offset:offset }, null, doc);
					if (el.offsetWidth != offsetWidth) {
						cornerControl(el, position, { offset:[offset[0], offset[1] - 1] }, null, doc);
					}

					if (options.fixed && API.fixElement) {

						// TODO: common function to extract effects options

						API.fixElement(el, true, options);
					}

					var hide = function(force, win) {
						if (shown && toast.element) {
							toast.element = null;
							if (force) {
								win.clearTimeout(toast.timer);
							}

							if (!options.onhide || callInContext(options.onhide, options.callbackContext || API) !== false) {
								toast.arranging = el.offsetHeight;

								//var pos = API.getElementPositionStyle(el);
								var pos = toast.destination;

								// FIXME: Core requires a duration to cancel ongoing effect
								if (pos) {
									API.positionElement(el, pos[0], pos[1], { duration:1 });
								}
								showControl(el, false, showOptions, function() {
									toast.arranging = false;
									arrangeToast(position, options, doc);
									if (options.autoDestroy) {
										API.destroyToast(el, win);
										el = null;
									}
								});
							}
						}
						if (!options.autoDestroy) {
							el = null;
						}
						shown = false;
					};

					attachListener(el, 'click', function() {
						if (!options.onclick || callInContext(options.onclick, options.callbackContext || API) !== false ) {
							hide(true, win);
						}						
					});

					toast = addToast(el, position, doc);
					if (!options.onshow || callInContext(options.onshow) !== false) {
						showControl(el, true, showOptions, function() {
							toast.timer = win.setTimeout(function() { hide(false, win); }, options.pause || 5000);
						});
					}

					if (playEventSound && !options.mute) {
						global.setTimeout(function() {
							playEventSound('toast');
						}, options.effects ? options.duration || 0 : 0);
					}

					shown = true;
					
					return el;
				}
				return null;
			};

			if (api.createElement && createElement('div')) {
				api.createToast = function(options, win) {
					var doc = getWindowDocument(win), body = getBodyElement(doc);
					if (!win) {
						win =  global;
					}
					if (!options) {
						options = {};
					}

					var el = createElement('div', doc);
					if (el) {
						if (API.setControlRole) {
							API.setControlRole(el, 'alertdialog');
						}

						el.style.visibility = 'hidden';
						el.style.position = 'absolute';
						el.style.left = el.style.top =  '0';
			
						API.setControlContent(el, options);
						if (options.onopen) {
							callInContext(options.onopen, options.callbackContext || API);
						}

						body.appendChild(el);
						return enhanceToast(el, options, win);
					}
					return null;
				};
				api.destroyToast = function(el, win) {
					var doc;

					if (win) {
						doc = getWindowDocument(win);
					} else {
						doc = getElementDocument(el);
						if (doc == global.document) {
							win = global;
						} else if (getDocumentWindow) {
							win = getDocumentWindow(doc);
						}
					}
					if (win) {
						var toast = findToast(el, doc), body = getBodyElement(doc);
						if (toast) {
							body.removeChild(toast.element);
							win.clearTimeout(toast.timer);
							toast.element = null;
							toast.arranging = false;
							return true;
						}
					}
					return false;
				};
			}
		}

		api = body = null;
	});
}