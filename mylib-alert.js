// My Library Alert add-on
// Requires Event, Center, Scroll, Show and Size modules
// Optionally uses DOM, HTML, Class, Opacity, Drag, Maximize and Full Screen modules and/or the Fix Element add-on

var global = this;
if (this.API && typeof this.API == 'object' && this.API.areFeatures && this.API.areFeatures('attachListener', 'createElement', 'setElementText')) {
	this.API.attachDocumentReadyListener(function() {
		var api = global.API;
		var isHostMethod = api.isHostMethod;
		var canAdjustStyle = api.canAdjustStyle;
		var cancelDefault = api.cancelDefault;
		var createElement = api.createElement;
		var showElement = api.showElement;
		var attachListener = api.attachListener;
		var attachDocumentListener = api.attachDocumentListener;
		var getKeyboardKey = api.getKeyboardKey;
		var attachDrag = api.attachDrag;
		var detachDrag = api.detachDrag;
		var centerElement = api.centerElement;
                var constrainPositionToViewport = api.constrainPositionToViewport;
		var maximizeElement = api.maximizeElement;
		var restoreElement = api.restoreElement;
		var setElementText = api.setElementText;
		var setElementHtml = api.setElementHtml;
		var setElementNodes = api.setElementNodes;
		var setOpacity = api.setOpacity;
		var positionElement = api.positionElement;
		var sizeElement = api.sizeElement;
		var fixElement = api.fixElement;
		var getChildren = api.getChildren;
		var addClass = api.addClass;
		var removeClass = api.removeClass;
		var hasClass = api.hasClass;
		var getElementPositionStyle = api.getElementPositionStyle;
		var getElementSizeStyle = api.getElementSizeStyle;
		var elCaption, elSizeHandle, elSizeHandleH, elSizeHandleV;
		var el = createElement('div');
		var elLabel = createElement('div');
		var elButton = createElement('input');
		var elFieldset = createElement('fieldset');
		var elFixButton, elIconButton, elMaximizeButton, elMinimizeButton, elCloseButton, elHelpButton, elCancelButton, elNoButton, elApplyButton;
		var body = api.getBodyElement();
		var bMaximized, showOptions, dimOptions, shown;
		var preMinimizedDimensions = {};
		var onhelp, onpositive, onnegative, onindeterminate, onsave, onclose, onbeforeclose;
		var bDirty, disableControl, updateSizeHandle, updateSizeHandles, updateMin, updateMaxCaption, updateMaxButton, updateDrag, update, minimize, maximize, restore, sizable, decision;

		if (attachDrag) {
			updateDrag = function(b) {
				((b)?detachDrag:attachDrag)(el, elCaption);
			};
		}

		if (addClass) {
			disableControl = function(el, b) {
				if (arguments.length == 1) { b = true; }
				if (b) {
					addClass(el, 'disabled');
				}
				else {
					removeClass(el, 'disabled');
				}
				if (setOpacity) {
					setOpacity(el, (b)?0.6:1);
				}
			};
		}

		if (disableControl) {
			updateMaxCaption = function(b) {
				if (elCaption) {
					elCaption.title = "Double-click to " + ((b)?'restore':'maximize');
				}
			};

			updateMaxButton = function(b) {
				if (b) {
					removeClass(elMaximizeButton, 'maximizebutton');
					addClass(elMaximizeButton, 'restorebutton');
				} else {
					removeClass(elMaximizeButton, 'restorebutton');
					addClass(elMaximizeButton, 'maximizebutton');
				}
				elMaximizeButton.title = (!b)?'Maximize':'Restore';
			};

			updateMin = function(b) {
				if (elMinimizeButton) {
					disableControl(elMinimizeButton, elLabel.style.display == 'none');
				}

				if (elMaximizeButton) {
					if (b) {
						updateMaxButton(!bMaximized);
						if (sizable && elCaption) { updateMaxCaption(!bMaximized); }
					} else {
						updateMaxButton(bMaximized);
						if (sizable && elCaption) { updateMaxCaption(bMaximized); }
					}
				}
			};

			updateSizeHandle = function(el, b) {
				el.style.visibility = (b)?'hidden':'';
			};

			updateSizeHandles = function(b) {
				if (elSizeHandle) { updateSizeHandle(elSizeHandle, b); }
				if (elSizeHandleH) { updateSizeHandle(elSizeHandleH, b); }
				if (elSizeHandleV) { updateSizeHandle(elSizeHandleV, b); }
			};

			// Called after maximize/restore

			update = function(b) {
				if (sizable) {
					updateSizeHandles(b);
				}
				if (elCaption) {
					if (sizable) {
						updateMaxCaption(b);
					}
					updateDrag(b);
				}

				if (elMaximizeButton) {
					updateMaxButton(b);
				}

				if (elFixButton) {
					disableControl(elFixButton, b);
				}
			};
		}

		function presentControls(b) {
			var i, c, children = getChildren(el);
			i = children.length;

			while (i--) {
				c = children[i];
				if (c != elCloseButton && c != elMinimizeButton && c != elCaption && c != elIconButton && c != elFixButton && c != elMaximizeButton) {
					c.style.display = b ? 'none' : '';
				}
			}
		}

		if (update && maximizeElement) {
			minimize = function(b, bEffects) {
				if (b) {
					preMinimizedDimensions.pos = getElementPositionStyle(el);
					preMinimizedDimensions.dim = getElementSizeStyle(el);
					removeClass(el, 'maximized');
					addClass(el, 'minimized');
					updateDrag(false);
				} else {
					if (!bMaximized) {
						if (elFixButton && hasClass(elFixButton, 'selected') && el.style.position != 'fixed') {
							constrainPositionToViewport(preMinimizedDimensions.pos);
						}
						positionElement(el, preMinimizedDimensions.pos[0], preMinimizedDimensions.pos[1], dimOptions);
						sizeElement(el, preMinimizedDimensions.dim[0], preMinimizedDimensions.dim[1], dimOptions);
					}
					removeClass(el, 'minimized');
					updateDrag(bMaximized);
				}

				presentControls(b);

				if (!b && bMaximized) {
					restoreElement(el);
					maximize(true);			
				}

				if (b) {
					el.style.height = el.style.width = '';
				}
				updateMin(b);
			};

			maximize = function(b) {				
				(b ? maximizeElement : restoreElement)(el, dimOptions, function() {
					(b ? addClass : removeClass)(el, 'maximized');
				});
				update(b);
				bMaximized = b;
			};

			restore = function() {
				if (elLabel.style.display == 'none') {
					minimize(false);
				} else {
					maximize(!bMaximized);
				}
			};
		}

		function positiveCallback() {
			return !onpositive || !onpositive();
		}

		function negativeCallback() {
			return !onnegative || !onnegative();
		}

		function indeterminateCallback() {
			return !onindeterminate || !onindeterminate();
		}

		function makeDecision(b) {
			switch(decision) {
			case'confirm':
			case'yesno':
			case'dialog':
				return (b ? positiveCallback : negativeCallback)();
			case'yesnocancel':
				if (typeof b == 'undefined') {
					return indeterminateCallback(bDirty);
				}
				return (b ? positiveCallback : negativeCallback)();
			}
		}

		function dismiss(bSave) {			
			if (shown) {
				if (bSave) {
					if (onsave && onsave()) {
						return false;
					}
				}
				if (bDirty) {
					if (onbeforeclose && onbeforeclose())  {
						return false;
					}
				}				

				if (!onclose || !onclose(el, showOptions)) {
					showElement(el, false, showOptions);
				}
				shown = false;
				return true;
			}
			return false;
		}

		api.dismissAlert = dismiss;

                api.getAlertElement = function() {
			return el;
		};

		api.setAlertDirty = function(b) {
			if (elApplyButton) {
				elApplyButton.disabled = !b;
			}		
			bDirty = !!b;
		};

		// Need getScrollPosition as centerElement only works for fixed positioned elements without it.

		if (showElement && centerElement && sizeElement && api.getScrollPosition && el && elButton && elFieldset && elLabel && body && isHostMethod(global, 'setTimeout')) {
			if (updateDrag) {
				elCaption = createElement('div');
				if (elCaption) {
					elCaption.className = 'movehandle';
					el.appendChild(elCaption);

					// Must make positionable, else attachDrag (called in updateDrag) won't take

					if (!api.absoluteElement) { el.style.position = 'absolute'; }
					updateDrag(false);

					if (maximize) {
						elMaximizeButton = createElement('div'); 
						if (elMaximizeButton) {
							elMaximizeButton.title = 'Maximize';
							elMaximizeButton.className = 'maximize captionbutton';
							el.appendChild(elMaximizeButton);

							attachListener(elMaximizeButton, 'click', function(e) {
								if (!hasClass(this, 'disabled')) {
									restore();
								}
							});
						}
						attachListener(elCaption, 'dblclick', function(e) {
							if (sizable) {
								restore();
								return cancelDefault(e);
							}
						});
					}

					elIconButton = createElement('div');
					if (elIconButton) {
						elIconButton.className = 'icon';
						attachListener(elIconButton, 'dblclick', function() {
							if (!elCloseButton || !hasClass || !hasClass(elCloseButton, 'disabled')) {
								dismiss(false);
							}
						});
						el.appendChild(elIconButton);
					}
					elCloseButton = createElement('div');
					if (elCloseButton) {
						elCloseButton.className = 'close captionbutton';
						elCloseButton.title = 'Close';
						attachListener(elCloseButton, 'click', function() {
							if (!hasClass || !hasClass(this, 'disabled')) {
								dismiss(false);
							}
						});
						el.appendChild(elCloseButton);
					}
					if (getChildren && canAdjustStyle && canAdjustStyle('display') && minimize) {
						elMinimizeButton = createElement('div');
						if (elMinimizeButton) {
							elMinimizeButton.className = 'minimize captionbutton';
							elMinimizeButton.title = 'Minimize';
							attachListener(elMinimizeButton, 'click', function() {
								if (!hasClass(this, 'disabled')) {
									minimize(true);
								}
							});
							el.appendChild(elMinimizeButton);
						}

					}
					
					if (fixElement && disableControl) {
						elFixButton = createElement('div');
						if (elFixButton) {
							elFixButton.title = 'Fix';
							elFixButton.className = 'fix captionbutton';
							el.appendChild(elFixButton);
							attachListener(elFixButton, 'click', function(e) {
								if (!hasClass(this, 'disabled')) {
									if (!hasClass(this, 'selected')) {
										addClass(this, 'selected');
										this.title = 'Detach';
										fixElement(el, true, dimOptions);
									} else {
										removeClass(this, 'selected');
										this.title = 'Fix';
										fixElement(el, false, dimOptions);
									}
								}
							});
						}
					}

					if (sizeElement) {
						elSizeHandleH = createElement('div');
						if (elSizeHandleH) {
							elSizeHandleH.className = 'sizehandleh';
							el.appendChild(elSizeHandleH);
							attachDrag(el, elSizeHandleH, { mode:'size',axes:'horizontal' });
						}
						elSizeHandleV = createElement('div');
						if (elSizeHandleV) {
							elSizeHandleV.className = 'sizehandlev';
							el.appendChild(elSizeHandleV);
							attachDrag(el, elSizeHandleV, { mode:'size',axes:'vertical' });
						}
						elSizeHandle = createElement('div');
						if (elSizeHandle) {
							elSizeHandle.className = 'sizehandle';
							el.appendChild(elSizeHandle);
							attachDrag(el, elSizeHandle, { mode:'size' });
						}
					}
				}
			}

			elLabel.className = 'content';
			el.appendChild(elLabel);

			elButton.type = 'button';
			elButton.value = 'Close';
			elFieldset.appendChild(elButton);

			elNoButton = createElement('input');
			if (elNoButton) {
				elNoButton.type = 'button';
				elNoButton.value = 'No';
				elFieldset.appendChild(elNoButton);
			}

			elCancelButton = createElement('input');
			if (elCancelButton) {
				elCancelButton.type = 'button';
				elCancelButton.value = 'Cancel';
				elFieldset.appendChild(elCancelButton);
			}

			elApplyButton = createElement('input');
			if (elApplyButton) {
				elApplyButton.type = 'button';
				elApplyButton.value = 'Apply';
				elFieldset.appendChild(elApplyButton);
			}

			elHelpButton = createElement('input');
			if (elHelpButton) {
				elHelpButton.type = 'button';
				elHelpButton.value = 'Help';
				elFieldset.appendChild(elHelpButton);
			}

			el.appendChild(elFieldset);

			el.style.position = 'absolute';
			showElement(el, false);
			positionElement(el, 0, 0);
			attachListener(elButton, 'click', function() {
				if (!decision || makeDecision(true)) {
					dismiss(bDirty);
				}
			});
			body.appendChild(el);

			if (attachDocumentListener && getKeyboardKey) {
				attachDocumentListener('keyup', function(e) {
					if (shown) {
						switch(getKeyboardKey(e)) {
						case 27:
							if (!elCloseButton || !hasClass || !hasClass(elCloseButton, 'disabled') || makeDecision()) {
								dismiss(false);
								return cancelDefault(e);
							}
							break;
						case 13:
							if (!decision || makeDecision(true)) {
								dismiss(bDirty);
								return cancelDefault(e);
							}
						}
					}
				});
			}

			if (elHelpButton) {
				attachListener(elHelpButton, 'click', function() {
					if (onhelp) { onhelp(); }
				});
			}

			if (elCancelButton) {
				attachListener(elCancelButton, 'click', function() {
					if (makeDecision()) {
						dismiss(false);
					}
				});
			}

			if (elNoButton) {
				attachListener(elNoButton, 'click', function() {
					if (makeDecision(false)) {
						dismiss(false);
					}
				});
			}

			if (elApplyButton) {
				attachListener(elApplyButton, 'click', function() {
					if (!onsave || !onsave()) {
						bDirty = false;
						this.disabled = true;
					}
				});
			}
			
			api.alert = function(sText, options, fnShow, fnHide) {
				var dummy, title, hasTitle;

				options = options || {};
				showOptions = options;
				dimOptions = { duration:options.duration,ease:options.ease };
				decision = options.decision;

				// TODO: Should add/remove extra buttons, not set display style

				if (elHelpButton) {
					onhelp = options.onhelp;
					elHelpButton.style.display = (onhelp)? '' : 'none';
				}

				if (elCancelButton) {
					elCancelButton.style.display = (options.decision && options.decision != 'yesno')? '' : 'none';
				}

				if (elNoButton) {
					elNoButton.style.display = (options.decision == 'yesno' || options.decision == 'yesnocancel')? '' : 'none';
				}

				if (elCloseButton && disableControl) {
					disableControl(elCloseButton, options.decision && options.decision != 'dialog');
				}

				if (elIconButton) {
					elIconButton.title = options.decision ? '' : 'Double-click to close';
				}

				onpositive = options.onpositive;
				onindeterminate = options.onindeterminate;
				onnegative = options.onnegative;

				bDirty = false;

				if (elApplyButton) {
					elApplyButton.disabled = !bDirty;
					onsave = options.onsave;
					onbeforeclose = options.onbeforeclose;
					elApplyButton.style.display = (options.onsave && options.decision == 'dialog')?'':'none';
				}				

				elButton.value = (options.decision)?((options.decision.indexOf('yes') != -1)?'Yes':options.buttonCaption || 'OK'):'Close';

				if (elCaption) {
					title = options.title;
					hasTitle = typeof title == 'string';
					if (hasTitle) {
						elCaption.style.display = '';
						setElementText(elCaption, title);
					} else {
						elCaption.style.display = 'none';
					}
				}
				onclose = fnHide || options.onclose;
				showElement(el, false);
				if (!bMaximized && options.shrinkWrap !== false) {
					el.style.height = '';
					el.style.width = '';
				}
				if (setElementHtml && options.html) {
					setElementHtml(elLabel, options.html);
				} else if (setElementNodes && options.nodes) {
					setElementNodes(elLabel, options.nodes);
				} else {
					if (sText !== null) { setElementText(elLabel, sText); }
				}

				el.className = options.className || 'alert';

				sizable = options.sizable !== false;

				if (addClass) {
					(options.decision ? addClass : removeClass)(el, 'decision');
					if (maximize) {
						if (!sizable) {
							if (elCaption) {
								elCaption.title = '';
							}
							removeClass(el, 'maximizable');
						} else {
							updateMaxCaption(bMaximized);
							addClass(el, 'maximizable');
						}
					}
				}

				el.style.display = 'block';

				if (elLabel.style.display == 'none') {
					presentControls(false);
					if (bMaximized) {
						restoreElement(el);
						maximizeElement(el, null, function() {
							addClass(el, 'maximized');
						});
					}
					updateMin(false);
				}

				if (updateSizeHandles) {
					updateSizeHandles(!sizable);
				}

				if (elMaximizeButton) {
					elMaximizeButton.style.visibility = (sizable && hasTitle) ? '' : 'hidden';
				}

				if (elMinimizeButton) {
					elMinimizeButton.style.visibility = (sizable && hasTitle) ? '' : 'hidden';
				}

				if (elCloseButton) {
					elCloseButton.style.visibility = hasTitle ? '' : 'hidden';
				}

				if (sizeElement) {

					// NOTE: So called shrink-wrapping cross-browser is a bad proposition

					if (options.shrinkWrap !== false) {
						if (!bMaximized) {
							// Hack for FF1
							el.style.height = '1px';
							dummy = el.offsetHeight;
							el.style.height = '';
						}
						// (Harmless) mystical incantation causes the browser to adjust the offsetHeight/Width properties
						// Assignment would likely work as well
						dummy = el.clientLeft;
					}

					var dim = getElementSizeStyle(el);
					if (dim) {
						sizeElement(el, dim[0], dim[1]);
					}
				}
				if (shown || !fnShow || !fnShow(el, options, bMaximized)) {
					if (shown) {
						if (!elFixButton || elFixButton.className.indexOf('selected') == -1) { global.setTimeout(function() { centerElement(el, { duration:options.duration, ease:options.ease, fps:options.fps }); }, 10); } // FireFox issue with resize/center animation
						showElement(el);
					} else {
						if (!bMaximized) {
							centerElement(el);
						} else {
							maximizeElement(el, null, function() {
								addClass(el, 'maximized');
							});
						}
						showElement(el, true, options);
					}
				}
				if (!shown && elButton && isHostMethod(elButton, 'focus')) { global.setTimeout(function() { if (el.style.visibility == 'visible' && elLabel.style.display != 'none') { elButton.focus(); } }, options.duration || 0); }
				shown = true;
			};
		}
		elFieldset = body = api = null;
	});
}