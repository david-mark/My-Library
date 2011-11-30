<%
Option Explicit
Dim bPersistent

bPersistent = True
%>
<!-- #INCLUDE file="mylib-buildquery.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en-US">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Language" content="en-us">
<meta name="description" content="My Library Builder builds custom versions of My Library, a cross-browser scripting library, written in Javascript">
<meta name="keywords" content="My Library, Javascript, library, project, repository, builder, browser scripting, Ajax, comp.lang.javascript, newsgroup, builder, custom, version">
<meta name="author" content="David Mark">
<title>My Library Builder</title>
<link rel="home" href="mylib.html">
<link rel="stylesheet" type="text/css" href="style/mylib.css" media="all">
<!--[if IE]>
<link rel="stylesheet" type="text/css" href="style/mylib-ie.css" media="all">
<![endif]-->
<link rel="stylesheet" type="text/css" href="style/mylib-handheld.css" media="handheld">
<link rel="stylesheet" type="text/css" href="style/mylib-print.css" media="print">
<script type="text/javascript" src="mylib-builder.js"></script>
</head>
<body>
<div id="sidebar">
<a href="#content" id="skipnav">Skip Navigation</a>
<h2>Resources</h2>
<h3>Contents</h3>
<ul><li><a href="mylib.html" accesskey="1" title="Home [1]">Home</a></li><li><a href="mylib-downloads.html">Downloads</a></li><li><a href="mylib-doc0.html">Documentation</a></li><li><a href="mylib-examples.html" title="Try out examples and generate code">Examples</a></li><li class="current"><span id="current">Builder</span></li><li><a href="mylib-test.asp?version=1.0&amp;requester=on&amp;array=on&amp;script=on&amp;mouseposition=on&amp;drag=on&amp;every=on&amp;cookie=on&amp;contextclick=on&amp;adjacent=on&amp;ajaxlink=on&amp;ajax=on&amp;event=on&amp;audio=on&amp;statusbar=on&amp;position=on&amp;scrollfx=on&amp;filter=on&amp;dispatch=on&amp;help=on&amp;flash=on&amp;opacity=on&amp;maximize=on&amp;ashtml=on&amp;foreach=on&amp;query=on&amp;serialize=on&amp;region=on&amp;class=on&amp;show=on&amp;map=on&amp;bookmark=on&amp;collections=on&amp;html=on&amp;offset=on&amp;size=on&amp;fx=on&amp;ajaxform=on&amp;overlay=on&amp;some=on&amp;crumb=on&amp;text=on&amp;dom0=on&amp;mousewheel=on&amp;preload=on&amp;margin=on&amp;ease=on&amp;dom=on&amp;setattribute=on&amp;stylesheets=on&amp;style=on&amp;coverdocument=on&amp;dollar=on&amp;objects=on&amp;import=on&amp;rollover=on&amp;locationquery=on&amp;border=on&amp;updater=on&amp;form=on&amp;image=on&amp;plugin=on&amp;directx=on&amp;present=on&amp;viewport=on&amp;fullscreen=on&amp;scroll=on&amp;center=on&amp;gethtml=on&amp;mode=HTML" title="Test full build">Build Test</a></li><li><a href="mylib-testspeed.html" title="Compare the performance of the query feature to three popular libraries">Speed Tests</a></li><li><a href="mylib-sponsors.html" title="List of our benefactors">Sponsors</a></li></ul>
<h3>Related Links</h3>
<ul><li><a href="http://www.pledgie.com/campaigns/9768" title="Please make a donation today!">Donations</a></li><li><a href="http://groups.google.com/group/my-library-general-discussion/">Discussion</a></li><li><a href="http://code.google.com/p/ourlibrary/source/checkout">Repository</a></li></ul>
<h3>Primers</h3>
<ul><li><a href="attributes.html" title="A is for Attributes primer">Attributes</a></li><li><a href="host.html" title="H is for Host primer">Host</a></li><li><a href="keyboard.html" title="K is for Keyboard primer">Keyboard</a></li><li><a href="position.html" title="P is for Position primer">Position</a></li><li><a href="size.html" title="S is for Size primer">Size</a></li><li><a href="viewport.asp" title="V is for Viewport primer">Viewport</a></li></ul>
<h3>Bookmark</h3>
<ul><li><a title="Digg this" href="http://digg.com/submit?phase=2&amp;url=http%3A%2F%2Fwww.cinsoft.net%2Fmylib-builder.html&amp;title=My%20Library&amp;bodytext=Build%20your%20own%20browser%20scripting%20library&amp;topic=programming">Digg This</a></li><li><a title="Add bookmark to deli.cio.us" href="http://del.icio.us/post?url=http%3A%2F%2Fwww.cinsoft.net%2Fmylib-builder.html">Add to deli.cio.us</a></li></ul>
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
<h1><span class="redundant">My Library </span>Builder</h1>
<p>Build and test your own custom version with this form.</p>
<form name="builder" action="mylib-build.asp">
<fieldset id="build">
<legend id="buildlegend">Builder</legend>
<input type="hidden" name="version" value="<%=strVersion%>">
<input type="hidden" name="helptopic" value="">
<fieldset>
<legend>Modules</legend>
<ul>
<li><input tabindex="0" type="checkbox" name="ajax" id="ajax"<%If bAjax Then%> checked<%End If%>><label for="ajax">Ajax</label><a href="#trycatch">*</a><ul><li><input tabindex="0" type="checkbox" name="requester" id="requester"<%If bRequester Then%> checked<%End If%>><label for="requester">Requester</label></li></ul></li>
<li><input tabindex="0" type="checkbox" name="array" id="array"<%If bArray Then%> checked<%End If%>><label for="array">Array</label><ul><li><input tabindex="0" type="checkbox" name="every" id="every"<%If bEvery Then%> checked<%End If%>><label for="every">Every</label></li><li><input tabindex="0" type="checkbox" name="filter" id="filter"<%If bFilter Then%> checked<%End If%>><label for="filter">Filter</label></li><li><input tabindex="0" type="checkbox" name="foreach" id="foreach"<%If bForEach Then%> checked<%End If%>><label for="foreach">For Each</label></li><li><input tabindex="0" type="checkbox" name="map" id="map"<%If bMap Then%> checked<%End If%>><label for="map">Map</label></li><li><input tabindex="0" type="checkbox" name="some" id="some"<%If bSome Then%> checked<%End If%>><label for="some">Some</label></li></ul></li>
<li><input tabindex="0" type="checkbox" name="bookmark" id="bookmark"<%If bBookmark Then%> checked<%End If%>><label for="bookmark">Bookmark</label></li>
<li><input tabindex="0" type="checkbox" name="cookie" id="cookie"<%If bCookie Then%> checked<%End If%>><label for="cookie">Cookie</label><ul><li><input tabindex="0" type="checkbox" name="crumb" id="crumb"<%If bCrumb Then%> checked<%End If%>><label for="crumb">Crumb</label></li></ul></li>
<li><input tabindex="0" type="checkbox" name="dom" id="dom"<%If bDOM Then%> checked<%End If%>><label for="dom">DOM</label><ul><li><input tabindex="0" type="checkbox" name="collections" id="collections"<%If bCollections Then%> checked<%End If%>><label for="collections">Collections</label><a href="#domfilter">&dagger;</a></li><li><input tabindex="0" type="checkbox" name="query" id="query"<%If bQuery Then%> checked<%End If%>><label for="query">Query</label><ul><li><input tabindex="0" type="checkbox" name="objects" id="objects"<%If bObjects Then%> checked<%End If%>><label for="objects">Object Wrappers</label></ul></li><li><input tabindex="0" type="checkbox" name="script" id="script"<%If bScript Then%> checked<%End If%>><label for="script">Script</label><a href="#trycatch">*</a></li><li><input tabindex="0" type="checkbox" name="setattribute" id="setattribute"<%If bSetAttribute Then%> checked<%End If%>><label for="setattribute">Set Attribute</label><ul><li><input tabindex="0" type="checkbox" name="import" id="import"<%If bImport Then%> checked<%End If%>><label for="import">Import</label></li></ul></li><li><input tabindex="0" type="checkbox" name="stylesheets" id="stylesheets"<%If bStyleSheets Then%> checked<%End If%>><label for="stylesheets">Style Sheet</label></li><li><input tabindex="0" type="checkbox" name="text" id="text"<%If bText Then%> checked<%End If%>><label for="text">Text</label></li></ul></li>
<li><input tabindex="0" type="checkbox" name="event" id="event"<%If bEvent Then%> checked<%End If%>><label for="event">Event</label><ul><li><input tabindex="0" type="checkbox" name="contextclick" id="contextclick"<%If bContextClick Then%> checked<%End If%>><label for="contextclick">Context Click</label></li><li><input tabindex="0" type="checkbox" name="dispatch" id="dispatch"<%If bDispatch Then%> checked<%End If%>><label for="dispatch">Dispatch</label></li><li><input tabindex="0" type="checkbox" name="dom0" id="dom0"<%If bDOM0 Then%> checked<%End If%>><label for="dom0">DOM0</label></li><li><input tabindex="0" type="checkbox" name="help" id="help"<%If bHelp Then%> checked<%End If%>><label for="help">Help</label></li><li><input tabindex="0" type="checkbox" name="mouseposition" id="mouseposition"<%If bMousePosition Then%> checked<%End If%>><label for="mouseposition">Mouse Position</label></li><li><input tabindex="0" type="checkbox" name="mousewheel" id="mousewheel"<%If bMousewheel Then%> checked<%End If%>><label for="mousewheel">Mousewheel</label></li><li><input tabindex="0" type="checkbox" name="rollover" id="rollover"<%If bRollover Then%> checked<%End If%>><label for="rollover">Rollover</label><a href="#rolloverneedsdom">***</a></li></ul></li>
<li><input tabindex="0" type="checkbox" name="form" id="form"<%If bForm Then%> checked<%End If%>><label for="form">Form</label><ul><li><input tabindex="0" type="checkbox" name="serialize" id="serialize"<%If bSerialize Then%> checked<%End If%>><label for="serialize">Serialize</label></ul></li>
<li><input tabindex="0" type="checkbox" name="html" id="html"<%If bHTML Then%> checked<%End If%>><label for="html">HTML</label></li>
<li><input tabindex="0" type="checkbox" name="image" id="image"<%If bImage Then%> checked<%End If%>><label for="image">Image</label><ul><li><input tabindex="0" type="checkbox" name="preload" id="preload"<%If bPreload Then%> checked<%End If%>><label for="preload">Preload</label></li></ul></li>
<li><input tabindex="0" type="checkbox" name="locationquery" id="locationquery"<%If bLocationQuery Then%> checked<%End If%>><label for="locationquery">Location Query</label></li>
<li><input tabindex="0" type="checkbox" name="offset" id="offset"<%If bOffset Then%> checked<%End If%>><label for="offset">Offset</label><a href="#offsetstyle">**</a><ul><li><input tabindex="0" type="checkbox" name="region" id="region"<%If bRegion Then%> checked<%End If%>><label for="region">Region</label></li></ul></li>
<li><input tabindex="0" type="checkbox" name="plugin" id="plugin"<%If bPlugin Then%> checked<%End If%>><label for="plugin">Plugin</label><ul><li><input tabindex="0" type="checkbox" name="audio" id="audio"<%If bAudio Then%> checked<%End If%>><label for="audio">Audio</label></li><li><input tabindex="0" type="checkbox" name="flash" id="flash"<%If bFlash Then%> checked<%End If%>><label for="flash">Flash</label><a href="#trycatch">*</a></li></ul></li>
<li><input tabindex="0" type="checkbox" name="scroll" id="scroll"<%If bScroll Then%> checked<%End If%>><label for="scroll">Scroll</label></li>
<li><input tabindex="0" type="checkbox" name="statusbar" id="statusbar"<%If bStatusBar Then%> checked<%End If%>><label for="statusbar">Status Bar</label></li>
<li><input tabindex="0" type="checkbox" name="style" id="style"<%If bStyle Then%> checked<%End If%>><label for="style">Style</label><ul><li><input tabindex="0" type="checkbox" name="border" id="border"<%If bBorder Then%> checked<%End If%>><label for="border">Border</label></li><li><input tabindex="0" type="checkbox" name="class" id="class"<%If bClass Then%> checked<%End If%>><label for="class">Class</label></li><li><input tabindex="0" type="checkbox" name="directx" id="directx"<%If bDirectX Then%> checked<%End If%>><label for="directx">DirectX</label></li><li><input tabindex="0" type="checkbox" name="margin" id="margin"<%If bMargin Then%> checked<%End If%>><label for="margin">Margin</label></li><li><input tabindex="0" type="checkbox" name="opacity" id="opacity"<%If bOpacity Then%> checked<%End If%>><label for="opacity">Opacity</label></li><li><input tabindex="0" type="checkbox" name="position" id="position"<%If bPosition Then%> checked<%End If%>><label for="position">Position</label></li><li><input tabindex="0" type="checkbox" name="present" id="present"<%If bPresent Then%> checked<%End If%>><label for="present">Present</label></li><li><input tabindex="0" type="checkbox" name="show" id="show"<%If bShow Then%> checked<%End If%>><label for="show">Show</label></li><li><input tabindex="0" type="checkbox" name="size" id="size"<%If bSize Then%> checked<%End If%>><label for="size">Size</label></li><li><input tabindex="0" type="checkbox" name="fx" id="fx"<%If bFX Then%> checked<%End If%>><label for="fx">Special Effects</label><ul><li><input tabindex="0" type="checkbox" name="ease" id="ease"<%If bEase Then%> checked<%End If%>><label for="ease">Easing</label></li></ul></li></ul></li>
<li><input tabindex="0" type="checkbox" name="viewport" id="viewport"<%If bViewport Then%> checked<%End If%>><label for="viewport">Viewport</label><a href="#viewportstyle">&dagger;&dagger;</a></li>
</ul>
</fieldset>
<fieldset>
<legend>Combinations</legend>
<ul>
<li><input tabindex="0" type="checkbox" name="adjacent" id="adjacent" title="Requires Offset, Position and Size"<%If bAdjacent Then%> checked<%End If%>><label for="adjacent">Adjacent Element</label></li>
<li><input tabindex="0" type="checkbox" name="ajaxform" id="ajaxform" title="Requires DOM, Form and Requester"<%If bAjaxForm Then%> checked<%End If%>><label for="ajaxform">Ajax Form</label></li>
<li><input tabindex="0" type="checkbox" name="ajaxlink" id="ajaxlink" title="Requires DOM, Event and Requester"<%If bAjaxLink Then%> checked<%End If%>><label for="ajaxlink">Ajax Link</label></li>
<li><input tabindex="0" type="checkbox" name="center" id="center" title="Requires Position and Viewport"<%If bCenter Then%> checked<%End If%>><label for="center">Center Element</label></li>
<li><input tabindex="0" type="checkbox" name="coverdocument" id="coverdocument" title="Requires Position, Size and Viewport"<%If bCoverDocument Then%> checked<%End If%>><label for="coverdocument">Cover Document</label></li>
<li><input tabindex="0" type="checkbox" name="drag" id="drag" title="Requires Mouse Position, Position and Scroll"<%If bDrag Then%> checked<%End If%>><label for="drag">Drag and Drop</label></li>
<li><input tabindex="0" type="checkbox" name="fullscreen" id="fullscreen" title="Requires Position, Size and Viewport"<%If bFullScreen Then%> checked<%End If%>><label for="fullscreen">Full-screen Element</label></li>
<li><input tabindex="0" type="checkbox" name="gethtml" id="gethtml" title="Requires DOM and HTML"<%If bGetHTML Then%> checked<%End If%>><label for="gethtml">Get HTML</label></li>
<li><input tabindex="0" type="checkbox" name="maximize" id="maximize" title="Requires Position, Size and Viewport"<%If bMaximize Then%> checked<%End If%>><label for="maximize">Maximize Element</label></li>
<li><input tabindex="0" type="checkbox" name="overlay" id="overlay" title="Requires Offset, Position and Size"<%If bOverlay Then%> checked<%End If%>><label for="overlay">Overlay Element</label></li>
<li><input tabindex="0" type="checkbox" name="scrollfx" id="scrollfx" title="Requires Scroll and Special Effects"<%If bScrollFX Then%> checked<%End If%>><label for="scrollfx">Scrolling Effects</label></li>
<li><input tabindex="0" type="checkbox" name="updater" id="updater" title="Requires HTML and Requester"<%If bUpdater Then%> checked<%End If%>><label for="updater">Updater</label></li>
</ul>
</fieldset>
<fieldset>
<legend>Options</legend>
<ul>
<li><input tabindex="0" type="checkbox" name="dollar" id="dollar"<%If bDollar Then%> checked<%End If%>><label for="dollar">Create $ global variable (not recommended)</label></li>
<li><input tabindex="0" type="checkbox" name="xhtmlsup" id="xhtmlsup"<%If bXHTMLSupport Then%> checked<%End If%>><label for="xhtmlsup">XHTML support (not recommended for Web)</label></li>
</ul>
</fieldset>
<input type="button" id="selectall" name="selectall" value="Select All" disabled><input type="button" id="deselectall" name="deselectall" value="Deselect All" disabled><input tabindex="0" type="submit" name="action" value="Build"><input tabindex="0" type="submit" name="action" value="Test HTML">
<fieldset><legend>XHTML</legend><input tabindex="0" type="submit" name="action" id="testxhtml" value="Test XHTML"><span id="ashtmlcontainer"><input tabindex="0" type="checkbox" name="ashtml" id="ashtml" value="on"><label for="ashtml">as&nbsp;<code>HTML</code></label></span></fieldset><input tabindex="0" type="submit" name="action" value="Help" accesskey="h" title="Help [H]">
<a name="trycatch" class="footnote">*Contains try-catch clauses, which cause parse errors in some agents (e.g. IE4)</a>
<hr>
<a name="offsetstyle" class="footnote">**Requires Position and Scroll modules to support fixed positioning</a>
<hr>
<a name="rolloverneedsdom" class="footnote">***Requires DOM to support elements with descendants</a>
<hr>
<a name="domfilter" class="footnote">&dagger;Requires Filter module to support XHTML</a>
<hr>
<a name="viewportstyle" class="footnote">&dagger;&dagger;Requires Margin and Border modules to support documentElement/body margins and borders</a>
</fieldset>
</form>
<h2>Tips for Deployment</h2>
<p>Before using your library, be sure to read the <a href="mylib-doc0.html">documentation</a>.</p>
<p>It is recommended that you process the created file with a <a href="http://developer.yahoo.com/yui/compressor/" class="external">minifier</a> to remove comments and whitespace and shorten variable names. In most cases, this will reduce the download time for users of your site or application. The complete build passes <a href="http://jslint.com" class="external">JSLint</a> verification, so minification should not present issues.</p>
<p>It is <em>not</em> recommended that you compress the file as that should be left up to the Web server and clients to negotiate.</p>
<h2>Issues</h2>
<p>Pruning of the object wrappers should be done during the build. Currently a lot of potentially unneeded testing is done at runtime. This issue will be addressed in a future version of the builder.</p>
<div id="logo"><a href="mylib.html" title="Home"><img src="images/mylibrarylogo.jpg" height="108" width="260" alt="My Library" title="Home"></a></div>
<address>By <a title="Send email to David Mark" href="mailto:dmark@cinsoft.net">David Mark</a></address>
<div class="legal">Copyright &copy; 2007-2008 by <a href="mailto:dmark@cinsoft.net">David Mark</a>. All Rights Reserved.</div>
</div>
</body>
</html>