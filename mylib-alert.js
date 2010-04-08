/* My Library Alert add-on
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
		var getEventTarget = api.getEventTarget;
		var getKeyboardKey = api.getKeyboardKey;
		var attachDrag = api.attachDrag;
		var detachDrag = api.detachDrag;
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
		var elCaption, elSizeHandle, elSizeHandleH, elSizeHandleV;
		var elCurtain, el = createElement('div');
		var elLabel = createElement('div');
		var elButton = createElement('input');
		var elFieldset = createElement('fieldset');
		var elFixButton, elIconButton, elMaximizeButton, elMinimizeButton, elCloseButton, elHelpButton, elCancelButton, elNoButton, elApplyButton;
		var body = api.getBodyElement();
		var bMaximized, showOptions, dimOptions, shown;
		var preMinimizedDimensions = {};
		var onhelp, onpositive, onnegative, onindeterminate, onsave, onclose;
		var bDirty, focusAlert, isCaptionButton, presentControls, updateSizeHandle, updateSizeHandles, updateMin, updateMaxCaption, updateMaxButton, updateDrag, update, minimize, maximize, restore, sizable, maximizable, minimizable, decision, showButtons;
		var setRole = api.setControlRole, setProperty = api.setWaiProperty, removeProperty = api.removeWaiProperty;
		var disableControl = api.disableControl, isDisabled = api.isControlDisabled, checkControl = api.checkControl, isChecked = api.isControlChecked;

		var captionButtonTitle = function(title, accelerator) {
			return title + (accelerator ? ' [Ctrl+' + accelerator + ']' : '');
		};

		var appendCaptionButton = function(title, accelerator) {
			var elButton = createElement('div'); 
			if (elButton) {
				elButton.title = captionButtonTitle(title, accelerator);
				elButton.className = title.toLowerCase() + ' captionbutton';

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
				elButton.className = 'commandbutton';
				elButton.type = 'button';
				elButton.value = name;
				elFieldset.appendChild(elButton);
			}
			return elButton;
		};
		
		if (attachDrag) {
			updateDrag = function(b) {
				((b)?detachDrag:attachDrag)(el, elCaption);
			};
		}
	
		var showCurtain = function(b) {
			if (b) {
				elCurtain.style.display = 'block';
				coverDocument(elCurtain);

				elCurtain.style.visibility = 'visible';
				if (addClass) {
					addClass(elCurtain, 'drawn');
				}

				showElement(elCurtain);
			} else {
				if (removeClass) {
					removeClass(elCurtain, 'drawn');
				}
				showElement(elCurtain, false, { removeOnHide:true });
			}
		};

		updateMaxCaption = function(b) {
			if (elCaption) {
				elCaption.title = "Double-click to " + (b ? 'restore' : 'maximize');
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
		};

		updateMin = function(b) {
			if (elMinimizeButton) {
				disableControl(elMinimizeButton, b);
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

			minimize = function(b, bEffects) {
				if (b) {
					preMinimizedDimensions.pos = getElementPositionStyle(el);
					preMinimizedDimensions.dim = getElementSizeStyle(el);
					if (addClass) {
						removeClass(el, 'maximized');
						addClass(el, 'minimized');
					}
					updateDrag(false);
				} else {
					if (!bMaximized) {
						if (elFixButton && isChecked(elFixButton) && el.style.position != 'fixed') {
							constrainPositionToViewport(preMinimizedDimensions.pos);
						}
						positionElement(el, preMinimizedDimensions.pos[0], preMinimizedDimensions.pos[1], dimOptions);
						sizeElement(el, preMinimizedDimensions.dim[0], preMinimizedDimensions.dim[1], dimOptions);
					}
					if (removeClass) {
						removeClass(el, 'minimized');
					}
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
				if (elMinimizeButton && minimizable && isDisabled(elMinimizeButton)) {
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
			if (elCurtain) {
				showCurtain(false);
			}

			if (shown) {
				if (bSave) {
					if (onsave && onsave()) {
						return false;
					}
				}
				
				if (!onclose || !onclose(el, showOptions)) {
					showElement(el, false, showOptions);
					shown = false;
					return true;
				}				
			}
			return false;
		}

		api.dismissAlert = dismiss;

                api.getAlertElement = function() {
			return el;
		};

		api.isAlertOpen = function() {
			return shown;
		};

		api.focusAlert = focusAlert = function() {
			if (el.style.visibility == 'visible' && elFieldset.style.display != 'none') {
				elButton.focus();
			}
		};

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
				bDirty = b;
			}
		};

		// Need getScrollPosition as centerElement only works for fixed positioned elements without it.

		if (showElement && centerElement && sizeElement && api.getScrollPosition && el && elButton && elFieldset && elLabel && body && isHostMethod(global, 'setTimeout')) {

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

					// Must make positionable, else attachDrag (called in updateDrag) won't take

					if (!api.absoluteElement) { el.style.position = 'absolute'; }
					updateDrag(false);

					if (maximize) {
						elMaximizeButton = appendCaptionButton('Maximize', '.'); 
						if (elMaximizeButton) {
							attachListener(elMaximizeButton, 'click', function(e) {
								if (!isDisabled(this)) {
									restore();
								}
							});
						}
						attachListener(elCaption, 'dblclick', function(e) {
							if (maximizable) {
								restore();
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
			elButton.className = 'commandbutton';
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
					dismiss(bDirty);
				}
			});
			if (elCurtain) {
				body.appendChild(elCurtain);
				attachListener(elCurtain, 'click', function() {
					focusAlert();
				});
			}
			body.appendChild(el);

			if (attachDocumentListener && getKeyboardKey) {
				attachDocumentListener('keyup', function(e) {
					var el, key;

					if (shown && !e.shiftKey && !e.metaKey) {
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
								el = getEventTarget(e);

								while (el && el != elFieldset) {
									el = getElementParentElement(el);
								}
								if (el && !(/^textarea$/i).test(el.tagName) && !(/^commandbutton$/).test(el.className) && (!decision || makeDecision(true))) {
									dismiss(bDirty);
									return cancelDefault(e);
								}
							}
							break;
						default:
							if (maximize && sizable && e.ctrlKey) {
								switch(key) {
								case 190:
									if (minimizable && elMinimizeButton && isDisabled(elMinimizeButton)) {
										restore();
									} else {
										maximize(!bMaximized);
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
					if (!onsave || !onsave()) {
						bDirty = false;
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
			
			api.alert = function(sText, options, fnShow, fnHide) {
				var dummy, captionButtons, icon, title, hasTitle;

				options = options || {};
				showOptions = options;
				dimOptions = { duration:options.duration,ease:options.ease };
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
					disableControl(elCloseButton, !!decision && decision != 'dialog');
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

				bDirty = false;

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

				onclose = fnHide || options.onclose;
				if (!fnShow) {
					fnShow = options.onopen;
				}
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
					setElementText(elLabel, sText || '');
				}

				el.className = (options.className || 'alert') + ' popup window';

				sizable = options.sizable !== false;
				if (sizable) {
					maximizable = options.maximizable !== false;
				}

				if (addClass) {
					if (maximize) {
						if (!sizable) {							
							removeClass(el, 'maxminbuttons');
						} else {
							addClass(el, 'maxminbuttons');
						}
					}
					if (captionButtons) {
						(icon ? addClass : removeClass)(el, 'iconic');
						removeClass(el, 'nocaptionbuttons');
					} else {
						addClass(el, 'nocaptionbuttons');
					}

					if (fixElement) {
						addClass(el, 'fixable');
					}
				}
				
				el.style.display = 'block';

				if (presentControls && minimizable && isDisabled(elMinimizeButton)) {
					presentControls(false);
					if (bMaximized) {
						restoreElement(el);
						if (maximizable) {
							maximizeElement(el, null, function() {
								if (addClass) {
									addClass(el, 'maximized');
								}
							});
						} else {
							bMaximized = false;
						}
						update(bMaximized);
					}
					updateMin(false);
				}

				if (sizable && maximize && maximizable) {
					disableControl(elMaximizeButton, false);
					updateMaxCaption(bMaximized);
				} else {
					disableControl(elMaximizeButton);
					if (elCaption) {
						elCaption.title = '';
					}
					if (bMaximized) {
						restoreElement(el);
						bMaximized = false;
						update(false);
					}
				}

				if (sizable) {
					minimizable = options.minimizable !== false;
				}

				if (elMinimizeButton) {
					if (sizable && minimize && minimizable) {
						disableControl(elMinimizeButton, false);
					} else {
						disableControl(elMinimizeButton);
					}
				}

				if (updateSizeHandles) {
					updateSizeHandles(!sizable || bMaximized);
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
					if (elCurtain) {
						showCurtain(options.modal);
					}
					if (shown) {
						if (!elFixButton || !isChecked(elFixButton)) {
							global.setTimeout(function() {
								centerElement(el, { duration:options.duration, ease:options.ease, fps:options.fps });
							}, 10);
						}
						showElement(el);						
					} else {
						if (!bMaximized) {
							centerElement(el);
						} else {
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