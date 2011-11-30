<%
Dim bAdjacent, bAjax, bAjaxForm, bAjaxLink, bArray, bAudio, bBorder, bBookmark, bCenter, bClass, bCollections, bContextClick, bCookie, bCoverDocument, bCrumb, bDirectX, bDispatch, bDOM, bDOM0, bDrag, bEase, bEvent, bEvery, bFilter, bFlash, bForEach, bForm, bFullscreen, bFX, bGetHTML, bHelp, bHTML, bImage, bImport, bLocationQuery, bMap, bMargin, bMaximize, bMousePosition, bMouseWheel, bOffset, bOpacity, bOverlay, bPlugin, bPosition, bPreload, bPresent, bQuery, bRegion, bRequester, bRollover, bScroll, bSerialize, bSetAttribute, bShow, bSize, bSome, bStatusBar, bScript, bScrollFX, bStyle, bStyleSheets, bText, bUpdater, bViewport, bObjects, bDollar
Dim bXHTMLSupport

Dim strVersion
strVersion = "1.0"

Dim bEdit
bEdit = (Request.QueryString("action") = "edit")

Function CheckSetting(strName)
	If bPersistent And Not bEdit Then
		If Not IsNull(Request.Cookies("build")) Then
			If Request.Cookies("build").HasKeys Then
				CheckSetting = Request.Cookies("build")(strName) = "on"
				Exit Function
			End If
		End If
	End If
	If Request.QueryString(strName) <> "" Then
		CheckSetting = True
		Response.Cookies("build")(strName) = "on"
	Else
		CheckSetting = False
		Response.Cookies("build")(strName) = ""
	End If
	Response.Cookies("build").Expires = DateAdd("d", 30, Now())
End Function

bXHTMLSupport = CheckSetting("xhtmlsup")

bAjax = CheckSetting("ajax")
If bAjax Then
	bRequester = CheckSetting("requester")
End If

bArray = CheckSetting("array")
If bArray Then
	bEvery = CheckSetting("every")
	bFilter = CheckSetting("filter")
	bForEach = CheckSetting("foreach")
	bMap = CheckSetting("map")
	bSome = CheckSetting("some")
End If

bBookmark = CheckSetting("bookmark")

bPlugin = CheckSetting("plugin")
If bPlugin Then
	bAudio = CheckSetting("audio")
	bFlash = CheckSetting("flash")
End If

bCookie = CheckSetting("cookie")
If bCookie Then
	bCrumb = CheckSetting("crumb")
End If

bDOM = CheckSetting("dom")
If bDOM Then
	bCollections = CheckSetting("collections")
	bQuery = CheckSetting("query")
	If bQuery Then
		bObjects = CheckSetting("objects")
		bDollar = CheckSetting("dollar")
	End If
	bScript = CheckSetting("script")
	bSetAttribute = CheckSetting("setattribute")

	If bSetAttribute Then
		bImport = CheckSetting("import")
	End If

	bStyleSheets = CheckSetting("stylesheets")
	bText = CheckSetting("text")
End If

bEvent = CheckSetting("event")
If bEvent Then
	bContextClick = CheckSetting("contextclick")
	bHelp = CheckSetting("help")
	bMouseWheel = CheckSetting("mousewheel")
	bRollover = CheckSetting("rollover")
	bDispatch = CheckSetting("dispatch")
	bMousePosition = CheckSetting("mouseposition")
        bDOM0 = CheckSetting("dom0")
End If

bForm = CheckSetting("form")
If bForm Then
	bSerialize = CheckSetting("serialize")
End If

bImage = CheckSetting("image")
If bImage Then
	bPreload = CheckSetting("preload")
End If

bStatusBar = CheckSetting("statusbar")

bStyle = CheckSetting("style")
If bStyle Then
	bClass = CheckSetting("class")
	bBorder = CheckSetting("border")
	bMargin = CheckSetting("margin")
	bDirectX = CheckSetting("directx")
	bFX = CheckSetting("fx")
	If bFX Then
		bEase = CheckSetting("ease")
	End If
	bOpacity = CheckSetting("opacity")
	bPresent = CheckSetting("present")
	bShow = CheckSetting("show")
	bPosition = CheckSetting("position")
	bSize = CheckSetting("size")
End If

bHTML = CheckSetting("html")
bLocationQuery = CheckSetting("locationquery")
bOffset = CheckSetting("offset")
bScroll = CheckSetting("scroll")
bViewport = CheckSetting("viewport")

If bOffset Then
	bRegion = CheckSetting("region")
End If

' Combinations

If bPosition And bSize And bOffset Then
	bAdjacent = CheckSetting("adjacent")
	bOverlay = CheckSetting("overlay")
End If

If bViewport And bPosition Then
	bCenter = CheckSetting("center")
	If bSize Then
		bCoverDocument = CheckSetting("coverdocument")
		bFullscreen = CheckSetting("fullscreen")
		bMaximize = CheckSetting("maximize")
	End If
End If

If bScroll And bFX Then
	bScrollFX = CheckSetting("scrollfx")
End If

If bScroll And bMousePosition And bPosition Then
	bDrag = CheckSetting("drag")
End If

If bRequester And bHTML Then
	bUpdater = CheckSetting("updater")
End If

If bRequester And bForm And bDOM Then
	bAjaxForm = CheckSetting("ajaxform")
End If

If bRequester And bEvent And bDOM Then
	bAjaxLink = CheckSetting("ajaxlink")
End If

If bHTML And bDOM Then
        bGetHTML = CheckSetting("gethtml")
End If
%>