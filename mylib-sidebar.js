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
			if (createElement) {
				api.createSideBar = function(options, doc) {
					var el = createElement('div');
					if (el) {
						API.setControlContent(el, options);
						return enhanceSideBar(el, options, doc);
					}
					return null;
				};
			}
			if (showElement) {
				var oldShowSideBar = api.showSideBar;

				api.showSideBar = function(el, b, options, callback) {
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