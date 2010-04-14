/* My Library Alert Widget
   Requires Widgets add-on
   Requires Event, Center, Scroll, Show and Size modules
   Optionally uses DOM, HTML, Class, Cover Document, Drag, Maximize and Full Screen modules and/or the Fix Element extension */

var API, global = this;
if (API && typeof API == 'object' && API.areFeatures && API.areFeatures('attachListener', 'createElement', 'setElementText', 'setControlState')) {
	API.attachDocumentReadyListener(function() {
		var api = API;
		var isHostMethod = api.isHostMethod;
		var canAdjustStyle = api.canAdjustStyle;
		var cancelDefault = api.cancelDefault;
		var createElement = api.createElement;
		var showElement = api.showElement;
		var attachListener = api.attachListener;
		var attachDocumentListener = api.attachDocumentListener;
		var getEventTarget = api.getEventTarget, getEventTargetRelated = api.getEventTargetRelated;
		var getKeyboardKey = api.getKeyboardKey;
		var attachDrag = api.attachDrag, attachDragToControl = api.attachDragToControl;
		var detachDragFromControl = api.detachDragFromControl;
		var centerElement = api.centerElement;
		var coverDocument = api.coverDocument;
                var constrainPositionToViewport = api.constrainPositionToViewport;
		var maximizeElement = api.maximizeElement;
		var restoreElement = api.restoreElement;
		var setElementText = api.setElementText;
		var setElementHtml = api.setElementHtml;
		var setElementNodes = api.setElementNodes;
		var positionElement = api.positionElement;
		var sizeElement = api.sizeElement;
		var fixElement = api.fixElement;
		var getChildren = api.getChildren;
		var addClass = api.addClass;
		var removeClass = api.removeClass;
		var hasClass = api.hasClass;
		var getElementPositionStyle = api.getElementPositionStyle;
		var getElementSizeStyle = api.getElementSizeStyle;
		var getElementParentElement = api.getElementParentElement;
		var makeElementUnselectable = api.makeElementUnselectable;
		var callInContext = api.callInContext;
		var elCaption, elSizeHandle, elSizeHandleH, elSizeHandleV;
		var elCurtain, el = createElement('div');
		var elLabel = createElement('div');
		var elButton = createElement('input');
		var elFieldset = createElement('fieldset');
		var elFixButton, elIconButton, elMaximizeButton, elMinimizeButton, elCloseButton, elHelpButton, elCancelButton, elNoButton, elApplyButton;
		var body = api.getBodyElement();
		var isMaximized, showOptions, dimOptions, curtainOptions, shown;
		var preMinimizedDimensions = {};
		var onhelp, onpositive, onnegative, onindeterminate, onsave, onclose, onhide, oniconclick, onactivate, ondeactivate, onfocus, onblur, ondragstart, ondrop, onmaximize, onminimize, onrestore, callbackContext;
		var isDirty, isInBackground, isModal, focusAlert, focusTimer, isCaptionButton, presentControls, updateSizeHandle, updateSizeHandles, updateMin, updateMaxCaption, updateMaxButton, updateDrag, update, minimize, maximize, restore, sizable, maximizable, minimizable, decision, showButtons;
		var setRole = api.setControlRole, setProperty = api.setWaiProperty, removeProperty = api.removeWaiProperty;
		var disableControl = api.disableControl, isDisabled = api.isControlDisabled, checkControl = api.checkControl, isChecked = api.isControlChecked, showControl = api.showControl;
		var activateAlert, deactivateAlert, attachActivationListeners;

		var callback = function(fn, arg1, arg2, arg3) {
			return callInContext(fn, callbackContext || API, arg1 || el, arg2, arg3);
		};

		var captionButtonTitle = function(title, accelerator) {
			return title + (accelerator ? ' [Ctrl+' + accelerator + ']' : '');
		};

		var disableAlertControl = function(el, b) {
			disableControl(el, b);
		};

		var appendCaptionButton = function(title, accelerator) {
			var elButton = createElement('div'); 
			if (elButton) {
				elButton.title = captionButtonTitle(title, accelerator);
				elButton.className = title.toLowerCase() + ' button captionbutton';

				if (setRole) {
					setRole(elButton, 'button');
				}

				el.appendChild(elButton);
			}
			return elButton;
		};

		var appendCommandButton = function(name) {
			var elButton = createElement('input');
			if (elButton) {
				elButton.className = 'commandbutton button';
				elButton.type = 'button';
				elButton.value = name;
				elFieldset.appendChild(elButton);
				if (attachActivationListeners) {
					attachActivationListeners(elButton);
				}
			}
			return elButton;
		};
		
		if (attachDragToControl) {
			updateDrag = function(b) {
				(b ? detachDragFromControl : attachDragToControl)(el, elCaption, { ondragstart:ondragstart, ondrop:ondrop });
			};
		}
	
		var showCurtain = function(b) {
			if (b) {
				elCurtain.style.display = 'block';
				coverDocument(elCurtain);
				if (addClass) {

					// TODO: Create ease classes to correspond to stock easing functions

					if (curtainOptions.ease) {
						addClass(elCurtain, 'ease');						
						addClass(elCurtain, 'in');
						removeClass(elCurtain, 'out');
					} else {
						removeClass(elCurtain, 'ease');
					}
				}
				if (addClass) {
					addClass(elCurtain, 'drawn');
				}
				curtainOptions.keyClassName = 'drawn';
				showControl(elCurtain, true, curtainOptions);
				//showElement(elCurtain, true, curtainOptions);
			} else {
				if (removeClass) {
					removeClass(elCurtain, 'drawn');
					if (showOptions.ease) {
						removeClass(elCurtain, 'in');
						addClass(elCurtain, 'out');
					}
				}
				showElement(elCurtain, false, { removeOnHide:true });
				if (removeClass) {
					removeClass(elCurtain, 'animated');
				}
			}
		};

		updateMaxCaption = function(b) {
			if (elCaption) {
				if (maximizable) {
					elCaption.title = "Double-click to " + (b ? 'restore' : 'maximize');
				} else if (elMinimizeButton) {
					elCaption.title = b ? 'Double-click to restore' : '';	
				}
			}
		};

		updateMaxButton = function(b) {
			if (addClass) {
				if (b) {
					removeClass(elMaximizeButton, 'maximizebutton');
					addClass(elMaximizeButton, 'restorebutton');
				} else {
					removeClass(elMaximizeButton, 'restorebutton');
					addClass(elMaximizeButton, 'maximizebutton');
				}
			}
			elMaximizeButton.title = captionButtonTitle(!b ? 'Maximize' : 'Restore', '.');
			if (isDisabled(elMaximizeButton)) {
				elMaximizeButton.title += ' (disabled)';
			}
		};

		updateMin = function(b) {
			if (elMinimizeButton) {
				disableAlertControl(elMinimizeButton, b);
			}

			if (elMaximizeButton) {
				disableAlertControl(elMaximizeButton, !b && !maximizable);
			}

			if (elMaximizeButton) {
				if (b) {
					updateMaxButton(!isMaximized);
					if (sizable && elCaption) { updateMaxCaption(!isMaximized); }
				} else {
					updateMaxButton(isMaximized);
					if (sizable && elCaption) { updateMaxCaption(isMaximized); }
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
				disableAlertControl(elFixButton, b);
			}
		};

		if (maximizeElement) {
			if (hasClass) {
				isCaptionButton = function(el) {
				  return hasClass(el, 'captionbutton');
				};
			} else {
				isCaptionButton = function(el) {
					return el == elMinimizeButton || el == elMaximizeButton || el == elCloseButton || el == elFixButton;
				};
			}

			presentControls = function(b) {
				var i, c, children = getChildren(el);
				i = children.length;

				while (i--) {
					c = children[i];
					if (!isCaptionButton(c) && c != elCaption && c != elIconButton) {
						c.style.display = (b || (c == elFieldset && !showButtons)) ? 'none' : '';
					}
				}
			};

			var minimizeCallback = function() {
				if (focusAlert) {
					global.setTimeout(focusAlert, 10);
				}
			};

			minimize = function(b, bEffects) {				
				if (b) {
					preMinimizedDimensions.pos = getElementPositionStyle(el);
					preMinimizedDimensions.dim = getElementSizeStyle(el);
					if (addClass) {
						removeClass(el, 'maximized');
						addClass(el, 'minimized');
					}
					if (elCaption) {
						updateDrag(false);
					}
					if (b && onminimize) {
						callback(onminimize);
					}
				} else {
					if (!isMaximized) {
						if (elFixButton && isChecked(elFixButton) && el.style.position != 'fixed') {
							constrainPositionToViewport(preMinimizedDimensions.pos);
						}
						positionElement(el, preMinimizedDimensions.pos[0], preMinimizedDimensions.pos[1], dimOptions);
						sizeElement(el, preMinimizedDimensions.dim[0], preMinimizedDimensions.dim[1], dimOptions, minimizeCallback);
						if (!sizeElement.async) {
							minimizeCallback();
						}
					}
					if (removeClass) {
						removeClass(el, 'minimized');
					}
					if (elCaption) {
						updateDrag(isMaximized);
					}
				}

				presentControls(b);

				if (!b && isMaximized) {
					restoreElement(el);
					maximize(true);
				}

				if (b) {
					el.style.height = el.style.width = '';
				}
				updateMin(b);
			};

			maximize = function(b) {
				var maximizeCallback = function() {
					if (addClass) {
						(b ? addClass : removeClass)(el, 'maximized');
					}
					if (focusAlert) {
						global.setTimeout(focusAlert, 10);
					}
				};

				(b ? maximizeElement : restoreElement)(el, dimOptions, maximizeCallback);
				update(b);
				if (b && onmaximize) {
					callback(onmaximize);
				}
				isMaximized = b;				
				if (!maximizeElement.async) {
					maximizeCallback();
				}
			};

			restore = function() {
				var result;
				if (elMinimizeButton && minimizable && preMinimizedDimensions.dim && isDisabled(elMinimizeButton)) {
					minimize(false);					
					result = true;
				} else if (isMaximized) {
					maximize(false);
					result = true;
				} else {
					result = false;
				}
				if (result && onrestore) {
					callback(onrestore);
				}
				return result;
			};
			api.maximizeAlert = function() {
				if (!isMaximized) {
					maximize(true);
					return true;
				}
				return false;
			};
			api.restoreAlert = restore;
			api.minimizeAlert = function() {
				if (elMinimizeButton && minimizable && !isDisabled(elMinimizeButton)) {
					minimize(true);
					return true;
				}
				return false;
			};
		}

		function positiveCallback() {
			return !onpositive || !callback(onpositive);
		}

		function negativeCallback() {
			return !onnegative || !callback(onnegative);
		}

		function indeterminateCallback() {
			return !onindeterminate || !callback(onindeterminate);
		}

		function makeDecision(b) {
			switch(decision) {
			case'confirm':
			case'yesno':
			case'dialog':
				return (b ? positiveCallback : negativeCallback)();
			case'yesnocancel':
				if (typeof b == 'undefined') {
					return indeterminateCallback();
				}
				return (b ? positiveCallback : negativeCallback)();
			}
		}

		function hideAlert() {
			if (elCurtain) {
				showCurtain(false);
			}
			showElement(el, false, showOptions);
		}

		/*
		Return true from onshow/hide to take responsibility for showing/hiding the alert element
		Return false from onclose or onsave to stop the dismissal
		Returns boolean result
		*/

		function dismiss(isSaving) {
			var good, result;

			if (shown) {
				if (isSaving) {
					if (onsave && callback(onsave) === false) {
						return false;
					}
				}

				if (onclose && callback(onclose) === false) {
					return false;
				}

				if (!onhide) {
					hideAlert();
					good = true;					
				} else {
					result = callback(onhide, showOptions);
					if (typeof result == 'undefined') {
						hideAlert();
						good = true;
					} else {
						good = result;
					}
				}
				if (good) {
					shown = false;
				}
				return !shown;				
			}
			return false;
		}


		// Need getScrollPosition as centerElement only works for fixed positioned elements without it.

		if (showElement && centerElement && sizeElement && api.getScrollPosition && el && elButton && elFieldset && elLabel && body && isHostMethod(global, 'setTimeout')) {

			api.dismissAlert = dismiss;

	                api.getAlertElement = function() {
				return el;
			};

			api.isAlertOpen = function() {
				return shown;
			};

			api.isAlertModal = function() {
				return shown && !isModal;
			};

			api.deactivateAlert = deactivateAlert = function() {
				if (addClass) {
					addClass(el, 'background');
				}
				if (ondeactivate) {
					callback(ondeactivate);
				}
				isInBackground = true;
			};
			api.activateAlert = activateAlert = function() {
				if (removeClass) {
					removeClass(el, 'background');
				}
				if (onactivate) {
					callback(onactivate);
				}
				isInBackground = false;
			};

			if (isHostMethod(elButton, 'focus')) {
				attachActivationListeners = function(el) {
					attachListener(el, 'focus', function(e) {
						if (focusTimer) {
							global.clearTimeout(focusTimer);
						}
						var elTarget = getEventTargetRelated(e);
						var elRelated = elTarget;
						while (elTarget && elTarget != elFieldset) {
							elTarget = getElementParentElement(elTarget);
						}
						var doActivate = true;
						if (!elTarget && onfocus) {
							doActivate = callback(onfocus, el, elRelated) !== false;
						}
						if (doActivate) {
							activateAlert();
						} else {
							this.blur();
							return cancelDefault(e);
						}
					});
					attachListener(el, 'blur', function(e) {
						if (!isModal) {
							focusTimer = global.setTimeout(function() {
								var doActivate = true;
								if (onblur) {
									doActivate = callback(onblur, el, getEventTargetRelated(e)) !== false;
								}
								if (doActivate) {
									if (!elMinimizeButton || !minimizable || !isDisabled(elMinimizeButton)) {
										deactivateAlert();
									}
								} else {
									this.focus();
									return cancelDefault(e);
								}
							}, 100);
						}
					});
				};
			}

			if (attachActivationListeners) {
				attachActivationListeners(elButton);
			}

			api.focusAlert = focusAlert = function() {
				if (shown && el.style.visibility == 'visible' && elFieldset.style.display != 'none') {
					elButton.focus();
				}
				if (activateAlert) {
					activateAlert();
				}
			};

			var blurIfPossible = function(el) {
				if (!el.disabled && elCancelButton.style.display != 'none') {
					el.blur();
				}
			};

			api.blurAlert = function() {
				if (el.style.visibility == 'visible' && elFieldset.style.display != 'none') {
					elButton.blur();
					if (elCancelButton) {
						blurIfPossible(elCancelButton);
					}
					if (elNoButton) {
						blurIfPossible(elNoButton);
					}
					if (elApplyButton) {
						blurIfPossible(elApplyButton);
					}
					if (elHelpButton) {
						blurIfPossible(elHelpButton);
					}
				}
				if (deactivateAlert) {
					deactivateAlert();
				}
			};

			attachListener(el, 'click', function(e) {
				var doFocus;
				if (focusTimer) {
					global.clearTimeout(focusTimer);
					focusTimer = null;
				}
				if (isInBackground) {
					activateAlert();
					doFocus = true;
				}
				var elTarget = getEventTarget(e);

				if (doFocus && focusAlert && (elTarget == this || elTarget == elLabel || elTarget == elFieldset || elTarget == elIconButton || elTarget == elCaption || elTarget == elSizeHandle || elTarget == elSizeHandleH || elTarget == elSizeHandleV)) {
					focusAlert();
				}
			});

			api.setAlertDirty = function(b, external) {
				if (decision == 'dialog') {
					if (typeof external == 'boolean') {
						elButton.value = b ? 'Close' : 'OK';
						if (elCancelButton) {
							elCancelButton.disabled = b;
						}
					}
					if (elApplyButton) {
						elApplyButton.disabled = !b;
					}
					isDirty = b;
				}
			};

			api.isAlertModal = function() {
				return shown && isModal;
			};

			if (coverDocument) {
				elCurtain = createElement('div');
				elCurtain.className = 'curtain';
				elCurtain.style.display = 'none';
				elCurtain.style.visibility = 'hidden';
			}


			if (setProperty) {
				elLabel.id = 'mylibalertcontent';			
			}

			if (updateDrag) {
				elCaption = createElement('div');
				if (elCaption) {
					elCaption.className = 'movehandle';
					el.appendChild(elCaption);

					if (makeElementUnselectable) {
						makeElementUnselectable(elCaption);
					}
					
					el.style.position = 'absolute';
					
					updateDrag(false);

					if (maximize) {
						elMaximizeButton = appendCaptionButton('Maximize', '.'); 
						if (elMaximizeButton) {
							attachListener(elMaximizeButton, 'click', function(e) {
								if (maximizable || !isDisabled(this)) {
									if (!restore()) {
										maximize(true);
									}
								}
							});
						}
						attachListener(elCaption, 'dblclick', function(e) {
							if (maximizable || !isDisabled(elMaximizeButton)) {
								if (!restore()) {
									maximize(true);
								}
								return cancelDefault(e);
							}
						});
					}

					elIconButton = createElement('div');
					if (elIconButton) {
						elIconButton.className = 'icon';
						if (setRole) {
							setRole(elIconButton, 'button');
						}
						attachListener(elIconButton, 'dblclick', function() {
							if (!elCloseButton || !isDisabled(elCloseButton)) {
								dismiss(false);
							}
						});
						attachListener(elIconButton, 'click', function() {
							if (oniconclick) {
								callback(oniconclick);
							}
						});
						el.appendChild(elIconButton);
					}
					elCloseButton = appendCaptionButton('Close');
					if (elCloseButton) {
						attachListener(elCloseButton, 'click', function() {
							if (!isDisabled(this)) {
								dismiss(false);
							}
						});
					}
					if (getChildren && canAdjustStyle && canAdjustStyle('display') && minimize) {
						elMinimizeButton = appendCaptionButton('Minimize', ',');
						if (elMinimizeButton) {
							attachListener(elMinimizeButton, 'click', function() {
								if (!isDisabled(this)) {
									minimize(true);
								}
							});
						}
					}
					
					if (fixElement) {
						elFixButton = appendCaptionButton('Fix');
						if (elFixButton) {
							checkControl(elFixButton, false);
							attachListener(elFixButton, 'click', function(e) {
								if (!isDisabled(this)) {
									if (!isChecked(this)) {
										checkControl(this);
										if (addClass) {
											addClass(el, 'fixed');
										}
										this.title = 'Detach';
										fixElement(el, true, dimOptions);
									} else {
										checkControl(this, false);
										if (removeClass) {
											removeClass(el, 'fixed');
										}
										this.title = 'Fix';
										fixElement(el, false, dimOptions);
									}
									if (focusAlert) {
										global.setTimeout(focusAlert, 10);
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
			elButton.className = 'commandbutton close';
			elFieldset.appendChild(elButton);

			elNoButton = appendCommandButton('No');
			elCancelButton = appendCommandButton('Cancel');
			elApplyButton = appendCommandButton('Apply');
			elHelpButton = appendCommandButton('Help');

			el.appendChild(elFieldset);

			el.style.position = 'absolute';
			showElement(el, false);
			positionElement(el, 0, 0);
			attachListener(elButton, 'click', function() {
				if (!decision || makeDecision(true)) {
					dismiss(isDirty);
				}
			});
			if (elCurtain) {
				body.appendChild(elCurtain);
				if (focusAlert) {
					attachListener(elCurtain, 'click', function() {
						focusAlert();
					});
				}
			}
			body.appendChild(el);

			if (attachDocumentListener && getKeyboardKey) {
				attachDocumentListener('keyup', function(e) {
					var elTarget, key, targetTagName ;

					if (shown && !e.shiftKey && !e.metaKey && !isInBackground) {
						key = getKeyboardKey(e);
						switch(key) {
						case 27:
							if (!e.ctrlKey) {
								if (!elCloseButton || !isDisabled(elCloseButton) || makeDecision()) {
									dismiss(false);
									return cancelDefault(e);
								}
							}
							break;
						case 13:
							if (!e.ctrlKey) {
								elTarget = getEventTarget(e);
								targetTagName = elTarget.tagName;

								if (elTarget.type == 'text' && /^input$/i.test(targetTagName)) {

									while (elTarget && elTarget != elFieldset) {
										elTarget = getElementParentElement(elTarget);
									}
									if (elTarget && (!decision || makeDecision(true))) {
										dismiss(isDirty);
										return cancelDefault(e);
									}
								}
							}
							break;
						default:
							if (maximize && sizable && e.ctrlKey) {
								switch(key) {
								case 190:
									if (maximizable && !restore()) {
										maximize(true);
									}
									break;
								case 188:
									if (minimizable && elMinimizeButton && !isDisabled(elMinimizeButton)) {
										minimize(true);
									}
								}
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
					if (!onsave || callback(onsave) !== false) {
						isDirty = false;
						this.disabled = true;
						if (elButton.value == 'Close') {
							elButton.value = 'OK';
							if (elCancelButton) {
								elCancelButton.disabled = false;
							}
						}
					}
				});
			}
			
			api.alert = function(sText, options) {
				var dummy, captionButtons, icon, title, hasTitle, oldLeft, oldTop;

				options = options || {};
				if (options.effects && typeof options.duration == 'undefined') {
					options.duration = 400;
				}

				showOptions = options;
				dimOptions = { duration:options.duration,ease:options.ease,fps:options.fps };
				curtainOptions = options.curtain || {};
				decision = options.decision;
				showButtons = options.buttons !== false;
				captionButtons = options.captionButtons !== false;
				icon = options.icon !== false;

				if (setRole) {
					setRole(el, decision == 'dialog' ? 'dialog' : 'alertdialog');
					if (decision == 'dialog') {
						removeProperty(el, 'described-by');
					} else {
						setProperty(el, 'described-by', 'mylibalertcontent');
					}
				}

				// TODO: Should add/remove extra buttons, not set display style

				if (elHelpButton) {
					onhelp = options.onhelp;
					elHelpButton.style.display = (onhelp)? '' : 'none';
				}

				if (elCancelButton) {
					elCancelButton.style.display = (decision && decision != 'yesno')? '' : 'none';
				}

				if (elNoButton) {
					elNoButton.style.display = (decision == 'yesno' || decision == 'yesnocancel')? '' : 'none';
				}

				if (elCloseButton) {
					disableAlertControl(elCloseButton, !!decision && decision != 'dialog');
				}

				if (elIconButton) {
					elIconButton.title = decision ? '' : 'Double-click to close';

					if (setRole) {
						setRole(elIconButton, decision ? '' : 'button');
					}

					elIconButton.style.visibility = (!captionButtons || !icon || !addClass) ? 'hidden' : '';
				}

				onpositive = options.onpositive;
				onindeterminate = options.onindeterminate;
				onnegative = options.onnegative;
				oniconclick = options.oniconclick;
				onfocus = options.onfocus;
				onblur = options.onblur;
				onactivate = options.onactivate;
				ondeactivate = options.ondeactivate;
				onmaximize = options.onmaximize;
				onminimize = options.onminimize;
				onrestore = options.restore;
				ondragstart = options.ondragstart;
				ondrop = options.ondrop;
				callbackContext = options.callbackContext;

				isDirty = false;

				elButton.value = 'OK';

				if (elCancelButton) {
					elCancelButton.disabled = false;
				}

				if (elApplyButton) {
					elApplyButton.disabled = true;
					onsave = options.onsave;
					elApplyButton.style.display = (options.onsave && decision == 'dialog') ? '' : 'none';
				}				

				elButton.value = decision ? ((decision.indexOf('yes') != -1) ? 'Yes' : 'OK') : 'Close';

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

				if (elFieldset) {
					elFieldset.style.display = showButtons ? '' : 'none';
				}

				onclose = options.onclose;
				onhide = options.onhide || arguments[3];

				var fnShow, onopen = options.onopen;
				if (!fnShow) {
					fnShow = options.onshow || arguments[2];
				}
				showElement(el, false);
				if (!isMaximized && options.shrinkWrap !== false) {
					el.style.height = '';
					el.style.width = '';
				}

				if (elCurtain) {
					var wasModal = isModal;
					isModal = options.modal;
					if (!shown || isModal != wasModal) {
						showCurtain(options.modal);
					}
				}

				el.className = (options.className || 'alert') + ' popup window';

				if (!shown) {
					oldLeft = el.style.left;
					oldTop = el.style.top;
					el.style.left = el.style.top = '0';
				}

				if (setElementHtml && options.html) {
					setElementHtml(elLabel, options.html);
				} else if (setElementNodes && options.nodes) {
					setElementNodes(elLabel, options.nodes);
				} else {
					setElementText(elLabel, sText || '');
				}

				sizable = options.sizable !== false;

				maximizable = sizable && options.maximizable !== false;
					
				if (addClass) {
					if (maximize) {
						removeClass(el, 'nomaxminbuttons');
						(sizable ? addClass : removeClass)(el, 'maxminbuttons');
					} else {
						addClass(el, 'nomaxminbuttons');
					}

					if (captionButtons) {
						(icon ? addClass : removeClass)(el, 'iconic');
						removeClass(el, 'nocaptionbuttons');
					} else {
						addClass(el, 'nocaptionbuttons');
					}

					if (fixElement && options.fixable !== false) {
						addClass(el, 'fixable');
					}
				}
				
				el.style.display = 'block';

				if (presentControls && minimizable && elMinimizeButton && isDisabled(elMinimizeButton)) {
					presentControls(false);
					if (isMaximized) {
						restoreElement(el);
						if (maximizable) {
							maximizeElement(el, null, function() {
								if (addClass) {
									addClass(el, 'maximized');
								}
							});
						} else {
							isMaximized = false;
						}
						update(isMaximized);
					}
					updateMin(false);
				}

				if (elMaximizeButton) {
					if (sizable && maximize && maximizable) {
						disableAlertControl(elMaximizeButton, false);
					} else {
						disableAlertControl(elMaximizeButton);
						if (isMaximized) {
							restoreElement(el);
							isMaximized = false;
						}						
					}
					update(!!isMaximized);
				}

				if (sizable) {
					minimizable = options.minimizable !== false;
				}

				if (elMinimizeButton) {
					if (sizable && minimize && minimizable) {
						disableAlertControl(elMinimizeButton, false);
					} else {
						disableAlertControl(elMinimizeButton);
					}
				}

				if (updateSizeHandles) {
					updateSizeHandles(!sizable || isMaximized);
				}

				if (elFixButton) {
					elFixButton.style.visibility = (options.fixable !== false && hasTitle && captionButtons) ? '' : 'hidden';
				}

				if (elMaximizeButton) {
					elMaximizeButton.style.visibility = (sizable && hasTitle && captionButtons) ? '' : 'hidden';
				}

				if (elMinimizeButton) {
					elMinimizeButton.style.visibility = (sizable && hasTitle && captionButtons) ? '' : 'hidden';
				}

				if (elCloseButton) {
					elCloseButton.style.visibility = (hasTitle && captionButtons) ? '' : 'hidden';
				}				

				if (sizeElement) {

					// NOTE: So called shrink-wrapping cross-browser is a bad proposition

					if (options.shrinkWrap !== false) {
						if (!isMaximized) {
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
				if (!shown) {
					el.style.left = oldLeft;
					el.style.top = oldTop;
				}
				if (onopen) {
					callback(onopen);
				}
				isInBackground = options.background;
				if (isInBackground) {
					deactivateAlert();
				}
				if (shown || !fnShow || !callback(fnShow, el, options, isMaximized)) {
					if (shown) {
						if (!elFixButton || !isChecked(elFixButton)) {
							global.setTimeout(function() {
								centerElement(el, { duration:options.duration, ease:options.ease, fps:options.fps }, function() { if (focusAlert) { focusAlert(); } });
							}, 10);
						}
						showElement(el);						
					} else {
						if (!isMaximized) {
							centerElement(el);
						} else {
							restoreElement(el);
							maximizeElement(el, null, function() {
								if (addClass) {
									addClass(el, 'maximized');
								}
							});
						}
						showElement(el, true, options);
					}
				}
				if (!shown && elButton && isHostMethod(elButton, 'focus')) {
					global.setTimeout(focusAlert, options.duration || 0);
				}
				shown = true;
			};
		}
		body = api = null;
	});
}