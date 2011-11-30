<%If Request.QueryString("quirks") <> "1" Then %><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"><%end if%>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Language" content="en-us">
<title>V is for Viewport</title>
<link rel="home" href="mylib.html">
<link rel="up" href="mylib.html">
<link rel="previous" href="size.html" title="S is for Size">
<link rel="stylesheet" type="text/css" media="all" href="style/mylib.css">
<link rel="stylesheet" type="text/css" media="all" href="style/tester.css">
<style type="text/css" media="all">
body { text-align:center }
#indicator {
	border:none;
	padding:0;
	position:absolute;
	background-color:#000;
	color:#fff;
	left:0;
	top:0;
	overflow:hidden
}
#indicator div {
	padding:1em
}
#indicator legend {
	background-color:#000;
	color:#fff;
}
p, pre, h1, h2, h3, fieldset, ul {
	text-align:left;
}
</style>
<style type="text/css" media="print">
#indicator, fieldset {
	display:none !important
}
pre {
	overflow:visible;
	overflow-y:visible;
}
</style>
</head>
<body onload="if (typeof bodyLoad == 'function') { bodyLoad(); }">
<h1>V is for Viewport</h1>
<p><%If Request.QueryString("quirks") = "1" Then%>
You are testing in <em>quirks</em> mode.  Test in <a href="viewport.asp">standards mode</a>.
<%Else%>
You are testing in <em>standards</em> mode.  Test in <a href="viewport.asp?quirks=1">quirks mode</a>.
<%End If%></p>

<script type="text/javascript">

if (typeof window.document.getElementById != 'undefined' && typeof window.document.documentElement.style.display == 'string') {
	window.document.write('<div id="indicator" style="display:none"><div>When the document is scrolled to its origin, this <code>DIV<\/code> should cover the client area of the viewport <em>exactly<\/em>.<fieldset><legend>Test<\/legend><input type="button" onclick="if (testResize) testResize()" value="Resize"><input type="button" onclick="window.document.getElementById(\'indicator\').style.display = \'none\'" value="Close"><\/fieldset><\/div><\/div>');
}

var testResize, bodyLoad = function() {
	var getViewportDimensions, getRoot, scrollbarHeight, scrollChecks;
	var doc = window.document, html = doc.documentElement;

	// NOTE: Assumes height of horizontal scroll bar is equal to the width of the vertical

	if (typeof doc.createElement != 'undefined') {
		scrollbarHeight = (function() {
			var height = 0, elDivOuter = doc.createElement('div');
			elDivOuter.style.width = '5px';
			elDivOuter.style.overflow = 'auto';
			elDivOuter.style.visibility = 'hidden';
			elDivOuter.style.position = 'absolute';
			elDivOuter.style.top = '0';
			var elDivInner = doc.createElement('div');
			elDivInner.style.width = '200px';
			elDivInner.style.height = elDivOuter.style.height = '100px';
			elDivOuter.appendChild(elDivInner);
			elDivOuter.style.overflowX = 'auto';
			doc.body.appendChild(elDivOuter);
			if (typeof elDivOuter.offsetHeight == 'number' && typeof elDivOuter.clientHeight == 'number' && elDivOuter.offsetHeight > elDivOuter.clientHeight) {
				height = elDivOuter.offsetHeight - elDivOuter.clientHeight;
			}
			doc.body.removeChild(elDivOuter);
			return height;
		})();

		// Test to find which element contains the changing clientWidth/Height properties

		if (html && typeof doc.createElement != 'undefined') {

			// Possible ambiguity between HTML and body

			scrollChecks = (function() {
				var oldBorder, body = doc.body, result = { compatMode: doc.compatMode };
				var clientHeight = html.clientHeight, bodyClientHeight = body.clientHeight;
				var elDiv = doc.createElement('div');
				elDiv.style.height = '100px';
				body.appendChild(elDiv);
				result.body = !clientHeight || clientHeight != html.clientHeight;
				result.html = bodyClientHeight != body.clientHeight;
				body.removeChild(elDiv);
				if (result.body || result.html && (result.body != result.html)) {

					// found single scroller--check if borders should be included
					// skipped if body is the real root (as opposed to just reporting the HTML element's client dimensions)

					if (typeof body.clientTop == 'number' && body.clientTop && html.clientWidth) {
						oldBorder = body.style.borderTopWidth;
						body.style.borderTopWidth = '0px';
						result.includeBordersInBody = body.clientHeight != bodyClientHeight;
						body.style.borderTopWidth = oldBorder;
					}
					return result;
				}
			})();
		}
	}

	// Try to figure the outer-most rendered element.
	// NOTE: This element may not hold the proper clientWidth/Height properties

	if (typeof doc.compatMode == 'string') {
		getRoot = function(win) {
			var doc = win.document, html = doc.documentElement, compatMode = doc.compatMode;

			return (html && compatMode.toLowerCase().indexOf('css') != -1 && html.clientWidth) ? html : doc.body;
		};
	} else {
		getRoot = function(win) {
			var doc = win.document, html = doc.documentElement;

			return (!html || html.clientWidth === 0) ? doc.body : html;
		};
	}

	// NOTE: Do not pass bogus window objects to these functions

	if (typeof doc.clientWidth == 'number') {

		// If the document itself implements clientWidth/Height (e.g. Safari 2)
		// This one is a rarity.  Coincidentally KHTML-based browsers reported to implement
		// these properties have trouble with clientHeight/Width as well as innerHeight/Width.

		getViewportDimensions = function(win) {
			if (!win) {
				win = window;
			}
			var doc = win.document;
			return [doc.clientWidth, doc.clientHeight];
		};
	} else if (html && typeof html.clientWidth == 'number') {

		// If the document element implements clientWidth/Height
		
		getViewportDimensions = function(win) {
			if (!win) {
				win = window;
			}

			var root = getRoot(win), doc = win.document;
			var clientHeight = root.clientHeight, clientWidth = root.clientWidth;				

			// Replace previous guess at root container

			if (scrollChecks) {
				root = scrollChecks.body ? doc.body : doc.documentElement;
			}

			clientHeight = root.clientHeight;
			clientWidth = root.clientWidth;

			if (scrollChecks && scrollChecks.body && scrollChecks.includeBordersInBody) {

				// Add body borders

				clientHeight += doc.body.clientTop * 2;
				clientWidth += doc.body.clientLeft * 2;
			}

			return [clientWidth, clientHeight];
		};
	} else if (typeof window.innerWidth == 'number') {

		// If the window implements innerWidth/Height

		if (html && typeof html.scrollWidth == 'number' && typeof html.clientWidth == 'number' && scrollbarHeight) {

			// Adjusted for scroll bars

			// *** NOTE: branch orphaned now (remove as not needed)

			getViewportDimensions = function(win) {
				if (!win) {
					win = window;
				}
				var root = getRoot(win);
				return [win.innerWidth - ((root.scrollHeight > root.clientHeight && win.innerWidth > scrollbarHeight) ? scrollbarHeight : 0), win.innerHeight - ((root.scrollWidth > root.clientWidth  && win.innerHeight > scrollbarHeight) ? scrollbarHeight : 0)];
			};
		} else {

			// Last resort, return innerWidth/Height
			// NOTE: May include space occupied by scroll bars

			getViewportDimensions = function(win) {
				if (!win) {
					win = window;
				}
			
				return [win.innerWidth, win.innerHeight];
			};
		}
	}

	// Test

	if (typeof doc.getElementById != 'undefined') {

		var el = doc.getElementById('indicator');

		if (el) {
			el.style.display = 'none'

			if (getViewportDimensions) {
				testResize = function() {
					var root = getRoot(window);
		
					el.style.display = 'none';

					var clientHeight = root.clientHeight;

					var d = getViewportDimensions();
					el.style.display = '';
					el.style.width = d[0] + 'px';
					el.style.height = d[1] + 'px';

					// IE8 screwiness, setting width to container clientWidth can cause a 1px overflow,
					// creating a horizontal scroll bar.

					// Next line is a mystical incantation (appears to allow IE to recalculate the container clientWidth)

					(root.clientHeight);

					if (clientHeight > root.clientHeight) {
						el.style.width = (d[0] - 0.1) + 'px';
					}
				};
			} else {
				el = doc.getElementById('testbutton');
				if (el) {
					el.disabled = true;
				}
			}
		} else {
			el = doc.getElementById('testbutton');
			if (el) {
				el.disabled = true;
			}
		}
	}

	// Discard unneeded host objects

	doc = html = null;
};

if (typeof window.document.getElementById != 'undefined' && typeof window.document.documentElement.style.display == 'string') {
	window.document.write('<fieldset><legend>Test<\/legend><input id="testbutton" type="button" onclick="window.document.getElementById(\'indicator\').style.display = \'\';testResize()" value="Open Indicator"><\/fieldset>');
}

</script>
<h2>IE Has it Right</h2>
<p>Measuring the client area of the viewport is very easy in MSHTML.  The viewport is actually an element.  Which one?  The Big One With the Scroll Bar.  We need the area inside the border, excluding space taken up by scroll bars.  MS invented the <code><a href="http://msdn.microsoft.com/en-us/library/ms533566(VS.85).aspx">clientWidth</a>/Height</code> properties for just this purpose. 
<h3>Finding the Right Element</h3>
<p>In MSHTML, the HTML element (<code>document.documentElement</code>) is used for the viewport in standards mode and the body in quirks (HTML is not rendered).  In IE6-8, the <code><a href="http://msdn.microsoft.com/en-us/library/ms533687(VS.85).aspx">document.compatMode</a></code> property indicates the rendering mode.  This property does not exist in IE < 6, but quirks mode can be detected easily enough as we know that the HTML element is not rendered in quirks mode.  Inspecting the HTML element's <code>clientWidth/Height</code> properties reveals they are 0 in quirks mode.  A document is more likely to legitimately have an 0 pixel height than width, so we will check the <code>clientWidth</code> property.</p>

<pre>
// This code works for all IE versions and modes

var getRoot, getViewportDimensions;

if (typeof doc.compatMode == 'string') {
	getRoot = function(win) {
		var doc = win.document, html = doc.documentElement, compatMode = doc.compatMode;

		return (html && compatMode.toLowerCase().indexOf('css') != -1) ? html : doc.body;
	};
} else {
	getRoot = function(win) {
		var doc = win.document, html = doc.documentElement;

		return (!html || html.clientWidth === 0) ? doc.body : html;
	};
}

getViewportDimensions = function(win) {
	if (!win) {
		win = window;
	}
	var root = getRoot(win);
	return [root.clientWidth, root.clientHeight];
};

</pre>

<h2>The Trouble with the Others</h2>
<p>The history of this critical implementation is a comedy of errors.</p>
<h3>Tried to Copy IE</h3>
<p>Over the years, the other major browsers have copied IE, but there have been troubles along the way.  For one, the browser developers observed that the properties needed to measure the client area of the viewport moved between the HTML and body elements when the rendering mode was switched, but apparently did not correlate this with the MSHTML rendering behavior.  In quirks mode, the HTML element <em>is</em> typically rendered, but its rightful (per MS) <code>clientHeight/Width</code> properties are reported by the body element.  This makes no logical sense, but doesn't hinder the initial rendition as the <code>document.compatMode</code> property still indicates the proper element <em>in most cases</em>.</p>

<h3>Opera Fouled Up Worse</h3>
<p>Prior to 9.5, Opera used the body <em>exclusively</em> to report what should be the HTML <code>clientHeight/Width</code>, which makes even less sense and requires feature testing to work around, with the body's border(s) figuring in when present.  As of 9.5, they have caught up to the other major non-IE browsers.</p>

<h3>The Window innerHeight/Width Properties</h3>
<p>More often than not, especially in modern browsers released in the last five years, these properties include space occupied by scroll bars.  Therefore we refer to these properties only as a last resort.</p>
<pre>

// Last resort, return innerWidth/Height
// NOTE: May include space occupied by scroll bars

getViewportDimensions = function(win) {
	if (!win) {
		win = window;
	}

	return [win.innerWidth, win.innerHeight];
};

</pre>

<h3>Safari 2 Oddity</h3>
<p>Some older KHTML-based browsers (e.g. Safari 2) feature <code>document.clientHeight/Width</code> properties.  These properties are arguably a better alternative to measuring elements, but are apparently no longer in production.</p>
<pre>

// This code will work in Safari 2 and other older KHTML-based browsers

getViewportDimensions = function(win) {
	if (!win) {
		win = window;
	}
	var doc = win.document;
	return [doc.clientWidth, doc.clientHeight];
};

</pre>
<h2>Putting it All Together</h2>
<p>We need a feature test to find the correct element.</p>
<pre>

var scrollChecks, html = doc.documentElement;

if (html && typeof doc.createElement != 'undefined') {

	// Test to resolve ambiguity between HTML and body

	scrollChecks = (function() {
		var oldBorder, body = doc.body, result = { compatMode: doc.compatMode };
		var clientHeight = html.clientHeight, bodyClientHeight = body.clientHeight;
		var elDiv = doc.createElement('div');
		elDiv.style.height = '100px';
		body.appendChild(elDiv);
		result.body = !clientHeight || clientHeight != html.clientHeight;
		result.html = bodyClientHeight != body.clientHeight;
		body.removeChild(elDiv);
		if (result.body || result.html && (result.body != result.html)) {

			// found single scroller--check if borders should be included
			// skipped if body is the real root (as opposed to just reporting the HTML element's client dimensions)

			if (typeof body.clientTop == 'number' && body.clientTop && html.clientWidth) {
				oldBorder = body.style.borderWidth;
				body.style.borderWidth = '0px';
				result.includeBordersInBody = body.clientHeight != bodyClientHeight;
				body.style.borderWidth = oldBorder;
			}
			return result;
		}
	})();
}

</pre>
<p>With this and the <code>getRoot</code> function, we can create a simple wrapper, choosing between 4 (5 in the longer version) different algorithms.</p>
<pre>

var doc = window.document, html = doc.documentElement;

if (typeof doc.clientWidth == 'number') {

	// If the document itself implements clientWidth/Height (e.g. Safari 2)
	// This one is a rarity.  Coincidentally KHTML-based browsers reported to implement
	// these properties have trouble with clientHeight/Width as well as innerHeight/Width.

	getViewportDimensions = function(win) {
		if (!win) {
			win = window;
		}
		var doc = win.document;
		return [doc.clientWidth, doc.clientHeight];
	};
} else if (html && typeof html.clientWidth == 'number') {

	// If the document element implements clientWidth/Height
		
	getViewportDimensions = function(win) {
		if (!win) {
			win = window;
		}

		var root = getRoot(win), doc = win.document;
		var clientHeight = root.clientHeight, clientWidth = root.clientWidth;				

		// Replace previous guess at root container

		if (scrollChecks) {
			root = scrollChecks.body ? doc.body : doc.documentElement;
		}

		clientHeight = root.clientHeight;
		clientWidth = root.clientWidth;

		if (scrollChecks && scrollChecks.body && scrollChecks.includeBordersInBody) {

			// Add body borders

			clientHeight += doc.body.clientTop * 2;
			clientWidth += doc.body.clientLeft * 2;
		}

		return [clientWidth, clientHeight];
	};
} else if (typeof window.innerWidth == 'number') {

	// Last resort, return innerWidth/Height
	// NOTE: May include space occupied by scroll bars

	getViewportDimensions = function(win) {
		if (!win) {
			win = window;
		}
			
		return [win.innerWidth, win.innerHeight];
	};
}

// Discard unneeded host object references

doc = html = null;

</pre>
<p>This can be simplified further for contexts where body borders are not used.</p>
<p>See the source for the complete rendition.  It is based on a method from <a href="http://www.cinsoft.net/mylib.html">My Library</a>.</p>
<p><a href="http://www.jibbering.com/faq/#getWindowSize">CLJ FAQ article on the same subject</a></p>
<h2>Other Primers</h2>
<ul><li><a href="attributes.html">A is for Attributes</a></li><li><a href="host.html">H is for Host</a></li><li><a href="keyboard.html">K is for Keyboard</a></li><li><a href="position.html">P is for Position</a></li><li><a rel="previous" href="size.html">S is for Size</a></li></ul>
<div id="legal">&copy; 2007-2009 by <a href="mailto:dmark@cinsoft.net">David Mark</a></div>
<div><a href="mylib.html" id="home" title="Home"><img src="images/logo.gif" height="20" width="22" alt="Home"></a></div>
<address><a href="mailto:dmark@cinsoft.net">dmark@cinsoft.net</a></address>
</body>
</html>