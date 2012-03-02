<%
Option Explicit

Response.Buffer = True

Dim re, reLastComma, reSpace, sQuery
Dim bPersistent, bXHTML, bAsHTML, bQuirks
Dim colCardTotals(10), colCardTotalsIE(10), colCardTotalsIE7(10), colCardTotalsIEOld(10), colCardTotalsNotIE(10), colCardTotalsIENew(10)

Const GOCARD = 0
Const CAUTIONCARD = 1
Const STOPCARD = 2
Const SUGGESTIONCARD = 3

colCardTotals(GOCARD) = 0
colCardTotals(CAUTIONCARD) = 0
colCardTotals(STOPCARD) = 0
colCardTotals(SUGGESTIONCARD) = 0

colCardTotalsIE(GOCARD) = 0
colCardTotalsIE(CAUTIONCARD) = 0
colCardTotalsIE(STOPCARD) = 0
colCardTotalsIE(SUGGESTIONCARD) = 0

colCardTotalsIE7(GOCARD) = 0
colCardTotalsIE7(CAUTIONCARD) = 0
colCardTotalsIE7(STOPCARD) = 0
colCardTotalsIE7(SUGGESTIONCARD) = 0

colCardTotalsIEOld(GOCARD) = 0
colCardTotalsIEOld(CAUTIONCARD) = 0
colCardTotalsIEOld(STOPCARD) = 0
colCardTotalsIEOld(SUGGESTIONCARD) = 0

colCardTotalsNotIE(GOCARD) = 0
colCardTotalsNotIE(CAUTIONCARD) = 0
colCardTotalsNotIE(STOPCARD) = 0
colCardTotalsNotIE(SUGGESTIONCARD) = 0

If Instr(LCase(Request.QueryString), "action") > 0 Then
        Response.Status = 500
	Response.End
End If

If Left(Request.QueryString("mode"), 5) = "XHTML" Then bXHTML = True
If Request.QueryString("mode") = "XHTMLasHTML" Then bAsHTML = True

If bXHTML And Not bAsHTML Then
	Response.ContentType = "application/xhtml+xml"
End If

If Request.QueryString("layout") = "quirks" Then bQuirks = True

Set re = New RegExp
re.IgnoreCase = True
re.Global = True
re.MultiLine = True
re.pattern = "&"

Set reSpace = New RegExp
reSpace.pattern = " "
reSpace.global = False

Set reLastComma = New RegExp
reLastComma.pattern = ", (.*)$"
reLastComma.global = False

'This is ugly

sQuery = Request.QueryString
sQuery = re.replace(sQuery, "&amp;")
re.pattern = "mode=(X)?HTML"
sQuery = re.replace(sQuery, "")
re.pattern = "asHTML=on"
sQuery = re.replace(sQuery, "")
re.pattern = "layout=quirks"
sQuery = re.replace(sQuery, "")
re.pattern = "layout=" 'Empty is default (indicates standard layout)
sQuery = re.replace(sQuery, "")
re.pattern = "mode=" 'In case of missing mode (direct navigation to test page)
sQuery = re.replace(sQuery, "")
re.pattern = "asHTML"
sQuery = re.replace(sQuery, "")

'Clean up any mess left behind

re.pattern = "&amp;&amp;"
sQuery = re.replace(sQuery, "&amp;")
re.pattern = "^&amp;"
sQuery = re.replace(sQuery, "")

If sQuery <> "" And Right(sQuery, 5) <> "&amp;" Then sQuery = sQuery & "&amp;"

Function WriteCard(lClass, sHTML, sModules)
	Dim bAdd, sModule, C, match, sQ, X
	Dim sClass

	Select Case lClass
		Case 1:
			sClass = "caution"
		Case 2:
			sClass = "stop"
		Case 3:
			sClass = "suggestion"
		Case Else:
			sClass = "go"
	End Select

	sQ = sQuery

	Dim aModules

	If sClass = "go" And sModules <> "" Then
		aModules = Split(sModules, ",")
		sModules = ""

		C = 0
		For X = 0 To UBound(aModules)
			bAdd = False
			sModule = LCase(aModules(X))
			sModule = reSpace.Replace(sModule, "")

			re.pattern = sModule & "=[^&]*"
			If Request.QueryString(sModule) <> "" Then
				sQ = re.replace(sQ, sModule & "=on")
				bAdd = (Request.QueryString(sModule) <> "on")
			Else
				sQ = sQ & sModule & "=on&amp;"
				bAdd = True
			End If
			If bAdd Then
				If C = 0 Then
					sModules = sModules & aModules(X)
				Else					
					sModules = sModules & ", " & aModules(X)
				End If
				C = C + 1
			End If

			Set match = reLastComma.Execute(sModules)

			If match.Count > 0 Then
				sModules = reLastComma.replace(sModules, " and " & match(0).subMatches(0))
			End If
		Next
	End If

%>
<p class="<%=sClass%>note"><%If sClass = "caution" Then%><strong>Note:</strong> <%End If%>
<%If sClass = "go" Then%>Add the <a href="mylib-test.asp?<%=sQ%>layout=<%=Request.QueryString("layout")%>&amp;mode=<%=Request.QueryString("mode")%>"><%=sModules%> module<%If C <> 1 Then%>s<%End If%></a> to <%End If%><%=sHTML%>.</p>
<%

	colCardTotals(lClass) = colCardTotals(lClass) + 1
End Function

Function WriteCardForIE(lClass, sHTML, sModules)
	Response.Write "<!--[if IE]>"
	WriteCard lClass, sHTML, sModules
	Response.Write "<![endif]-->"
	colCardTotalsIE(lClass) = colCardTotalsIE(lClass) + 1
End Function

Function WriteCardForIE7(lClass, sHTML, sModules)
	Response.Write "<!--[if IE 7]>"
	WriteCard lClass, sHTML, sModules
	Response.Write "<![endif]-->"
	colCardTotalsIE(lClass) = colCardTotalsIE(lClass) + 1
	colCardTotalsIE7(lClass) = colCardTotalsIE7(lClass) + 1
End Function

Function WriteCardForIEOld(lClass, sHTML, sModules)
	Response.Write "<!--[if lt IE 7]>"
	WriteCard lClass, sHTML, sModules
	Response.Write "<![endif]-->"
	colCardTotalsIE(lClass) = colCardTotalsIE(lClass) + 1
	colCardTotalsIEOld(lClass) = colCardTotalsIEOld(lClass) + 1
End Function

Function WriteCardForIENew(lClass, sHTML, sModules)
	Response.Write "<!--[if gt IE 7]>"
	WriteCard lClass, sHTML, sModules
	Response.Write "<![endif]-->"
	colCardTotalsIE(lClass) = colCardTotalsIE(lClass) + 1
	colCardTotalsIENew(lClass) = colCardTotalsIENew(lClass) + 1
End Function

Function WriteCardNotForIE(lClass, sHTML, sModules)
	Response.Write "<!--[if !IE]>-->"
	WriteCard lClass, sHTML, sModules
	Response.Write "<!--<![endif]-->"
	colCardTotalsNotIE(lClass) = colCardTotalsNotIE(lClass) + 1
End Function
%>
<!-- #INCLUDE file="mylib-buildquery.asp" -->
<%If bXHTML And Not bAsHTML Then%><?xml version="1.0" encoding="UTF-8"?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<%Else%><%If Not bQuirks Then%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"><%End If%>
<html lang="en-US">
<%End If%>
<head>
<%If Not bXHTML Or bAsHTML Then%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Language" content="en-us">
<%End If%>
<meta name="description" content="My Library build test tests custom versions of My Library, a browser scripting library, written in JavaScript and based on current and proposed code from the Code Worth Recommending project"<%If bXHTML Then%> /<%End If%>>
<meta name="keywords" content="My Library, JavaScript, library, Code Worth Recommending, project, repository, builder, browser scripting, Ajax, comp.lang.javascript, newsgroup, test, build, custom, version"<%If bXHTML Then%> /<%End If%>>
<meta name="author" content="David Mark"<%If bXHTML Then%> /<%End If%>>
<title>My Library Build Test (<%If bXHTML Then%>X<%End If%>HTML<%If bAsHTML Then%> as HTML<%End If%>)</title>
<link rel="home" href="mylib.html" title="Home"<%If bXHTML Then%> /<%End If%>>
<link rel="up" href="mylib-builder.asp" title="Builder"<%If bXHTML Then%> /<%End If%>>
<link rel="stylesheet" type="text/css" href="style/mylib.css" media="all"<%If bXHTML Then%> /<%End If%>>
<link rel="stylesheet" type="text/css" media="all" href="style/mylib-test.css"<%If bXHTML Then%> /<%End If%>>
<link rel="stylesheet" type="text/css" href="style/mylib-widgets.css" media="all"<%If bXHTML Then%> /<%End If%>>
<link rel="stylesheet" type="text/css" href="style/mylib-skin-blues.css" media="all"<%If bXHTML Then%> /<%End If%>>
<link rel="stylesheet" type="text/css" href="style/mylib-alert.css" media="all"<%If bXHTML Then%> /<%End If%>>
<!--[if IE]>
<%If Not bXHTML Or bAsHtml Then%>
<script type="text/javascript">
// Quirks mode adjustments for dialog caption buttons

if (typeof this.document.compatMode == 'undefined' || this.document.compatMode.toLowerCase().indexOf('css') == -1) {
	this.document.write('<link rel="stylesheet" type="text/css" media="all" href="style/mylib-widgets-ie5.css">');
}
</script>
<%End If%>
<link rel="stylesheet" type="text/css" href="style/mylib-ie.css" media="all"<%If bXHTML Then%> /<%End If%>>
<link rel="stylesheet" type="text/css" href="style/mylib-widgets-ie.css" media="all"<%If bXHTML Then%> /<%End If%>>
<![endif]-->
<!--[if lt IE 6]>
<link rel="stylesheet" type="text/css" media="all" href="style/mylib-widgets-ie5.css">
<![endif]-->
<link rel="stylesheet" type="text/css" href="style/mylib-handheld.css" media="handheld"<%If bXHTML Then%> /<%End If%>>
<link rel="stylesheet" type="text/css" href="style/mylib-print.css" media="print"<%If bXHTML Then%> /<%End If%>>
<link rel="stylesheet" type="text/css" href="style/mylib-widgets-print.css" media="print"<%If bXHTML Then%> /<%End If%>>
<script type="text/javascript">var API = { deferAudio: true };</script>
<script type="text/javascript" src="mylib-build.asp?<%=sQuery%>"></script>
<script type="text/javascript" src="mylib-debug.js"></script>
<script type="text/javascript" src="mylib-fix.js"></script>
<script type="text/javascript" src="mylib-widgets.js"></script>
<script type="text/javascript" src="mylib-alert.js"></script>
<script type="text/javascript" src="mylib-ajaxmonitor.js"></script>
<script type="text/javascript">
<%If bXHTML And Not bAsHTML Then%><![CDATA[<%End If%>
var global = this;

if (this.API.attachDocumentReadyListener && (this.API.getAnElement || this.API.isRealObjectProperty(this.document, 'documentElement'))) {
	this.API.attachDocumentReadyListener(function() {
		var el;
		var api = global.API;
		var doc = global.document;
		var html = api.getAnElement ? api.getAnElement() : doc.documentElement;
		var isHostMethod = api.isHostMethod;
		var isHostObjectProperty = api.isHostObjectProperty;
		var isRealObjectProperty = api.isRealObjectProperty;
                var disableElements = api.disableElements;
                var getEBI = api.getEBI;
                var addOption, currentObject, i, objects, removeOptions, updateProperties;
		var unitTests = [];

		function addUnitTest(name, run, expected) {
			unitTests[unitTests.length] = { name: name, run: run, expected: expected };
		};
<%If Not bDOM Then%>
		// DOM module not present

		if (typeof getEBI != 'function') {
			getEBI = (function() {
				if (isHostMethod(doc, 'getElementById')) {
					return function(id) { return doc.getElementById(id); };
				}
				if (isRealObjectProperty(doc, 'all')) {
					return function(id) { return doc.all[id]; };
				}
			})();
		}
<%End If%>
<%If ((bCenter And bSize) Or bMaximize) And bScroll Then%>
		// Sidebar test (if ((center and size) or maximize) and scroll and offset)
		// Like center and maximize modules, sidebars can work with true fixed positioning when scroll module is absent

		var elBody, elSideBar, sideBars = [ 'top','left','bottom','right' ], oppositeSides = [ 'bottom','right','top','left' ];
                var sideBarShowOptions = (api.effects && api.effects.slide)?{ effects:api.effects.slide, duration:400 }:{};

                if (api.ease) {
                  sideBarShowOptions.ease = api.ease.circle;
                }

                function appendSideBarButton(elSideBar, v, fn) {
			var elButton = api.createElement('input');
			elButton.type = 'button';
			elButton.value = v;
			elSideBar.appendChild(elButton);
			if (api.getElementParentElement(elButton) == elSideBar) {
                          elButton.onclick = function() { var that = this; return fn(api.getElementParentElement(this), that); };
                        }
                        else {
                          elSideBar.removeChild(elButton);
                        }
			elButton = null;
                        elSideBar = null;
                }

		if (api.sideBar && api.createElement && api.showElement) {
			i = sideBars.length;

			while (i--) {
				el = getEBI('sidebar' + sideBars[i]);
				if (el) {
					el.disabled = false;
					el.onclick = (function(s, o) {
						return function() {
							elSideBar = api.createElement('div');
							if (elSideBar) {
								elSideBar.className = 'sidebar panel';
								elBody = api.getBodyElement();

								if (api.showElement) { // Append buttons to show/hide if possible
									// Auto-hide button
									if (api.attachRolloverListeners) { appendSideBarButton(elSideBar, 'Auto-hide', function(el, elButton) { if (api.autoHideSideBar(el, true, { duration:sideBarShowOptions.duration, ease:sideBarShowOptions.ease })) { el.className += ' autohide'; elButton.disabled = true; } else { myalert('Only one sidebar per edge may be hidden.', elButton, 'Sidebar', 'stop'); } }); }

									// Close button
									appendSideBarButton(elSideBar, 'Close', function(el, elButton) { api.showSideBar(el, false, { effects:sideBarShowOptions.effects, effectParams:{side:o}, duration:sideBarShowOptions.duration, ease:sideBarShowOptions.ease, removeOnHide:true}); api.unSideBar(el); });
								}
								if (s == 'right' || s == 'left') { elSideBar.className += ' vertical'; }

								elBody.appendChild(elSideBar);
								elSideBar.style.position = 'absolute'; // Handled automatically if application includes offset module

								if (api.fixElement) { api.fixElement(elSideBar); }
								api.sideBar(elSideBar, s);
								elSideBar = null;
							}
						};
					})(sideBars[i], oppositeSides[i]);
					el = null;
				}
                        }
                }

<%End If%>
		var elCurtain, curtainOptions = { duration:600, removeOnHide:true };

		function showCurtain(b) {
			if (!arguments.length) { b = true; }
			api.showElement(elCurtain, b, curtainOptions);
		}

		function hideCurtain() {
			showCurtain(false);
		}

		var myalert = (function() {
			var options = { removeOnHide:true }
			options.effects = [];

			if (api.effects) {
				if (api.effects.fade) { options.effects[options.effects.length] = api.effects.fade } else { options.effects = null; }
				options.duration = 500;
				options.fps = 60;
				if (api.ease) {
					options.ease = api.ease.cosine;
				}
			}

			if (api.alert) {
				if (api.coverDocument && api.presentElement && api.isHostMethod(global, 'setTimeout')) {
					elCurtain = api.createElement('div');

					if (elCurtain) {
						elCurtain.className = 'curtain';
						elCurtain.style.position = 'absolute';
						elCurtain.style.visibility = 'hidden';
						elCurtain.style.top = '0';

						elBody = api.getBodyElement();
						if (elBody) {
							elBody.appendChild(elCurtain);
							if (api.effects && api.effects.fade) {
								curtainOptions.effects = api.effects.fade;
								api.setOpacity(elCurtain, 0.5);
							}
						}

					}
				}

				api.getAlertElement().style.fontSize = '100%';

				return function(sText, elFrom, sTitle, sClassName, bModal) {
					var fn = function() {
						api.alert(sText, options, (api.spring && elFrom)?function(el, options, bMaximized) { if (bMaximized) { api.restoreElement(el); api.maximizeElement(el); } options.springMode = (bMaximized)?'':'center'; api.spring(el, elFrom, true, options, function() { API.focusAlert(); }); return true; }:null, (elFrom && api.spring)?function(el, options) { api.spring(el, elFrom, false, options); if (elCurtain && options.modal) { global.setTimeout(hideCurtain, (curtainOptions.duration)?curtainOptions.duration:0); } return true; }:null);
					};

					options.title = sTitle || 'Alert';
					options.modal = bModal;
					options.mute = true;

					options.className = (sClassName ? 'alert ' + sClassName : 'alert') + ' rounded shadow';

					if (elCurtain && api.coverDocument) {
						if (bModal) {
							api.coverDocument(elCurtain);
							showCurtain();
							global.setTimeout(fn, (bModal)?curtainOptions.duration:0);
							return;
						}
						else {
							showCurtain(false);
						}
					}
					fn();
				};
			}
			if (api.isHostMethod(global, 'alert')) {
				return function(sText) {
					global.alert(sText);
				};
			}
		})();

<%If bRequester Then%>
		var img, ajaxheadline;

		if (api.getTotals) {
			var updateTotal = function(name, totals) {
				var el = getEBI('total' + name);
				if (el) {
					el.value = totals[name];
				}
			};

			var updateTotals = function() {
				var totals = api.getTotals();
				if (totals) {
					updateTotal('successes', totals);
					updateTotal('failures', totals);
					updateTotal('cancels', totals);
					updateTotal('errors', totals);
				}
			};
		}

		if (getEBI && api.ajax && api.createElement && api.canAdjustStyle && api.canAdjustStyle('visibility')) {
			ajaxheadline = getEBI('ajax');

			if (ajaxheadline) {
				img = api.createElement('img');
				if (img) {
					img.src = 'images/ajax.gif';
					img.style.visibility = 'hidden';
					img.style.verticalAlign = 'middle';
					img.style.position = 'absolute';
					img.style.width = img.style.height = '24px';
					ajaxheadline.appendChild(img);					
					api.ajax.onstart = function() { img.style.visibility = 'visible'; };
					api.ajax.onfinish = function() { img.style.visibility = 'hidden'; };
				}
			}		
		}

		if (api.ajax) {
			api.ajax.onerror = function(sId, sGroup, xmlhttp, e, URI) {
				if (myalert) { myalert('Error sending to: ' + URI + ' ' + e, null, 'Ajax', 'stop'); }
				if (updateTotals) { updateTotals(); }
			};
		}

		if (api.monitorSession) {
			api.monitorSession();
			if (getEBI) {
				var elTotalsButton = getEBI('logtotals');
				if (elTotalsButton) {
					elTotalsButton.onclick = api.logTotals;
				}
				elTotalsButton = getEBI('resettotals');
				if (elTotalsButton) {
					elTotalsButton.onclick = function() {						
						api.resetTotals();
						if (updateTotals) { updateTotals(); }
					};
				}
				elTotalsButton = null;
			}
		}
<%End If%>
<%If bDrag Then%>
		var elDropReport, elDropTarget, elMoveHandle, elMoveButton, elSizeHandle, elSizeButton;
		var elAbsoluteButton, elCenterButton, elFixButton, elFullScreenButton, elMaximizeButton;

		function initiateSize(e) {
			api.initiateDrag(getEBI('drag5'), elSizeHandle, e);
		}

		function initiateMove(e) {
                        var ce = api.getContainerElement();
			(ce || getEBI('drag5')).style.cursor = 'move';
			getEBI('initiatemove').style.visibility = 'hidden';
			api.initiateDrag(getEBI('drag5'), elMoveHandle, e);
		}

		function updateDrag(el, b) {
			elSizeHandle.style.visibility = (b)?'hidden':'visible';
			getEBI('movehandle').title = "Double-click to " + ((b)?'restore':'maximize');
			getEBI('initiatesize').disabled = b;
			getEBI('initiatemove').disabled = b;
			getEBI('absolutedrag').disabled = b || !api.absoluteElement || getEBI('fixdrag').value != 'Fix';
			getEBI('fixdrag').disabled = b || !api.fixElement;
			getEBI('centerdrag').disabled = b || !api.centerElement;
			((b)?api.detachDrag:api.attachDrag)(el, getEBI('movehandle'), { ondrop:function() { getEBI('initiatemove').style.visibility = 'visible'; var ce = api.getContainerElement(); (ce || getEBI('drag5')).style.cursor = ''; } });
		}

		function maximizeDrag(b) {
			var el = getEBI('drag5');
			((b)?api.maximizeElement:api.restoreElement)(el, { duration:600, ease:(api.ease)?api.ease.circle:null });
			getEBI('fullscreendrag').disabled = b || !api.fullScreenElement;
			updateDrag(el, b);
		}

		function fullScreenDrag(b) {
			var el = getEBI('drag5');
			((b)?api.fullScreenElement:api.restoreElement)(el);
			getEBI('maximizedrag').disabled = b || !api.maximizeElement;
			updateDrag(el, b);
		}

		if (api.attachDrag && getEBI) {
			el = getEBI('drag1');
			if (el) {
				api.attachDrag(el);
				el = null;
			}
			el = getEBI('drag2');
			if (el) {
				api.attachDrag(el, null, { axes:'horizontal' });
				el = null;
			}

			el = getEBI('drag3');
			if (el) {
				api.attachDrag(el, null, { constrain:true });
				el = null;
			}

			el = getEBI('drag4');
			if (el) {
				api.attachDrag(el);
				el = null;
			}

			elSizeHandle = getEBI('sizehandle');
			elMoveHandle = getEBI('movehandle');

			el = getEBI('drag5');
			if (el && elMoveHandle && elSizeHandle) {
				elFixButton = getEBI('fixdrag');
				if (elFixButton && api.fixElement) {
					elFixButton.disabled = false;
					elFixButton.onclick = function() {
						var v = this.value;
						if (v == 'Fix') {
							api.fixElement(getEBI('drag5'));
							this.value = 'Unfix';
							getEBI('absolutedrag').disabled = true;
						}
						else {
							api.fixElement(getEBI('drag5'), false);
							this.value = 'Fix';
							getEBI('absolutedrag').disabled = false;
						}
					};
				}
				elFixButton = null;

				elMaximizeButton = getEBI('maximizedrag');
				if (elMaximizeButton && api.maximizeElement) {
					elMaximizeButton.disabled = false;
					elMaximizeButton.onclick = function() {
						var b = this.value == 'Maximize';
						this.value = (b)?'Restore':'Maximize';
				 		maximizeDrag(b);
					};
				}
				elMaximizeButton = null;

				elAbsoluteButton = getEBI('absolutedrag');
				if (elAbsoluteButton && api.absoluteElement) {
					elAbsoluteButton.disabled = false;
					elAbsoluteButton.onclick = function() {
						var b = this.value == 'Float';
						this.value = (b)?'Unfloat':'Float';
						((b)?api.absoluteElement:api.relativeElement)(getEBI('drag5'));
					};
				}
				elAbsoluteButton = null;

				elCenterButton = getEBI('centerdrag');
				if (elCenterButton && api.centerElement) {
					elCenterButton.disabled = false;
					elCenterButton.onclick = function() {
						api.centerElement(getEBI('drag5'), { duration:600, ease:(api.ease)?api.ease.circle:null });
						if (getEBI('fixdrag').value == 'Fix') { getEBI('absolutedrag').value = 'Unfloat'; }
					};
				}
				elMaximizeButton = null;

				elFullScreenButton = getEBI('fullscreendrag');
				if (elFullScreenButton && api.fullScreenElement) {
					elFullScreenButton.disabled = false;
					elFullScreenButton.onclick = function() {
						var b = this.value == 'Full Screen';
						this.value = (b)?'Restore':'Full Screen';
						fullScreenDrag(b);
					};
				}
				elFullScreenButton = null;

				el.style.position = 'relative'; // Backward compatible with browsers that cannot compute style (otherwise default of absolute would apply)
				api.attachDrag(el, elMoveHandle, { ondrop:function() { getEBI('initiatemove').style.visibility = 'visible'; var ce = api.getContainerElement(); (ce || getEBI('drag5')).style.cursor = ''; } });
				api.attachDrag(el, elSizeHandle, { mode:'size' });
				elSizeButton = getEBI('initiatesize');
				elMoveButton = getEBI('initiatemove');
				if (api.initiateDrag && elSizeButton && elMoveButton) {
					elSizeButton.disabled = false;
					elMoveButton.disabled = false;
					elSizeButton.onclick = initiateSize;
					elMoveButton.onclick = initiateMove; 
				}
				if (api.maximizeElement) {
					api.attachListener(elMoveHandle, 'dblclick', function(e) {
                                                b = elSizeHandle.style.visibility != 'hidden';
				 		maximizeDrag(b);
						getEBI('maximizedrag').value = (b)?'Restore':'Maximize';
						return api.cancelDefault(e);
					});
					elMoveHandle.title = "Double-click to maximize";
				}
				elMoveButton = null;
				elSizeButton = null;
				el = null;
			}

			el = getEBI('drag6');
			if (el) {
				api.attachDrag(el, null, { mode:'size' });
				el = null;
			}

			el = getEBI('drag7');
			if (el) {
				api.attachDrag(el, null, { mode:'scroll' });
				el = null;
			}

			el = getEBI('drag8');
			elDropTarget = getEBI('droptarget');
			elDropReport = getEBI('dropreport');

			if (el && elDropTarget && elDropReport) {
				api.attachDrag(el, null, { targets:[elDropTarget], ondrop:function(t) { if (t && t.length) { elDropReport.value = 'Dropped.'; } else { elDropReport.value = 'Drag image to start'; } }, ondragover:function() { elDropReport.value = 'Over'; }, ondragout:function() { elDropReport.value = 'Out'; }, ondragstart:function() { elDropReport.value = 'Drag over the target';  } });
				el = null;
			}
                }
<%End If%>
		// From Form module, included to reduce console dependencies
		if (isHostMethod(global, 'Option')) {
			addOption = function(el, text, value) {
				var o = new global.Option(), len = el.options.length;
				o.text = text;
				if (typeof(value) != 'undefined') { o.value = value; }
				if (el.options.add) {
					el.options.add(o, el.options.length);
				}
				if (el.options.length == len) {
					el.options[el.options.length] = o;
				}
				return o;
			};
		}

		removeOptions = function(el) {
			el.options.length = 0;
			var i = el.options.length;		
			while (i--) { el.options[i] = null; }
		};

		if (getEBI && addOption && api.log) {
<%If bXHTML And Not bAsHTML Then%>
			var elBefore, elChild, elGrandChild, body;
			var createElement = api.createElement;
			var getBodyElement = api.getBodyElement;

			function appendButton(el, id, value) {
				var elButton = createElement('input');
				if (elButton) {
					elButton.setAttribute('id', id);
					elButton.setAttribute('type', 'button');
					elButton.setAttribute('value', value);
					el.appendChild(elButton);
				}
			}

			if (doc && createElement && getBodyElement && isHostMethod(doc, 'createTextNode')) {
				body = getBodyElement();
				if (body) {
					elBefore = getEBI('address');
 					if (elBefore) {
						elChild = createElement('h2');
						if (elChild) {
							elChild.className = 'test';
							elChild.appendChild(doc.createTextNode('Console'));
							body.insertBefore(elChild, elBefore);
						}

						elChild = createElement('p');
						if (elChild) {
							elChild.appendChild(doc.createTextNode('Inspect the API with the console. Note that the interface changes according to the environment.'));
							body.insertBefore(elChild, elBefore);
						}

						if (isHostMethod(body, 'appendChild') && isHostMethod(body, 'setAttribute')) {
		 					el = createElement('fieldset');
							if (el) {
								el.setAttribute('id', 'fieldset');
								elChild = createElement('legend');
								if (elChild) {
									elChild.appendChild(doc.createTextNode('Console'));
									el.appendChild(elChild);
								}

								elChild = createElement('textarea');
								if (elChild) {
									elChild.setAttribute('id', 'log');
									elChild.setAttribute('rows', '10');
									elChild.setAttribute('readonly', 'readonly');
									el.appendChild(elChild);						
								}
								appendButton(el, 'toggledebug', 'Toggle Debug');
								appendButton(el, 'inspectdocument', 'Inspect Document');
								appendButton(el, 'clearlog', 'Clear Log');
								elChild = createElement('fieldset');
								if (elChild) {
									elChild.setAttribute('id', 'propertiesfieldset');
									elGrandChild = createElement('legend');
									if (elGrandChild) {
										elGrandChild.appendChild(doc.createTextNode('Properties'));
										elChild.appendChild(elGrandChild);
									}
									elGrandChild = createElement('label');
									if (elGrandChild) {
										elGrandChild.appendChild(doc.createTextNode('Object:'));
										elGrandChild.setAttribute('for', 'objects');
										elChild.appendChild(elGrandChild);
									}
									elGrandChild = createElement('select');
									if (elGrandChild) {
										elGrandChild.setAttribute('id', 'objects');
										elChild.appendChild(elGrandChild);
									}
									elGrandChild = createElement('label');
									if (elGrandChild) {
										elGrandChild.appendChild(doc.createTextNode('Property:'));
										elGrandChild.setAttribute('for', 'properties');
										elChild.appendChild(elGrandChild);
									}
									elGrandChild = createElement('select');
									if (elGrandChild) {
										elGrandChild.setAttribute('id', 'properties');
										elChild.appendChild(elGrandChild);
									}
									appendButton(elChild, 'inspect', 'Inspect');
									el.appendChild(elChild);
								}


								elChild = createElement('fieldset');
								if (elChild) {
									elGrandChild = createElement('legend');
									if (elGrandChild) {
										elGrandChild.appendChild(doc.createTextNode('Immediate'));
										elChild.appendChild(elGrandChild);
									}

									elGrandChild = createElement('input');
									elGrandChild.setAttribute('class', 'test');
									elGrandChild.setAttribute('id', 'immediate');
									elChild.appendChild(elGrandChild);
									appendButton(elChild, 'runimmediate', 'Run');
									appendButton(elChild, 'clearimmediate', 'Clear');
									appendButton(elChild, 'multiimmediate', 'Multi-line');
									el.appendChild(elChild);
								}
								body.insertBefore(el, elBefore);

								elChild = createElement('fieldset');
								if (elChild) {
									elGrandChild = createElement('legend');
									if (elGrandChild) {
										elGrandChild.appendChild(doc.createTextNode('Unit Testing'));
										elChild.appendChild(elGrandChild);
									}

									appendButton(elChild, 'rununittests', 'Run Unit Tests');
									el.appendChild(elChild);
								}
								body.insertBefore(el, elBefore);



<%If bRequester Then%>
								elChild = createElement('fieldset');
								if (elChild) {
									elGrandChild = createElement('legend');
									if (elGrandChild && api.monitorSession) {
										elGrandChild.appendChild(doc.createTextNode('Ajax Monitor'));
										elChild.appendChild(elGrandChild);

										elGrandChild = createElement('label');
										elGrandChild.setAttribute('for', 'totalsuccesses');
										elGrandChild.appendChild(doc.createTextNode('Successful:'));
										elChild.appendChild(elGrandChild);

										elGrandChild = createElement('input');
										elGrandChild.setAttribute('id', 'totalsuccesses');
										elGrandChild.setAttribute('value', '0');
										elGrandChild.setAttribute('class', 'total');
										elChild.appendChild(elGrandChild);

										elGrandChild = createElement('label');
										elGrandChild.setAttribute('for', 'totalfailures');
										elGrandChild.appendChild(doc.createTextNode('Failed:'));
										elChild.appendChild(elGrandChild);

										elGrandChild = createElement('input');
										elGrandChild.setAttribute('id', 'totalfailures');
										elGrandChild.setAttribute('value', '0');
										elGrandChild.setAttribute('class', 'total');
										elChild.appendChild(elGrandChild);

										elGrandChild = createElement('label');
										elGrandChild.setAttribute('for', 'totalcancels');
										elGrandChild.appendChild(doc.createTextNode('Canceled:'));
										elChild.appendChild(elGrandChild);

										elGrandChild = createElement('input');
										elGrandChild.setAttribute('id', 'totalcancels');
										elGrandChild.setAttribute('value', '0');
										elGrandChild.setAttribute('class', 'total');
										elChild.appendChild(elGrandChild);

										elGrandChild = createElement('label');
										elGrandChild.setAttribute('for', 'totalerrors');
										elGrandChild.appendChild(doc.createTextNode('Errored:'));
										elChild.appendChild(elGrandChild);

										elGrandChild = createElement('input');
										elGrandChild.setAttribute('id', 'totalerrors');
										elGrandChild.setAttribute('value', '0');
										elGrandChild.setAttribute('class', 'total error');
										elChild.appendChild(elGrandChild);

										appendButton(elChild, 'logtotals', 'Log');
										appendButton(elChild, 'resettotals', 'Reset');
										el.appendChild(elChild);

										var elTotalsButton = getEBI('logtotals');
										if (elTotalsButton) {
											elTotalsButton.onclick = api.logTotals;
										}
										elTotalsButton = getEBI('resettotals');
										if (elTotalsButton) {
											elTotalsButton.onclick = function() {
												api.resetTotals();
												if (updateTotals) {
													updateTotals();
												}
											};
										}
										elTotalsButton = null;
									}
								}
<%End If%>
								el = elChild = elGrandChild = null;
							}
						}
					}
				}
			}
<%End If%>
			var elLog = getEBI('log');
			var elToggle = getEBI('toggledebug');
			var elClear = getEBI('clearlog');
			var elInspect = getEBI('inspect');
			var elInspectDocument = getEBI('inspectdocument');
			var elObjects = getEBI('objects');
			var elProperties = getEBI('properties');
			var elImmediate = getEBI('immediate');
			var elRunImmediate = getEBI('runimmediate');
			var elClearImmediate = getEBI('clearimmediate');
			var elMultiImmediate = getEBI('multiimmediate');
			var elRunUnitTests = getEBI('rununittests');

			if (addOption) {
				updateProperties = function() {
					var a, i;
					var s = elObjects.options[elObjects.selectedIndex].text;
					var v = elObjects.options[elObjects.selectedIndex].value;
					var o = global[v];
					removeOptions(elProperties);
					if (o) {
						switch(v) {
						case 'Q':
							o = new o('html');
							break;
						case 'E':
							o = new o('properties');
							break;
						case 'F':
							o = new o(); // Need form
							break;
						case 'I':
							o = new o(); // Need image
							break;
						case 'D':
						case 'W':
							o = new o();
						}
						currentObject = o;
						a = api.properties(o, s != 'API').reverse();
						i = a.length;
						while (i--) {						
							addOption(elProperties, a[i]);
						}
					}
					else {
						currentObject = null;
					}
				};
	                }

			if (elLog && elToggle && elClear && elInspect && elInspectDocument && elObjects && elProperties && elImmediate && elRunImmediate && elClearImmediate && elMultiImmediate && elRunUnitTests) {
				api.setConsoleElement(elLog);
				elClear.onclick = function() { global.API.clearLog(); };
				if (api.logElementTraversal) {
					elInspectDocument.onclick = function() { global.API.logElementTraversal(global.document); };
				} else {
					if (disableElements) { disableElements(elInspectDocument); }
				}

				if (api.debug) {
					elToggle.onclick = function() { global.API.toggleDebug(); };
				}
				else {
					if (disableElements) { disableElements(elToggle); }
				}
				if (updateProperties) {
					addOption(elObjects, 'API', 'API');
<%If bObjects Then%>
					objects = ['W', 'Q', 'I', 'F', 'E', 'D'];
					i = objects.length;
					while (i--) {
						addOption(elObjects, 'new ' + objects[i], objects[i]);
					}
<%End If%>
					if (elObjects.options.length) {
						elObjects.options[0].selected = true;
						updateProperties();
						elObjects.onchange = updateProperties;
						elInspect.onclick = function() {
							if (currentObject) {
								api.log(currentObject[elProperties.options[elProperties.selectedIndex].text]);
								if (typeof currentObject == 'object' && isRealObjectProperty(global, 'console') && isHostMethod(global.console, 'inspect')) {
									console.inspect(currentObject);
								}
							}
						};
					} else {
						if (disableElements) { disableElements(elProperties, elObjects, elInspect); }					
					}
				}
				else {
					if (disableElements) { disableElements(elProperties, elObjects, elInspect); }
				}

				var myEval = function(str) {
					return eval(str);
				};

				if (api.isHostMethod(elImmediate, 'focus')) {
					var focusImmediate = function() {
						if (elImmediate.focus) {
							elImmediate.focus();
						}
					};
				}

				var runImmediate = function() {
					api.log(myEval(elImmediate.value));
					if (focusImmediate) {
						focusImmediate();
					}
					if (isHostMethod(elImmediate, 'select')) {
						elImmediate.select();
					}

				};

				elImmediate.onkeyup = function(e) {
					e = e || global.window.event;
					var key = e.which || e.keyCode;
					if (key == 13) {
						runImmediate();
						return false;
					}
				};

				elRunImmediate.onclick = function() {
					runImmediate();
				};

				elClearImmediate.onclick = function() {
					elImmediate.value = '';
					if (focusImmediate) {
						focusImmediate();
					}
				};

				addUnitTest('Assert', function() { return true; }, true);
				addUnitTest('Deny', function() { return false; }, false);

				if (api.runUnitTests) {
					elRunUnitTests.onclick = function() {
						api.runUnitTests(unitTests);
					};
				} else if (disableElements) {
					disableElements(elRunUnitTests);
				}

				if (isHostObjectProperty(elImmediate, 'parentNode') && isHostMethod(elImmediate.parentNode, 'replaceChild')) {
					elMultiImmediate.onclick = function() {
						var elTextarea = api.createElement('textarea');
						elTextarea.id = elImmediate.id;
						elTextarea.value = elImmediate.value;
						elImmediate.parentNode.replaceChild(elTextarea, elImmediate);
						elImmediate = elTextarea;
						if (focusImmediate) {
							focusImmediate();
						}
						if (disableElements) {
							disableElements(elMultiImmediate);
						}
					};
				}
				else if (disableElements) {
					disableElements(elMultiImmediate);
				}

        	                global.onunload = function() {
					elImmediate.onkeyup = null;
					elRunUnitTests.onclick = null;
					elRunImmediate.onclick = null;
					elClearImmediate.onclick = null;
					elMultiImmediate.onclick = null;
					elClear.onclick = null;
					elInspectDocument.onclick = null;
					elInspect.onclick = null;
					elToggle.onclick = null;
					elObjects.onchange = null;
                	        };
			}
		}

<%If (bImage Or bShow Or bHTML Or bUpdater Or bScrollFX) Then%>
		var effectNames = { fade:'Fade', horizontalBlinds:'Horizontal Blinds', verticalBlinds:'Vertical Blinds', grow:'Grow', fold:'Fold', drop:'Drop', zoom:'Zoom', slide:'Slide', clip:'Clip' }

		function effectOptions(display, duration, elEffect1, elEffect2, elEffectDirectX, elEase, elFPS) {
			var options = { display:display, removeOnHide:true, duration:duration };
			var effects;
			if (api.effects && elEffect1 && elEffect2 && elEffect1.selectedIndex != -1 && !elEffect1.disabled) {
				if (elEffect1.options[elEffect1.selectedIndex].value) {
					effects = [];
					effects[0] = api.effects[elEffect1.options[elEffect1.selectedIndex].value];
					if (elEffect2.selectedIndex) {
						effects[1] = api.effects[elEffect2.options[elEffect2.selectedIndex].value];
					}
				}
			}
			if (elEffectDirectX && elEffectDirectX.selectedIndex != -1 && !elEffectDirectX.disabled && elEffectDirectX.options[elEffectDirectX.selectedIndex].value) {
				options.directXTrans = elEffectDirectX.options[elEffectDirectX.selectedIndex].value;
			}
			if (effects) {
				if (effects.length == 1) { effects = effects[0]; }
				options.effects = effects;
				options.fps = parseInt(elFPS.options[elFPS.selectedIndex].value, 10);
				if (api.ease && elEase && elEase.options[elEase.selectedIndex].value) { options.ease = api.ease[elEase.options[elEase.selectedIndex].value]; }
			}
			return options;
		}

		function disableEffectControl(el, b) {
			var elLabel;
			if (arguments.length == 1) { b = true; }
			el.disabled = b;
			elLabel = getEBI(el.id + 'label')
			if (elLabel) {
				elLabel.disabled = b;
				elLabel.className = (b)?'disabled':'';
			}
                }

		function updateEffectFields(elEffect1, elEffect2, elEffectDirectX, elEase, elFPS, elEffectOptions) {
			var i, s = elEffect2.selectedIndex;
			var e = elEffect1.options[elEffect1.selectedIndex].text;			
			removeOptions(elEffect2);
			addOption(elEffect2, '[None]');

			var directX = (elEffectDirectX && elEffectDirectX.options[elEffectDirectX.selectedIndex].value);
			disableEffectControl(elFPS, directX);
			disableEffectControl(elEffect1, directX);
			if (elEase) { disableEffectControl(elEase, directX); }

			if (e == '[None]') {
				disableEffectControl(elEffect2);
				disableEffectControl(elFPS);
				elEffectOptions.className = 'disabled';
				if (elEase) { disableEffectControl(elEase); }
				elEffect2.selectedIndex = 0;
			}
			else {
				if (e != 'Fade') {
					if (api.effects.fade) { addOption(elEffect2, 'Fade', 'fade'); }
				}
				else {
					for (i in api.effects) {
						if (api.isOwnProperty(api.effects, i) && effectNames[i] && i != 'fade') {
							addOption(elEffect2, effectNames[i], i);
						}
					}

				}
				disableEffectControl(elEffect2, directX || elEffect2.options.length < 2);
				elEffectOptions.className = (directX)?'disabled':'';
				if (s && s <= elEffect2.options.length) {
					elEffect2.selectedIndex = s;
				}
				else {
					elEffect2.selectedIndex = 0;
				}
			}
		}

		function populateEffectsControl(el) {
			for (i in api.effects) {
				if (api.isOwnProperty(api.effects, i) && effectNames[i]) {
					addOption(el, effectNames[i], i);
				}
			}
		}

<%End If%>
<%If (bImage Or bShow Or bHTML Or bUpdater Or bScroll) Then%>
		function populateEasingControl(el) {
			var i;
			for (i in api.ease) {
				if (api.isOwnProperty(api.ease, i)) {
					addOption(el, i.substring(0, 1).toUpperCase() + i.substring(1), i);
				}
			}
		}

<%End If%>

<%If bRequester Or bUpdater Then%>
		var Requester = api.Requester;

		function requestFailed(xmlhttp) {
			myalert('Request failed. Status: ' + xmlhttp.status, null, 'Ajax', 'stop');
			if (updateTotals) { updateTotals(); }
		}

		function requestCanceled(xmlhttp) {
			myalert('Request canceled.', null, 'Ajax', 'caution');
			if (updateTotals) { updateTotals(); }
		}
<%End If%>

<%If bRequester Then%>
		var requester, elRequestHtml, elRequestXhtml, elRequestXml, elRequestJson;

		function interpretResponse(xmlhttp, obj) {
			var r = '';
			if (xmlhttp.responseText) {
				r += ' Received text';
				if (xmlhttp.responseXML && xmlhttp.responseXML.childNodes && xmlhttp.responseXML.childNodes.length) {
					r += ' and XML';
				}
				if (obj && obj.oranges == 2) {
					r += ' and parsed object';
				}
				r += '.';
			}
			return r;
		}

		function requestSucceeded(xmlhttp, obj) {
			myalert('Request succeeded.' + interpretResponse(xmlhttp, obj), null, 'Ajax');
			if (updateTotals) { updateTotals(); }
		}

		if (api.Requester && getEBI && myalert) {
			requester = new Requester('test');
			requester.onsuccess = requestSucceeded;
			requester.onfail = requestFailed;
			requester.oncancel = requestCanceled;
			if (api.monitorRequest) { api.monitorRequest(requester); }
			elRequestHtml = getEBI('requesthtml');
			elRequestXhtml = getEBI('requestxhtml');
			elRequestXml = getEBI('requestxml');
			elRequestJson = getEBI('requestjson');

			if (elRequestHtml) {
				elRequestHtml.disabled = false;
				elRequestHtml.onclick = function() { requester.get('http://www.cinsoft.net/testupdate.asp'); }
				elRequestHtml = null;
			}

			if (elRequestXhtml) {
				elRequestXhtml.disabled = false;
				elRequestXhtml.onclick = function() { requester.get('http://www.cinsoft.net/testupdate.asp?mode=XHTML'); }
				elRequestXhtml = null;
			}

			if (elRequestXml) {
				elRequestXml.disabled = false;
				elRequestXml.onclick = function() { requester.get('http://www.cinsoft.net/testupdate.asp?mode=XML'); }
				elRequestXml = null;
			}

			if (elRequestJson) {
				elRequestJson.disabled = false;
				elRequestJson.onclick = function() { requester.get('http://www.cinsoft.net/testupdate.asp?mode=JSON', true); }
				elRequestJson = null;
			}
		}
<%End If%>

<%If bUpdater Then%>
		var requesterUpdate, elUpdateHtml, elUpdateXhtml, elUpdateXml, elTestUpdate, elEaseU, elFPSU, elEffect1U, elEffect2U, elEffectDirectXU, elEffectOptionsU, updateUpdaterEffectFields;
		var reDiv = new RegExp('<div id="content">(.*)<\/div>');

		function updateRequestSucceeded(text, xml) {
			var el, html, match;			

			if (api.setElementNodes) { // Can import nodes
				if (xml && xml.childNodes && xml.childNodes.length) {
					var el = xml.getElementsByTagName('div');
					if (el[0]) {
						return el[0];
					}
				}
			}
			if (text) {
				match = text.match(reDiv);
				if (match) {
					return match[0];
				}
				else {
					myalert('Content not found in response.', null, 'Ajax', 'stop');
				}
			}
			else {
				myalert('Response is empty.', null, 'Ajax', 'stop');
			}
		}

		if (api.updateElement && getEBI && myalert) {
			requesterUpdate = new Requester('testupdate');
			if (updateTotals) {
				requesterUpdate.onsuccess = updateTotals;
			}
			requesterUpdate.onfail = requestFailed;
			requesterUpdate.oncancel = requestCanceled;
			if (api.monitorRequest) { api.monitorRequest(requesterUpdate); }
			elEaseU = getEBI('easeU');
			elFPSU = getEBI('fpsU');
			elEffect1U = getEBI('effect1U');
			elEffect2U = getEBI('effect2U');
			elEffectDirectXU = getEBI('effectdirectxU');
			elEffectOptionsU = getEBI('effectoptionsU');
			elTestUpdate = getEBI('testupdate');

			if (elTestUpdate) {
				if (elTestUpdate.style) { elTestUpdate.style.fontSize = '100%'; }
				updateUpdaterEffectFields = function() { updateEffectFields(elEffect1U, elEffect2U, elEffectDirectXU, elEaseU, elFPSU, elEffectOptionsU); };
				elUpdateHtml = getEBI('updatehtml');
				elUpdateXhtml = getEBI('updatexhtml');
				elUpdateXml = getEBI('updatexml');

				if (elUpdateHtml) {
					elUpdateHtml.disabled = false;
					elUpdateHtml.onclick = function() { api.updateElement(elTestUpdate, 'http://www.cinsoft.net/testupdate.asp', false, effectOptions(null, 600, elEffect1U, elEffect2U, elEffectDirectXU, elEaseU, elFPSU), updateRequestSucceeded, null, requesterUpdate); }
					elUpdateHtml = null;
				}

				if (elUpdateXhtml) {
					elUpdateXhtml.disabled = false;
					elUpdateXhtml.onclick = function() { api.updateElement(elTestUpdate, 'http://www.cinsoft.net/testupdate.asp?mode=XHTML', false, effectOptions(null, 600, elEffect1U, elEffect2U, elEffectDirectXU, elEaseU, elFPSU), updateRequestSucceeded, null, requesterUpdate); }
					elUpdateXhtml = null;
				}

				if (elUpdateXml) {
					elUpdateXml.disabled = false;
					elUpdateXml.onclick = function() { api.updateElement(elTestUpdate, 'http://www.cinsoft.net/testupdate.asp?mode=XML', false, effectOptions(null, 600, elEffect1U, elEffect2U, elEffectDirectXU, elEaseU, elFPSU), updateRequestSucceeded, null, requesterUpdate); }
					elUpdateXml = null;
				}


				if (api.effects && elEffect1U && elEffect2U && elFPSU) {
					populateEffectsControl(elEffect1U);

					if (api.ease && elEaseU) {
						populateEasingControl(elEaseU);
					}
					if (api.overlayElement) {
						(elEffect1U.onchange = updateUpdaterEffectFields)();
					} else {
						disableEffectControl(elEffect1U, true);
					}
				}

				if (api.overlayElement && api.playDirectXTransitionFilter && elEffectDirectXU) {
					disableEffectControl(elEffectDirectXU, false);
					(elEffectDirectXU.onchange = updateUpdaterEffectFields)();
				}
			}
		}
<%End If%>
<%If bGetHTML Then%>
                var elInnerHtml, elOuterHtml, elHtmlReport, elNativeHtml, elXhtml;

                if (api.getElementHtml && getEBI) {
			elHtmlReport = getEBI('htmlreport');
			elNativeHtml = getEBI('nativehtml');
			elXhtml = getEBI('xhtml');
			if (elHtmlReport && elNativeHtml && elXhtml) {				
				disableEffectControl(elNativeHtml, false);
				disableEffectControl(elXhtml, false);
				elInnerHtml = getEBI('getinnerhtml');
				if (elInnerHtml) {
					elInnerHtml.disabled = false;
					elInnerHtml.onclick = function() { elHtmlReport.value = api.getElementHtml(api.getHtmlElement(), elXhtml.checked, elNativeHtml.checked); };
					elInnerHtml = null;
				}
				elOuterHtml = getEBI('getouterhtml');
				if (elOuterHtml) {
					elOuterHtml.disabled = false;
					elOuterHtml.onclick = function() { elHtmlReport.value = api.getElementOuterHtml(api.getHtmlElement(), elXhtml.checked, elNativeHtml.checked); };
					elOuterHtml = null;
				}
			}
                }
<%End If%>
<%If bImage Then%>
		var elChangeImage, elEaseI, elFPSI, elEffect1I, elEffect2I, elEffectDirectXI, elEffectOptionsI, elImageChange, imgReceiver, imgTV, updateImageEffectFields;

		if (api.changeImage && getEBI) {
			elChangeImage = getEBI('changeimage');
			elEaseI = getEBI('easeI');
			elFPSI = getEBI('fpsI');
			elEffect1I = getEBI('effect1I');
			elEffect2I = getEBI('effect2I');
			elEffectDirectXI = getEBI('effectdirectxI');
			elEffectOptionsI = getEBI('effectoptionsI');
			elImageChange = getEBI('imagechange');

			updateImageEffectFields = function() { updateEffectFields(elEffect1I, elEffect2I, elEffectDirectXI, elEaseI, elFPSI, elEffectOptionsI); };

			if (elChangeImage && elImageChange) {
				elChangeImage.disabled = false;
				if (api.effects && elEffect1I && elEffect2I && elFPSI) {
					populateEffectsControl(elEffect1I);

					if (api.ease && elEaseI) {
						populateEasingControl(elEaseI);
					}

					if (api.overlayElement) { // *** Check async flag instead
						(elEffect1I.onchange = updateImageEffectFields)();
					} else {
						disableEffectControl(elEffect1I, true);
					}
				}

				if (api.overlayElement && api.playDirectXTransitionFilter && elEffectDirectXI) {
					disableEffectControl(elEffectDirectXI, false);
					(elEffectDirectXI.onchange = updateImageEffectFields)();
				}

				elChangeImage.onclick = function() {
					api.changeImage(elImageChange, (elImageChange.src.indexOf('painting1') == -1)?imgReceiver:imgTV, effectOptions(null, 600, elEffect1I, elEffect2I, elEffectDirectXI, elEaseI, elFPSI));
				};

				elChangeImage = null;
			}

			imgTV = 'images/painting2.jpg'
			imgReceiver = 'images/painting1.jpg'
			if (api.preloadImage) { imgTV = api.preloadImage(imgTV); imgReceiver = api.preloadImage(imgReceiver); }
		}
<%End If%>
<%If bHTML Then %>
		var elChangeHTML, elChangeHTMLSelect, elEaseH, elFPSH, elEffect1H, elEffect2H, elEffectDirectXH, elEffectOptionsH, elHTMLChange, elHTMLChangeSelect, updateHTMLEffectFields;

		if (api.setElementHtml && getEBI) {
			elChangeHTML = getEBI('changehtml');
			elChangeHTMLSelect = getEBI('changehtmlselect');
			elEaseH = getEBI('easeH');
			elFPSH = getEBI('fpsH');
			elEffect1H = getEBI('effect1H');
			elEffect2H = getEBI('effect2H');
			elEffectDirectXH = getEBI('effectdirectxH');
			elEffectOptionsH = getEBI('effectoptionsH');
			elHTMLChange = getEBI('htmlchange');
			elHTMLChangeSelect = getEBI('htmlchangeselect');

			updateHTMLEffectFields = function() { updateEffectFields(elEffect1H, elEffect2H, elEffectDirectXH, elEaseH, elFPSH, elEffectOptionsH); };

			if (elChangeHTML && elHTMLChange) {
				elChangeHTML.disabled = false;
				elHTMLChange.style.fontSize = '100%';

				if (api.effects && elEffect1H && elEffect2H && elFPSH) {
					populateEffectsControl(elEffect1H);

					if (api.ease && elEaseH) {
						populateEasingControl(elEaseH);
					}

					if (api.overlayElement) {
						(elEffect1H.onchange = updateHTMLEffectFields)();
					} else {
						disableEffectControl(elEffect1H, true);
					}
				}

				if (api.overlayElement && api.playDirectXTransitionFilter && elEffectDirectXH) {
					disableEffectControl(elEffectDirectXH, false);
					(elEffectDirectXH.onchange = updateHTMLEffectFields)();
				}

				elChangeHTML.onclick = function() {
					api.setElementHtml(elHTMLChange, '<em>Changed<\/em> at ' + new Date(), effectOptions(null, 600, elEffect1H, elEffect2H, elEffectDirectXH, elEaseH, elFPSH));
				};

				if (elChangeHTMLSelect && elHTMLChangeSelect) {

					elHTMLChangeSelect.style.fontSize = '80%';
					elChangeHTMLSelect.disabled = false;
					elChangeHTMLSelect.onclick = function() {
						if (elHTMLChangeSelect.parentNode) {
 							elHTMLChangeSelect = api.setElementHtml(elHTMLChangeSelect, '<option>Changed at ' + new Date() +  '<\/option>', effectOptions(null, 600, elEffect1H, elEffect2H, elEffectDirectXH, elEaseH, elFPSH), function(el) { elHTMLChangeSelect = el; }); // Callback for non-DirectX special effects, which don't replace the SELECT element immediately
						}
					};
				}

				elChangeHTML = null;
				elChangeHTMLSelect = null;
			}
		}
<%End If%>

<%If bScroll Then%>
		var m, scrollSides = ['Top', 'Left', 'Bottom', 'Right'];

		function scrollOptions() {
			var options, el = getEBI('scrolleffect');
			if (el && el.checked) {
				options = { duration:1200, fps:60, wheelInterrupts:true };
				el = getEBI('scrollease');
				if (el) {
					if (el.selectedIndex) {
						options.ease = api.ease[el.options[el.selectedIndex].value];
					}
				}
			}
			return options;		
		}

		function updateScrollEasingFields() {
			var el = getEBI('scrolleffect');
			var b = el.checked;
			el = getEBI('scrollease');
			if (el) { disableEffectControl(el, !b); }
		}

		if (api.setScrollPosition && getEBI) {
			i = scrollSides.length;
			while (i--) {
				el = getEBI('scroll' + scrollSides[i].toLowerCase());
				if (el) {
					m = 'setScrollPosition' + scrollSides[i];
					if (api[m]) {
						el.onclick = (function(n) { return function() { var options = scrollOptions(); api[n](null, options); }; })(m);
						el.disabled = false;
					}
				}

			}

			if (api.effects) {
				el = getEBI('scrolleffect');
				if (el) {
					el.onclick = function() {
						global.setTimeout(updateScrollEasingFields, 0);
					};
					disableEffectControl(el, false);
					if (api.ease) {
						el = getEBI('scrollease');
						if (el) {
							populateEasingControl(el);
							updateScrollEasingFields();
						}
					}
				}
			}
			el = null;
		}
<%End If%>
<%If bShow Then%>
		var elToggle1, elToggle2, elToggle3, elToggle4, elToggle5, elToggleStatic, elToggleAbsolute, elToggleFixed, elToggleImage, elEase, elFPS, elEffect1, elEffect2, elEffectDirectX, elEffectOptions, updateShowEffectFields;

		if (api.showElement && getEBI) {
			elToggle1 = getEBI('toggleElement');
			elToggle2 = getEBI('toggleElementAbsolute');
			elToggle3 = getEBI('toggleElementImage');
			elToggle4 = getEBI('toggleElements');
			elToggle5 = getEBI('toggleElementFixed');
			elToggleStatic = getEBI('toggle1');
			elToggleAbsolute = getEBI('toggle2');
			elToggleImage = getEBI('toggle3');
			elToggleFixed = getEBI('toggle4');
			elEase = getEBI('ease');
			elFPS = getEBI('fps');
			elEffect1 = getEBI('effect1');
			elEffect2 = getEBI('effect2');
			elEffectDirectX = getEBI('effectdirectx');
			elEffectOptions = getEBI('effectoptions');

			updateShowEffectFields = function() { updateEffectFields(elEffect1, elEffect2, elEffectDirectX, elEase, elFPS, elEffectOptions); };

			if (elToggle1 && elToggle2 && elToggle3 && elToggle4 && elToggle5 && elToggleStatic && elToggleAbsolute && elToggleFixed && elToggleImage) {
				elToggle1.disabled = false;
				elToggle2.disabled = false;
				elToggle3.disabled = false;
				elToggle4.disabled = false;

				if (api.fixElement) {
					api.fixElement(elToggleFixed);
					elToggleFixed.style.left = '0';
					elToggleFixed.style.top = '0';
					elToggle5.disabled = false;
				}

				// For backward compatibility with browsers that cannot compute styles (ensures isVisible will get the correct initial result)
				if (api.presentElement) {
					elToggleStatic.style.display = 'none';
				}

				elToggleStatic.visibility = 'hidden';
				elToggleAbsolute.style.visibility = 'hidden';
				elToggleFixed.style.visibility = 'hidden';
				elToggleImage.style.visibility = 'hidden';

				elToggleAbsolute.style.fontSize = '1em';
				elToggleStatic.style.fontSize = '1em';
				elToggleFixed.style.fontSize = '1em';

				if (api.effects && elEffect1 && elEffect2 && elFPS) {
					populateEffectsControl(elEffect1);

					if (api.ease && elEase) {
						populateEasingControl(elEase);
					}

					(elEffect1.onchange = updateShowEffectFields)();
				}

				if (api.playDirectXTransitionFilter && elEffectDirectX) {
					disableEffectControl(elEffectDirectX, false);
					(elEffectDirectX.onchange = updateShowEffectFields)();
				}
				elToggle1.onclick = function() {
					var cb, options = effectOptions('block', 2200, elEffect1, elEffect2, elEffectDirectX, elEase, elFPS);

					if (options.effects || options.directXTrans) {
						cb = function() { elToggle1.disabled = false; };
						this.disabled = true;
					}						
					api.toggleElement(elToggleStatic, options, cb);
				};
				elToggle2.onclick = function() {
					var cb, options = effectOptions('block', 800, elEffect1, elEffect2, elEffectDirectX, elEase, elFPS);

					if (options.effects || options.directXTrans) {
						cb = function() { elToggle2.disabled = false; };
						this.disabled = true;
					}
					api.toggleElement(elToggleAbsolute, options, cb);
				};
				elToggle3.onclick = function() {
					var cb, options = effectOptions('inline', 600, elEffect1, elEffect2, elEffectDirectX, elEase, elFPS);
					if (options.effects || options.directXTrans) {
						options.effectParams = options.effectParams || {};
						cb = function() { elToggle3.disabled = false; };
						this.disabled = true;
					}
					api.toggleElement(elToggleImage, options, cb);
				};
				elToggle4.onclick = function() {
					var cb = [];
					if ((api.effects && elEffect1 && elEffect1.selectedIndex) || (elEffectDirectX && elEffectDirectX.options[elEffectDirectX.selectedIndex].value)) {
						elToggle1.disabled = true;
						elToggle2.disabled = true;
						elToggle3.disabled = true;
						elToggle4.disabled = true;
						elToggle5.disabled = true;
						cb[0] = function() { elToggle1.disabled = false; elToggle4.disabled = false; };
						cb[1] = function() { elToggle2.disabled = false; };
						cb[2] = function() { elToggle3.disabled = false; };
						cb[3] = function() { elToggle5.disabled = false; };
					}
					api.toggleElement(elToggleStatic, effectOptions('block', 2200, elEffect1, elEffect2, elEffectDirectX, elEase, elFPS), cb[0]);
					api.toggleElement(elToggleAbsolute, effectOptions('block', 800, elEffect1, elEffect2, elEffectDirectX, elEase, elFPS), cb[1]);
					api.toggleElement(elToggleImage, effectOptions('inline', 600, elEffect1, elEffect2, elEffectDirectX, elEase, elFPS), cb[2]);
					if (api.fixElement) { api.toggleElement(elToggleFixed, effectOptions('block', 800, elEffect1, elEffect2, elEffectDirectX, elEase, elFPS), cb[3]); }
				};
				elToggle5.onclick = function() {
					var cb, options = effectOptions('block', 800, elEffect1, elEffect2, elEffectDirectX, elEase, elFPS);
					if (options.effects) {
						cb = function() { elToggle5.disabled = false; };
						this.disabled = true;
					}
					api.toggleElement(elToggleFixed, options, cb);
				};
	                        global.onunload = (function(oldOnunload) {
					return function() {
						elToggle1.onclick = null;
						elToggle2.onclick = null;
						elToggle3.onclick = null;
						elToggle4.onclick = null;
						elToggle5.onclick = null;
						if (elEffect1) {
							elEffect1.onchange = null;
						}
						if (elEffectDirectX) {
							elEffectDirectX.onchange = null;
						}
						if (oldOnunload) { oldOnunload(); }
					};
        	                })(global.onunload);
			}
		}
<%End If%>
<%If bAudio Then%>
		var elStop, elVolume;

		function soundCallback() {
			if (elStop && !api.isPlayingAudio()) { elStop.disabled = true; }
		}

		function stopSound() {
			api.stopAudio();
			elStop.disabled = true;
		}

		function adjustVolume() {
			api.adjustVolume(elVolume.value);
		}

		if (api.playAudio && getEBI) {
			elVolume = getEBI('volume');

			// Only IE supports preload and volume
			// MP3's stream with some plugins in non-IE browsers (preloading isn't necessary)
			if (api.preloadAudio) {
				api.preloadAudio('audio/thunder.wav');
				api.preloadAudio('audio/bach.mid');
				api.preloadAudio('audio/free.mp3');
				if (elVolume) {
					var elVolumeLabel = getEBI('volumeLabel');
					if (elVolumeLabel) { elVolumeLabel.disabled = false; }
					elVolume.disabled = false;
					elVolume.onchange = adjustVolume;
				}
			}

			el = getEBI('play');
			elStop = getEBI('stop');
			if (elStop && elVolume) {
				if (el && api.audioFileTypeSupported('wav')) {
					el.onclick = function() { api.playAudio('audio/thunder.wav', 5000, soundCallback, null, elVolume.value); elStop.disabled = false; };
					el.disabled = false;
				}
				el = getEBI('playMusic');
				if (el && api.audioFileTypeSupported('mid')) {
					el.onclick = function() { api.playAudio('audio/bach.mid', 30000, soundCallback, null, elVolume.value); elStop.disabled = false; };
					el.disabled = false;
				}
				el = getEBI('playMusicMP3');
				if (el && api.audioFileTypeSupported('mp3')) {
					el.onclick = function() { api.playAudio('http://www.cinsoft.net/audio/free.mp3', 30000, soundCallback, null, elVolume.value); elStop.disabled = false; };
					el.disabled = false;
				}
				elStop.onclick = stopSound;
				el = null;

	                        global.onunload = (function(oldOnunload) {
 					return function() {
						elStop.onclick = null;
						elVolume.onchange = null;
						if (oldOnunload) { oldOnunload(); }
					};
        	                })(global.onunload);
			}
		}
<%End If%>
<%If bStyle Then%>
		if (api.getComputedStyle && getEBI && myalert) {
			el = api.getHtmlElement();
			if (el) {
				el = getEBI('computebgcolor');
				if (el) {
					el.onclick = function() {
						myalert(api.getComputedStyle(api.getHtmlElement(), 'backgroundColor') || 'Cannot compute', this, 'Style');
					};
					el.disabled = false;
				}
				el = getEBI('computefontsize');
				if (el) {
					el.onclick = function() {
						myalert(api.getComputedStyle(api.getHtmlElement(), 'fontSize') || 'Cannot compute', this, 'Style');
					};
					el.disabled = false;
				}
				el = null;
<%If bDOM Then%>
				el = api.getBodyElement();
				if (el) {
					el = getEBI('computeborderwidth');
					if (el) {
						el.onclick = function() {
							myalert(api.getComputedStyle(api.getBodyElement(), 'borderTopWidth') || 'Cannot compute', this, 'Style');
						};
						el.disabled = false;
					}
				}
				el = null;
<%End If%>
			}
		}

		if (api.getCascadedStyle && getEBI && myalert) {
			el = api.getHtmlElement();
			if (el) {
				el = getEBI('cascadebgcolor');
				if (el) {
					el.onclick = function() {
						myalert(api.getCascadedStyle(api.getHtmlElement(), 'backgroundColor'), this, 'Style');
					};
					el.disabled = false;
				}
				el = getEBI('cascadefontsize');
				if (el) {
					el.onclick = function() {
						myalert(api.getCascadedStyle(api.getHtmlElement(), 'fontSize'), this, 'Style');
					};
					el.disabled = false;
				}
				el = null;
<%If bDOM Then%>
				el = api.getBodyElement();
				if (el) {
					el = getEBI('cascadeborderwidth');
					if (el) {
						el.onclick = function() {
							myalert(api.getCascadedStyle(api.getBodyElement(), 'borderTopWidth'), this, 'Style');
						};
						el.disabled = false;
					}
				}
				el = null;
<%End If%>
			}
		}

		if (api.getComputedStyle && getEBI && myalert) {
			el = api.getHtmlElement();
			if (el) {
				el = getEBI('normalbgcolor');
				if (el) {
					el.onclick = function() {
						myalert(api.getStyle(api.getHtmlElement(), 'backgroundColor') || 'Cannot compute.', this, 'Style');
					};
					el.disabled = false;
				}
			}
		}
<%End If%>
<%If bClass Then%>
		if (api.addClass && getEBI) {
			el = getEBI('testclass');
			if (el) {
				el = getEBI('addclass');
				if (el) {
					el.onclick = function() { api.addClass(getEBI('testclass'), 'testclass'); var el = getEBI('removeclass'); this.disabled = true; if (el) { el.disabled = false; } };
					el.disabled = false;
				}

				el = getEBI('removeclass');
				if (el) {
					el.onclick = function() { api.removeClass(getEBI('testclass'), 'testclass'); var el = getEBI('addclass'); this.disabled = true; if (el) { el.disabled = false; } };
				}

				el = getEBI('hasclass');
				if (el && myalert) {
					el.onclick = function() { myalert((api.hasClass(getEBI('testclass'), 'testclass'))?'Yes':'No', this, 'Class'); };
					el.disabled = false;
				}
				el = null;
			}
		}
<%End If%>
<%If bAjax Then%>		
		if (api.createXmlHttpRequest && getEBI) {
			if (myalert) {
				el = getEBI('createxhr');
				if (el) {
					el.onclick = function() { var xhr = api.createXmlHttpRequest(); myalert(xhr?'Created':'Failed to create', this, 'Ajax', (xhr)?null:'stop'); };
					el.disabled = false;
					el = null;
				}
			}
			addUnitTest('Ajax', function() { return !!(api.createXmlHttpRequest()); }, true);
		}
<%End If%>
<%If bBookmark Then%>
		if (api.addBookmark && getEBI) {
			if (api.addBookmarkCurrent) {
				el = getEBI('bookmark');
				if (el) {
					el.onclick = function() { api.addBookmarkCurrent(); };
					el.disabled = false;
				}
			}
			el = getEBI('bookmarkGoogle');
			if (el) {
				el.onclick = function() { api.addBookmark('http://www.google.com', 'Google'); };
				el.disabled = false;
			}
			el = null;
		}
<%End If%>
<%If bCookie Then%>
		if (api.cookiesEnabled && getEBI && myalert) {
			el = getEBI('testcookies');
			if (el) {
				el.onclick = function() { myalert('Cookies are ' + ((api.cookiesEnabled())?'en':'dis') + 'abled.', this, 'Cookie'); };
				el.disabled = false;
				el = null;
			}
		}
<%End If%>
<%If bDOM Then%>
		if (api.getEBTN && getEBI) {
			if (myalert) {
				el = getEBI('countheadlines');
				if (el) {
					el.onclick = function() {
						var coll = api.getEBTN('h2');
						myalert('Counted ' + coll.length + ' h2 element' + (coll.length > 1 ? 's' : ''), this, 'DOM');
					};
					el.disabled = false;
					el = null;
				}
				el = getEBI('countheadlines2');
				if (el) {
					el.onclick = function() {
						var coll = api.getEBTN('h1');
						myalert('Counted ' + coll.length + ' h1 element' + (coll.length > 1 ? 's' : ''), this, 'DOM');
					};
					el.disabled = false;
					el = null;
				}
			}
			addUnitTest('Count Top Headline', function() { var coll = api.getEBTN('h1'); return coll.length == 1 }, true);
		}
		if (getEBI) {
			if (myalert) {
				el = getEBI('findelement');
				if (el) {
					el.onclick = function() {
						var elHeadline = api.getEBI('topheadline');
						myalert(elHeadline ? 'Found it' : 'Did not find', this, 'DOM', elHeadline ? null : 'stop');
					};
					el.disabled = false;
					el = null;
				}
			}
			addUnitTest('Find Top Headline', function() { var el = api.getEBI('topheadline'); return !!el }, true);
		}
<%If bQuery Then%>
		if (api.getEBCS && getEBI) {
			if (myalert) {
				el = getEBI('querycountheadlines');
				if (el) {
					el.onclick = function() {
						var coll = api.getEBCS('h2');
						myalert('Counted ' + coll.length + ' h2 element' + (coll.length > 1 ? 's' : ''), this, 'Query');
					};
					el.disabled = false;
					el = null;
				}
				el = getEBI('querycountheadlines2');
				if (el) {
					el.onclick = function() {
						var coll = api.getEBCS('h1');
						myalert('Counted ' + coll.length + ' h1 element' + (coll.length > 1 ? 's' : ''), this, 'Query');
					};
					el.disabled = false;
					el = null;
				}

				el = getEBI('queryfindelement');
				if (el) {
					el.onclick = function() {
						var elHeadline = api.getEBCS('#topheadline');
						myalert(elHeadline ? 'Found it' : 'Did not find', this, 'Query', elHeadline ? null : 'stop');
					};
					el.disabled = false;
					el = null;
				}
			}
			addUnitTest('Query Count Top Headline', function() { return api.getEBCS('h1').length == api.getEBTN('h1').length; }, true);
			addUnitTest('Query Count Secondary Headlines', function() { return api.getEBCS('h2').length == api.getEBTN('h2').length; }, true);
			addUnitTest('Query Find Element', function() { var el = api.getEBCS('#topheadline'); return !!el }, true);
		}
<%End If%>
<%End If%>
<%If bEvent Then%>
		if (api.attachListener && getEBI && myalert) {
			el = getEBI('clickevent');
			if (el) {
				api.attachListener(el, 'click', function() { myalert('Clicked', this, 'Event'); });
				el.disabled = false;
				el = null;
			}
		}

<%If bContextClick Then%>
		if (api.attachContextClickListener && getEBI && myalert) {
			el = getEBI('contextclickevent');
			if (el) {
				api.attachContextClickListener(el, function() { myalert('Context clicked', this, 'Event'); });
				el = null;
			}
		}
<%End If%>
<%If bHelp Then%>
		if (api.attachHelpListener && getEBI && myalert) {
			el = getEBI('helpevent');
			if (el) {
				api.attachHelpListener(el, function() { myalert('Help key pressed', null, 'Event'); });
				el = null;
			}
		} else {
			el = getEBI('helpevent');
			if (el) {
				el.title = 'Help features are absent';
				if (el.style) {
					el.style.textDecoration = 'line-through';
					el.style.color = '#666666';
				}
				el = null;
			}
		}
<%End If%>
<%If bMousewheel Then%>
		if (api.attachMousewheelListener && getEBI && myalert) {
			el = getEBI('mousewheelevent');
			if (el) {
				api.attachMousewheelListener(el, function(e, delta) { myalert('Mousewheel delta: ' + delta, this, 'Event'); });
				el = null;
			}
		} else {
			el = getEBI('mousewheelevent');
			if (el) {
				el.title = 'Mousewheel features are absent';
				if (el.style) {
					el.style.textDecoration = 'line-through';
					el.style.color = '#666666';
				}
				el = null;
			}
		}
<%End If%>
<%If bRollover Then%>
		if (api.attachRolloverListeners && getEBI) {
			el = getEBI('rolloverevent');
			if (el) {
				api.attachRolloverListeners(el, function() { this.value = 'Over'; }, function() { this.value = 'Out'; }, null, true, true);
				el = null;
			}
		} else {
			el = getEBI('rolloverevent');
			if (el) {
				el.title = 'Rollover features are absent';
				if (el.style) {
					el.style.textDecoration = 'line-through';
					el.style.color = '#666666';
				}
				el = null;
			}
		}
<%End If%>
<%If bMousePosition Then%>
		var elMousePositionReport, elMousePositionStart, elMousePositionStop;

		function reportMousePosition(e) {
			var pos = api.getMousePosition(e); // Pass document node as second parameter to speed up
			elMousePositionReport.value = (pos)?[pos[0], ', ', pos[1]].join(''):'Unavailable';
		}

		if (api.getMousePosition && api.attachDocumentListener && getEBI) {
			elMousePositionReport = getEBI('mousepositionreport');
			elMousePositionStart = getEBI('mousepositionstart');
			elMousePositionStop = getEBI('mousepositionstop');

			if (elMousePositionReport && elMousePositionStart && elMousePositionStop) {
				elMousePositionStart.disabled = false;
				elMousePositionStart.onclick = function() {
                                        api.attachDocumentListener('mousemove', reportMousePosition);
					elMousePositionStop.disabled = false;
					elMousePositionStart.disabled = true;
				};

				elMousePositionStop.onclick = function() {
                                        api.detachDocumentListener('mousemove', reportMousePosition);
					elMousePositionStop.disabled = true;
					elMousePositionStart.disabled = false;
					elMousePositionReport.value = 'Click Report button to start';
				};

				global.onunload = (function(oldOnunload) {
					return function() {
						elMousePositionStart.onclick = null;
						elMousePositionStop.onclick = null;
						if (oldOnunload) { oldOnunload(); }
					};
				})(global.onunload);
			}

		}
<%End If%>

<%End If%>
<%If bOpacity Then%>
		if (getEBI) {
			el = getEBI('testopacity');
			if (el) {
				if (api.setOpacity) {		
					api.setOpacity(el, 0.5);
				} else {
					el.title = 'Opacity features are absent';
					if (el.style) {
						el.style.textDecoration = 'line-through';
						el.style.color = '#666666';
					}
				}
				el = null;
			}
		}
<%End If%>
<%If bScript Then%>
		if (api.addScript && getEBI && isHostMethod(global, 'alert')) {
			el = getEBI('addscript');
			if (el) {
				el.onclick = function(e, delta) { api.addScript("global.alert('Script added');"); };
				el.disabled = false;
				el = null;
			}
		}
<%End If%>
	});
}
<%If bXHTML And Not bAsHTML Then%>]]><%End If%>
</script>
</head>
<body>
<%If bStyleSheets Then%>
<script type="text/javascript">
<%If bXHTML And Not bAsHTML Then%><![CDATA[<%End If%>
if (this.API) {
	if (this.API.addStyleRule) {
               if (this.API.addStyleRule('p.test', 'color:#FF0000', 'all') === false && this.API.attachDocumentReadyListener) {
			this.API.attachDocumentReadyListener(function() {
				if (API.getEBI) {
					var el = API.getEBI('teststylesheet');
	                                if (el) {
						if (el.style) {
							el.style.textDecoration = 'line-through';
							el.style.color = '#666666';
						}
						el.title = 'Add style rule feature is absent';
						el = null;
                        	        }
	                        }
                        });
		}
<%If bPresent Then%>
		if (this.API.canAdjustStyle && this.API.canAdjustStyle('display')) { this.API.addStyleRule('#toggle1', 'display:none', 'all'); }
<%End If%>
	} else {
                        if (this.API.attachDocumentReadyListener) {
			this.API.attachDocumentReadyListener(function() {
				if (API.getEBI) {
					var el = API.getEBI('teststylesheet');
	                                if (el) {
						if (el.style) {
							el.style.textDecoration = 'line-through';
							el.style.color = '#666666';
						}
						el.title = 'Add style rule feature is absent';
						el = null;
                        	        }
	                        }
                        });
                        }
	}
}
<%If bXHTML And Not bAsHTML Then%>]]><%End If%>
</script>
<%End If%>
<h1 id="topheadline"><span class="redundant">My Library </span>Build Test (<%If bXHTML Then%>X<%End If%>HTML<%If bAsHTML Then%> as HTML<%End If%>)</h1>
<div class="seealso"><ul><li><a href="mylib-builder.asp?action=edit&amp;<%=sQuery%>">Edit Build</a></li><li><a href="mylib-build.asp?action=Build&amp;<%=sQuery%>">Download</a></li></ul></div>
<p>The first indicator of a successful build is the lack of a script error.</p>
<%If Not bDOM Then%>
<p><a href="mylib-test.asp?<%=sQuery%>dom=on&amp;layout=<%=Request.QueryString("layout")%>&amp;mode=<%=Request.QueryString("mode")%>">Including the DOM module</a> will provide a console.</p>
<%End If%>
<%If Not bXHTML Or bAsHTML Then%>
<%If bQuirks Then%>
<p>Testing <em>quirks mode</em> layout. <a href="mylib-test.asp?<%=sQuery%>mode=<%=Request.QueryString("mode")%>">Test in <em>standards mode</em></a>.</p>
<%Else%>
<p>Testing <em>standards mode</em> layout. <a href="mylib-test.asp?<%=sQuery%>layout=quirks&amp;mode=<%=Request.QueryString("mode")%>">Test in <em>quirks mode</em></a>.</p>
<%End If%>
<%End If%>
<%If Not bXHTMLSupport And bXHTML And Not bAsHtml Then%>
<p class="stopnote">Testing XHTML but XHTML support is not present in the build.</p>
<%End If%>
<noscript><p class="stopnote">Scripting is required to test your library.</p></noscript>
<p>If all is well, <a href="mylib-build.asp?action=Build&amp;<%=sQuery%>">download</a> your library. If you encounter an error, please report it to the <a href="mailto:dmark@cinsoft.net">author</a>.</p>
<%If bAjax Then%>
<h2 class="test"><a name="ajax" id="ajax">Ajax</a></h2>
<p>Test the creation of an XHR object.</p>
<fieldset class="test">
<legend>Test</legend>
<input id="createxhr" type="button" value="Create" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>

<%If bRequester Then%>
<h3 class="test">Requester</h3>
<p>Test Ajax requests.</p>
<fieldset class="test">
<legend>Test</legend>
<input type="button" id="requesthtml" value="HTML" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input type="button" value="XHTML" id="requestxhtml" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input type="button" id="requestxml" value="XML" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input type="button" id="requestjson" value="JSON" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>

<%If bUpdater Then%>
<h3 class="test">Updater</h3>
<p>Test Ajax updates. Clicking the clock that appears should result in a test alert.</p>

<%
If (bXHTML And Not bAsHTML) And (Not bSetAttribute Or Not bImport) Then
	WriteCard GOCARD, "support XHTML", "Set Attribute,Import"
End If
%>

<%
If (bXHTML And Not bAsHTML) And bImport Then
	WriteCard CAUTIONCARD, "Updates to <code>XHTML</code> documents typically work with <code>XML</code> and <code>XHTML</code> responses, but not <code>HTML</code>. An <code>HTML</code> fragment will not be imported into an <code>XHTML</code> document.", ""
End If
%>

<div id="testupdate" class="htmlchange">This element will change.</div>
<fieldset class="test">
<legend>Test</legend>
<%If (bFX And bShow And bOverlay) Or bDirectX Then%>
<fieldset><legend>Effects</legend>
<label for="effect1U" class="disabled" id="effect1Ulabel">Effect #1:</label><select id="effect1U" disabled="disabled"><option>[None]</option></select><label for="effect2U" class="disabled" id="effect2Ulabel">Effect #2:</label><select id="effect2U" disabled="disabled"></select>
<%If bDirectX Then%>
<label for="effectdirectxU" class="disabled" id="effectdirectxUlabel">DirectX:</label><select id="effectdirectxU" disabled="disabled">
<option value="">[None]</option>
<option value="Barn">Barn</option>
<option value="Blinds">Blinds</option>
<option value="Checkerboard">Checkerboard</option>
<option value="Fade">Fade</option>
<option value="GradientWipe">Gradient Wipe</option>
<option value="Inset">Inset</option>
<option value="Iris">Iris</option>
<option value="Pixelate">Pixelate</option>
<option value="RadialWipe">Radial Wipe</option>
<option value="RandomBars">Random Bars</option>
<option value="RandomDissolve">Random Dissolve</option>
<option value="Slide">Slide</option>
<option value="Spiral">Spiral</option>
<option value="Stretch">Stretch</option>
<option value="Strips">Strips</option>
<option value="Wheel">Wheel</option>
<option value="ZigZag">Zig Zag</option>
</select>
<%End If%>
<fieldset id="effectoptionsU" class="disabled"><legend>Options</legend>
<%If bFX Then%><label for="easeU" class="disabled" id="easeUlabel">Easing:</label><select id="easeU" disabled="disabled"><option value="">[None]</option></select><%End If%><label for="fpsU" class="disabled" id="fpsUlabel">FPS:</label><select id="fpsU" disabled="disabled"><option value="5">5</option><option value="10">10</option><option value="20">20</option><option value="30">30</option><option value="40">40</option><option value="50">50</option><option value="60" selected="selected">60</option></select>
</fieldset>
</fieldset>
<%End If%>
<input type="button" id="updatehtml" value="HTML" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input type="button" value="XHTML" id="updatexhtml" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input type="button" id="updatexml" value="XML" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%End If%>
<%If bBookmark Then%>
<h2 class="test"><a name="bookmarks" id="bookmarks">Bookmark</a></h2>
<p>The bookmark methods work only in IE and Mozilla-based browsers.</p>
<fieldset class="test">
<legend>Test</legend>
<input id="bookmark" type="button" value="Bookmark Page" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="bookmarkGoogle" type="button" value="Bookmark Google" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%If bCookie Then%>
<h2 class="test"><a name="cookie" id="cookie">Cookie</a></h2>
<p>Test whether cookies are enabled.</p>

<%
	WriteCard CAUTIONCARD, "The result is cached until the next page load", ""
%>

<fieldset class="test">
<legend>Test</legend>
<input id="testcookies" type="button" value="Test Cookies" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%If bDOM Then%>
<h2 class="test"><a name="dom" id="dom">DOM</a></h2>
<p>Count elements.</p>
<fieldset class="test">
<legend>Test</legend>
<input id="countheadlines" type="button" value="Count H2" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="countheadlines2" type="button" value="Count H1" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>

<p>Find <code>h1</code> element.</p>
<fieldset class="test">
<legend>Test</legend>
<input id="findelement" type="button" value="Find" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>


<%If bScript Then%>
<h3 class="test"><a name="script" id="script">Script</a></h3>
<p>Test adding script.</p>
<fieldset class="test">
<legend>Test</legend>
<input id="addscript" type="button" value="Add" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%If bStyleSheets Then%>
<h3 class="test"><a name="stylesheet" id="stylesheet">Style Sheet</a></h3>
<p class="test" id="teststylesheet">This text should be red.</p>
<%End If%>
<%If bQuery Then%>

<%
If (bObjects And (bForm Or bImage) And Not bCollections) Then
	WriteCard GOCARD, "add the form and image wrapper objects", "Collections"
End If
%>


<h3 class="test">Query</h3>
<%
	WriteCard SUGGESTIONCARD, "To compare the performance of various queries, see the <a href=""mylib-testspeed.html"" class=""external"">speed test</a>", ""
%>
<p>Compare the query results with the <a href="#dom">DOM tests</a>.</p>
<fieldset class="test">
<legend>Test</legend>
<input id="querycountheadlines" type="button" value="Count H2" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="querycountheadlines2" type="button" value="Count H1" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="queryfindelement" type="button" value="Find H1" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%End If%>
<%If bDrag Then%>

<h2 class="test">Drag and Drop</h2>
<%
If Not bOpacity Then
	WriteCard GOCARD, "add the ghost option", "Opacity"
End If
%>
<div><img id="drag1" src="images/cdchanger.gif" alt="" height="48" width="48"<%If bXHTML Then%> /<%End If%>></div>
<h3 class="test">Basic</h3>
<p>Drag to move the image.</p>

<div><img id="drag2" src="images/receiver.gif" alt="" height="48" width="48"<%If bXHTML Then%> /<%End If%>></div>
<h3 class="test">Horizontal Axis</h3>
<p>The image only moves horizontally.</p>

<%If bViewport Then%>
<div><img id="drag3" src="images/tv1.gif" alt="" height="48" width="48"<%If bXHTML Then%> /<%End If%>></div>
<h3 class="test">Constrained</h3>
<p>The image position is constrained by the viewport.</p>
<%End If%>

<%If bOffset And bSize Then%>
<h3 class="test">Static Position</h3>
<p>The image is positioned on drag.</p>
<div><img id="drag4" src="images/tv2.gif" alt="" height="48" width="48"<%If bXHTML Then%> /<%End If%>></div>
<%End If%>

<%If bSize Then%>
<h3 class="test">Size</h3>
<p>Drag to size the image</p>
<div><img id="drag6" src="images/tv1.gif" alt="" height="48" width="48"<%If bXHTML Then%> /<%End If%>></div>
<%End If%>

<h3 class="test">Scroll</h3>
<p>Drag to scroll the image</p>
<div id="drag7"><img src="images/cinsoft.gif" alt="" height="332" width="244"<%If bXHTML Then%> /<%End If%>></div>

<%If bOffset Then%>
<div><img id="drag8" src="images/tv1.gif" alt="" height="48" width="48"<%If bXHTML Then%> /<%End If%>></div>
<h3 class="test">Drop Target</h3>
<p>Drag the image over the drop target.</p>
<fieldset id="droptarget">
<legend>Drop Target</legend>
<input class="test" value="Drag image to start" id="dropreport" readonly="readonly"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%If bSize Then%>
<h3 class="test">Handles<%If bDispatch Then%> and Initiation<%End If%></h3>
<p>Drag the handles to move or size the box.<%If bDispatch Then%> Alternatively, click the <em>Move</em> or <em>Size</em> button. Drag operations can be controlled by keyboard or mouse.<%End If%></p>
<%
If Not bDispatch Then
	WriteCard GOCARD, "support drag initiation", "Dispatch"
End If

If Not bBorder Then
	WriteCard GOCARD, "ensure consistent cross-browser positioning", "Border"
End If
%>

<div id="drag5"><div id="movehandle"></div><fieldset><legend>Menu</legend><input type="button" id="initiatemove" disabled="disabled" value="Move"<%If bXHTML Then%> /<%End If%>><input type="button" id="initiatesize" disabled="disabled" value="Size"<%If bXHTML Then%> /<%End If%>><input type="button" id="absolutedrag" disabled="disabled" value="Float"<%If bXHTML Then%> /<%End If%>><input type="button" id="fixdrag" disabled="disabled" value="Fix"<%If bXHTML Then%> /<%End If%>><input type="button" id="centerdrag" disabled="disabled" value="Center"<%If bXHTML Then%> /<%End If%>><input type="button" id="maximizedrag" disabled="disabled" value="Maximize"<%If bXHTML Then%> /<%End If%>><input type="button" id="fullscreendrag" disabled="disabled" value="Full Screen"<%If bXHTML Then%> /<%End If%>></fieldset><div id="sizehandle"></div></div>
<%End If%>

<%End If%>
<%If bEvent Then%>
<h2 class="test"><a name="events" id="events">Event</a></h2>
<p>Test click event.</p>
<fieldset class="test">
<legend>Test</legend>
<input id="clickevent" type="button" value="Click Me" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%If bContextClick Then%>
<h3 class="test"><a name="contextclick" id="contextclick">Context Click</a></h3>
<p id="contextclickevent">Click this text with the context button.</p>

<%
	WriteCard CAUTIONCARD, "Some browsers (e.g. Opera) cannot cancel the default context action (typically a popup menu.) Other browsers (e.g. Firefox) may execute the default action if the test alert is dismissed with the pointing device", ""
%>

<%End If%>
<%If bHelp Then%>
<h3 class="test"><a name="help" id="help">Help</a></h3>
<p>Test the help event.</p>

<%
	WriteCard CAUTIONCARD, "Some browsers (e.g. Opera) cannot cancel the default help action", ""
%>

<fieldset class="test">
<legend>Test</legend>
<input id="helpevent" class="test" value="Focus and press the help key" readonly="readonly"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%If bMousewheel Then%>
<h3 class="test"><a name="mousewheel" id="mousewheel">Mousewheel</a></h3>
<p id="mousewheelevent">Roll the mousewheel over this text.</p>
<%End If%>
<%If bRollover Then%>
<h3 class="test"><a name="rollover" id="rollover">Rollover</a></h3>
<p>Test the rollover events.</p>
<fieldset class="test">
<legend>Test</legend>
<input id="rolloverevent" title="Test rollover listeners" value="Focus or roll over" readonly="readonly"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%If bMousePosition Then%>
<h3 class="test">Mouse Position</h3>
<p>Test mouse position.</p>
<%
If Not bScroll Then
	WriteCard GOCARD, "support cross-browser mouse position reporting (some browsers will work without it)", "Scroll"
End If
%>
<fieldset class="test">
<legend>Test</legend>
<input class="test" id="mousepositionreport" value="Click Report button to start"<%If bXHTML Then%> /<%End If%>>
<input type="button" id="mousepositionstart" value="Report" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input type="button" value="Stop" id="mousepositionstop" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%End If%>
<%If bHTML Then%>
<h2 class="test">HTML</h2>
<p>Test setting inner <code>HTML</code>.</p>

<%
If bXHTML And Not bAsHTML Then
	WriteCard CAUTIONCARD, "This test typically fails in XHTML mode", ""

	If (Not bSetAttribute Or Not bImport) Then
		WriteCard GOCARD, "provide an alternate method for updates", "Import,Set Attribute"
	End If
End If
%>

<%
If bDirectX Then
	WriteCardForIE CAUTIONCARD, "Some of the DirectX effects do not work properly with the <code>select</code> element", ""
End If
%>

<%
If bFX And bShow And bOverlay And Not bBorder Then
	WriteCard GOCARD, "get the most consistent cross-browser results with bordered elements", "Border"
End If
%>

<div id="htmlchange" class="htmlchange">This element will change.</div>
<div><select id="htmlchangeselect" class="htmlchangeselect"><option>SELECT element</option></select></div>
<fieldset class="test">
<legend>test</legend>
<%If (bFX And bShow And bOverlay) Or bDirectX Then%>
<fieldset><legend>Effects</legend>
<label for="effect1H" class="disabled" id="effect1Hlabel">Effect #1:</label><select id="effect1H" disabled="disabled"><option>[None]</option></select><label for="effect2H" class="disabled" id="effect2Hlabel">Effect #2:</label><select id="effect2H" disabled="disabled"></select>
<%If bDirectX Then%>
<label for="effectdirectxH" class="disabled" id="effectdirectxHlabel">DirectX:</label><select id="effectdirectxH" disabled="disabled">
<option value="">[None]</option>
<option value="Barn">Barn</option>
<option value="Blinds">Blinds</option>
<option value="Checkerboard">Checkerboard</option>
<option value="Fade">Fade</option>
<option value="GradientWipe">Gradient Wipe</option>
<option value="Inset">Inset</option>
<option value="Iris">Iris</option>
<option value="Pixelate">Pixelate</option>
<option value="RadialWipe">Radial Wipe</option>
<option value="RandomBars">Random Bars</option>
<option value="RandomDissolve">Random Dissolve</option>
<option value="Slide">Slide</option>
<option value="Spiral">Spiral</option>
<option value="Stretch">Stretch</option>
<option value="Strips">Strips</option>
<option value="Wheel">Wheel</option>
<option value="ZigZag">Zig Zag</option>
</select>
<%End If%>
<fieldset id="effectoptionsH" class="disabled"><legend>Options</legend>
<%If bFX Then%><label for="easeH" class="disabled" id="easeHlabel">Easing:</label><select id="easeH" disabled="disabled"><option value="">[None]</option></select><%End If%><label for="fpsH" class="disabled" id="fpsHlabel">FPS:</label><select id="fpsH" disabled="disabled"><option value="5">5</option><option value="10">10</option><option value="20">20</option><option value="30">30</option><option value="40">40</option><option value="50">50</option><option value="60" selected="selected">60</option></select>
</fieldset>
</fieldset>
<%End If%>
<input id="changehtml" type="button" value="Change DIV" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="changehtmlselect" type="button" value="Change SELECT" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>

<%If bGetHTML Then%>
<h3 class="test">Get</h3>
<p>Test getting inner and outer <code>HTML</code>.</p>
<fieldset class="test">
<legend>Test</legend>
<fieldset>
<legend>Report</legend>
<textarea id="htmlreport" readonly="readonly" rows="10" cols="80"></textarea>
</fieldset>
<fieldset><legend>Options</legend>
<input type="checkbox" id="xhtml" disabled="disabled"<%If bXHTML Then%> /<%End If%>><label for="xhtml" id="xhtmllabel" class="disabled">XHTML</label><input type="checkbox" id="nativehtml" disabled="disabled"<%If bXHTML Then%> /<%End If%>><label for="nativehtml" id="nativehtmllabel" class="disabled">Use native properties (when available)</label>
</fieldset>
<input id="getinnerhtml" value="Get Inner" type="button" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="getouterhtml" value="Get Outer" type="button" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%End If%>
<%If bImage Then%>
<h2 class="test">Image</h2>
<p>Test changing images.</p>

<%
If Not bPreload Then
	WriteCard GOCARD, "preload the alternate image", "Preload"
End If
%>

<div><img id="imagechange" src="images/painting1.jpg" alt="" height="194" width="297"<%If bXHTML Then%> /<%End If%>></div>
<fieldset class="test">
<legend>Test</legend>
<%If (bFX And bShow And bOverlay) Or bDirectX Then%>
<fieldset><legend>Effects</legend>
<label for="effect1I" class="disabled" id="effect1Ilabel">Effect #1:</label><select id="effect1I" disabled="disabled"><option>[None]</option></select><label for="effect2I" class="disabled" id="effect2Ilabel">Effect #2:</label><select id="effect2I" disabled="disabled"></select>
<%If bDirectX Then%>
<label for="effectdirectxI" class="disabled" id="effectdirectxIlabel">DirectX:</label><select id="effectdirectxI" disabled="disabled">
<option value="">[None]</option>
<option value="Barn">Barn</option>
<option value="Blinds">Blinds</option>
<option value="Checkerboard">Checkerboard</option>
<option value="Fade">Fade</option>
<option value="GradientWipe">Gradient Wipe</option>
<option value="Inset">Inset</option>
<option value="Iris">Iris</option>
<option value="Pixelate">Pixelate</option>
<option value="RadialWipe">Radial Wipe</option>
<option value="RandomBars">Random Bars</option>
<option value="RandomDissolve">Random Dissolve</option>
<option value="Slide">Slide</option>
<option value="Spiral">Spiral</option>
<option value="Stretch">Stretch</option>
<option value="Strips">Strips</option>
<option value="Wheel">Wheel</option>
<option value="ZigZag">Zig Zag</option>
</select>
<%End If%>
<fieldset id="effectoptionsI" class="disabled"><legend>Options</legend>
<%If bEase Then%><label for="easeI" class="disabled" id="easeIlabel">Easing:</label><select id="easeI" disabled="disabled"><option value="">[None]</option></select><%End If%><label for="fpsI" class="disabled" id="fpsIlabel">FPS:</label><select id="fpsI" disabled="disabled"><option value="5">5</option><option value="10">10</option><option value="20">20</option><option value="30">30</option><option value="40">40</option><option value="50">50</option><option value="60" selected="selected">60</option></select>
</fieldset>
</fieldset>
<%End If%>
<input id="changeimage" type="button" value="Change Image" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>


<%If bPlugin Then%>
<h2 class="test"><a name="plugin" id="plugin">Plugin</a></h2>
<%If bFlash Then%>
<h3 class="test"><a name="flash" id="flash">Flash</a></h3>
<p>This test attempts to create two Flash movies. The first is a simple animation that does not interact with the script, so its static fallbacks are the standard nested Flash objects and an image. When scripting is enabled, the Flash objects are replaced with the image if the required version of Flash is unavailable. Note that the Flash movie is replaced by a derived copy when Flash support is present (to avoid the "Click to activate" issue in IE and Opera.) When scripting is disabled, the image will be visible if plug-ins are disabled; otherwise, most browsers will prompt to download the Flash plugin. The second movie demonstrates adding parameters with script, so its static fallback is an empty <code>div</code>.</p>
<script type="text/javascript">
<%If bXHTML And Not bAsHTML Then%><![CDATA[<%End If%>
if (this.API && this.API.createFlash) {
	(function() {
		this.API.createFlash('http://www.cinsoft.net/flash/testflash_streaming.swf', 'flashFallback1', { height:120, width:300, menu:true, loop:true, quality:'high', swLiveConnect:false, allowScriptAccess:'Always', deviceFont:false, seamlessTabbing:true, title:'Star Wars movie', versionRequired:6 });
		var vars = new this.API.FlashVariables();
		//vars.addQuery('name1');
		//vars.addBookmark('name3');
		vars.add('name1', 'Test 1');
		vars.add('name2', 'Test 2');
		vars.add('name3', 'Test 3');
		this.API.createFlash('http://www.cinsoft.net/flash/testflash_vars.swf', 'flashFallback2', { height:120, width:300, variables:vars, versionRequired:6 });
	})();
}
<%If bXHTML And Not bAsHTML Then%>]]><%End If%>
</script>
<div>
<object id="flashFallback1" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="300" height="120" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" title="Star Wars toy movie">
<param name="movie" value="http://www.cinsoft.net/flash/testflash_streaming.swf"<%If bXHTML Then%> /<%End If%>>
<!-- #INCLUDE file="mylib-nestedobjects.inc" -->
</object>
<div id="flashFallback2"></div>
</div>
<%End If%>
<%If bAudio Then%>
<h3 class="test"><a name="audio" id="audio">Audio</a></h3>

<%
WriteCard CAUTIONCARD, "In browsers that use plug-ins for audio, the first file played may be delayed (and clipped) by the plug-in loading. This is because the <code>deferAudio</code> property has been set", ""

If Not bDOM Then
	If Not bXHTML Or bAsHTML Then
		WriteCardForIE GOCARD, "support IE", "DOM"
	End If
	If bXHTML And Not bAsHTML Then
		WriteCard GOCARD, "support XHTML agents that do not feature a <code>body</code> property of the <code>document</code> object", "DOM"
	End If
End If
%>

<fieldset class="test">
<legend>Test</legend>
<input id="play" type="button" value="Play Sound" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="playMusic" type="button" value="Play Music" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="playMusicMP3" type="button" value="Play Music (MP3)" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="stop" type="button" value="Stop" disabled="disabled"<%If bXHTML Then%> /<%End If%>><label id="volumeLabel" for="volume" class="disabled">Volume:</label><select id="volume" disabled="disabled"><option>0%</option><option value="10">10%</option><option value="20">20%</option><option value="30">30%</option><option value="40">40%</option><option value="50">50%</option><option value="60">60%</option><option value="70">70%</option><option value="80">80%</option><option value="90">90%</option><option value="100" selected="selected">100%</option></select>
</fieldset>
<%End If%>
<%End If%>
<%If bScroll Then%>
<h2 class="test">Scroll</h2>
<p>Test scrolling to the edges of the document.</p>

<%
If Not bViewport Then
	WriteCard GOCARD, "enable right and bottom edges (some browsers work without it)", "Viewport"
End If
%>

<%
If bScrollFX And Not bMousewheel Then
	WriteCard GOCARD, "enable interruption of the effect", "Event,Mousewheel"
End If
%>

<%
If Not bEase And bScrollFX Then
	WriteCard GOCARD, "improve the effects", "Ease"
End If

%>

<fieldset class="test">
<legend>Test</legend>
<%If bScrollFX Then%>
<fieldset><legend><input type="checkbox" id="scrolleffect" disabled="disabled"<%If bXHTML Then%> /<%End If%>><label for="scrolleffect" class="disabled" id="scrolleffectlabel">Effect</label></legend>
<%If bEase Then%><label for="scrollease" class="disabled" id="scrolleaselabel">Easing:</label><select id="scrollease" disabled="disabled"><option value="">[None]</option></select><%End If%>
</fieldset>
<%End If%>
<input id="scrolltop" type="button" value="Top" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
<input id="scrollleft" type="button" value="Left" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
<input id="scrollbottom" type="button" value="Bottom" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
<input id="scrollright" type="button" value="Right" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%If ((bCenter And bSize) Or bMaximize) And bScroll Then%>
<h2 class="test">Sidebars</h2>
<p>Sidebars are currently an <em>Easter Egg</em> feature as the dependencies have not been finalized.</p>
<%
If Not bShow Then
	WriteCard GOCARD, "add close buttons", "Show"
End If
If Not bRollover Then
	WriteCard GOCARD, "add auto-hide buttons", "Rollover"
End If
If Not bOffset Then
	WriteCard GOCARD, "to fix the position of the sidebars", "Offset,Event"
End If
%>
<fieldset class="test"><legend>Test</legend>
<input type="button" id="sidebartop" value="Top" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
<input type="button" id="sidebarleft" value="Left" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
<input type="button" id="sidebarbottom" value="Bottom" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
<input type="button" id="sidebarright" value="Right" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>



<%If bStyle Then%>
<h2 class="test">Style</h2>
<p>Test computed styles.</p>
<fieldset class="test">
<legend>Test</legend>
<input id="computebgcolor" type="button" value="HTML Background Color" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="computefontsize" type="button" value="HTML Font Size" disabled="disabled"<%If bXHTML Then%> /<%End If%>><%If bDOM Then%><input id="computeborderwidth" type="button" value="Body Border Width" disabled="disabled"<%If bXHTML Then%> /<%End If%>><%End If%>
</fieldset>
<p>Test cascaded styles.</p>
<%

WriteCardNotForIE CAUTIONCARD, "Cascaded style reporting is not typically found in non-IE browsers. Opera 9 has some level of support, but reported inconsistent (and often completely wrong) results in testing", ""

%>
<fieldset class="test">
<legend>Test</legend>
<input id="cascadebgcolor" type="button" value="HTML Background Color" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="cascadefontsize" type="button" value="HTML Font Size" disabled="disabled"<%If bXHTML Then%> /<%End If%>><%If bDOM Then%><input id="cascadeborderwidth" type="button" value="Body Border Width" disabled="disabled"<%If bXHTML Then%> /<%End If%>><%End If%>
</fieldset>
<p>Test normalized style.</p>
<fieldset class="test">
<legend>Test</legend>
<input id="normalbgcolor" type="button" value="HTML Background Color" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%If bClass Then%>
<h3 class="test"><a name="class" id="class">Class</a></h3>
<p id="testclass">This text should reflect the class changes.</p>
<fieldset class="test">
<legend>Test</legend>
<input id="addclass" type="button" value="Add Class" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="hasclass" type="button" value="Has Class" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="removeclass" type="button" value="Remove Class" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If%>
<%If bOpacity Then%>
<h3 class="test"><a name="opacity" id="opacity">Opacity</a></h3>
<p id="testopacity">This text should be 50% opaque.</p>
<%End If%>
<%If bShow Then%>
<div id="toggle4">Fixed Position</div>
<div id="toggle2">Absolute Position</div>
<div><img id="toggle3" src="images/dishwasher.gif" alt="" height="48" width="48"<%If bXHTML Then%> /<%End If%>></div>
<h3 class="test"><a name="show" id="show">Show</a></h3>
<div id="toggle1">Static Position</div>
<p>Test toggling elements.</p>

<%
If Not bPresent Then
	WriteCard GOCARD, "remove statically positioned elements on hide", "Present"
End If
%>


<%
If bFX And (Not bSize Or Not bPosition Or Not bOffset) Then
	WriteCard GOCARD, "enable additional effects", "Size,Offset,Position"
End If
%>

<fieldset class="test">
<legend>Test</legend>
<%If bFX Or bDirectX Then%>
<fieldset><legend>Effects</legend>
<label for="effect1" class="disabled" id="effect1label">Effect #1:</label><select id="effect1" disabled="disabled"><option>[None]</option></select><label for="effect2" class="disabled" id="effect2label">Effect #2:</label><select id="effect2" disabled="disabled"></select>
<%If bDirectX Then%>
<label for="effectdirectx" class="disabled" id="effectdirectxlabel">DirectX:</label><select id="effectdirectx" disabled="disabled">
<option value="">[None]</option>
<option value="Barn">Barn</option>
<option value="Blinds">Blinds</option>
<option value="Checkerboard">Checkerboard</option>
<option value="Fade">Fade</option>
<option value="GradientWipe">Gradient Wipe</option>
<option value="Inset">Inset</option>
<option value="Iris">Iris</option>
<option value="Pixelate">Pixelate</option>
<option value="RadialWipe">Radial Wipe</option>
<option value="RandomBars">Random Bars</option>
<option value="RandomDissolve">Random Dissolve</option>
<option value="Slide">Slide</option>
<option value="Spiral">Spiral</option>
<option value="Stretch">Stretch</option>
<option value="Strips">Strips</option>
<option value="Wheel">Wheel</option>
<option value="ZigZag">Zig Zag</option>
</select>
<%End If%>
<fieldset id="effectoptions" class="disabled"><legend>Options</legend>
<%If bEase Then%><label for="ease" class="disabled" id="easelabel">Easing:</label><select id="ease" disabled="disabled"><option value="">[None]</option></select><%End If%><label for="fps" class="disabled"  id="fpslabel">FPS:</label><select id="fps" disabled="disabled"><option value="5">5</option><option value="10">10</option><option value="20">20</option><option value="30">30</option><option value="40">40</option><option value="50">50</option><option value="60" selected="selected">60</option></select>
</fieldset>
</fieldset>
<%End If%>
<input id="toggleElement" type="button" value="Toggle Static" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="toggleElementAbsolute" type="button" value="Toggle Absolute" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="toggleElementFixed" type="button" value="Toggle Fixed" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="toggleElementImage" type="button" value="Toggle Image" disabled="disabled"<%If bXHTML Then%> /<%End If%>><input id="toggleElements" type="button" value="Toggle All" disabled="disabled"<%If bXHTML Then%> /<%End If%>>
</fieldset>
<%End If 'Show%>
<%End If 'Style%>
<%If (colCardTotals(GOCARD) > 0 Or colCardTotals(CAUTIONCARD) > 0 Or colCardTotals(STOPCARD) > 0 Or colCardTotals(SUGGESTIONCARD) > 0) And colCardTotals(GOCARD) - colCardTotalsIE(GOCARD) = 0 And colCardTotals(CAUTIONCARD) - colCardTotalsIE(CAUTIONCARD) = 0 And colCardTotals(STOPCARD) - colCardTotalsIE(STOPCARD) = 0 And colCardTotals(SUGGESTIONCARD) - colCardTotalsIE(SUGGESTIONCARD) = 0 Then%>
<!--[if IE]>
<h2 class="test">Key</h2><div id="key">
<![endif]-->
<%Else%>
<%If colCardTotals(GOCARD) - colCardTotalsNotIE(GOCARD) > 0 Or colCardTotals(CAUTIONCARD) - colCardTotalsNotIE(CAUTIONCARD) > 0 Or colCardTotals(STOPCARD) - colCardTotalsNotIE(STOPCARD) > 0 Or colCardTotals(SUGGESTIONCARD) - colCardTotalsNotIE(SUGGESTIONCARD) > 0 Then%>
<h2 class="test">Key</h2><div id="key">
<%Else%>
<%If colCardTotals(GOCARD) > 0 Or colCardTotals(CAUTIONCARD) > 0 Or colCardTotals(STOPCARD) > 0 Or colCardTotals(SUGGESTIONCARD) > 0 Then%>
<!--[if !IE]>-->
<h2 class="test">Key</h2><div id="key">
<!--<![endif]-->
<%End If%>
<%End If%>
<%End If%>
<%
Sub WriteCardTotals(lClass, sClass, sCaption)
%>

<%
If colCardTotals(lClass) - colCardTotalsNotIE(lClass) - colCardTotalsIEOld(lClass) - colCardTotalsIE7(lClass) > 0 Then
%>

<!--[if gt IE 7]>
<p class="<%=sClass%>note"><%=sCaption%> (<%=colCardTotals(lClass) - colCardTotalsNotIE(lClass) - colCardTotalsIEOld(lClass) - colCardTotalsIE7(lClass)%>)</p>
<![endif]-->
<%
End If
%>


<%
If colCardTotals(lClass) - colCardTotalsNotIE(lClass) - colCardTotalsIEOld(lClass) - colCardTotalsIENew(lClass) > 0 Then
%>
<!--[if IE 7]>
<p class="<%=sClass%>note"><%=sCaption%> (<%=colCardTotals(lClass) - colCardTotalsNotIE(lClass) - colCardTotalsIEOld(lClass) - colCardTotalsIENew(lClass)%>)</p>
<![endif]-->
<%
End If
%>

<%
If colCardTotals(lClass) - colCardTotalsNotIE(lClass) - colCardTotalsIE7(lClass) - colCardTotalsIENew(lClass) > 0 Then
%>
<!--[if lt IE 7]>
<p class="<%=sClass%>note"><%=sCaption%> (<%=colCardTotals(lClass) - colCardTotalsNotIE(lClass) - colCardTotalsIE7(lClass) - colCardTotalsIENew(lClass)%>)</p>
<![endif]-->
<%
End If
%>

<%
If colCardTotals(lClass) - colCardTotalsIE(lClass) > 0 Then
%>
<!--[if !IE]>-->
<p class="<%=sClass%>note"><%=sCaption%> (<%=colCardTotals(lClass) - colCardTotalsIE(lClass)%>)</p>
<!--<![endif]-->
<%
End If
%>

<%
End Sub

If colCardTotals(GOCARD) > 0 Then
	WriteCardTotals GOCARD, "go", "Compatibility"
End If
If colCardTotals(CAUTIONCARD) > 0 Then
	WriteCardTotals CAUTIONCARD, "caution", "Caution"
End If
If colCardTotals(STOPCARD) > 0 Then
	WriteCardTotals STOPCARD, "stop", "Problem"
End If
If colCardTotals(SUGGESTIONCARD) > 0 Then
	WriteCardTotals SUGGESTIONCARD, "suggestion", "Suggestion"
End If
%>
<%
If colCardTotals(GOCARD) > 0 Or colCardTotals(CAUTIONCARD) > 0 Or colCardTotals(STOPCARD) > 0 Or colCardTotals(SUGGESTIONCARD) > 0 Then
%>
</div>
<%
End If
%>
<%If bDOM And Request.QueryString("mode") <> "XHTML" Then%>
<script type="text/javascript">
(function() {
	var api = global.API;
	if (api && api.isRealObjectProperty && api.isRealObjectProperty(this, 'document') && api.isHostMethod(global.document, 'write')  && api.getEBI) {
		var s = '<h2 class="test">Console<\/h2><p>Inspect the API with the console. Note that the interface changes according to the environment.<\/p><fieldset id="fieldset"><legend>Console<\/legend><textarea id="log" rows="10" readonly="readonly"><\/textarea><input id="toggledebug" type="button" value="Toggle Debug"><input id="inspectdocument" type="button" value="Inspect Document"><input id="clearlog" type="button" value="Clear Log"><fieldset id="propertiesfieldset"><legend>Properties<\/legend><label for="objects">Object:<\/label><select id="objects"><\/select><label for="properties">Property:<\/label><select id="properties"><\/select><input type="button" id="inspect" value="Inspect"><\/fieldset><fieldset><legend>Immediate<\/legend><input class="test" id="immediate"><input id="runimmediate" type="button" value="Run"><input id="clearimmediate" type="button" value="Clear"><input id="multiimmediate" type="button" value="Multi-line"><\/fieldset><fieldset><legend>Unit Testing<\/legend><input id="rununittests" type="button" value="Run Unit Tests"><\/fieldset>';
<%If bRequester Then%>
		if (api.monitorSession) {
			s += '<fieldset><legend>Ajax Monitor</legend><label for="totalsuccesses">Successful:<\/label><input readonly="readonly" id="totalsuccesses" class="total" value="0"><label for="totalfailures">Failed:<\/label><input readonly="readonly" id="totalfailures" class="total" value="0"><label for="totalcancels">Canceled:</label><input readonly="readonly" id="totalcancels" class="total" value="0"><label for="totalerrors">Errored:<\/label><input readonly="readonly" id="totalerrors" class="total error" value="0"><input id="logtotals" type="button" value="Log"><input id="resettotals" type="button" value="Reset"><\/fieldset>';
		}
<%End If%>
		s += '<\/fieldset>';
		global.document.write(s);
	}
})();
</script>
<%End If%>
<div id="logo"><a href="mylib.html" title="Home"><img src="images/mylibrarylogo.jpg" height="108" width="260" title="Home" alt="My Library"<%If bXHTML Then%> /<%End If%>></a></div>
<address>By <a title="Send email to David Mark" href="mailto:dmark@cinsoft.net">David Mark</a></address>
<div class="legal">Copyright &copy; 2007-2010 by <a href="mailto:dmark@cinsoft.net">David Mark</a>. All Rights Reserved.</div>
<script type="text/javascript" src="mylib-unclip.js"></script>
<script type="text/javascript" src="mylib-domready.js"></script>
</body>
</html>