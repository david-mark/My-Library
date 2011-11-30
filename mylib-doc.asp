<%
Option Explicit

Response.AddHeader "Last-Modified", "22 Apr 2010 22:29:00 GMT"

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en-US">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Last-Modified" content="22 Apr 2010 22:29:00 GMT">
<title>My Library API Reference</title>
<meta name="description" content="API reference for My Library, which is a cross-browser scripting library, written in Javascript">
<meta name="keywords" content="My Library, Javascript, library, project, repository, builder, browser scripting, Ajax, comp.lang.javascript, newsgroup, documentation, reference">
<meta name="author" content="David Mark">
<link rel="home" href="mylib.html" title="Home">
<link rel="up" href="mylib-doc0.html" title="Documentation">
<link rel="next" href="mylib-doc-objects.html" title="Object Reference">
<link rel="stylesheet" type="text/css" href="style/mylib.css" media="all">
<link rel="stylesheet" type="text/css" href="style/mylib-handheld.css" media="handheld">
<link rel="stylesheet" type="text/css" href="style/mylib-print.css" media="print">
</head>
<body>
<div id="sidebar">
<a href="#content" id="skipnav">Skip Navigation</a>
<h2>Resources</h2>
<h3>Contents</h3>
<ul><li><a href="mylib.html" title="Home [1]" accesskey="1">Home</a></li><li><a href="mylib-downloads.html">Downloads</a></li><li class="current"><a href="mylib-doc0.html">Documentation</a><ul><li><span id="current">API Reference</span></li><li><a href="mylib-doc-objects.html">Object Reference</a></li></ul></li><li><a href="mylib-examples.html" title="Try out examples and generate code">Examples</a></li><li><a href="mylib-builder.asp">Builder</a></li><li><a href="mylib-test.asp?version=1.0&amp;requester=on&amp;array=on&amp;script=on&amp;mouseposition=on&amp;drag=on&amp;every=on&amp;cookie=on&amp;contextclick=on&amp;adjacent=on&amp;ajaxlink=on&amp;ajax=on&amp;event=on&amp;audio=on&amp;statusbar=on&amp;position=on&amp;scrollfx=on&amp;filter=on&amp;dispatch=on&amp;help=on&amp;flash=on&amp;opacity=on&amp;maximize=on&amp;ashtml=on&amp;foreach=on&amp;query=on&amp;serialize=on&amp;region=on&amp;class=on&amp;show=on&amp;map=on&amp;bookmark=on&amp;collections=on&amp;html=on&amp;offset=on&amp;size=on&amp;fx=on&amp;ajaxform=on&amp;overlay=on&amp;some=on&amp;crumb=on&amp;text=on&amp;dom0=on&amp;mousewheel=on&amp;preload=on&amp;margin=on&amp;ease=on&amp;dom=on&amp;setattribute=on&amp;stylesheets=on&amp;style=on&amp;coverdocument=on&amp;dollar=on&amp;objects=on&amp;import=on&amp;rollover=on&amp;locationquery=on&amp;border=on&amp;updater=on&amp;form=on&amp;image=on&amp;plugin=on&amp;directx=on&amp;present=on&amp;viewport=on&amp;fullscreen=on&amp;scroll=on&amp;center=on&amp;gethtml=on&amp;mode=HTML" title="Test full build">Build Test</a></li><li><a href="mylib-testspeed.html" title="Compare the performance of the query feature to three popular libraries">Speed Tests</a></li><li><a href="mylib-sponsors.html" title="List of our benefactors">Sponsors</a></li></ul>
<h3>Related Links</h3>
<ul><li><a href="http://www.pledgie.com/campaigns/9768" title="Please make a donation today!">Donations</a></li><li><a href="http://groups.google.com/group/my-library-general-discussion/">Discussion</a></li><li><a href="http://code.google.com/p/ourlibrary/source/checkout">Repository</a></li></ul>
<h3>Primers</h3>
<ul><li><a href="attributes.html" title="A is for Attributes primer">Attributes</a></li><li><a href="host.html" title="H is for Host primer">Host</a></li><li><a href="keyboard.html" title="K is for Keyboard primer">Keyboard</a></li><li><a href="position.html" title="P is for Position primer">Position</a></li><li><a href="size.html" title="S is for Size primer">Size</a></li><li><a href="viewport.asp" title="V is for Viewport primer">Viewport</a></li></ul>
<h3>Bookmark</h3>
<ul><li><a title="Digg this" href="http://digg.com/submit?phase=2&amp;url=http%3A%2F%2Fwww.cinsoft.net%2Fmylib-doc.html&amp;title=My%20Library&amp;bodytext=Build%20your%20own%20browser%20scripting%20library&amp;topic=programming">Digg This</a></li><li><a title="Add bookmark to deli.cio.us" href="http://del.icio.us/post?url=http%3A%2F%2Fwww.cinsoft.net%2Fmylib-doc.html">Add to deli.cio.us</a></li></ul>
<h3>Javascript Help</h3>
<ul><li><a href="http://groups.google.com/group/comp.lang.javascript/topics" title="comp.lang.javascript newsgroup">Newsgroup</a></li><li><a href="http://jibbering.com/faq/index.html" title="comp.lang.javascript newsgroup FAQ">FAQ</a></li></ul>
<script type="text/javascript">
google_ad_client = "pub-0919891272636534";
google_ad_slot = "6037707224";
google_ad_width = 120;
google_ad_height = 90;
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</div>
<div>
<a name="content"></a>
<h1><span class="redundant">My Library </span>API Reference</h1>
<p>This is the reference for the functional API, which is the only interface used by the <a href="mylib-test.asp?version=1.0&amp;requester=on&amp;array=on&amp;script=on&amp;mouseposition=on&amp;drag=on&amp;every=on&amp;cookie=on&amp;contextclick=on&amp;adjacent=on&amp;ajaxlink=on&amp;ajax=on&amp;event=on&amp;audio=on&amp;statusbar=on&amp;position=on&amp;scrollfx=on&amp;filter=on&amp;dispatch=on&amp;help=on&amp;flash=on&amp;opacity=on&amp;maximize=on&amp;ashtml=on&amp;foreach=on&amp;query=on&amp;serialize=on&amp;region=on&amp;class=on&amp;show=on&amp;map=on&amp;bookmark=on&amp;collections=on&amp;html=on&amp;offset=on&amp;size=on&amp;fx=on&amp;ajaxform=on&amp;overlay=on&amp;some=on&amp;crumb=on&amp;text=on&amp;dom0=on&amp;mousewheel=on&amp;preload=on&amp;margin=on&amp;ease=on&amp;dom=on&amp;setattribute=on&amp;stylesheets=on&amp;style=on&amp;coverdocument=on&amp;dollar=on&amp;objects=on&amp;import=on&amp;rollover=on&amp;locationquery=on&amp;border=on&amp;updater=on&amp;form=on&amp;image=on&amp;plugin=on&amp;directx=on&amp;present=on&amp;viewport=on&amp;fullscreen=on&amp;scroll=on&amp;center=on&amp;gethtml=on&amp;mode=HTML">Build Test</a> and <a href="mylib-examples.html">Examples</a> pages. There is also an <a href="mylib-doc0.html">object-oriented interface</a> built on top of the API. See the <a href="mylib-doc-objects.html">Object Reference</a> for details.</p>
<p><strong>Note</strong> the Table of Contents contains links to functions and objects, organized <em>by module</em>; however, the entries that follow are organized <em>alphabetically</em>. This incongruity, which is an issue inherited from the original documentation, will be addressed in a future revision (likely by breaking up the content into multiple documents).</p>
<ul title="Contents">
<li>(All)<ul>
<li><a href="#api">API</a></li>
</ul></li>

<li>(Multiple)<ul>
<li><a href="#arefeatures">areFeatures</a></li>
<li><a href="#attachdocumentreadylistener">attachDocumentReadyListener</a></li>
<li><a href="#createelement">createElement</a></li>
<li><a href="#documentready">documentReady</a></li>
<li><a href="#documentreadylistener">documentReadyListener</a></li>
<li><a href="#getanelement">getAnElement</a></li>
<li><a href="#getbodyelement">getBodyElement</a></li>
<li><a href="#getdocumentwindow">getDocumentWindow</a></li>
<li><a href="#getelementdocument">getElementDocument</a></li>
<li><a href="#getelementnodename">getElementNodeName</a></li>
<li><a href="#getelementparentelement">getElementParentElement</a></li>
<li><a href="#getframebyid">getFrameById</a></li>
<li><a href="#getheadelement">getHeadElement</a></li>
<li><a href="#gethtmlelement">getHtmlElement</a></li>
<li><a href="#getiframedocument">getIFrameDocument</a></li>
<li><a href="#hasattribute">hasAttribute</a></li>
<li><a href="#isdescendant">isDescendant</a></li>
<li><a href="#inherit">inherit</a></li>
<li><a href="#ishostmethod">isHostMethod</a></li>
<li><a href="#ishostobjectproperty">isHostObjectProperty</a></li>
<li><a href="#isownproperty">isOwnProperty</a></li>
<li><a href="#isrealobjectproperty">isRealObjectProperty</a></li>
<li><a href="#isxmlparsemode">isXmlParseMode</a></li>
<li><a href="#toarray">toArray</a></li>
</ul></li>

<li>(Combinations)<ul>
<li><a href="#absoluteelement">absoluteElement</a></li>
<li><a href="#adjacentelement">adjacentElement</a></li>
<li><a href="#attachdrag">attachDrag</a></li>
<li><a href="#centerelement">centerElement</a></li>
<li><a href="#coverdocument">coverDocument</a></li>
<li><a href="#detachdrag">detachDrag</a></li>
<li><a href="#fullscreenelement">fullScreenElement</a></li>
<li><a href="#getdocumenthtml">getDocumentHtml</a></li>
<li><a href="#getelementhtml">getElementHtml</a></li>
<li><a href="#getelementouterhtml">getElementOuterHtml</a></li>
<li><a href="#initiatedrag">initiateDrag</a></li>
<li><a href="#maximizeelement">maximizeElement</a></li>
<li><a href="#overlayelement">overlayElement</a></li>
<li><a href="#restoreelement">restoreElement</a></li>
<li><a href="#submitajaxform">submitAjaxForm</a></li>
</ul></li>

<li id="ajax">Ajax<ul>

<li>Requester<ul>

<li><a href="#requester">Requester</a></li>

</ul></li>

<li><a href="#createxmlhttprequest">createXmlHttpRequest</a></li>

</ul></li>


<li id="array">Array<ul>

<li>Every<ul>

<li><a href="#every">every</a></li>

</ul></li>

<li>Filter<ul>

<li><a href="#filter">filter</a></li>

</ul></li>

<li>For Each<ul>

<li><a href="#foreach">forEach</a></li>
<li><a href="#foreachproperty">forEachProperty</a></li>

</ul></li>

<li>Map<ul>

<li><a href="#map">map</a></li>

</ul></li>

<li>Some<ul>

<li><a href="#some">some</a></li>

</ul></li>

<li><a href="#pop">pop</a></li>
<li><a href="#push">push</a></li>

</ul></li>

<li id="bookmark">Bookmark<ul>

<li><a href="#addbookmark">addBookmark</a></li>
<li><a href="#addbookmarkcurrent">addBookmarkCurrent</a></li>

</ul></li>

<li id="cookie">Cookie<ul>

<li id="crumb">Crumb<ul>

<li><a href="#deletecookiecrumb">deleteCookieCrumb</a></li>
<li><a href="#getcookiecrumb">getCookieCrumb</a></li>
<li><a href="#setcookiecrumb">setCookieCrumb</a></li>

</ul></li>

<li><a href="#cookiesenabled">cookiesEnabled</a></li>
<li><a href="#deletecookie">deleteCookie</a></li>
<li><a href="#getcookie">getCookie</a></li>
<li><a href="#setcookie">setCookie</a></li>



</ul></li>


<li id="dom">DOM<ul>


<li id="collections">Collections<ul>

<li><a href="#getanchor">getAnchor</a></li>
<li><a href="#getanchors">getAnchors</a></li>
<li><a href="#getform">getForm</a></li>
<li><a href="#getforms">getForms</a></li>
<li><a href="#getimage">getImage</a></li>
<li><a href="#getimages">getImages</a></li>
<li><a href="#getlink">getLink</a></li>
<li><a href="#getlinks">getLinks</a></li>


</ul></li>

<li id="query">Query<ul>

<li id="objects">Object Wrappers<ul>

<li><a href="mylib-doc-objects.html#c">C</a></li>
<li><a href="mylib-doc-objects.html#d">D</a></li>
<li><a href="mylib-doc-objects.html#e">E</a></li>
<li><a href="mylib-doc-objects.html#f">F</a></li>
<li><a href="mylib-doc-objects.html#i">I</a></li>
<li><a href="mylib-doc-objects.html#q">Q</a></li>
<li><a href="mylib-doc-objects.html#w">W</a></li>

</ul></li>

<li><a href="#dollar">$</a></li>
<li><a href="#getebcn">getEBCN</a></li>
<li><a href="#getebcs">getEBCS</a></li>
<li><a href="#getebxp">getEBXP</a></li>

</ul></li>


<li id="script">Script<ul>
<li><a href="#addscript">addScript</a></li>
<li><a href="#addelementscript">addElementScript</a></li>
<li><a href="#setelementscript">setElementScript</a></li>


</ul></li>


<li>Set Attribute<ul>

<li id="import">Import<ul>
<li><a href="#addelementnodes">addElementNodes</a></li>
<li><a href="#importnode">importNode</a></li>
<li><a href="#setelementnodes">setElementNodes</a></li>
</ul></li>

<li><a href="#createelementwithattributes">createElementWithAttributes</a></li>
<li><a href="#createelementwithproperties">createElementWithProperties</a></li>
<li><a href="#emptynode">emptyNode</a></li>
<li><a href="#setattribute">setAttribute</a></li>
<li><a href="#setattributeproperty">setAttributeProperty</a></li>
<li><a href="#setattributeproperties">setAttributeProperties</a></li>
<li><a href="#setattributes">setAttributes</a></li>
</ul></li>

<li id="stylesheets">Style Sheet<ul>

<li><a href="#addstylerule">addStyleRule</a></li>
<li><a href="#setactivestylesheet">setActiveStyleSheet</a></li>

</ul></li>

<li id="text">Text<ul>

<li><a href="#addelementtext">addElementText</a></li>
<li><a href="#getelementtext">getElementText</a></li>
<li><a href="#setelementtext">setElementText</a></li>

</ul></li>

<li><a href="#getattribute">getAttribute</a></li>
<li><a href="#getattributeproperty">getAttributeProperty</a></li>
<li><a href="#getchildren">getChildren</a></li>
<li><a href="#getebi">getEBI</a></li>
<li><a href="#getebtn">getEBTN</a></li>

</ul></li>

<li id="event">Event<ul>


<li id="contextclick">Context Click<ul>

<li><a href="#attachcontextclicklistener">attachContextClickListener</a></li>
<li><a href="#detachcontextclicklistener">detachContextClickListener</a></li>

</ul></li>


<li id="dispatch">Dispatch<ul>

<li><a href="#dispatchevent">dispatchEvent</a></li>

</ul></li>


<li id="help">Help<ul>
<li><a href="#attachhelplistener">attachHelpListener</a></li>
<li><a href="#detachhelplistener">detachHelpListener</a></li>
</ul></li>


<li id="mouseposition">Mouse Position<ul>

<li><a href="#getmouseposition">getMousePosition</a></li>

</ul></li>


<li id="mousewheel">Mousewheel<ul>

<li><a href="#attachmousewheellistener">attachMousewheelListener</a></li>
<li><a href="#detachmousewheellistener">detachMousewheelListener</a></li>
<li><a href="#getmousewheeldelta">getMousewheelDelta</a></li>

</ul></li>

<li id="rollover">Rollover<ul>

<li><a href="#attachrolloverlisteners">attachRolloverListeners</a></li>
<li><a href="#detachrolloverlisteners">detachRolloverListeners</a></li>

</ul></li>

<li><a href="#attachdocumentlistener">attachDocumentListener</a></li>
<li><a href="#attachlistener">attachListener</a></li>
<li><a href="#attachwindowlistener">attachWindowListener</a></li>
<li><a href="#canceldefault">cancelDefault</a></li>
<li><a href="#cancelpropagation">cancelPropagation</a></li>
<li><a href="#detachdocumentlistener">detachDocumentListener</a></li>
<li><a href="#detachlistener">detachListener</a></li>
<li><a href="#detachwindowlistener">detachWindowListener</a></li>
<li><a href="#geteventtarget">getEventTarget</a></li>
<li><a href="#geteventtargetrelated">getEventTargetRelated</a></li>
<li><a href="#getkeyboardkey">getKeyboardKey</a></li>
<li><a href="#getmousebuttons">getMouseButtons</a></li>

</ul></li>

<li id="form">Form<ul>

<li id="serialize">Serialize<ul>

<li><a href="#serializeformurlencoded">serializeFormUrlencoded</a></li>

</ul></li>

<li><a href="#addoption">addOption</a></li>
<li><a href="#addoptions">addOptions</a></li>
<li><a href="#formchanged">formChanged</a></li>
<li><a href="#inputchanged">inputChanged</a></li>
<li><a href="#removeoptions">removeOptions</a></li>
<li><a href="#urlencode">urlencode</a></li>

</ul></li>

<li id="html">HTML<ul>

<li><a href="#addelementhtml">addElementHtml</a></li>
<li><a href="#setelementhtml">setElementHtml</a></li>
<li><a href="#setelementouterhtml">setElementOuterHtml</a></li>

</ul></li>

<li id="image">Image<ul>

<li id="preload">Preload<ul>

<li><a href="#preloadimage">preloadImage</a></li>
<li><a href="#clonepreloadedimage">clonePreloadedImage</a></li>

</ul></li>

<li><a href="#changeimage">changeImage</a></li>

</ul></li>

<li id="locationquery">Location Query<ul>

<li><a href="#getquery">getQuery</a></li>

</ul></li>


<li id="offset">Offset<ul>
<li><a href="#getelementposition">getElementPosition</a></li>

<li id="region">Region<ul>

<li><a href="#elementcontainedinelement">elementContainedInElement</a></li>
<li><a href="#elementoverlapselement">elementOverlapsElement</a></li>

</ul></li>


</ul></li>

<li id="plugin">Plugin<ul>


<li id="audio">Audio<ul>
<li><a href="#playaudio">playAudio</a></li>
</ul></li>

<li id="flash">Flash<ul>

<li><a href="#createflash">createFlash</a></li>
<li><a href="#flashvariables">FlashVariables</a></li>
<li><a href="#getflashversion">getFlashVersion</a></li>

</ul></li>

<li><a href="#getenabledplugin">getEnabledPlugin</a></li>

</ul></li>

<li id="scroll">Scroll<ul>
<li><a href="#getscrollposition">getScrollPosition</a></li>
<li><a href="#setscrollposition">setScrollPosition</a></li>
</ul></li>

<li id="statusbar">Status Bar<ul>

<li><a href="#setdefaultstatus">setDefaultStatus</a></li>
<li><a href="#setstatus">setStatus</a></li>

</ul></li>


<li id="style">Style<ul>

<li id="border">Border<ul>

<li><a href="#getelementborder">getElementBorder</a></li>
<li><a href="#getelementborders">getElementBorders</a></li>
<li><a href="#getelementbordersorigin">getElementBordersOrigin</a></li>

</ul></li>

<li id="class">Class<ul>

<li><a href="#addclass">addClass</a></li>
<li><a href="#hasclass">hasClass</a></li>
<li><a href="#removeclass">removeClass</a></li>

</ul></li>

<li id="directx">DirectX<ul>

<li><a href="#applydirectxtransitionfilter">applyDirectXTransitionFilter</a></li>
<li><a href="#playdirectxtransitionfilter">playDirectXTransitionFilter</a></li>

</ul></li>

<li id="margin">Margin<ul>

<li><a href="#getelementmargin">getElementMargin</a></li>
<li><a href="#getelementmargins">getElementMargins</a></li>


</ul></li>

<li id="opacity">Opacity<ul>

<li><a href="#getopacity">getOpacity</a></li>
<li><a href="#setopacity">setOpacity</a></li>

</ul></li>

<li id="position">Position<ul>

<li><a href="#positionelement">positionElement</a></li>
<li><a href="#getelementpositionstyle">getElementPositionStyle</a></li>

</ul></li>

<li id="present">Present<ul>

<li><a href="#presentelement">presentElement</a></li>
<li><a href="#toggleelementpresence">toggleElementPresence</a></li>

</ul></li>

<li id="show">Show<ul>

<li><a href="#showelement">showElement</a></li>
<li><a href="#toggleelement">toggleElement</a></li>

</ul></li>

<li id="size">Size<ul>

<li><a href="#sizeelement">sizeElement</a></li>
<li><a href="#sizeelementouter">sizeElementOuter</a></li>
<li><a href="#getelementsizestyle">getElementSizeStyle</a></li>

</ul></li>

<li id="fx">Special Effects<ul>

<li><a href="#effects">effects</a></li>

<li id="ease">Easing<ul>
<li><a href="#ease">ease</a></li>
</ul></li>
</ul></li>

<li><a href="#canadjuststyle">canAdjustStyle</a></li>
<li><a href="#getcascadedstyle">getCascadedStyle</a></li>
<li><a href="#getcomputedstyle">getComputedStyle</a></li>
<li><a href="#getstyle">getStyle</a></li>
<li><a href="#ispositionable">isPositionable</a></li>
<li><a href="#ispresent">isPresent</a></li>
<li><a href="#isvisible">isVisible</a></li>
<li><a href="#setstyle">setStyle</a></li>
<li><a href="#setstyles">setStyles</a></li>

</ul></li>

<li id="viewport">Viewport<ul>
<li><a href="#getviewportclientrectangle">getViewportClientRectangle</a></li>
<li><a href="#getviewportscrollrectangle">getViewportScrollRectangle</a></li>
<li><a href="#getviewportscrollsize">getViewportScrollSize</a></li>
<li><a href="#getviewportsize">getViewportSize</a></li>
</ul></li>

</ul>
<h2><a name="dollar">$</a></h2>
<div class="seealso immediate">
<h3>Feature Detection</h3>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The global <code>$</code> variable is an alias for <code><a href="#getebcs">getEBCS</a></code>.</p>
<h3 class="syntax">Syntax</h3>
<pre>
a = $(<em>selector</em>[, <em>node</em>]);
</pre>
<h3>Examples</h3>
<pre>
divs = $('div div div');
divs = $('div.myclass');
divs = $('#myid div');
divs = $('div + div#myid');
divs = $('div ~ div#myid');
links = $('a[href]');
homelinks = $('a[rel~=home]');
stylesheets = $('a[rel~=stylesheet]');
alternatestylesheets = $('link[rel~=stylesheet][rel~=alternate]');
</pre>
<h4>Return Value</h4>
<p>The function returns an array of elements.</p>
<h2><a name="api">API</a></h2>
<p>The global <code>API</code> variable is an object that encapsulates all library functions.</p>
<h3><a name="absoluteelement">absoluteElement</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>absoluteElement</code> function positions an element absolutely, preserving its position and size.</p>
<h4 class="syntax">Syntax</h4>
<pre>
absoluteElement(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
API.absoluteElement(el);
</pre>
<h3><a name="addbookmark">addBookmark</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>addBookmark</code> function calls on the browser to display its bookmarking (AKA favorites) dialog with the supplied location and title.</p>
<h4 class="syntax">Syntax</h4>
<pre>
addBookmark(<em>href</em>, <em>title</em>[, <em>win</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.addBookmark('http://www.hartkelaw.net', 'Hartke Law Firm');
</pre>
<h3><a name="addbookmarkcurrent">addBookmarkCurrent</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>addBookmarkCurrent</code> function calls on the browser to display its bookmarking (AKA favorites) dialog with the current location and title.</p>
<h4 class="syntax">Syntax</h4>
<pre>
addBookmarkCurrent([<em>win</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.addBookmarkCurrent();
</pre>
<h3><a name="addclass">addClass</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#hasclass">hasClass</a></li><li><a href="#removeclass">removeClass</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>addClass</code> function adds a CSS class to an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
addClass(<em>el</em>, <em>className</em>);
</pre>
<h4>Examples</h4>
<pre>
API.addClass(el, 'sidebar');
</pre>
<h3><a name="addelementhtml">addElementHtml</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setelementhtml">setElementHtml</a></li><li><a href="#setelementouterhtml">setElementOuterHtml</a></li></ul></div>
<div class="seealso deferred"><h4>Feature Detection</h4><p><a href="mylib-doc0.html#deferred">Deferred</a></p></div>
<p>The <code>addElementHtml</code> function adds <code>HTML</code> to an element, preserving listeners attached to the existing nodes.</p>
<h4 class="syntax">Syntax</h4>
<pre>
addElementHtml(<em>el</em>, <em>html</em>);
</pre>
<h4>Examples</h4>
<pre>
API.addElementHtml(el, '&lt;p&gt;And the first guy says...&lt;/p&gt;');
</pre>
<h3><a name="addelementscript">addElementScript</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setelementhtml">setElementScript</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>addElementScript</code> function adds script to a <code>script</code> element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
addElementScript(<em>el</em>, <em>script</em>);
</pre>
<h4>Examples</h4>
<pre>
API.addElementScript(el, 'window.alert("Hello world!")');
</pre>
<h3><a name="addelementnodes">addElementNodes</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setelementnodes">setElementNodes</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>addElementNodes</code> function adds nodes to an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
addElementNodes(<em>el</em>, <em>elNewNodes</em>);
</pre>
<h4>Examples</h4>
<pre>
API.setElementHtml(elNew, '&lt;p&gt;Why would I exchange it?&lt;/p&gt;&lt;p&gt;It's the perfect colour!&lt;/p&gt;');
API.addElementNodes(elDiv, elNew);
</pre>
<h3><a name="addelementtext">addElementText</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setelementtext">setElementText</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>addElementText</code> function adds text to an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
addElementText(<em>el</em>, <em>text</em>);
</pre>
<h4>Examples</h4>
<pre>
API.addElementText(el, 'Burma-Shave');
</pre>
<h3><a name="addoption">addOption</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#addoptions">addOptions</a></li><li><a href="#removeoptions">removeOptions</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>addOption</code> function adds an option to a select element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
addOption(<em>el</em>, <em>text</em>[, <em>value</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.addOption(el, 'Apples');
API.addOption(el, 'Apples', 'apples');
elOption = API.addOption(el, 'oranges');
</pre>
<h4>Return Value</h4>
<p>The function returns the new option.</p>
<h3><a name="addoptions">addOptions</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#addoption">addOption</a></li><li><a href="#removeoptions">removeOptions</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>addOptions</code> function adds one or more options to a select element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
opt = addOption(<em>el</em>, <em>options</em>);
</pre>
<h4>Examples</h4>
<pre>
API.addOptions(el, { apples:'Apples', oranges:'Oranges' });
</pre>
<h3><a name="addscript">addScript</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>addScript</code> function adds script to a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
addScript(<em>text</em>[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.addScript('window.alert("Hello World!")');
API.addScript('window.alert("Hello Yourself!")', doc);
</pre>
<h3><a name="addstylerule">addStyleRule</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#canadjuststyle">canAdjustStyle</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>addStyleRule</code> function adds a CSS rule to a document. It is typically used to hide content during the page load, after which the content is enhanced and/or made visible, depending on the available features of the environment.</p>
<p><strong>Note</strong> that the <code><a href="#canadjuststyle">canAdjustStyle</a></code> function should be consulted before hiding content in this way.</p>
<h4 class="syntax">Syntax</h4>
<pre>
addStyleRule(<em>selector</em>, <em>rule</em>[, <em>media</em>[, <em>docNode</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.addStyleRule('.banner { display:none }', 'handheld');
API.addStyleRule('.flash { visibility:hidden }');
API.addStyleRule('.flash { visibility:hidden }', 'all', doc);
</pre>
<h3><a name="adjacentelement">adjacentElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#overlayelement">overlayElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>adjacentElement</code> function positions an element adjacent to another.</p>
<h4 class="syntax">Syntax</h4>
<pre>
adjacentElement(<em>el</em>, <em>elAdjacent</em>[, <em>side</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.adjacentElement(elMenu, elParentMenu, 'right');
</pre>
<h3><a name="applydirectxtransitionfilter">applyDirectXTransitionFilter</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#playdirectxtransitionfilter">playDirectXTransitionFilter</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>applyDirectXTransitionFilter</code> function applies a DirectX transition.</p>
<h4 class="syntax">Syntax</h4>
<pre>
applyDirectXTransitionFilter(<em>el</em>, <em>name</em>[,<em>duration</em>[, <em>params</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.applyDirectXTransitionFilter(el, 'fade', 1000);
API.applyDirectXTransitionFilter(el, 'iris', { irisstyle:'STAR' });
</pre>

<h3><a name="arefeatures">areFeatures</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>areFeatures</code> function is used to test features of the API. This allows application to degrade gracefully in older, buggy or otherwise limited environments.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = areFeatures(<em>feature1</em>[, <em>feature2</em>, ... <em>feature n</em>]);
</pre>
<h4>Examples</h4>
<pre>
canRunApp = API.areFeatures('getEBI', 'getOpacity', 'setScrollPosition');
</pre>

<h3><a name="attachcontextclicklistener">attachContextClickListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachlistener">attachListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>attachContextClickListener</code> function adds a listener to an element for two events (<code>contextmenu</code> and <code>mouseup</code>), calling the specified function once per click of the context button.</p>
<h4 class="syntax">Syntax</h4>
<pre>
attachContextClickListener(<em>el</em>, <em>fn</em>[, <em>context</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.attachContextClickListener(el, function() { window.alert('Do not do this!'); });
API.attachContextClickListener(el, function() { this.log('context'); }, clickHistory);
</pre>
<h3><a name="attachdocumentlistener">attachDocumentListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachlistener">attachListener</a></li><li><a href="#attachwindowlistener">attachWindowListener</a></li><li><a href="#detachdocumentlistener">detachDocumentListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>attachDocumentListener</code> function adds an event listener to a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
attachDocumentListener(<em>ev</em>, <em>fn</em>[, <em>docNode</em>[, <em>context</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.attachDocumentListener('click', function() { window.alert('Hello again!'); });
API.attachDocumentListener('click', function() { window.alert('Hello from another document'); }, doc);
API.attachDocumentListener('click', function() { this.doSomethingElse(); }, doc, someObject);
</pre>
<h3><a name="attachdocumentreadylistener">attachDocumentReadyListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachdocumentlistener">attachDocumentListener</a></li><li><a href="#attachwindowlistener">attachWindowListener</a></li><li><a href="#documentready">documentReady</a></li><li><a href="#documentreadylistener">documentReadyListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>attachDocumentReadyListener</code> function adds a <code>DOMContentLoaded</code> listener to a document and a <code>load</code> listener to the document's window, calling the specified function once when the document is ready for programmatic manipulation. The <code>load</code> event is used as a fallback for browsers that do not support the <code>DOMContentLoaded</code> event (e.g. Internet Explorer, Safari.) As the load event is not fired until all document assets (e.g. images, Flash movies) are fully loaded, it is usually preferable to call the <code><a>documentReady</a></code> function from a script at the end of the <code>body</code> element. The <a href="mylib-domready.js">Document Ready</a> add-on serves this purpose.</p>
<p><strong>Note</strong> that some features of the library are <a href="mylib-doc0.html#deferred">not available until the document is ready</a> (e.g. DirectX.) Code that utilizes these features should be wrapped in a function that is passed to <code>attachDocumentReadyListener</code>.</p>
<h4 class="syntax">Syntax</h4>
<pre>
attachDocumentReadyListener(<em>fn</em>[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.attachDocumentReadyListener(function() { window.alert('Ready!'); });
API.attachDocumentReadyListener(function() { window.alert('Me too!'); }, doc);
if (!API.attachDocumentReadyListener(function() { window.alert('Me too!'); }, doc)) {
  window.alert('No idea when that document will be ready');
}
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean indicating whether the operation was successful.</p>

<h3><a name="attachdrag">attachDrag</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#detachdrag">detachDrag</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>attachDrag</code> function enables an element to be dragged.</p>
<h4 class="syntax">Syntax</h4>
<pre>
attachDrag(<em>el</em>[, <em>elHandle</em>[, <em>options</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.attachDrag(el);
API.attachDrag(el, elHandle);
API.attachDrag(el, elHandle, { ondrop: function() { window.alert('Dropped!' } });
</pre>

<h3><a name="attachhelplistener">attachHelpListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachlistener">attachListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>attachHelpListener</code> function adds a listener to an element for two events (<code>help</code> and <code>keydown</code>), calling the specified function once per press of the help key.</p>
<h4 class="syntax">Syntax</h4>
<pre>
attachHelpListener(<em>el</em>, <em>fn</em>[, <em>context</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.attachHelpListener(el, function() { window.alert('Help!'); });
API.attachHelpListener(el, function() { this.showHelp(); }, helpObject);
</pre>
<h3><a name="attachlistener">attachListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachdocumentlistener">attachDocumentListener</a></li><li><a href="#attachwindowlistener">attachWindowListener</a></li><li><a href="#detachlistener">detachListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>attachListener</code> function adds an event listener to an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
attachListener(<em>el</em>, <em>ev</em>, <em>fn</em>[, <em>context</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.attachListener(el, 'click', function() { window.alert('Clicked!'); });
API.attachListener(el, 'click', function(e) { this.onclick(e); }, someObject);
</pre>
<h3><a name="attachmousewheellistener">attachMousewheelListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachlistener">attachListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>attachMousewheelListener</code> function adds a listener for two events (<code>mousewheel</code> and <code>dommousescroll</code>), calling the specified function once per mousewheel movement. In addition to passing the standard event parameter, a second argument indicates the direction and distance of the movement.</p>
<h4 class="syntax">Syntax</h4>
<pre>
attachMousewheelListener(<em>el</em>, <em>fn</em>[, <em>context</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.attachMousewheelListener(el, function(e, delta) { window.status = delta; });
API.attachMousewheelListener(el, function(e, delta) { this.onmousewheel(e, delta); }, someObject);
</pre>
<h3><a name="attachrolloverlisteners">attachRolloverListeners</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachlistener">attachListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>attachRolloverListeners</code> function adds listeners to an element for two events (<code>mouseover</code> and <code>mouseout</code>), calling each of the two passed functions as appropriate. Optionally, it adds the listeners for the <code>focus</code> and <code>blur</code> events. Another option allows for the automatic display of the element's title in the status bar (requires Status Bar module.)</p>
<h4 class="syntax">Syntax</h4>
<pre>
attachRolloverListeners(<em>el</em>, <em>fnOver</em>, <em>fnOut</em>[, <em>context</em>[, bAddFocusListeners[, bSetStatus]]]);
</pre>
<h4>Examples</h4>
<pre>
API.attachRolloverListeners(el, function() { window.status = 'over'; }, function() { window.status = 'and out'; } );
API.attachRolloverListeners(el, function(e) { this.onover(e); }, function(e) { this.onout(e); }, someObject);
</pre>
<h3><a name="attachwindowlistener">attachWindowListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachdocumentlistener">attachDocumentListener</a></li><li><a href="#attachlistener">attachListener</a></li><li><a href="#detachwindowlistener">detachWindowListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>attachWindowListener</code> function adds an event listener to a window.</p>
<h4 class="syntax">Syntax</h4>
<pre>
attachWindowListener(<em>ev</em>, <em>fn</em>[, <em>win</em>[, <em>context</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.attachWindowListener('resize', function() { window.status = 'Resized'; });
API.attachWindowListener('scroll', function(e) { this.onscroll(e); }, win, someObject);
</pre>
<h3><a name="canadjuststyle">canAdjustStyle</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#addstylerule">addStyleRule</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>canAdjustStyle</code> function tests if the specified style (<code>display</code>, <code>position</code> or <code>visibility</code>) can be changed programmatically.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = canAdjustStyle(<em>style</em>);
</pre>
<h4>Examples</h4>
<pre>
if (API.canAdjustStyle('visibility') && API.canAdjustStyle('display')) {
  enhanceDocument();
}
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="canceldefault">cancelDefault</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#cancelpropagation">cancelPropagation</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>cancelDefault</code> function prevents the default action of an event.</p>
<h4 class="syntax">Syntax</h4>
<pre>
cancelDefault(<em>e</em>);
</pre>
<h4>Examples</h4>
<pre>
API.cancelDefault(e);
return API.cancelDefault(e); // Compatible with DOM0
</pre>
<h3><a name="cancelpropagation">cancelPropagation</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#canceldefault">cancelDefault</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>cancelPropagation</code> function prevents the bubbling of an event.</p>
<h4 class="syntax">Syntax</h4>
<pre>
cancelPropagation(<em>e</em>);
</pre>
<h4>Examples</h4>
<pre>
API.cancelPropagation(e);
</pre>
<h3><a name="centerelement">centerElement</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>centerElement</code> function centers an element in the viewport.</p>
<h4 class="syntax">Syntax</h4>
<pre>
centerElement(<em>el</em>[, options[, callback]]);
</pre>
<h4>Examples</h4>
<pre>
API.centerElement(el);
API.centerElement(el, { duration:1000, ease:API.ease.circle });
API.centerElement(el, { duration:1000, ease:API.ease.circle }, fn);
</pre>
<p><strong>Note</strong> that like <a href="#showelement">showElement</a>, <a href="#sizeelement">sizeElement</a>, <a href="#positionelement">positionElement</a>, <a href="#maximizeelement">maximizeElement</a>, <a href="#restoreelement">restoreElement</a>, <a href="#setelementhtml">setElementHtml</a> and <a href="#setelementnodes">setElementNodes</a> this function has an <code>async</code> property, which determines whether a callback is supported.  This is used by the test page as it has to deal with any build, but is not needed for normal applications as the signature is known at build time, in this case depending on whether FX is included.</p>
<h3><a name="changeimage">changeImage</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#preloadimage">preloadImage</a></li></ul></div>
<div class="seealso">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#hybrid">Hybrid</a></p>
</div>
<p>The <code>changeImage</code> function changes the source of an image. The source may be specified by an image location or the handle of a preloaded image. The optional parameters are for use with effects modules (e.g. DirectX), which replace the standard function with one that supports progressively rendered changeovers.</p>
<h4 class="syntax">Syntax</h4>
<pre>
changeImage(<em>el</em>, <em>src</em>[, options[, callback]]);
</pre>
<h4>Examples</h4>
<pre>
API.changeImage(el, 'http://www.cinsoft.net/images/cinsoft.gif');
API.changeImage(el, 'http://www.cinsoft.net/images/cinsoft.gif', { effects: API.effects.fade, duration:1000, ease:API.ease.circle });
API.changeImage(el, 'http://www.cinsoft.net/images/cinsoft.gif', { effects: [API.effects.fade, API.effects.grow], duration:1000, ease:API.ease.circle });
</pre>
<h3><a name="clonepreloadedimage">clonePreloadedImage</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#preloadimage">preloadImage</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>clonePreloadedImage</code> function creates an image element from a preloaded image.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = clonePreloadedImage(<em>handle</em>);
</pre>
<h4>Examples</h4>
<pre>
handle = API.preloadImage('http://www.cinsoft.net/images/cinsoft.gif', 100, 100);
img = API.clonePreloadedImage(handle);
</pre>
<h4>Return Value</h4>
<p>The function returns an image element.</p>
<h3><a name="cookiesenabled">cookiesEnabled</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#deletecookie">deleteCookie</a></li><li><a href="#getcookie">getCookie</a></li><li><a href="#setcookie">setCookie</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>cookiesEnabled</code> function tests if cookies are enabled.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = cookiesEnabled();
</pre>
<h4>Examples</h4>
<pre>
var b = API.cookiesEnabled();
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="coverdocument">coverDocument</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>coverDocument</code> function sizes and positions an element to cover the document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
coverDocument(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
API.coverDocument(el);
</pre>
<h3><a name="createelement">createElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#createelementwithattributes">createElementWithAttributes</a></li><li><a href="#createelementwithproperties">createElementWithProperties</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>createElement</code> function creates an (X)HTML element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = createElement(<em>tag</em>[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
el = API.createElement('div');
el = API.createElement('div', doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an element.</p>
<h3><a name="createelementwithattributes">createElementWithAttributes</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#createelement">createElement</a></li><li><a href="#createelementwithproperties">createElementWithProperties</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>createElementWithAttributes</code> function creates an (X)HTML element and sets one or more attributes.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = createElementWithAttributes(<em>tag</em>, attributes[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
el = API.createElementWithAttributes('div', { id:'me', 'class':'hello' });
el = API.createElementWithAttributes('div', { id:'you', 'class':'hello' }, doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an element.</p>
<h3><a name="createelementwithproperties">createElementWithProperties</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#createelement">createElement</a></li><li><a href="#createelementwithattributes">createElementWithAttributes</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>createElementWithProperties</code> function creates an (X)HTML element and sets one or more properties.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = createElementWithProperties(<em>tag</em>, properties[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
el = API.createElementWithProperties('input', { type:'checkbox', checked:true });
el = API.createElementWithProperties('input', { type:'checkbox', checked:true }, doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an element.</p>
<h3><a name="createflash">createFlash</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#flashvariables">FlashVariables</a></li><li><a href="#getflashversion">getFlashVersion</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>createFlash</code> function creates a Flash movie, replacing the element with the specified <code>id</code> (if the required version of Flash is available). The Flash movie is not created until the document is ready. The fallback content is hidden during load (when possible).</p>
<h4 class="syntax">Syntax</h4>
<pre>
createFlash(<em>uri</em>, <em>id</em>[, <em>options</em>]);
</pre>
<h4>Examples</h4>
<pre>
var vars = new API.FlashVariables();
vars.addQuery('name1');
vars.addBookmark('name3');
vars.add('name1', 'Test 1');
vars.add('name2', 'Test 2');
vars.add('name3', 'Test 3');
API.createFlash('http://www.cinsoft.net/flash/testflash_vars.swf', 'flashFallback2', { height:120, width:300, variables:vars, versionRequired:6 });
</pre>
<h3><a name="createxmlhttprequest">createXmlHttpRequest</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>createXmlHttpRequest</code> creates an XHR object.</p>
<h4 class="syntax">Syntax</h4>
<pre>
xhr = createXmlHttpRequest();
</pre>
<h4>Examples</h4>
<pre>
xhr = API.createXmlHttpRequest();
</pre>
<h4>Return Value</h4>
<p>The function returns an XHR object.</p>
<h3><a name="deletecookie">deleteCookie</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#cookiesenabled">cookiesEnabled</a></li><li><a href="#deletecookiecrumb">deleteCookieCrumb</a></li><li><a href="#setcookie">setCookie</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>deleteCookie</code> function deletes a cookie.</p>
<h4 class="syntax">Syntax</h4>
<pre>
deleteCookie(<em>name</em>[, <em>path</em>[, <em>docNode</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.deleteCookie('test');
</pre>
<h3><a name="deletecookiecrumb">deleteCookieCrumb</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#deletecookie">deleteCookie</a></li><li><a href="#getcookiecrumb">getCookieCrumb</a></li><li><a href="#setcookiecrumb">setCookieCrumb</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>deleteCookieCrumb</code> function deletes a portion of a cookie.</p>
<h4 class="syntax">Syntax</h4>
<pre>
deleteCookieCrumb(<em>name</em>, <em>crumb</em>[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.deleteCookieCrumb('test', 'testing');
</pre>

<h3><a name="detachcontextclicklistener">detachContextClickListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachcontextclicklistener">attachContextClickListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>detachContextClickListener</code> function removes context click-related event listeners.</p>
<h4 class="syntax">Syntax</h4>
<pre>
detachContextClickListener(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
API.detachContextClickListener(el);
</pre>

<h3><a name="detachhelplistener">detachHelpListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachhelplistener">attachHelpListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>detachHelpListener</code> function removes context help-related event listeners.</p>
<h4 class="syntax">Syntax</h4>
<pre>
detachHelpListener(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
API.detachHelpListener(el);
</pre>

<h3><a name="detachlistener">detachListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachlistener">attachListener</a></li><li><a href="#detachdocumentlistener">detachDocumentListener</a></li><li><a href="#detachwindowlistener">detachWindowListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>detachListener</code> function removes an event listener from an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
detachListener(<em>el</em>, <em>ev</em>, <em>fn</em>);
</pre>
<h4>Examples</h4>
<pre>
API.detachListener(el, 'click', fn);
</pre>
<h3><a name="detachdocumentlistener">detachDocumentListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachdocumentlistener">attachDocumentListener</a></li><li><a href="#detachlistener">detachListener</a></li><li><a href="#detachwindowlistener">detachWindowListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>detachDocumentListener</code> function removes an event listener from a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
detachDocumentListener(<em>ev</em>, <em>fn</em>[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.detachDocumentListener('click', fn);
API.detachDocumentListener('click', fn, doc);
</pre>

<h3><a name="detachdrag">detachDrag</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachdrag">attachDrag</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>detachDrag</code> function disables dragging for an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
detachDrag(<em>el</em>[, <em>elHandle</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.detachDrag(el);
API.detachDrag(el, elHandle);
</pre>

<h3><a name="detachmousewheellistener">detachMousewheelListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachmousewheellisteners">attachMousewheelListeners</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>detachMousewheelListener</code> function removes mousewheel-related event listeners.</p>
<h4 class="syntax">Syntax</h4>
<pre>
detachMousewheelListener(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
API.detachRolloverListeners(el);
</pre>

<h3><a name="detachrolloverlisteners">detachRolloverListeners</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachrolloverlisteners">attachRolloverListeners</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>detachRolloverListeners</code> function removes rollover-related event listeners.</p>
<h4 class="syntax">Syntax</h4>
<pre>
detachRolloverListeners(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
API.detachRolloverListeners(el);
</pre>

<h3><a name="detachwindowlistener">detachWindowListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachwindowlistener">attachWindowListener</a></li><li><a href="#detachlistener">detachListener</a></li><li><a href="#detachdocumentlistener">detachDocumentListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>detachWindowListener</code> function removes an event listener from a window.</p>
<h4 class="syntax">Syntax</h4>
<pre>
detachWindowListener(<em>ev</em>, <em>fn</em>[, <em>win</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.detachWindowListener('resize', fn);
API.detachWindowListener('scroll', fn, win);
</pre>

<h3><a name="dispatchevent">dispatchEvent</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>dispatchEvent</code> function fires an event for an element, resulting in the execution of listeners attached to the specified event.</p>
<h4 class="syntax">Syntax</h4>
<pre>
dispatchEvent(<em>el</em>, <em>ev</em>[, <em>evType</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.dispatchEvent(el, 'click');
</pre>
<h3><a name="documentready">documentReady</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachdocumentreadylistener">attachDocumentReadyListener</a></li><li><a href="#documentreadylistener">documentReadyListener</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>documentReady</code> function tests if the document is ready.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = documentReady();
</pre>
<h4>Examples</h4>
<pre>
b = API.documentReady();
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="documentreadylistener">documentReadyListener</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachdocumentreadylistener">attachDocumentReadyListener</a></li><li><a href="#documentready">documentReady</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>documentReadyListener</code> function is called internally when the document is ready. It is exposed as a method so it can be called by script at the end of the <code>body</code> element, such as the <a href="mylib-domready.js">Document Ready</a> add-on.</p>
<h4 class="syntax">Syntax</h4>
<pre>
documentReadyListener();
</pre>
<h4>Examples</h4>
<pre>
API.documentReadyListener();
</pre>
<h3><a name="ease">ease</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>ease</code> object contains easing functions.</p>
<ul title="Easing functions"><li>bounce</li><li>circle</li><li>cosine</li><li>cube</li><li>expo</li><li>flicker</li><li>loop</li><li>pulsate</li><li>quad</li><li>sigmoid</li><li>sigmoid2</li><li>sigmoid3</li><li>sigmoid4</li><li>sine</li><li>square</li><li>swingTo</li><li>swingToFrom</li><li>tan</li><li>wobble</li></ul>
<h4 class="syntax">Syntax</h4>
<pre>
p = ease(p);
</pre>
<h4>Examples</h4>
<pre>
API.ease.linear = function(p) {
  return p;
};
</pre>
<p>...where <code>p</code> is a number from 0 to 1.</p>
<h3><a name="effects">effects</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>effects</code> object contains effect functions.</p>
<ul title="Effect functions"><li>clip</li><li>drop</li><li>fade</li><li>fold</li><li>grow</li><li>horizontalBlinds</li><li>move</li><li>scroll</li><li>slide</li><li>verticalBlinds</li><li>zoom</li></ul>
<h4 class="syntax">Syntax</h4>
<pre>
effect(<em>el</em>, <em>p</em>, <em>scratch</em>[, <em>endCode</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.effects.something = function(el, p, scratch, endCode) {
  switch (endCode) {
  case 1:

    // Store inline styles in scratch

    break;
  case 2:

    // Not normally needed

    break;
  case 3:

    // Restore inline styles from scratch

    break;
  }
};
</pre>
<p>The <code>endCode</code> argument indicates that the effect should initialize (1), complete early due to interruption (2) or revert back to the initial state (3). For example, the interruption code is passed when an effect timer is stopped prematurely (via its <code>stop</code> method) and the revert code is always passed by <a href="#showelement">showElement</a> on hiding an element so that the effect(s) can reload for subsequent shows. The <code>scratch</code> object is typically used to store (on initialization) and restore (on reverting) inline styles. Effects typically involve mutating styles of the element per the percentage (<code>p</code>).</p>
<h3><a name="elementcontainedinelement">elementContainedInElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#elementoverlapselement">elementOverlapsElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>elementContainedInElement</code> determines whether an element is <em>completely</em> contained in another (according to the layout, not the DOM structure).</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = elementContainedInElement(<em>el</em>, <em>elContainer</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.elementContainedInElement(el, elContainer);
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="elementoverlapselement">elementOverlapsElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#elementcontainedinelement">elementContainedInElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>elementOverlapsElement</code> determines whether two elements overlap.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = elementOverlapsElement(<em>el</em>, <em>el2</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.elementOverlaysElement(el, el2);
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="every">every</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#some">some</a></li><li><a href="https://developer.mozilla.org/En/Core_JavaScript_1.5_Reference/Objects/Array/Every" class="external">every (MDC)</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>every</code> function calls the specified function for each element of the specified array, returning true if every result is true.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = every(<em>a</em>, <em>fn</em>[, <em>context</em>]);
</pre>
<h4>Examples</h4>
<pre>
b = API.every(a, function(el, i) { return true; });
b = API.every(a, function(el, i) { return this[i] == el; }, someObject);
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>

<h3><a name="emptynode">emptyNode</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>emptyNode</code> function empties a document or element of nodes.</p>
<h4 class="syntax">Syntax</h4>
<pre>
emptyNode(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
API.emptyNode(el);
API.emptyNode(doc);
</pre>


<h3><a name="filter">filter</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#map">map</a></li><li><a href="https://developer.mozilla.org/En/Core_JavaScript_1.5_Reference/Objects/Array/Filter" class="external">filter (MDC)</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>filter</code> function calls the specified function for each element of the specified array, returning a new array of only the elements for which the result was true.</p>
<h4 class="syntax">Syntax</h4>
<pre>
a = filter(<em>a</em>, <em>fn</em>[, <em>context</em>]);
</pre>
<h4>Examples</h4>
<pre>
a = API.filter(a, function(el, i) { return true; });
a = API.filter(a, function(el, i) { return this[i] == el; }, someObject);
</pre>
<h4>Return Value</h4>
<p>The function returns a new array.</p>
<h3><a name="flashvariables">FlashVariables</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#createflash">createFlash</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <em>FlashVariables</em> method constructs an object representing variables for a Flash movie.</p>
<h4 class="syntax">Syntax</h4>
<pre>
vars = new FlashVariables();
</pre>
<h4>Examples</h4>
<pre>
var vars = new API.FlashVariables();
vars.addQuery('name1');
vars.addBookmark('name3');
vars.add('name1', 'Test 1');
vars.add('name2', 'Test 2');
vars.add('name3', 'Test 3');
</pre>
<h3><a name="foreach">forEach</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#foreachproperty">forEachProperty</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>forEach</code> function calls the specified function for each element of the specified array.</p>
<h4 class="syntax">Syntax</h4>
<pre>
forEach(<em>a</em>, <em>fn</em>[, <em>context</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.forEach(a, function(el, i) { el.id = 'test' + i });
API.forEach(a, function(el, i) { el.id = this.id(i) }, someObject);
</pre>
<p><strong>Note</strong> that the <code><a href="#foreach">forEach</a></code> function is only to be used with native array objects and does <em>not</em> guarantee order. <em>Never</em> pass host objects. Convert array-like host objects to arrays with <a href="#toarray">toArray</a>.</p>
<h3><a name="foreachproperty">forEachProperty</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#foreach">forEach</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>forEachProperty</code> function calls the specified function for each enumerable property of the specified object.</p>
<p><strong>Note</strong> that properties inherited from the object's prototype are excluded.</p>
<h4 class="syntax">Syntax</h4>
<pre>
forEachProperty(<em>o</em>, <em>fn</em>[, <em>context</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.forEachProperty(o, function(el, i) { el.id = 'test' + i });
API.forEachProperty(o, function(el, i) { el.id = this.id(i) }, someObject);
</pre>
<p><strong>Note</strong> that the this function is only to be used with native objects. <em>Never</em> pass host objects.</p>
<h3><a name="formchanged">formChanged</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#inputchanged">inputChanged</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>formChanged</code> function determines if one or more of the controls contained by the specified form have changed.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = formChanged(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.formChanged(el);
</pre>

<h3><a name="fullscreenelement">fullScreenElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#maximizeelement">maximizeElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>fullScreenElement</code> function displays an element using all of the available space in the viewport, hiding the scrollbars to accomodate.</p>
<h4 class="syntax">Syntax</h4>
<pre>
fullScreenElement(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
API.fullScreenElement(el);
</pre>
<h3><a name="getanchor">getAnchor</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getanchors">getAnchors</a></li><li><a href="#getlink">getLink</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getAnchor</code> function finds an anchor element by name or index.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getAnchor(<em>i</em>[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
elAnchor = API.getAnchor(0);
elAnchor = API.getAnchor('myanchor');
</pre>
<h4>Return Value</h4>
<p>The function returns an anchor element or <code>null</code> if none is found to match the specified name or index.</p>
<h3><a name="getanchors">getAnchors</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getanchor">getAnchor</a></li><li><a href="#getlinks">getLinks</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getAnchors</code> function finds all anchor elements in a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
a = getAnchors([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
anchors = API.getAnchors();
anchors = API.getAnchors(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array or array-like object.</p>
<p><strong>Note</strong> array-like host objects are <em>live</em> collections, so handle with results with care. Use the <a href="#toarray"><code>toArray</code></a> function to convert to an array.</p>
<h3><a name="getanelement">getAnElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#gethtmlelement">getHtmlElement</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getAnElement</code> function returns the first element in a document (typically the <code>html</code> element.)</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getAnElement([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
el = API.getAnElement('myid');
el = API.getAnElement('yourid', doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an element or <code>null</code> if none is found.</p>
<h3><a name="getattribute">getAttribute</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getattributeproperty">getAttributeProperty</a></li><li><a href="#hasattribute">hasAttribute</a></li><li><a href="#setattribute">setAttribute</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getAttribute</code> function returns the value of the specified attribute of the specified element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
v = getAttribute(<em>el</em>, <em>name</em>);
</pre>
<h4>Examples</h4>
<pre>
c = API.getAttribute(el, 'class');
s = API.getAttribute(el, 'style');
</pre>
<h4>Return Value</h4>
<p>The function returns a string or <code>null</code> if the specified attribute does not exist.</p>
<h3><a name="getattributeproperty">getAttributeProperty</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setattributeproperty">setAttributeProperty</a></li><li><a href="#getattribute">getAttribute</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getAttributeProperty</code> function returns the <em>property</em> value of the specified attribute of the specified element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
v = getAttributeProperty(<em>el</em>, <em>name</em>);
</pre>
<h4>Examples</h4>
<pre>
c = API.getAttributeProperty(el, 'class');
b = API.getAttributeProperty(el, 'readonly');
</pre>
<h4>Return Value</h4>
<p>The function returns the property value. For boolean properties, a boolean is always returned. For other types, <code>null</code> is returned if the specified attribute is missing.</p>
<h3><a name="getbodyelement">getBodyElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getheadelement">getHeadElement</a></li><li><a href="#gethtmlelement">getHtmlElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getBodyElement</code> function returns the <code>body</code> element of a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getBodyElement([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
elBody = API.getBodyElement();
elBody = API.getBodyElement(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns a <code>body</code> element or <code>null</code> if none is found.</p>
<h3><a name="getcascadedstyle">getCascadedStyle</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getcomputedstyle">getComputedStyle</a></li><li><a href="#getstyle">getStyle</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getCascadedStyle</code> function returns the named cascaded style of an element.</p>
<p><strong>Note</strong> this function is rarely used externally. Use <a href="#getstyle">getStyle</a> or <a href="#getcomputedstyle">getComputedStyle</a> instead.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getCascadedStyle(<em>el</em>, <em>style</em>);
</pre>
<h4>Examples</h4>
<pre>
s = API.getCascadedStyle(el, 'color');
s = API.getCascadedStyle(el, 'backgroundColor');
</pre>
<p><strong>Note</strong> that as with all style-related functions, the name of the style must be in camel-case.</p>
<h4>Return Value</h4>
<p>The function returns a string or <code>null</code>.</p>
<h3><a name="getchildren">getChildren</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getChildren</code> function returns all child elements of an element or document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
a = getChildren(<em>node</em>);
</pre>
<h4>Examples</h4>
<pre>
c = API.getChildren(el);
c = API.getChildren(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array.</p>
<h3><a name="getcomputedstyle">getComputedStyle</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getcascadedstyle">getCascadedStyle</a></li><li><a href="#getstyle">getStyle</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getComputedStyle</code> function returns the named computed style of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getComputedStyle(<em>el</em>, <em>style</em>);
</pre>
<h4>Examples</h4>
<pre>
s = API.getComputedStyle(el, 'color');
s = API.getComputedStyle(el, 'backgroundColor');
</pre>
<p><strong>Note</strong> that as with all style-related functions, the name of the style must be in camel-case.</p>
<h4>Return Value</h4>
<p>The function returns a string or <code>null</code>.</p>
<h3><a name="getcookie">getCookie</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#cookiesenabled">cookiesEnabled</a></li><li><a href="#deletecookie">deleteCookie</a></li><li><a href="#setcookie">setCookie</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getCookie</code> function returns the cookie with the specified name.</p>
<h4 class="syntax">Syntax</h4>
<pre>
c = getCookie(<em>name</em>[, <em>defaultValue</em>[, <em>encoded</em>[, <em>docNode</em>]]]);
</pre>
<h4>Examples</h4>
<pre>
c = API.getCookie('test');
c = API.getCookie('test', '');
</pre>
<h4>Return Value</h4>
<p>The function returns a string or <code>null</code> if a cookie with the specified name does not exist.</p>
<h3><a name="getcookiecrumb">getCookieCrumb</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#deletecookiecrumb">deleteCookieCrumb</a></li><li><a href="#getcookie">getCookie</a></li><li><a href="#setcookiecrumb">setCookieCrumb</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getCookieCrumb</code> function returns a portion of a cookie.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getCookieCrumb(<em>name</em>, <em>crumb</em>[, <em>defaultValue</em>[, <em>docNode</em>]]);
</pre>
<h4>Examples</h4>
<pre>
c = API.getCookieCrumb('test', 'me');
c = API.getCookieCrumb('test', 'me', '');
</pre>
<h4>Return Value</h4>
<p>The function returns a string or <code>null</code> if a cookie with the specified name does not exist.</p>
<h3><a name="getdocumentwindow">getDocumentWindow</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getelementdocument">getElementDocument</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getDocumentWindow</code> function returns the containing window of a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
win = getDocumentWindow([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
win = API.getDocumentWindow();
win = API.getDocumentWindow(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns a window.</p>
<h3><a name="getebi">getEBI</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getebcn">getEBCN</a></li><li><a href="#getebcs">getEBCS</a></li><li><a href="#getebtn">getEBTN</a></li><li><a href="#getebxp">getEBXP</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getEBI</code> function returns an element with the specified ID.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getEBI(<em>id</em>[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
el = API.getEBI('myid');
el = API.getEBI('yourid', doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an element with the specified ID or <code>null</code> if not found.</p>
<h3><a name="getelementborder">getElementBorder</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getelementborders">getElementBorders</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getElementBorder</code> function returns the width of the named border of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
w = getElementBorder(<em>id</em>, <em>side</em>);
</pre>
<h4>Examples</h4>
<pre>
t = API.getElementBorder(el, 'top');
r = API.getElementBorder(el, 'right');
</pre>
<h4>Return Value</h4>
<p>The function returns a number of pixels.</p>
<h3><a name="getelementborders">getElementBorders</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getelementborder">getElementBorder</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getElementBorders</code> function returns an object containing all border widths of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
o = getElementBorders(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
o = API.getElementBorders(el);
window.alert('Top border is: ' + o.top + ' pixels');
</pre>
<h4>Return Value</h4>
<p>The function returns an object with properties named for each side (top, left, bottom and right), containing a number of pixels.</p>
<h3><a name="getelementbordersorigin">getElementBordersOrigin</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getelementborder">getElementBorder</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getElementBordersOrigin</code> function returns an object containing the top and left border widths of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
o = getElementBordersOrigin(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
o = API.getElementBordersOrigin(el);
window.alert('Left border is: ' + o.left + ' pixels');
</pre>
<h4>Return Value</h4>
<p>The function returns an object with properties named for each side (top and left), containing a number of pixels.</p>
<h3><a name="getebcn">getEBCN</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getebcs">getEBCS</a></li><li><a href="#getebi">getEBI</a></li><li><a href="#getebtn">getEBTN</a></li><li><a href="#getebxp">getEBXP</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getEBCN</code> function returns elements with the specified class name(s) from an element or document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getEBCN(<em>className</em>[, <em>node</em>]);
</pre>
<h4>Examples</h4>
<pre>
els = API.getEBCN('myclass');
els = API.getEBCN('myclass yourclass');
els = API.getEBCN('otherclass');
els = API.getEBCN('otherotherclass', doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array.</p>
<h3><a name="getebcs">getEBCS</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getebcn">getEBCN</a></li><li><a href="#getebi">getEBI</a></li><li><a href="#getebtn">getEBTN</a></li><li><a href="#getebxp">getEBXP</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getEBCS</code> function returns elements that match the specified CSS selector from an element or document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getEBCS(<em>selector</em>[, <em>node</em>]);
</pre>
<h4>Examples</h4>
<pre>
els = API.getEBCS('div');
els = API.getEBCS('div div div');
els = API.getEBCS('.myclass');
els = API.getEBCS('#myid');
els = API.getEBCS('#myid p.myclass');
els = API.getEBCS('div:first-child');
els = API.getEBCS('div:only-child');
els = API.getEBCS('div:nth-child(5)');
els = API.getEBCS('h2 + div');
els = API.getEBCS('h2 + div#myid');
els = API.getEBCS('h2 ~ div#myid');
</pre>
<h4>Return Value</h4>
<p>The function returns an array.</p>
<h3><a name="getebtn">getEBTN</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getebcn">getEBCN</a></li><li><a href="#getebcs">getEBCS</a></li><li><a href="#getebi">getEBI</a></li><li><a href="#getebxp">getEBXP</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getEBTN</code> function returns elements with the specified tag name from an element or document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getEBTN(<em>tag</em>[, <em>node</em>]);
</pre>
<h4>Examples</h4>
<pre>
els = API.getEBTN('div');
els = API.getEBTN('div', el);
els = API.getEBTN('div', doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array or array-like host object.</p>
<p><strong>Note</strong> array-like host objects are <em>live</em> collections, so handle with results with care. Use the <a href="#toarray"><code>toArray</code></a> function to convert to an array.</p>
<h3><a name="getebxp">getEBXP</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getebcn">getEBCN</a></li><li><a href="#getebcs">getEBCS</a></li><li><a href="#getebi">getEBI</a></li><li><a href="#getebtn">getEBTN</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getEBXP</code> function returns elements that match the specified XPath expression from an element or document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getEBXP(<em>path</em>[, <em>node</em>]);
</pre>
<h4>Examples</h4>
<pre>
els = API.getEBXP('.//h2/following-sibling::*');
els = API.getEBXP('.//h2/following-sibling::*', el);
els = API.getEBXP('.//h2/following-sibling::*', doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array.</p>
<h3><a name="getelementdocument">getElementDocument</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getdocumentwindow">getDocumentWindow</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getElementDocument</code> function returns the containing document of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getElementDocument(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
doc = API.getElementDocument(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a document or <code>null</code> if the element is part of a fragment.</p>

<h3><a name="getelementmargin">getElementMargin</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getelementmargins">getElementMargins</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getElementMargin</code> function returns the width of the named margin of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
w = getElementMargin(<em>id</em>, <em>side</em>);
</pre>
<h4>Examples</h4>
<pre>
m = API.getElementMargin(el, 'top');
</pre>
<h4>Return Value</h4>
<p>The function returns a number of pixels.</p>
<h3><a name="getelementmargins">getElementMargins</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getelementmargin">getElementMargin</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getElementMargins</code> function returns an object containing all margin widths of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
o = getElementMargins(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
o = API.getElementMargins(el);
</pre>
<h4>Return Value</h4>
<p>The function returns an object with properties named for each side (top, left, bottom and right), containing a number of pixels.</p>
<h3><a name="getelementmargins">getElementMarginsOrigin</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getelementmargin">getElementMargin</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getElementMarginsOrigin</code> function returns an object containing the top and left margin widths of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
o = getElementMargins(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
o = API.getElementMarginsOrigin(el);
</pre>
<h4>Return Value</h4>
<p>The function returns an object with properties named for each side (top and left), containing a number of pixels.</p>

<h3><a name="getelementnodename">getElementNodeName</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getElementNodeName</code> function returns the tag name of an element in lower case. In XHTML DOM's, only the default HTML namespace is supported.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getElementNodeName(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
s = API.getElementNodeName(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a string.</p>

<h3><a name="getelementparentelement">getElementParentElement</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getElementParentElement</code> function returns the parent element of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getElementParentElement(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
el = API.getElementParentElement(el);
</pre>
<h4>Return Value</h4>
<p>The function returns an element or <code>null</code> if the element is has no parent element (e.g. is the child of a document.)</p>
<h3><a name="getelementposition">getElementPosition</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getElementPosition</code> function returns the absolute position of an element or the position relative to the specified ancestor.</p>
<h4 class="syntax">Syntax</h4>
<pre>
p = getElementPosition(<em>el</em>[, <em>elContainer</em>]);
</pre>
<h4>Examples</h4>
<pre>
p = API.getElementPosition(el);
p = API.getElementPosition(el, elContainer);
</pre>
<h4>Return Value</h4>
<p>The function returns an array containing the top and left coordinates.</p>

<h3><a name="getelementpositionstyle">getElementPositionStyle</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#positionelement">positionElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getElementPositionStyle</code> function returns the CSS top and left positions. For statically positioned elements, it returns the position it would have were it absolutely positioned.</p>
<h4 class="syntax">Syntax</h4>
<pre>
p = getElementPositionStyle(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
p = API.getElementPositionStyle(el);
</pre>
<h4>Return Value</h4>
<p>The function returns an array containing the top and left positions in pixels.</p>

<h3><a name="getelementsizestyle">getElementSizeStyle</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#sizeelement">sizeElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getElementSizeStyle</code> function returns the CSS height and width dimensions.</p>
<h4 class="syntax">Syntax</h4>
<pre>
d = getElementSizeStyle(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
d = API.getElementSizeStyle(el);
</pre>
<h4>Return Value</h4>
<p>The function returns an array containing the height and width in pixels.</p>

<h3><a name="getelementtext">getElementText</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setelementtext">setElementText</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getElementText</code> function returns the text of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getElementText(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
s = API.getElementText(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a string.</p>

<h3><a name="getdocumenthtml">getDocumentHtml</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getelementhtml">getElementHtml</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getDocumentHtml</code> function retrieves the inner <code>HTML</code> of a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getDocumentHtml(<em>doc</em>);
</pre>
<h4>Examples</h4>
<pre>
html = API.getDocumentHtml(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a string.</p>

<h3><a name="getelementhtml">getElementHtml</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getelementouterhtml">getElementOuterHtml</a></li><li><a href="#setelementhtml">setElementHtml</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getElementHtml</code> function retrieves the inner <code>HTML</code> of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getElementHtml(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
html = API.getElementHtml(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a string.</p>

<h3><a name="getelementouterhtml">getElementOuterHtml</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getelementhtml">getElementHtml</a></li><li><a href="#setelementouterhtml">setElementOuterHtml</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getElementOuterHtml</code> function retrieves the outer <code>HTML</code> of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getElementOuterHtml(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
html = API.getElementOuterHtml(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a string.</p>


<h3><a name="getenabledplugin">getEnabledPlugin</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getEnabledPlugin</code> function returns the description of an enabled plugin that matches the specified MIME type or title.</p>
<h4 class="syntax">Syntax</h4>
<pre>
p = getEnabledPlugin(<em>mimeType</em>[, <em>title</em>]);
</pre>
<h4>Examples</h4>
<pre>
p = API.getEnabledPlugin('audio/x-wav');
</pre>
<h4>Return Value</h4>
<p>The function returns a string or <code>null</code> if an enabled plugin is not found.</p>
<h3><a name="geteventtarget">getEventTarget</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#geteventtargetrelated">getEventTargetRelated</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getEventTarget</code> function returns the target element of an event.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getEventTarget(<em>e</em>);
</pre>
<h4>Examples</h4>
<pre>
el = API.getEventTarget(e);
</pre>
<h4>Return Value</h4>
<p>The function returns an element.</p>
<h3><a name="geteventtargetrelated">getEventTargetRelated</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#geteventtarget">getEventTarget</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getEventTarget</code> function returns the related target element of an event. For example, on a <code>mouseover</code> event, the related target is the element the pointer is coming from</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getEventTargetRelated(<em>e</em>);
</pre>
<h4>Examples</h4>
<pre>
el = API.getEventTargetRelated(e);
</pre>
<h4>Return Value</h4>
<p>The function returns an element or <code>null</code> if there is no related target.</p>
<h3><a name="getform">getForm</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getforms">getForms</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getForm</code> function finds a form element by name or index.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getForm(<em>i</em>[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
el = API.getForm(0);
el = API.getForm('myform');
el = API.getForm('yourform', doc);
</pre>
<h4>Return Value</h4>
<p>The function returns a form element or <code>null</code> if none is found to match the specified name or index.</p>
<h3><a name="getforms">getForms</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getform">getForm</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getForms</code> function finds all form elements in a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
a = getForms([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
els = API.getForms();
els = API.getForms(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array or array-like object.</p>
<p><strong>Note</strong> array-like host objects are <em>live</em> collections, so handle with results with care. Use the <a href="#toarray"><code>toArray</code></a> function to convert to an array.</p>
<h3><a name="getflashversion">getFlashVersion</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#createflash">createFlash</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getFlashVersion</code> function returns the installed Flash version <em>if available</em>.</p>
<h4 class="syntax">Syntax</h4>
<pre>
ver = getFlashVersion();
</pre>
<h4>Examples</h4>
<pre>
ver = API.getFlashVersion();
</pre>
<h4>Return Value</h4>
<p>The function returns an object containing the major (<code>version</code>), minor (<code>versionMinor</code>) and revision (<code>versionRevision</code>) versions as numbers and the full (<code>versionFull</code>) version as a string.</p>
<h3><a name="getheadelement">getHeadElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getbodyelement">getBodyElement</a></li><li><a href="#gethtmlelement">getHtmlElement</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getHeadElement</code> function returns the <code>head</code> element of a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getHeadElement([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
el = API.getHeadElement();
el = API.getHeadElement(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns a <code>head</code> element or <code>null</code> if none is found.</p>

<h3><a name="getframebyid">getFrameById</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getFrameById</code> retrieves a frame (or IFrame) window by name (or ID).</p>
<h4 class="syntax">Syntax</h4>
<pre>
frame = getFrameById(<em>id</em>[, <em>win</em>]);
</pre>
<h4>Examples</h4>
<pre>
frame = API.getFrameById('myid');
frame = API.getFrameById('myid', win);
</pre>
<h4>Return Value</h4>
<p>The function returns a window object or <code>null</code> if none is found.</p>

<h3><a name="gethtmlelement">getHtmlElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getbodyelement">getBodyElement</a></li><li><a href="#getheadelement">getHeadElement</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getHtmlElement</code> function returns the <code>html</code> element of a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getHtmlElement([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
el = API.getHtmlElement();
el = API.getHtmlElement(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an <code>html</code> element or <code>null</code> if none is found.</p>

<h3><a name="getiframedocument">getIFrameDocument</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getIFrameDocument</code> function returns the document contained in an <code>iframe</code> element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
doc = getIFrameDocument(<em>el</em>[, <em>win</em>]);
</pre>
<h4>Examples</h4>
<pre>
doc = API.getIFrameDocument(el);
doc = API.getIFrameDocument(el, win);
</pre>
<h4>Return Value</h4>
<p>The function returns a document.</p>


<h3><a name="getimage">getImage</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getimages">getImages</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getImage</code> function finds an image element by name or index.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getImage(<em>i</em>[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
el = API.getImage(0);
el = API.getImage('testimage');
el = API.getImage(0, doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an image element or <code>null</code> if none is found to match the specified name or index.</p>
<h3><a name="getimages">getImages</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getimage">getImage</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getImages</code> function finds all image elements in a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
a = getImages([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
els = API.getImages();
els = API.getImages(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array or array-like object.</p>
<p><strong>Note</strong> array-like host objects are <em>live</em> collections, so handle with results with care. Use the <a href="#toarray"><code>toArray</code></a> function to convert to an array.</p>
<h3><a name="getkeyboardkey">getKeyboardKey</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getKeyboardKey</code> function returns the code of the keyboard key (or character for <code>keypress</code> events) related to an event.</p>
<h4 class="syntax">Syntax</h4>
<pre>
n = getKeyboardKey(<em>e</em>);
</pre>
<h4>Examples</h4>
<pre>
k = API.getKeyboardKey(e);
</pre>
<h4>Return Value</h4>
<p>The function returns a number.</p>
<h3><a name="getlink">getLink</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getlinks">getLinks</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getLink</code> function finds a link by name or index.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = getLink(<em>i</em>[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
el = API.getLink(0);
el = API.getLink('testlink');
el = API.getLink(0, doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an anchor element or <code>null</code> if none is found to match the specified name or index.</p>
<h3><a name="getlinks">getLinks</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getlink">getLink</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getLinks</code> function finds all links in a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
a = getLinks([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
els = API.getLinks();
els = API.getLinks(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array or array-like object.</p>
<p><strong>Note</strong> array-like host objects are <em>live</em> collections, so handle with results with care. Use the <a href="#toarray"><code>toArray</code></a> function to convert to an array.</p>
<h3><a name="getmousebuttons">getMouseButtons</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getMouseButtons</code> function returns the state of the mouse buttons during an event.</p>
<h4 class="syntax">Syntax</h4>
<pre>
o = getMouseButtons(<em>e</em>);
</pre>
<h4>Examples</h4>
<pre>
o = API.getMouseButtons(e);
</pre>
<h4>Return Value</h4>
<p>The function returns a object with boolean <code>left</code>, <code>middle</code> and <code>right</code> properties.</p>
<h3><a name="getmouseposition">getMousePosition</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getMousePosition</code> function returns the position of the mouse, relative to the document, during an event.</p>
<p><strong>Note</strong> that this method may rewrite itself at any time, so always get a fresh reference before calling (or call as a method of API).</p>
<h4 class="syntax">Syntax</h4>
<pre>
a = getMousePosition(<em>e</em>);
</pre>
<h4>Examples</h4>
<pre>
a = API.getMousePosition(e);
</pre>
<h4>Return Value</h4>
<p>The function returns an array containing the top and left coordinates (in pixels.)</p>
<h3><a name="getmousewheeldelta">getMousewheelDelta</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getMousewheelDelta</code> function returns the distance and direction traveled by the mousewheel during an event.</p>
<h4 class="syntax">Syntax</h4>
<pre>
n = getMousewheelDelta(<em>e</em>);
</pre>
<h4>Examples</h4>
<pre>
n = API.getMousewheelDelta(e);
</pre>
<h4>Return Value</h4>
<p>The function returns a number.</p>
<h3><a name="getopacity">getOpacity</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setopacity">setOpacity</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getOpacity</code> function returns the opacity of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
o = getOpacity(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
o = API.getOpacity(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a number from 0 to 1.</p>
<h3><a name="getoptionvalue">getOptionValue</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getOptionValue</code> function returns the value of the specified option element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getOptionValue(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
s = API.getOptionValue(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a string.</p>
<h3><a name="getquery">getQuery</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getQuery</code> function returns the value of the named search parameter.</p>
<h4 class="syntax">Syntax</h4>
<pre>
q = getQuery(<em>name</em>[, <em>defaultValue</em>]);
</pre>
<h4>Examples</h4>
<pre>
q = API.getQuery('testing');
q = API.getQuery('testing', '123');
</pre>
<h4>Return Value</h4>
<p>The function returns a string or <code>null</code>.</p>
<h3><a name="getscrollposition">getScrollPosition</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getScrollPosition</code> function returns the scroll position of a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
a = getScrollPosition([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
a = API.getScrollPosition();
a = API.getScrollPosition(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array containing the top and left scroll positions or <code>null</code> if the position cannot be determined.</p>
<p><strong>Note</strong> that this method may rewrite itself at any time, so always get a fresh reference before calling (or call as a method of API).</p>
<h3><a name="getstyle">getStyle</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getcomputedstyle">getComputedStyle</a></li><li><a href="#getcascadedstyle">getCascadedStyle</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>getStyle</code> function returns the named style of an element or <code>null</code> if unavailable. The function will attempt to use the <a href="#getcomputedstyle"><code>getComputedStyle</code></a> or <a href="#getcascadedstyle"><code>getCascadedStyle</code></a> functions and then the inline style if necessary.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getStyle(<em>el</em>, <em>style</em>);
</pre>
<h4>Examples</h4>
<pre>
s = API.getStyle(el, 'color');
s = API.getStyle(el, 'backgroundColor');
</pre>
<h4>Return Value</h4>
<p>The function returns a string or <code>null</code>.</p>
<p><strong>Note</strong> that as with all style-related functions, the name of the style must be in camel-case.</p>
<h3><a name="getviewportclientrectangle">getViewportClientRectangle</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getViewportClientRectangle</code> function returns the size and scroll position of the viewport.</p>
<h4 class="syntax">Syntax</h4>
<pre>
r = getViewportClientRectangle([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
r = API.getViewportClientRectangle();
r = API.getViewportClientRectangle(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array containing the top, left, height and width of the viewport.</p>
<h3><a name="getviewportscrollrectangle">getViewportScrollRectangle</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getviewportscrollsize">getViewportScrollSize</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getViewportScrollRectangle</code> function returns the top, left, height and width of the top-level rendered element (HTML or body) in a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
r = getViewportScrollRectangle([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
r = API.getViewportScrollRectangle();
r = API.getViewportScrollRectangle(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array containing the top, left, height and width of the top-level rendered element (HTML or body).</p>
<h3><a name="getviewportscrollsize">getViewportScrollSize</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getviewportscrollrectangle">getViewportScrollRectangle</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getViewportScrollSize</code> function returns the size of the top-level rendered element (HTML or body).</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getViewportScrollSize([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
r = API.getViewportScrollSize();
r = API.getViewportScrollSize(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array containing the height and width of the top-level rendered element (HTML or body) in a document.</p>
<h3><a name="getviewportsize">getViewportSize</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>getViewportSize</code> function returns the size of a viewport for the specified document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = getViewportSize([<em>window</em>]);
</pre>
<h4>Examples</h4>
<pre>
s = API.getViewportSize(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns an array containing the height and width of the viewport.</p>
<h3><a name="hasattribute">hasAttribute</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getattribute">getAttribute</a></li><li><a href="#setattribute">setAttribute</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>hasAttribute</code> function tests if the specified element has an attribute with the specified name.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = hasAttribute(<em>el</em>, <em>name</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.hasAttribute(el, 'id');
b = API.hasAttribute(el, 'for');
b = API.hasAttribute(el, 'rel');
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="hasclass">hasClass</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#addclass">addClass</a></li><li><a href="#removeclass">removeClass</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>hasClass</code> function tests if the specified element has the specified CSS class.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = hasClass(<em>el</em>, <em>className</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.hasClass(el, 'myclass');
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="importnode">importNode</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>importNode</code> function imports an element from one document into another.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = importNode(<em>el</em>[, <em>bImportChildren</em>[, <em>docNode</em>]]);
</pre>
<h4>Examples</h4>
<pre>
el = API.importNode(elExport);
el = API.importNode(elExportWithChildren, true);
</pre>
<h4>Return Value</h4>
<p>The function returns the imported element.</p>

<h3><a name="inherit">inherit</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="mylib-doc-objects.html#c">C</a></li><li><a href="mylib-doc-objects.html#f">F</a></li><li><a href="mylib-doc-objects.html#i">I</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>inherit</code> function creates an inheritance relationship between two constructor functions.</p>
<h4 class="syntax">Syntax</h4>
<pre>
inherit(<em>fnSub</em>, <em>fnSuper</em>);
</pre>
<h4>Examples</h4>
<pre>
API.inherit(fnSub, fnSuper);
</pre>

<h3><a name="initiateDrag">initiateDrag</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#attachdrag">attachDrag</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>initiateDrag</code> function starts a drag action.</p>
<h4 class="syntax">Syntax</h4>
<pre>
initiateDrag(<em>el</em>[, <em>elHandle</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.initiateDrag(el);
API.initiateDrag(el, elHandle);
</pre>

<h3><a name="inputchanged">inputChanged</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#formchanged">formChanged</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>inputChanged</code> function determines whether a form control has changed.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = inputChanged(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.inputChanged(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>

<h3><a name="inputvalue">inputValue</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#inputchanged">inputChanged</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>inputValue</code> function retrieves the value of a form control.</p>
<h4 class="syntax">Syntax</h4>
<pre>
value = inputValue(<em>el</em>[, <em>default</em>]);
</pre>
<h4>Examples</h4>
<pre>
value = API.inputValue(el);
defaultValue = API.inputValue(el, true);
</pre>
<h4>Return Value</h4>
<p>The function returns a string or array.</p>

<h3><a name="isdescendant">isDescendant</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>isDescendant</code> function determines if an element is the ancestor of another.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = isDescendant(<em>elAncestor</em>, <em>elDescendant</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.isDescendant(elAncestor, elDescendant);
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>

<h3><a name="ishostmethod">isHostMethod</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>isHostMethod</code> function tests if the specified host object property references an object.</p>
<p>If the referenced object will not be called, use <a href="#ishostobjectproperty"><code>isHostObjectProperty</code></a>.</p>
<p>Allowed properties may be of type function, object (IE and possibly others) or unknown (IE ActiveX methods). Object types exclude null.</p>
<p>This test does <em>not</em> assert that an arbitrary property is callable. Pass only names of properties universally implemented as methods.</p>
<p>This test does <em>not</em> support properties that are methods in some browsers but not others (e.g. <code>childNodes</code>). This test will not discriminate between such implementations and applications should never call such objects.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = isHostMethod(<em>o</em>, <em>p</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.isHostMethod(el, 'getElementsByTagName');
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>

<h3><a name="ishostobjectproperty">isHostObjectProperty</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>isHostObjectProperty</code> function tests if the specified host object property references an object that is safe to evaluate. ActiveX methods and other properties of type <code>unknown</code> are excluded.</p>
<p>If the referenced object will be called, use <a href="#ishostmethod"><code>isHostMethod</code></a>.</p>
<p>Allowed properties may be of type function, object (IE and possibly others). Object types exclude null.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = isHostObjectProperty(<em>o</em>, <em>p</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.isHostObjectProperty(el, 'parentNode');
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>

<h3><a name="isownproperty">isOwnProperty</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>isOwnProperty</code> function tests if the specified object does not inherit the specified property from its prototype. The property is stipulated to exist. This function is typically used to filter inherited properties within for-in loops.</p>
<p><strong>Note</strong> the object must be native, <em>not</em> a host object.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = isOwnProperty(<em>o</em>, <em>p</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.isOwnProperty(o, 'apples');
b = API.isOwnProperty(o, 'oranges');
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="ispositionable">isPositionable</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>isPositionable</code> function determines if an element is positionable (position style is not <code>static</code>).</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = isPositionable(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.isPositionable(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="ispresent">isPresent</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#isvisible">isVisible</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>isPresent</code> function determines if an element is part of the layout (display style is not <code>none</code>).</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = isPresent(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.isPresent(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>

<h3><a name="isrealobjectproperty">isRealObjectProperty</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>isRealObjectProperty</code> function tests if the specified object property references an object.</p>
<p><strong>Note</strong> this function is not for use with host objects.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = isRealObjectProperty(<em>o</em>, <em>p</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.isRealObjectProperty(obj, 'tree');
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>

<h3><a name="isvisible">isVisible</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#ispresent">isPresent</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>isVisible</code> function determines if an element is visible (according to its style) and part of the layout (display style is not <code>none</code>).</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = isVisible(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
b = API.isVisible(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="isxmlparsemode">isXmlParseMode</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>isXmlParseMode</code> function tests if a document was parsed as XML. It is not magic as there are certain practices that <em>must</em> be followed to best ensure its accuracy.</p>
<p>You should include an appropriate Content-Type <code>meta</code> in the head of your documents (at least for HTML documents) as this ensures there will not be false positives. Putting an inappropriate Content-Type <code>meta</code> in documents that are to be served with an XML MIME type (e.g. <code>application/xhtml+xml</code>) will cause false negatives in some browsers, so should be avoided. For example, something like this should <em>never</em> appear in an XHTML document served as XML:</p>
<pre>&lt;meta http-equiv="Content-Type" content="text/html; charset=utf-8" /&gt;</pre>
<p>...but something along those lines (minus the slash) should <em>always</em> be present in a document served as HTML.</p>
<p><strong>Note</strong> that when serving HTML documents (virtually the only type served on the Web today), to avoid all confusion, you can simply disable this check entirely by setting API.disableXmlParseMode to <code>true</code> (highly recommended). This must be set prior to loading My Library:</p>
<pre>
var API = { disableXmlParseMode:true };
</pre>
<p>XHTML support can also be filtered at build time, in which case the above setting is superfluous (XML parse mode will never be detected).</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = isXmlParseMode([<em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
b = API.isXmlParseMode();
b = API.isXmlParseMode(doc);
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="map">map</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#filter">filter</a></li><li><a href="https://developer.mozilla.org/En/Core_JavaScript_1.5_Reference/Objects/Array/Map" class="external">map (MDC)</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>map</code> function calls the specified function for each element of the specified array, returning a new array of the results.</p>
<h4 class="syntax">Syntax</h4>
<pre>
a = map(<em>a</em>, <em>fn</em>[, <em>context</em>]);
</pre>
<h4>Examples</h4>
<pre>
a = map(a, function(el) { return el.id; });
a = map(a, function(el) { return this.fetchId(el); }, someObject);
</pre>
<h4>Return Value</h4>
<p>The function returns a new array.</p>
<h3><a name="maximizeelement">maximizeElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#fullscreenelement">fullScreenElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>maximizeElement</code> sizes and positions an element to fill its viewport.</p>
<h4 class="syntax">Syntax</h4>
<pre>
maximizeElement(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
API.maximizeElement(el);
</pre>
<h3><a name="overlayelement">overlayElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#adjacentelement">adjacentElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>overlayElement</code> function positions an element to overlay another, optionally covering it.</p>
<h4 class="syntax">Syntax</h4>
<pre>
overlayElement(<em>el</em>, <em>elOver</em>[, <em>cover</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.overlayElement(el, elTarget);
API.overlayElement(el, elTarget, true);
</pre>
<h3><a name="playaudio">playAudio</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>playAudio</code> function plays one or more audio files.</p>
<p><strong>Note</strong> that the boolean <code>API.deferAudio</code> property determines whether audio plug-ins are loaded when the document is ready (default) or when the first audio file is played (recommended). The unfortunate default will be changed in the future to defer the loading of plug-ins as plug-ins should not load without an explicit user action.</p>
<h4 class="syntax">Syntax</h4>
<pre>
playAudio(<em>files</em>, <em>time</em>[, <em>cb</em>[, <em>ext</em>[, <em>volume</em>]]]);
</pre>
<h4>Examples</h4>
<pre>
API.playAudio('ding.wav', 1000);
</pre>
<h3><a name="playdirectxtransitionfilter">playDirectXTransitionFilter</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#applydirectxtransitionfilter">applyDirectXTransitionFilter</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>playDirectXTransitionFilter</code> function plays a DirectX transition.</p>
<h4 class="syntax">Syntax</h4>
<pre>
playDirectXTransitionFilter(<em>el</em>, <em>name</em>);
</pre>
<h4>Examples</h4>
<pre>
API.playDirectXTransitionFilter(el, 'fade');
</pre>


<h3><a name="pop">pop</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#push">push</a></li><li><a href="https://developer.mozilla.org/En/Core_JavaScript_1.5_Reference/Objects/Array/Pop" class="external">pop (MDC)</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>pop</code> function removes the last element from an array and returns that the value of that element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
x = pop(a);
</pre>
<h4>Examples</h4>
<pre>
x = API.pop(a);
</pre>
<h4>Return Value</h4>
<p>The function returns the value of an array element.</p>


<h3><a name="positionelement">positionElement</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>positionElement</code> function positions an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
positionElement(<em>el</em>, <em>top</em>, <em>left</em>[, <em>options</em>[, <em>callback</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.positionElement(el, 0, 0);
API.positionElement(el, 0, 0, { duration:1000, ease:API.ease.circle });
</pre>
<h3><a name="preloadimage">preloadImage</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#changeimage">changeImage</a></li><li><a href="#clonepreloadedimage">clonePreloadedImage</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>preloadImage</code> function loads and stores the specified image resource.</p>
<h4 class="syntax">Syntax</h4>
<pre>
handle = preloadImage(<em>src</em>, <em>h</em>, <em>w</em>);
</pre>
<h4>Examples</h4>
<pre>
handle = API.preloadImage('cinsoft.gif', 100, 100);
</pre>
<h4>Return Value</h4>
<p>The function returns a numeric handle to reference the stored image.</p>
<h3><a name="presentelement">presentElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#showelement">showElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>presentElement</code> function adds or removes an element from the layout (e.g. sets its display property).</p>
<h4 class="syntax">Syntax</h4>
<pre>
presentElement(<em>el</em>[, <em>b</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.presentElement(el);
API.presentElement(el, false);
</pre>

<h3><a name="push">push</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#push">push</a></li><li><a href="https://developer.mozilla.org/En/Core_JavaScript_1.5_Reference/Objects/Array/Push" class="external">push (MDC)</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>push</code> function apppends elements to an array and returns the new length of the array.</p>
<h4 class="syntax">Syntax</h4>
<pre>
push(a, x1[, x2, ..., xN]);
</pre>
<h4>Examples</h4>
<pre>
API.push(a, x);
API.push(a, x, y);
API.push(a, x, y, z);
</pre>
<h4>Return Value</h4>
<p>The function returns a number.</p>



<h3><a name="removeclass">removeClass</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#addclass">addClass</a></li><li><a href="#hasclass">hasClass</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>removeClass</code> function removes a CSS class from an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
removeClass(<em>el</em>, <em>className</em>);
</pre>
<h4>Examples</h4>
<pre>
API.removeClass(el, 'testclass');
</pre>
<h3><a name="removeoptions">removeOptions</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#addoption">addOption</a></li><li><a href="#addoptions">addOptions</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>removeOptions</code> function removes all options from a select element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
removeOptions(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
API.removeOptions(el);
</pre>
<h3><a name="requester">Requester</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>Requester</code> function is a constructor that creates an object that simplifies the process of sending Ajax requests.</p>
<h4 class="syntax">Syntax</h4>
<pre>
requester = new Requester([<em>sId</em>[, <em>sGroup</em>]]);
</pre>
<h4>Examples</h4>
<pre>
r = API.Requester('id');
r = API.Requester('id', 'groupid');
</pre>
<h3><a name="restoreelement">restoreElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#fullscreenelement">fullScreenElement</a></li><li><a href="#maximizeelement">maximizeElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>restoreElement</code> function restores the size and position of a previously maximized or full-screen element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
restoreElement(<em>el</em>);
</pre>
<h4>Examples</h4>
<pre>
API.restoreElement(el);
</pre>
<h3><a name="serializeformurlencoded">serializeFormUrlencoded</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#urlencode">urlencode</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>serializeFormUrlencoded</code> function encodes name/value pairs of a <code>form</code> element according to the specification of the <code>application/x-www-form-urlencoded</code> MIME type.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = serializeFormUrlencoded(<em>form</em>);
</pre>
<h4>Examples</h4>
<pre>
s = API.serializeFormUrlencoded(el);
</pre>
<h4>Return Value</h4>
<p>The function returns a string.</p>
<h3><a name="setactivestylesheet">setActiveStyleSheet</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setActiveStyleSheet</code> function activates style sheets with the specified ID for a document. Style sheets with ID's other than the one specified are deactivated. This function is typically used to switch between alternate style sheets.</p>
<h4 class="syntax">Syntax</h4>
<pre>
setActiveStyleSheet(<em>id</em>[, <em>docNode</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.setActiveStyleSheet('winter');
API.setActiveStyleSheet('summer', doc);
</pre>
<h3><a name="setattribute">setAttribute</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getattribute">getAttribute</a></li><li><a href="#hasattribute">hasAttribute</a><li><a href="#setattributeproperty">setAttributeProperty</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setAttribute</code> function sets the value of the specified attribute of the specified element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = setAttribute(<em>el</em>, <em>name</em>, <em>value</em>);
</pre>
<h4>Examples</h4>
<pre>
el = API.setAttribute(el, 'id', 'myid');
el = API.setAttribute(el, 'style', 'color:red');
</pre>
<h4>Return Value</h4>
<p>The function returns an element, which in some cases may be a replacement (e.g. setting the type attribute of an <code>input</code> element in IE.)</p>
<h3><a name="setattributeproperty">setAttributeProperty</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getattributeproperty">getAttributeProperty</a></li><li><a href="#setattribute">setAttribute</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setAttributeProperty</code> function sets the <em>property</em> value of the specified attribute of the specified element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = setAttributeProperty(<em>el</em>, <em>name</em>, <em>value</em>);
</pre>
<h4>Examples</h4>
<pre>
el = API.setAttributeProperty(el, 'id', 'myid');
el = API.setAttributeProperty(el, 'readonly', true);
</pre>
<h4>Return Value</h4>
<p>The function returns an element, which in some cases may be a replacement (e.g. changing the type attribute of an <code>input</code> element in IE.)</p>
<h3><a name="setattributeProperties">setAttributeProperties</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setattributeproperty">setAttributeProperty</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setAttributeProperties</code> function sets the <em>property</em> values of the specified attributes of the specified element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = setAttributeProperties(<em>el</em>, <em>attributes</em>);
</pre>
<h4>Examples</h4>
<pre>
el = API.setAttributeProperties(el, { id:'myid', readonly:true });
</pre>
<h4>Return Value</h4>
<p>The function returns an element, which in some cases may be a replacement (e.g. changing the type attribute of an <code>input</code> element in IE.)</p>
<h3><a name="setattributes">setAttributes</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setattribute">setAttribute</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setAttributes</code> function sets the values of the specified attributes of the specified element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = setAttributes(<em>el</em>, <em>attributes</em>);
</pre>
<h4>Examples</h4>
<pre>
el = API.setAttributes(el, { id:'myid', 'class':'myclass' });
</pre>
<h4>Return Value</h4>
<p>The function returns an element, which in some cases may be a replacement (e.g. changing the type attribute of an <code>input</code> element in IE.)</p>
<h3><a name="setcookie">setCookie</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#cookiesenabled">cookiesEnabled</a></li><li><a href="#deletecookie">deleteCookie</a></li><li><a href="#getcookie">getCookie</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setCookie</code> function sets the cookie with the specified name to the specified value.</p>
<h4 class="syntax">Syntax</h4>
<pre>
setCookie(<em>name</em>, <em>value</em>[, <em>expires</em>[, <em>path</em>[, <em>secure</em>[, <em>docNode</em>]]]]);
</pre>
<h4>Examples</h4>
<pre>
API.setCookie('myname', 'myvalue');
API.setCookie('myname', 'myvalue', 7); // Expires in 7 days
</pre>
<h3><a name="setcookiecrumb">setCookieCrumb</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#deletecookiecrumb">deleteCookieCrumb</a></li><li><a href="#getcookiecrumb">getCookieCrumb</a></li><li><a href="#setcookie">setCookie</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setCookieCrumb</code> function sets a portion of a cookie.</p>
<h4 class="syntax">Syntax</h4>
<pre>
setCookieCrumb(<em>name</em>, <em>crumb</em>, <em>value</em>[,<em>path</em>[, <em>docNode</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.setCookieCrumb('myname', 'mycrumbname', 'myvalue');
</pre>
<h3><a name="setdefaultstatus">setDefaultStatus</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setstatus">setStatus</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setDefaultStatus</code> function sets the default status bar text for a window.</p>
<h4 class="syntax">Syntax</h4>
<pre>
setDefaultStatus(<em>text</em>[, <em>win</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.setDefaultStatus('My Library rocks!');
API.setDefaultStatus('Definitely!', win);
</pre>
<h3><a name="setelementhtml">setElementHtml</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#addelementhtml">addElementHtml</a></li><li><a href="#setelementouterhtml">setElementOuterHtml</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>setElementHtml</code> function sets the inner <code>HTML</code> of an element. The optional parameters are for use with effects modules (e.g. DirectX), which replace the standard function with one that supports progressive rendering.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = setElementHtml(<em>el</em>, <em>html</em>[<em>options</em>[, <em>callback</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.setElementHtml(el, '&lt;p&gt;This is a test.&lt;/p&gt;');
</pre>
<h4>Return Value</h4>
<p>The function returns an element, which in some cases may be a replacement (e.g. <code>select</code> elements in IE.)</p>
<h3><a name="setelementnodes">setElementNodes</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#addelementnodes">addElementNodes</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>setElementNodes</code> function replaces the nodes of an element. The optional parameters are for use with effects modules (e.g. DirectX), which replace the standard function with one that supports progressive rendering.</p>
<h4 class="syntax">Syntax</h4>
<pre>
setElementNodes(<em>el</em>, <em>elNewNodes</em>[<em>options</em>[, <em>callback</em>]]);
</pre>
<h4>Examples</h4>
<pre>
el = API.setElementNodes(el, elNewNodes);
</pre>
<h3><a name="setelementouterhtml">setElementOuterHtml</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#addelementhtml">addElementHtml</a></li><li><a href="#setelementhtml">setElementHtml</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>setElementOuterHtml</code> function sets the outer <code>HTML</code> of an element. The optional parameters are for use with effects modules (e.g. DirectX), which replace the standard function with one that supports progressive rendering.</p>
<h4 class="syntax">Syntax</h4>
<pre>
el = setElementOuterHtml(<em>el</em>, <em>html</em>[<em>options</em>[, <em>callback</em>]]);
</pre>
<h4>Examples</h4>
<pre>
el = API.setElementOuterHtml(el, '&lt;p&gt;Testing...&lt;/p&gt;');
</pre>
<h4>Return Value</h4>
<p>The function returns an element, which is always a replacement.</p>
<h3><a name="setelementscript">setElementScript</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setelementtext">setElementText</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>setElementScript</code> function sets the text of a script element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
setElementScript(<em>el</em>, <em>text</em>);
</pre>
<h4>Examples</h4>
<pre>
API.setElementScript(el, 'window.alert("Hello world!");');
</pre>
<h3><a name="setelementtext">setElementText</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getelementtext">getElementText</a></li><li><a href="#setelementscript">setElementScript</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setElementText</code> function sets the text of an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
setElementText(<em>el</em>, <em>text</em>);
</pre>
<h4>Examples</h4>
<pre>
API.setElementText(el, 'Hello world!');
</pre>
<h3><a name="setopacity">setOpacity</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#getopacity">getOpacity</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setOpacity</code> function sets the opacity of an element, specified as a number from 0 (invisible) to 1 (opaque).</p>
<h4 class="syntax">Syntax</h4>
<pre>
setOpacity(<em>el</em>, <em>opacity</em>);
</pre>
<h4>Examples</h4>
<pre>
API.setOpacity(el, 0.5);
</pre>
<h3><a name="setscrollposition">setScrollPosition</a></h3>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>setScrollPosition</code> function sets the scroll position of a document.</p>
<h4 class="syntax">Syntax</h4>
<pre>
setScrollPosition(<em>t</em>, <em>l</em>[, <em>docNode</em>[, <em>isNormalized</em>[, <em>options</em>[, <em>callback</em>]]]]);
</pre>
<h4>Examples</h4>
<pre>
API.setScrollPosition(el, 0, 0);
API.setScrollPosition(el, 0, 0, doc);
</pre>
<h3><a name="setstatus">setStatus</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setdefaultstatus">setDefaultStatus</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setStatus</code> function sets the status bar text for a window.</p>
<h4 class="syntax">Syntax</h4>
<pre>
setStatus(<em>text</em>[, <em>win</em>]);
</pre>
<h4>Examples</h4>
<pre>
API.setStatus(el, 'Hello world!');
API.setStatus(el, 'Hello back!', win);
</pre>
<h3><a name="setstyle">setStyle</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setstyles">setStyles</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>setStyle</code> function sets the style of the specified element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
setStyle(<em>el</em>, <em>style</em>, <em>rule</em>);
</pre>
<h4>Examples</h4>
<pre>
API.setStyle(el, 'color', '#CCCCCC');
API.setStyle(el, 'backgroundColor', '#333333');
</pre>
<p><strong>Note</strong> that as with all style-related functions, the name of the style must be in camel-case.</p>
<h3><a name="setstyles">setStyles</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#setstyle">setStyle</a></li></ul></div>
<p>The <code>setStyles</code> function sets multiple styles of the specified element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
setStyles(<em>el</em>, <em>rules</em>);
</pre>
<h4>Examples</h4>
<pre>
API.setStyles(el, { color: '#CCCCCC', backgroundColor:'#333333' });
</pre>
<p><strong>Note</strong> that as with all style-related functions, the name of the style must be in camel-case.</p>
<h3><a name="showelement">showElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#toggleelement">toggleElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>showElement</code> function shows or hides an element as indicated by the <code>show</code> argument.</p>
<h4 class="syntax">Syntax</h4>
<pre>
showElement(<em>el</em>, [<em>show</em>[, <em>options</em>[, <em>callback</em>]]]);
</pre>
<h4>Examples</h4>
<pre>
API.showElement(el);
API.showElement(el, false);
API.showElement(el, false, { removeOnHide: true });
API.showElement(el, false, { effects:API.effects.fade, duration:1000 });
</pre>
<h3><a name="sizeelement">sizeElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#sizeelementouter">sizeElementOuter</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>sizeElement</code> function sizes an element by setting its <em>height</em> and <em>width</em> styles to the indicated number of pixels.</p>
<h4 class="syntax">Syntax</h4>
<pre>
sizeElement(<em>el</em>, <em>h</em>, <em>w</em>[, <em>options</em>[, <em>callback</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.sizeElement(el, 100, 100);
API.sizeElement(el, 100, 100, { duration:1000, ease:API.ease.circle });
</pre>
<h3><a name="sizeelementouter">sizeElementOuter</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#sizeelement">sizeElement</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>sizeElementOuter</code> function sets an element's outer dimensions.</p>
<h4 class="syntax">Syntax</h4>
<pre>
sizeElementOuter(<em>el</em>, <em>h</em>, <em>w</em>);
</pre>
<h4>Examples</h4>
<pre>
API.sizeElementOuter(el, 100, 100);
</pre>

<h3><a name="some">some</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#every">every</a></li><li><a href="https://developer.mozilla.org/En/Core_JavaScript_1.5_Reference/Objects/Array/Some" class="external">some (MDC)</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>some</code> function calls the specified function for each element of the specified array, returning true if at least one result is true.</p>
<h4 class="syntax">Syntax</h4>
<pre>
b = some(<em>a</em>, <em>fn</em>[, <em>context</em>]);
</pre>
<h4>Examples</h4>
<pre>
b = API.some(a, function(el) { return el.id.indexOf('test') != -1 });
b = API.some(a, fn, someObject);
</pre>
<h4>Return Value</h4>
<p>The function returns a boolean.</p>
<h3><a name="submitajaxform">submitAjaxForm</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#requester">Requester</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>submitAjaxForm</code> function submits a form via Ajax.</p>
<h4 class="syntax">Syntax</h4>
<pre>
submitAjaxForm(<em>el</em>[, <em>json</em>[, <em>requester</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.submitAjaxForm(el);
API.submitAjaxForm(el, true);
API.submitAjaxForm(el, true, requester);
</pre>
<h3><a name="toarray">toArray</a></h3>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>toArray</code> function copies an array or array-like object to a new array.</p>
<h4 class="syntax">Syntax</h4>
<pre>
a = toArray(<em>c</em>);
</pre>
<h4>Examples</h4>
<pre>
a = API.toArray(el.childNodes);
</pre>
<h4>Return Value</h4>
<p>The function returns a array.</p>
<h3><a name="toggleelement">toggleElement</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#showelement">showElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>toggleElement</code> function shows or hides an element.</p>
<h4 class="syntax">Syntax</h4>
<pre>
toggleElement(<em>el</em>[, <em>options</em>[, <em>callback</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.toggleElement(el);
API.toggleElement(el, { removeOnHide:true, effects:API.effects.fade, duration:1000 });
</pre>
<h3><a name="toggleelementpresence">toggleElementPresence</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#presentelement">presentElement</a></li></ul></div>
<div class="seealso deferred">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#deferred">Deferred</a></p>
</div>
<p>The <code>toggleElementPresence</code> function adds or removes an element from the layout by changing its <code>display</code> style.</p>
<h4 class="syntax">Syntax</h4>
<pre>
toggleElementPresence(<em>el</em>[, <em>display</em>]]);
</pre>
<h4>Examples</h4>
<pre>
API.toggleElementPresence(el);
API.toggleElement(el, 'block');
API.toggleElement(el, 'inline');
</pre>

<h3><a name="urlencode">urlencode</a></h3>
<div class="seealso"><h4>See Also</h4><ul><li><a href="#serializeformurlencoded">serializeFormUrlencoded</a></li></ul></div>
<div class="seealso immediate">
<h4>Feature Detection</h4>
<p><a href="mylib-doc0.html#immediate">Immediate</a></p>
</div>
<p>The <code>urlencode</code> function encodes a string according to the specification of the <code>application/x-www-form-urlencoded</code> MIME type.</p>
<h4 class="syntax">Syntax</h4>
<pre>
s = urlencode(<em>text</em>);
</pre>
<h4>Examples</h4>
<pre>
s = API.urlencode(text);
</pre>
<h4>Return Value</h4>
<p>The function returns a string.</p>
<div id="logo"><a href="mylib.html" title="Home"><img src="images/mylibrarylogo.jpg" height="108" width="260" alt="My Library" title="Home"></a></div>
<p class="meta">Last Modified: 22 Apr 2010 22:29:00 GMT</p>
<address>By <a title="Send email to David Mark" href="mailto:dmark@cinsoft.net">David Mark</a></address>
<div class="legal">Copyright &copy; 2007-2010 by <a href="mailto:dmark@cinsoft.net">David Mark</a>. All Rights Reserved.</div>
</div>
</body>
</html>