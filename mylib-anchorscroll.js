// My Library Scrolling Anchors Add-on
// Requires Scrolling Effects combination (Scroll + Special Effects), DOM Collection, Offset and Event modules
// Adding the Mousewheel module enables the wheelInterrupts option, allowing the scrolling effect to be canceled by the mousewheel

var global = this;
if (this.API && typeof this.API == 'object' && this.API.attachDocumentReadyListener && this.API.attachListener && this.API.getAnchor && this.API.getAttribute && this.API.isHostMethod(global, 'location')) {
	this.API.attachDocumentReadyListener(function() {
		var attachLinkScrollEvent;
		var api = global.API;
		var isHostMethod = api.isHostMethod;
		var getScrollPosition = api.getScrollPosition;
		var setScrollPosition = api.setScrollPosition;
		var setScrollPositionToElement = api.setScrollPositionToElement; // Created on document ready

		if (!setScrollPositionToElement || !api.effects || !api.effects.scroll) {
			return;
		}

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

		var scrollToAnchor, defaultOptions = { duration: 500 };

		// Against my better judgement, but the kids really seem to like it
		// Do not try this at home

		var currentHash, globalOptions, hashTimer, hashWatcher, scrolling, defaultScroll = [0, 0];

		// Multiple object inference to exclude broken MSHTML versions and modes (e.g. IE < 8)
		// Always best to avoid such inferences, but only downside is exclusion of dead-on IE6/7 mimics from scrolling effects).

		var wontWorkWithHashes = (api.isHostObjectProperty(global, 'external') && !isHostMethod(global, 'XMLHttpRequest') && isHostMethod(global, 'ActiveXObject') && isHostMethod(global, 'attachEvent'));

		var locationHash = function(win) {
			var loc = win.location.href, index = loc.indexOf('#');

			if (index == -1) {
				return '';
			}
			return loc.substring(index + 1);
		};

		var scrolledToDefault = function() {
			scrolling = false;
		};

		hashWatcher = function() {
			var elAnchor, currentScroll, hash = locationHash(global);
			
			if (currentHash != hash) {
				if (scrolling) {
					currentScroll = getScrollPosition();
					setScrollPosition(currentScroll[0], currentScroll[1]); // Interrupt animation
				}
				if (hash) {
					elAnchor = getAnchor(hash);
					if (!elAnchor && getEBI) {
						elAnchor = getEBI(hash);
					}
					if (elAnchor) {
						scrolling = true;
						currentHash = hash;
						scrollToAnchor(elAnchor, global, hash, globalOptions);
					}
				} else {
					currentHash = hash;
					scrolling = true;
					setScrollPosition(defaultScroll[0], defaultScroll[1], null, true, globalOptions, scrolledToDefault);
				}
			}
		};

		var isAnchorReference = function(loc, href) {
			if (loc.indexOf('#') != -1) {
				loc = loc.substring(0, loc.indexOf('#'));
			}
			return !!(href && (!href.indexOf('#') || (!href.indexOf(loc) && href.indexOf('#') != -1)));
		};

		scrollToAnchor = function(el, win, name, options, e) {
			if (e) {				
				if (win.location.hash.length < 2) {
					defaultScroll = getScrollPosition();
				}
			}

			setScrollPositionToElement(el, [0, 0], options, function(doc) {
				if (win == global && !hashTimer) {
					if (typeof currentHash == 'undefined') {
						currentHash = locationHash(win);
					}
					if (options && options.animateBackForward) {
						globalOptions = options;
					}
					hashTimer = win.setInterval(hashWatcher, 60);
				}

				currentHash = name;
				if (e && win.location.hash.substring(1) != name && options.updateHash !== false) {
					win.location.hash = name;
				}

				scrolling = false;
			});
			scrolling = true;
			if (e) {
				return cancelDefault(e);
			}
		};

		attachLinkScrollEvent = api.attachLinkScrollEvent = function(el, options) {
			var doc, elAnchor, href, loc, win;

			if (!options) {
				options = defaultOptions;
			}

			if (!wontWorkWithHashes || options.updateHash === false) {
				doc = getElementDocument(el);
				win = getDocumentWindow(doc);
				loc = win.location.href;
				href = getAttribute(el, 'href');
				if (isAnchorReference(loc, href)) {
					href = href.substring(href.indexOf('#') + 1);
					elAnchor = getAnchor(href, doc);
					if (!elAnchor && getEBI) {
						elAnchor = getEBI(href);
					}
					if (elAnchor) {
						attachListener(el, 'click', function(e) {
							return scrollToAnchor(elAnchor, win, href, options, e);
						});
						return true;
					}
				}
			}
			return false;
		};

		api.attachLinkScrollEvents = function(options, links, doc) {
			var body, el, elAnchor, href, i, win, loc;

			if (!options) {
				options = defaultOptions;
			}

			if (!wontWorkWithHashes || options.updateHash === false) {
				if (links) {
					i = links.length;
					while (i--) { attachLinkScrollEvent(links[i], options); }
				} else {

					// Delegate for all links

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
									if (!elAnchor && getEBI) {
										elAnchor = getEBI(href);
									}
									if (elAnchor) {
										return scrollToAnchor(elAnchor, win, href.substring(href.indexOf('#') + 1), options, e);
									}
								}
							}
						});
					}
				}
				return true;
			}
			return false;
		};
	});
}