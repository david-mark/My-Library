// My Library Alert add-on
// Requires Event, Center, Scroll, Show and Size modules
// Optionally uses DOM, HTML, Class, Opacity, Drag, Maximize and Full Screen modules and/or the Fix Element add-on
var global = this;
if (this.API && typeof this.API == 'object' && this.API.areFeatures && this.API.areFeatures('attachListener', 'createElement', 'setElementText')) {
	this.API.attachDocumentReadyListener(function() {
		var api = global.API;
		var showElement = api.showElement;
		var centerElement = api.centerElement;
                var constrainPositionToViewport = api.constrainPositionToViewport;
		var maximizeElement = api.maximizeElement;
		var restoreElement = api.restoreElement;
		var setElementText = api.setElementText;
		var setElementHtml = api.setElementHtml;
		var setOpacity = api.setOpacity;
		var sizeElement = api.sizeElement;
		var fixElement = api.fixElement;
		var getChildren = api.getChildren;
		var addClass = api.addClass;
		var removeClass = api.removeClass;
		var getElementPositionStyle = api.getElementPositionStyle;
		var getElementSizeStyle = api.getElementSizeStyle;
		var cancelDefault = api.cancelDefault;
		var elCaption, elSizeHandle, elSizeHandleH, elSizeHandleV;
		var el = api.createElement('div');
		var elLabel = api.createElement('div');
		var elButton = api.createElement('input');
		var elFieldset = api.createElement('fieldset');
		var elFixButton, elIconButton, elMaximizeButton, elMinimizeButton, elCloseButton, elHelpButton, elCancelButton, elNoButton, elApplyButton;
		var body = api.getBodyElement();
		var bMaximized, showOptions, dimOptions, shown;
		var preMinimizedDimensions = {};
		var onhelp, oncancel, onno, onsave, onclose, onbeforeclose;
		var bDirty;

		function updateMaxCaption(b) {
			elCaption.title = "Double-click to " + ((b)?'restore':'maximize');
		}

		function updateMaxButton(b) {
			if (b) {
				removeClass(elMaximizeButton, 'maximizebutton');
				addClass(elMaximizeButton, 'restorebutton');
			}
			else {
				removeClass(elMaximizeButton, 'restorebutton');
				addClass(elMaximizeButton, 'maximizebutton');
			}
			elMaximizeButton.title = (!b)?'Maximize':'Restore';
		}

		function updateDrag(b) {
			((b)?api.detachDrag:api.attachDrag)(el, elCaption);
		}

		function disableControl(el, b) {
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
		}

		// Called after minimize/restore

		function updateMin(b) {
			if (elMinimizeButton) {
				disableControl(elMinimizeButton, elLabel.style.display == 'none');
			}

			if (elMaximizeButton) {
				if (b) {
					updateMaxButton(!bMaximized);
					if (elCaption) { updateMaxCaption(!bMaximized); }
				}
				else {
					updateMaxButton(bMaximized);
					if (elCaption) { updateMaxCaption(bMaximized); }
				}
			}
		}

		function updateSizeHandle(el, b) {
			el.style.visibility = (b)?'hidden':'';
		}

		// Called after maximize/restore

		function update(b) {
			if (elSizeHandle) { updateSizeHandle(elSizeHandle, b); }
			if (elSizeHandleH) { updateSizeHandle(elSizeHandleH, b); }
			if (elSizeHandleV) { updateSizeHandle(elSizeHandleV, b); }
			if (elCaption) {
				updateMaxCaption(b);
				updateDrag(b);
			}

			if (elMaximizeButton) {
				updateMaxButton(b);
			}

			if (elFixButton) {
				disableControl(elFixButton, b);
			}
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

		function minimize(b, bEffects) {
			if (b) {
				preMinimizedDimensions.pos = getElementPositionStyle(el);
				preMinimizedDimensions.dim = getElementSizeStyle(el);
				addClass(el, 'minimized');
				updateDrag(false);
			}
			else {
				if (!bMaximized) {
					if (elFixButton && elFixButton.className.indexOf('selected') != -1 && el.style.position != 'fixed') {
						constrainPositionToViewport(preMinimizedDimensions.pos);
					}
					api.positionElement(el, preMinimizedDimensions.pos[0], preMinimizedDimensions.pos[1], dimOptions);
					api.sizeElement(el, preMinimizedDimensions.dim[0], preMinimizedDimensions.dim[1], dimOptions);
				}
				removeClass(el, 'minimized');
				updateDrag(bMaximized);
			}

			presentControls(b);

			if (!b && bMaximized) {
				restoreElement(el);
				maximize(true);			
			}

			if (b) { el.style.height = el.style.width = ''; }
			updateMin(b);
		}

		function maximize(b) {
			((b)?maximizeElement:restoreElement)(el, dimOptions);
			update(b);
			bMaximized = b;
		}

		function restore() {
			if (elLabel.style.display == 'none') {
				minimize(false);
			} else {
				maximize(!bMaximized);
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

		api.enableAlertApplyButton = function(b) {
			if (elApplyButton) {
				elApplyButton.disabled = !!b;
			}		
			bDirty = !b;
		};

		// Need getScrollPosition as centerElement only works for fixed positioned elements without it.

		if (showElement && centerElement && sizeElement && api.getScrollPosition && el && elButton && elFieldset && elLabel && body && api.isHostMethod(global, 'setTimeout')) {
			if (api.attachDrag) {
				elCaption = api.createElement('div');
				if (elCaption) {
					elCaption.className = 'movehandle';
					el.appendChild(elCaption);

					// Must make positionable, else attachDrag (called in updateDrag) won't take

					if (!api.absoluteElement) { el.style.position = 'absolute'; }
					updateDrag(false);

					if (maximizeElement && addClass) {
						elMaximizeButton = api.createElement('div'); 
						if (elMaximizeButton) {
							updateMaxCaption(false);
							elMaximizeButton.title = 'Maximize';
							elMaximizeButton.className = 'maximizebutton';
							el.appendChild(elMaximizeButton);

							api.attachListener(elMaximizeButton, 'click', function(e) {
								if (this.className.indexOf('disabled') == -1) {
									restore();
								}
							});
						}
						api.attachListener(elCaption, 'dblclick', function(e) {
							restore();
							return cancelDefault(e);
						});
					}

					elIconButton = api.createElement('div');
					if (elIconButton) {
						elIconButton.className = 'icon';
						api.attachListener(elIconButton, 'dblclick',  function() { if (!elCloseButton || elCloseButton.className.indexOf('disabled') == -1) { dismiss(false); } });
						el.appendChild(elIconButton);
					}
					elCloseButton = api.createElement('div');
					if (elCloseButton) {
						elCloseButton.className = 'closebutton';
						elCloseButton.title = 'Close';
						api.attachListener(elCloseButton, 'click', function() {
							if (this.className.indexOf('disabled') == -1) {
								dismiss(false);
							}
						});
						el.appendChild(elCloseButton);
					}
					if (getChildren && api.canAdjustStyle && api.canAdjustStyle('display') && addClass && api.maximizeElement) {
						elMinimizeButton = api.createElement('div');
						if (elMinimizeButton) {
							elMinimizeButton.className = 'minimizebutton';
							elMinimizeButton.title = 'Minimize';
							api.attachListener(elMinimizeButton, 'click', function() {
								if (this.className.indexOf('disabled') == -1) {
									minimize(true);
								}
							});
							el.appendChild(elMinimizeButton);
						}

					}
					
					if (fixElement && addClass && removeClass) {
						elFixButton = api.createElement('div');
						if (elFixButton) {
							elFixButton.title = 'Fix';
							elFixButton.className = 'fixbutton';
							el.appendChild(elFixButton);
							api.attachListener(elFixButton, 'click', function(e) {
								if (elFixButton.className.indexOf('disabled') != -1) { return; }
								if (this.className == 'fixbutton') {
									addClass(this, 'selected');
									elFixButton.title = 'Detach';
									fixElement(el, true, dimOptions);
								}
								else {
									removeClass(this, 'selected');
									this.className = 'fixbutton';
									elFixButton.title = 'Fix';
									fixElement(el, false, dimOptions);
								}
							});
						}
					}

					if (sizeElement) {
						elSizeHandleH = api.createElement('div');
						if (elSizeHandleH) {
							elSizeHandleH.className = 'sizehandleh';
							el.appendChild(elSizeHandleH);
							api.attachDrag(el, elSizeHandleH, { mode:'size',axes:'horizontal' });
						}
						elSizeHandleV = api.createElement('div');
						if (elSizeHandleV) {
							elSizeHandleV.className = 'sizehandlev';
							el.appendChild(elSizeHandleV);
							api.attachDrag(el, elSizeHandleV, { mode:'size',axes:'vertical' });
						}
						elSizeHandle = api.createElement('div');
						if (elSizeHandle) {
							elSizeHandle.className = 'sizehandle';
							el.appendChild(elSizeHandle);
							api.attachDrag(el, elSizeHandle, { mode:'size' });
						}
					}
				}
			}

			elLabel.className = 'content';
			el.appendChild(elLabel);

			elButton.type = 'button';
			elButton.value = 'Close';
			elFieldset.appendChild(elButton);

			elNoButton = api.createElement('input');
			if (elNoButton) {
				elNoButton.type = 'button';
				elNoButton.value = 'No';
				elFieldset.appendChild(elNoButton);
			}

			elCancelButton = api.createElement('input');
			if (elCancelButton) {
				elCancelButton.type = 'button';
				elCancelButton.value = 'Cancel';
				elFieldset.appendChild(elCancelButton);
			}


			elApplyButton = api.createElement('input');
			if (elApplyButton) {
				elApplyButton.type = 'button';
				elApplyButton.value = 'Apply';
				elFieldset.appendChild(elApplyButton);
			}

			elHelpButton = api.createElement('input');
			if (elHelpButton) {
				elHelpButton.type = 'button';
				elHelpButton.value = 'Help';
				elFieldset.appendChild(elHelpButton);
			}

			el.appendChild(elFieldset);

			el.style.position = 'absolute';
			showElement(el, false);
			api.positionElement(el, 0, 0);
			api.attachListener(elButton, 'click', function() { dismiss(bDirty); });
			body.appendChild(el);

			if (api.attachDocumentListener && api.getKeyboardKey) {
				api.attachDocumentListener('keyup', function(e) { if (shown && api.getKeyboardKey(e) == 27) { if (!elCloseButton || elCloseButton.className.indexOf('disabled') == -1) { dismiss(false); return api.cancelDefault(e); } } } );
			}

			if (elHelpButton) {
				api.attachListener(elHelpButton, 'click', function() { if (onhelp) { onhelp(); } });
			}

			if (elCancelButton) {
				api.attachListener(elCancelButton, 'click', function() { if (!oncancel || !oncancel()) { dismiss(false); } });
			}

			if (elNoButton) {
				api.attachListener(elNoButton, 'click', function() { if (!onno || !onno()) { dismiss(false); } });
			}

			if (elApplyButton) {
				api.attachListener(elApplyButton, 'click', function() { if (!onsave || !onsave()) { this.disabled = true; } });
			}
			
			api.alert = function(sText, options, fnShow, fnHide) {
				options = options || {};
				showOptions = options;
				dimOptions = { duration:options.duration,ease:options.ease };

				// TODO: add and remove from DOM instead of using display style

				if (elHelpButton) {
					onhelp = options.onhelp;
					elHelpButton.style.display = (onhelp)?'':'none';
				}

				if (elCancelButton) {
					oncancel = options.oncancel;
					elCancelButton.style.display = (options.decision && options.decision != 'yesno')?'':'none';
				}

				if (elNoButton) {
					onno = options.onno;
					elNoButton.style.display = (options.decision == 'yesno' || options.decision == 'yesnocancel')?'':'none';
				}

				if (elCloseButton) {
					disableControl(elCloseButton, !!options.decision);
				}

				if (elIconButton) {
					elIconButton.title = options.decision ? '' : 'Double-click to close';
				}

				bDirty = false;

				if (elApplyButton) {
					elApplyButton.disabled = !bDirty;
					onsave = options.onsave;
					onbeforeclose = options.onbeforeclose;
					elApplyButton.style.display = (options.onsave && options.decision && options.decision != 'yesno' && options.decision != 'confirm')?'':'none';
				}				

				elButton.value = (options.decision)?((options.decision.indexOf('yes') != -1)?'Yes':options.buttonCaption || 'OK'):'Close';

				if (elCaption) {
					var title = options.title || 'Alert';
					setElementText(elCaption, title);
				}
				onclose = fnHide || options.onclose;
				showElement(el, false);
				if (!bMaximized && options.shrinkWrap !== false) {
					el.style.height = '';
					el.style.width = '';
				}
				if (setElementHtml && options.html) {
					setElementHtml(elLabel, options.html);
				}
				else {
					if (sText !== null) { setElementText(elLabel, sText); }
				}

				el.className = options.className || 'alert';
				el.style.display = 'block';

				if (elLabel.style.display == 'none') {
					presentControls(false);
					if (bMaximized) {
						restoreElement(el);
						maximizeElement(el);
					}
					updateMin(false);
				}
				if (sizeElement) {
					// NOTE: So called shrink-wrapping cross-browser is a bad proposition
					if (options.shrinkWrap !== false) {
						var dummy;

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
					}
					else {
						if (!bMaximized) { centerElement(el); } else { maximizeElement(el); }
						showElement(el, true, options);
					}
				}
				if (!shown && elButton && api.isHostMethod(elButton, 'focus')) { global.setTimeout(function() { if (el.style.visibility == 'visible' && elLabel.style.display != 'none') { elButton.focus(); } }, (options.duration)?options.duration:0); }
				shown = true;
			};
		}
		elFieldset = null;
		body = null;
	});
}