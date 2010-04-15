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
			api.createSideBar = function(options, doc) {
				var el = createElement('div'), body = getBodyElement(doc);

				if (!options) {
					options = {};
				}

				var side = options.side;

				if (el && body) {
					el.style.position = 'absolute';
					el.className = options.className || 'sidebar';
					if (side == 'left' || side == 'right') {
						el.className += ' vertical';
					}
					el.className += ' ' + side;
					body.appendChild(el);
					return el;
				}
				return null;
			};
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
			};
		}

		api = body = null;
	});
}