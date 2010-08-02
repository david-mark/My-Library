// My Library Editor Widget
// Requires DOM and Event modules
// Optionally uses Size, HTML and Get HTML modules
// Optionally uses Text Selection add-on

var API, global = this;

if (API && API.attachDocumentReadyListener) {
	API.attachDocumentReadyListener(function() {
		var el, doc, body, editorNewPage, editorExecCommand, editorQueryCommandEnabled, editorQueryCommandState, editorQueryCommandValue, getEditorHtml, setEditorHtml, restoreSelection;
		var api = API;
		var isHostMethod = api.isHostMethod, isEventSupported = api.isEventSupported;
		var attachListener = api.attachListener, attachDocumentListener = api.attachDocumentListener, attachWindowListener = api.attachWindowListener;
		var getBodyElement = api.getBodyElement, getHtmlElement = api.getHtmlElement;
		var createElement = api.createElement;
		var showElement = api.showElement;
		var getElementParentElement = api.getElementParentElement;
		var getIFrameDocument = api.getIFrameDocument, getDocumentWindow = api.getDocumentWindow;
		var getElementSize = api.getElementSize, sizeElementOuter = api.sizeElementOuter;
		var getHostRange = api.getHostRange;

		var getEditorDocument = function(el) {
			return el.contentDocument || (el.contentWindow && el.contentWindow.document);
		};

		var getEditorWindow = function(el) {
			var win = el.contentWindow;
			if (!win && getDocumentWindow) {
				var doc = el.contentDocument;
				if (doc) {
					win = getDocumentWindow(doc);
				}
			}
			return win;
		};

		body = getBodyElement();

		if (createElement && getElementParentElement && getIFrameDocument && body && isHostMethod(body, 'appendChild')) {
			el = createElement('iframe');
			el.style.visibility = 'hidden';
			el.style.position = 'absolute';
			el.style.top = el.style.left = el.style.width = el.style.height = '0';

			body.appendChild(el);
			doc = getEditorDocument(el);
			body.removeChild(el);
			el = createElement('div');
			if (el && doc && (typeof doc.designMode == 'string' || typeof el.contentEditable == 'string')) {
				api.getEditorDocument = getEditorDocument;
				api.getEditorWindow = getEditorWindow;

				editorNewPage = API.editorNewPage = function(el, html) {
					var doc = getEditorDocument(el);
					doc.open();
					doc.write('<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title></title></head><body>' + html + '</body></html>');
					doc.close();
				};

				if (api.getElementHtml) {
					var getElementHtml = api.getElementHtml;

					getEditorHtml = api.getEditorHtml = function(el) {
						return getElementHtml(getBodyElement(getEditorDocument(el)));
					};
				} else {
					getEditorHtml = api.getEditorHtml = function(el) {
						return getBodyElement(getEditorDocument(el)).innerHTML;
					};
				}

				if (getHostRange) {
					restoreSelection = function(win) {
						var range = getHostRange(win.document);
						if (win.selectionBookmark) {
							try {
								range.moveToBookmark(win.selectionBookmark);
								range.select();
							} catch(e) {							
							}
							win.selectionBookmark = null;
						}
					};
				}

				var editorReloadSource = function(el) {
					var win = getEditorWindow(el);

					var elSource = win.textarea;
					setEditorHtml(el, elSource.value);
				};

				var editorViewSource = api.editorViewSource = function(elEditor, b, options) {
					var el = elEditor.contentWindow.textarea;

					if (typeof b == 'undefined') {
						b = true;
					}
					if (b) {
						el.style.visibility = 'hidden';
					}
					el.style.height = el.style.width = b ? '' : '0';
					el.style.position = b ? '' : 'absolute';
					el.style.top = el.style.left = b ? '' : '-10000px';
					el.tabIndex = b ? 0 : -1;
					if (b) {
						if (showElement) {
							showElement(el, true, options);
						} else {
							el.style.visibility = 'visible';
						}
					}
					el.readOnly = !b;
				};

				api.enhanceEditor = function(el, options) {
					var dim, win, doc, elHtml;
					var elEditor = createElement('iframe');
					var elParent = getElementParentElement(el);
					var text = el.value;

					if (!options) {
						options = {};
					}

					if (elEditor && elParent) {
						if (options.id) {
							elEditor.id = options.id;
						}
						if (getElementSize && options.autoSize) {
							dim = getElementSize(el);							
						}

						elParent.insertBefore(elEditor, el);

						win = getEditorWindow(elEditor);
						doc = getEditorDocument(elEditor);
						elHtml = getHtmlElement();

						if (win && doc && elHtml && isEventSupported(elHtml, 'keyup')) {
							if (dim) {
								sizeElementOuter(elEditor, dim[0], dim[1]);
							}
							doc.designMode = 'on';

							el.value = '<p>' + text + '</p>';
							editorNewPage(elEditor, el.value);

							win.textarea = el;

							if (attachListener) {
								attachListener(el, 'change', function() {
									editorReloadSource(elEditor);
								});
							}

							editorViewSource(elEditor, false);

							el.readOnly = true;

							var events = ['keyup', 'mouseup'];
	
							if (options.updateInterfaceOnKeyDown) {
								events.push('keydown');
							}

							var onupdateinterface = options.onupdateinterface, autoUpdate = options.autoUpdate;
							win.autoUpdate = autoUpdate;
	
							var updateListener = function() {
								if (onupdateinterface) {
									onupdateinterface.call(options.callbackContext, elEditor);
								}
								if (autoUpdate) {
									el.value = getEditorHtml(elEditor);
								}
							};

							var blurListener = function() {
								if (getHostRange) {						
									var range = API.getHostRange(getEditorDocument(elEditor));
									if (isHostMethod(range, 'getBookmark')) {
										getEditorWindow(elEditor).selectionBookmark = range.getBookmark();
									}
								}
								if (autoUpdate) {
									el.value = getEditorHtml(elEditor);
								}
							};

							if (attachDocumentListener) {
								doc = getEditorDocument(elEditor);
								for (var i = events.length; i--;) {
									attachDocumentListener(events[i], updateListener, doc);
								}
							}

							if (attachListener) {
								if (isEventSupported('beforedeactivate', elEditor)) {
									attachListener(elEditor, 'beforedeactivate', blurListener);
								} else {
									attachWindowListener('blur', blurListener, win);
								}

								if (restoreSelection && isEventSupported('activate', elEditor)) {
									attachListener(elEditor, 'activate', function() {
										restoreSelection(getEditorWindow(this));
									});
								}
							}
						} else {
							elParent.removeChild(elEditor);
						}
					}

					win = elParent = elHtml = null;

					return elEditor;
				};

				// TODO: Localize

				var blockFormatAliases = {
					'Normal':'P',
					'Heading 1':'H1',
					'Heading 2':'H2',
					'Heading 3':'H3',
					'Heading 4':'H4',
					'Heading 5':'H5',
					'Heading 6':'H6',
					'Formatted':'PRE',
					'Bulleted List':'UL',
					'Numbered List':'OL'
				};

				var fontSizeAliases = {
					'10px':'1',
					'13px':'2',
					'16px':'3',
					'18px':'4',
					'24px':'5',
					'32px':'6'
				};

				var insertTable = function(el, value) {
					var i, j, rows = value.rows, columns = value.columns, border = value.border;
					var padding = value.padding, spacing = value.spacing, height = value.height, width = value.width;
					var html = '<table';

					if (height) {
						html += ' height="' + height + '"';
					}
					if (width) {
						html += ' width="' + width + '"';
					}
					if (border) {
						html += ' border="' + border + '"';
					}
					if (padding) {
						html += ' padding="' + padding + '"';
					}
					if (spacing) {
						html += ' spacing="' + spacing + '"';
					}
					html += '><tbody>';
					for (i = rows; i--;) {
						html += '<tr>';
						for (j = columns; j--;) {
							html += '<td></td>';
						}
						html += '</tr>';
					}
					html += '</tbody></table>';
					editorExecCommand(el, 'inserthtml', false, html);
				};

				editorExecCommand = API.editorExecCommand = function(el, command, ui, value) {
					var result;

					if (command == 'inserttable' && !ui) {
						insertTable(el, value);
					}

					if (command == 'formatblock' && value.charAt(0) != '<') {
						value = '<' + value + '>';
					}

					try {
						getEditorDocument(el).execCommand(command, ui, value);
						result = true;
					} catch(e) {
						if (/^(cut|copy|paste)$/.test(command)) {
							window.alert('Your security settings do not allow clipboard access.');
						} else if (command == 'inserthtml' && getHostRange) {
							var range = getHostRange(getEditorDocument(el));
							if (isHostMethod(range, 'pasteHTML')) {
								try {
									range.pasteHTML(value);
									result = true;
								} catch(e2) {
								}
							}
						}
					}

					if (result) {
						var win = getEditorWindow(el);

						if (win.textarea && win.autoUpdate) {
							win.textarea.value = getEditorHtml(el);
						}
					}

					return result;
				};

				editorQueryCommandState = api.getEditorCommandState = function(el, command) {
					return getEditorDocument(el).queryCommandState(command);
				};

				var reStripQuotes = /^'|'$/g;
				var reRGB = new RegExp('rgb[a]*\\((\\d*),[\\s]*(\\d*),[\\s]*(\\d*)[),]', 'i');
				var reTransparent = new RegExp('^rgba\\(\\d+,\\s*\\d+,\\s*\\d,\\s*0\\)$', 'i');

				// TODO: The next two functions are duplicate (private) functions of core. Make public.

				var hexByte = function(d) {
					return ('0' + d.toString(16)).slice(-2);
				};

				var hexRGB = function(rgb) {
					return [hexByte(rgb[0]), hexByte(rgb[1]), hexByte(rgb[2])].join('').toUpperCase();
				};

				editorQueryCommandValue = api.getEditorCommandValue = function(el, command) {
					var value = getEditorDocument(el).queryCommandValue(command);
					if (typeof value == 'string') {
						value = value.replace(reStripQuotes, '');
					}
					if (value) {
						if (command == 'formatblock') {
							value = (blockFormatAliases[value] || value).toUpperCase();
						} else if (command == 'fontsize') {
							value = fontSizeAliases[value] || value;
						} else if (/color/.test(command)) {
							if (typeof value == 'number') {
								value = '#' + hexRGB([value % 256, Math.floor(value % 65536 / 256), Math.floor(value / 65536)]);
							} else {
								if (reTransparent.test(value)) {
									value = '';
								} else {
									var m = reRGB.exec(value);
								        if (m) {
										value = ['#', hexByte(parseInt(m[1], 10)), hexByte(parseInt(m[2], 10)), hexByte(parseInt(m[3], 10))].join('').toUpperCase();
									}
								}
							}
						}
					}
					return value;
				};

				editorQueryCommandEnabled = api.getEditorCommandEnabled = function(el, command) {
					if (command == 'inserttable') {
						command = 'inserthtml';
					}
					try {
						return getEditorDocument(el).queryCommandEnabled(command);
					} catch(e) {						
						if (command == 'inserthtml' && getHostRange) {
							return true;
						}
					}
				};
				
				setEditorHtml = api.setEditorHtml = function(el, html) {
					getBodyElement(getEditorDocument(el)).innerHTML = html;
				};

				api.focusEditor = function(el) {
					if (el.contentWindow) {
						el.contentWindow.focus();
						if (restoreSelection) {
							restoreSelection(el.contentWindow);
						}
					} else {
						var doc = getEditorDocument(el);
						if (doc && doc.focus) {
							doc.focus();
						}
					}
				};

				var methodCommands = {
					orderedlist:'insertorderedlist',
					unorderedlist:'insertunorderedlist',
					left:'justifyleft',
					center:'justifycenter',
					right:'justifyright',
					justify:'justifyfull'
				};

				var method, methodName, suffix, methods = ['bold', 'italic', 'strikethrough', 'underline', 'cut', 'copy', 'paste', 'undo', 'redo', 'delete', 'selectall', 'left', 'center', 'right', 'justify', 'orderedlist', 'unorderedlist', 'subscript', 'superscript', 'indent', 'outdent', 'insertparagraph', 'inserthorizontalrule', 'removeformat', 'unlink', 'formatblock', 'fontname', 'fontsize', 'forecolor', 'backcolor', 'createlink', 'insertimage', 'inserthtml', 'inserttable'];

				var methodFactory = function(command) {
					return function(el, ui, value) {
						editorExecCommand(el, command, ui, value);
					};
				};

				var methodEnabledFactory = function(command) {
					return function(el) {
						return editorQueryCommandEnabled(el, command);
					};
				};

				var methodStateFactory = function(command) {
					return function(el) {
						return editorQueryCommandState(el, command);
					};
				};

				var methodValueFactory = function(command) {
					return function(el) {
						return editorQueryCommandValue(el, command);
					};
				};

				for (var i = methods.length; i--;) {
					method = methods[i];
					methodName = methodCommands[method] || method;
					suffix = method.charAt(0).toUpperCase() + method.slice(1);
					api['editor' + suffix] = methodFactory(methodName);
					api['editor' + suffix + 'Enabled'] = methodEnabledFactory(methodName);
					api['editor' + suffix + 'State'] = methodStateFactory(methodName);
					api['editor' + suffix + 'Value'] = methodValueFactory(methodName);
				}
			}
			el = doc = null;
		}
		body = api = null;
	});
}