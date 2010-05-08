// Enables fixed positioning
// Not included in main script as conditional compilation fouls up minification
// Requires Offset, Position, Scroll and Event modules

var global = this;

if (this.API && typeof this.API == 'object' && this.API.attachDocumentReadyListener && this.API.attachWindowListener && this.API.canAdjustStyle && this.API.canAdjustStyle('position') && this.API.getDocumentWindow) {
	this.API.attachDocumentReadyListener(function() {
		var api = global.API;
		var attachWindowListener = api.attachWindowListener;
		var detachWindowListener = api.detachWindowListener;
		var absoluteElement = api.absoluteElement;
		var elementUniqueId = api.elementUniqueId;
		var getElementMarginsOrigin = api.getElementMarginsOrigin;
		var getElementPosition = api.getElementPosition;
		var getElementPositionStyle = api.getElementPositionStyle;
		var getPositionedParent = api.getPositionedParent;
		var getScrollPosition = api.getScrollPosition;
		var getStyle = api.getStyle;
		var htmlToViewportOrigin = api.htmlToViewportOrigin;
		var positionElement = api.positionElement;
		var viewportToHTMLOrigin = api.viewportToHTMLOrigin;
		var getElementDocument = api.getElementDocument;
		var getDocumentWindow = api.getDocumentWindow;
		var deltaY, deltaX, deltaScrollX, deltaScrollY, margins, posComp;
		var elementsFixed = {}, timeouts = {}, eventCounters = {};

		if (absoluteElement && getScrollPosition && positionElement) {
			api.fixElement = function(el, b, options, fnDone) {
				if (typeof b == 'undefined') {
					b = true;
				}
				options = options || {};
				var pos, y, x;
				var docNode = getElementDocument(el);
				var sp = getScrollPosition(docNode);
				var win = getDocumentWindow(docNode);
				var uid = elementUniqueId(el);
				var o = elementsFixed[uid];
				var bRevert = options.revert;
				var bWasFixed, fn, fnPos;

				if (!b) {
					if (!o) { // Not fixed yet
						return false;
					}

					pos = o.pos;

					deltaX = el.offsetLeft - o.offsetLeftFixed;
					deltaY = el.offsetTop - o.offsetTopFixed;

					if (o.sp) {
						sp = getScrollPosition(docNode);
						deltaScrollY = sp[0] - o.sp[0];
						deltaScrollX = sp[1] - o.sp[1];
					}

					bWasFixed = el.style.position == 'fixed';

					el.style.position = o.position;

					if (win && o.ev) {
						detachWindowListener('scroll', o.ev, win);
					}
					posComp = o.posComp;
					if (bRevert || !posComp || posComp == 'static') {
						el.style.left = o.left;
						el.style.top = o.top;
					}
					else {						
						switch(posComp) {
						case 'relative':
							if (o.pos && typeof deltaY == 'number') {
								o.pos[0] += deltaY; o.pos[1] += deltaX;
							}
							if (typeof deltaScrollY == 'number' && bWasFixed) {
								o.pos[0] += deltaScrollY; o.pos[1] += deltaScrollX;
							}
							pos = o.pos;
							break;
						case 'absolute':
							if (o.pos && typeof deltaY == 'number') {
								o.pos[0] += deltaY; o.pos[1] += deltaX;
								pos = o.pos;
								if (typeof deltaScrollY == 'number' && bWasFixed) {
									o.pos[0] += deltaScrollY; o.pos[1] += deltaScrollX;
								}
							}
							else {
								pos = getElementPositionStyle(el);
								if (htmlToViewportOrigin && o.viewportAdjust) { pos = htmlToViewportOrigin(pos, docNode); }
							}
						}
						positionElement(el, pos[0], pos[1]);
					}
					elementsFixed[uid] = null;
					return true;
				}

				if (o) { // Already fixed
					return false;
				}

				posComp = getStyle(el, 'position');

				margins = getElementMarginsOrigin ? getElementMarginsOrigin(el) : [0, 0];

				o = { position:el.style.position, left:el.style.left, top:el.style.top, posComp:posComp, offsetLeft:el.offsetLeft, offsetTop:el.offsetTop, pos:getElementPositionStyle(el), sp:getScrollPosition(docNode) };

				if (getPositionedParent(el)) {
					pos = getElementPosition(el);
					pos[0] -= margins[0];
					pos[1] -= margins[1];
				}
				else {
					switch(posComp) {
					case 'relative':
						pos = getElementPosition(el);
						pos[0] -= margins[0];
						pos[1] -= margins[1];
						break;
					case 'absolute':
						pos = getElementPositionStyle(el);
						break;
					default:
						absoluteElement(el);
						pos = getElementPositionStyle(el);
					}
				}

				y = pos[0];
				x = pos[1];

				var oldPos = [y, x];

				/*@cc_on @*/
				/*@if (@_jscript_version >= 5.7)
				try {
					el.style.position = 'fixed';
					if (el.currentStyle && el.currentStyle.position != 'fixed') throw(0);
					positionElement(el, y - sp[0], x - sp[1]);

					o.offsetLeftFixed = el.offsetLeft;
					o.offsetTopFixed = el.offsetTop;
					elementsFixed[uid] = o;

					return true;
				}
				catch(e) {
					if (!e) {
						el.style.position = '';
						el.style.position = 'absolute';
					}			
				}
				@else
				el.style.position = 'absolute'
				@end
				if (win) {
					y -= sp[0];
					x -= sp[1];

					fnPos = function() {
						var docNode = getElementDocument(el);
						var sp = getScrollPosition(docNode);

						oldPos = [y + sp[0], x + sp[1]];
						positionElement(el, y + sp[0], x + sp[1], { duration:options.duration, ease:options.ease }, function() { eventCounters[uid]--; });

						if (!positionElement.async) {
							eventCounters[uid]--;
						}
						timeouts[uid] = 0;
					};					


					fn = function() {
						if (!timeouts[uid]) {
							if (!eventCounters[uid]) {
								var pos2 = getElementPositionStyle(el);
								if (pos2[0] != oldPos[0] || pos2[1] != oldPos[1]) {
									y -= (oldPos[0] - pos2[0]);
									x -= (oldPos[1] - pos2[1]);
								}
								eventCounters[uid] = 1;
							}
							else {
		                                                eventCounters[uid]++;
							}
						}
						else {				
							global.clearTimeout(timeouts[uid]);
						}
						
						timeouts[uid] = global.setTimeout(fnPos, options.scrollTimeout || 100);
					};

					o.ev = fn;

					attachWindowListener('scroll', fn, win);
					win = null;

					positionElement(el, y + sp[0], x + sp[1]);

					elementsFixed[uid] = o;
					o.offsetLeftFixed = el.offsetLeft;
					o.offsetTopFixed = el.offsetTop;
					return true;
				}
				return false;
				@*/
				if (el.style.position != 'fixed') {
					el.style.position = 'fixed';
					if (viewportToHTMLOrigin) {
						pos = viewportToHTMLOrigin(pos, docNode);
						o.viewportAdjust = true;
					}
					positionElement(el, pos[0] - sp[0], pos[1] - sp[1]);

					elementsFixed[uid] = o;
					o.offsetLeftFixed = el.offsetLeft;
					o.offsetTopFixed = el.offsetTop;

					return true;
				}
				return false;
			};
		}
		api = null;
	});
}