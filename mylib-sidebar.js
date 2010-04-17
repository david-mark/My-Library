/* My Library Sidebar Widget
   Requires DOM module
   Requires Widgets add-on
   Optionally uses Class */

var API, global = this;
if (API && API.areFeatures && API.areFeatures('createElement', 'attachDocumentReadyListener')) {
	API.attachDocumentReadyListener(function() {
		var api = API, getBodyElement = api.getBodyElement, showElement = api.showElement, createElement = api.createElement;
		var body = getBodyElement();
		var oppositeSides = { left:'right', right:'left', top:'bottom', bottom:'top' };
		var attachListener = api.attachListener, getElementParentElement = api.getElementParentElement, callInContext = api.callInContext;
		var appendSideBarButton;

		if (createElement && attachListener) {
			appendSideBarButton = function(elSideBar, v, fn) {
				var elButton = createElement('input');

				if (elButton) {
					elButton.type = 'button';
					elButton.className = 'commandbutton';
					elButton.value = v;
					elSideBar.appendChild(elButton);

					attachListener(elButton, 'click', function() {
						return fn(getElementParentElement(this), this);
					});
					elButton = elSideBar = null;
					return true;
				}
				return false;
			};
		}

		if (body && API.isHostMethod(body, 'appendChild') && api.sideBar) {
                        api.enhanceSideBar = function(el, options, doc) {
				var body = getBodyElement(doc);

				if (!options) {
					options = {};
				}

				var side = options.side || 'left';

				if (body) {
					el.style.position = 'absolute';
					el.className = options.className || 'sidebar';
					if (side == 'left' || side == 'right') {
						el.className += ' vertical';
					}
					el.className += ' ' + side;
					body.appendChild(el);
					API.sideBar(el, side, options);
					return el;
				}
				return null;
			};
			if (appendSideBarButton) {
				api.createSideBar = function(options, doc) {
					if (!options) {
						options = {};
					}
					var el = createElement('div');
					if (el) {
						API.setControlContent(el, options);
						if (options.buttons) {
							var onclose = options.onclose;

							if (API.showSideBar) {
							appendSideBarButton(el, 'Close', function() {
					                  API.showSideBar(el, false, {
					                    effects:options.effects,
					                    side:options.side,
					                    duration:options.duration,
					                    ease:options.ease,
                                                            fps:options.fps,
					                    removeOnHide:true
					                  });
					                  API.unSideBar(el);
					                  if (onclose) {
                                                            callInContext(onclose, options.callbackContext || API, el);
                                                          }
					                });
                                                        }

							var onautohidecollision = options.onautohidecollision, onautohide = options.onautohide;

							if (API.autoHideSideBar) {
                                                            appendSideBarButton(el, 'Auto-hide', function(el, elButton) {
					                    if (API.autoHideSideBar(el, true, { duration:options.duration, ease:options.ease, fps:options.fps })) {
						                      el.className += ' autohide';
						                      elButton.disabled = true;
						                      if (onautohide) {
                                                                        callInContext(onautohide, options.callbackContext || API, el);
                                                                      }
                                                            } else {
                                                              var doAlert = true;

                                                              if (onautohidecollision) {
								doAlert = callInContext(onautohidecollision, options.callbackContext || API, el) !== false;
					                      }
                                                              if (doAlert && API.isHostMethod(global, 'alert')) {
                                                                global.alert('Only one sidebar per edge may be hidden.');
                                                              }
					                    }
                                                          });
                                                        }
						}
						return API.enhanceSideBar(el, options, doc);
					}
					return null;
				};
			}
			if (showElement) {
				var oldShowSideBar = api.showSideBar;

				api.showSideBar = function(el, b, options) {
					if (options && options.side && options.effects && options.effects == API.effects.slide && !options.effectParams) {
						options.effectParams = { side:oppositeSides[options.side] };
					}
					oldShowSideBar(el, b, options);
				};
			}
			api.destroySideBar = function(el) {
				API.unSideBar(el);
				var elParent = API.getElementParentElement(el);
				if (elParent) {
					elParent.removeChild(el);
				}
			};
		}

		api = body = null;
	});
}