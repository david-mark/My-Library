// My Library Scrolling Anchors Add-on
// Requires Scrolling Effects combination (Scroll + Special Effects), DOM Collection, Offset and Event modules
// Adding the Mousewheel module enables the wheelInterrupts option, allowing the scrolling effect to be canceled by the mousewheel

var global = this;
if (this.API && typeof(this.API) == 'object' && this.API.attachDocumentReadyListener && this.API.attachListener && this.API.getAnchor && this.API.getAttribute && this.API.isHostMethod(global, 'location')) {
	this.API.attachDocumentReadyListener(function() {
		var attachLinkScrollEvent;
		var api = global.API;
		var setScrollPositionToElement = api.setScrollPositionToElement; // Created on document ready

		if (!setScrollPositionToElement) { return; }

		var attachListener = api.attachListener;
		var cancelDefault = api.cancelDefault;
		var getAnchor = api.getAnchor;
		var getAttribute = api.getAttribute;
		var getBodyElement = api.getBodyElement;
		var getEBI = api.getEBI;
		var getElementDocument = api.getElementDocument;
		var getElementNodeName = api.getElementNodeName;
		var getEventTarget = api.getEventTarget;
		var getDocumentWindow = api.getDocumentWindow;

		function isAnchorReference(loc, href) {
			if (loc.indexOf('#') != -1) { loc = loc.substring(0, loc.indexOf('#')); }
			return !!(href && (!href.indexOf('#') || (!href.indexOf(loc) && href.indexOf('#') != -1)));
		}

		function scrollToAnchor(el, win, name, options, e) {
			setScrollPositionToElement(el, [0, 0], options, function(interrupt) { if (!interrupt) { win.location.hash = name; } });
			return cancelDefault(e);
		}

		attachLinkScrollEvent = api.attachLinkScrollEvent = (function() {
			return function(el, options) {
				var doc, elAnchor, href, loc, win;
				doc = getElementDocument(el);
				win = getDocumentWindow(doc);
				loc = win.location.href;
				href = getAttribute(el, 'href');
				if (isAnchorReference(loc, href)) {
					href = href.substring(href.indexOf('#') + 1);
					elAnchor = getAnchor(href, doc);
					if (!elAnchor && getEBI) { elAnchor = getEBI(href); }
					if (elAnchor) {					
						attachListener(el, 'click', function(e) {
							return scrollToAnchor(elAnchor, win, href, options, e);
						});
						return true;
					}
				}
				return false;
			};
		})();

		api.attachLinkScrollEvents = function(options, links, doc) {
			var body, el, elAnchor, href, i, win;

			if (links) {
				i = links.length;
				while (i--) { attachLinkScrollEvent(links[i], options); }
			}
			else { // Delegate for all links
				body = getBodyElement(doc);
				if (body) {
					win = getDocumentWindow(doc);
					loc = win.location.href;
					attachListener(body, 'click', function(e) {
						el = getEventTarget(e);
						if (getElementNodeName(el) == 'a') {
							href = getAttribute(el, 'href');
							if (isAnchorReference(loc, href)) {
								href = href.substring(href.indexOf('#') + 1);
								elAnchor = getAnchor(href, doc);
								if (!elAnchor && getEBI) { elAnchor = getEBI(href); }
								if (elAnchor) {
									return scrollToAnchor(elAnchor, win, href.substring(href.indexOf('#') + 1), options, e);
								}
							}
						}
					});
				}
			}
		};
	});
}