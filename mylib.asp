// My Library (http://www.cinsoft.net/mylib.html)
// Copyright (c) 2007-2012 by David Mark. All Rights Reserved.
var API, global = this;
API = API || {};
<%If bDollar Then%>
var $;
<%End If%>
<%If bObjects Then%>
var Q, E, D, F, W, I, C;
<%End If%>
(function() {
  var doc, html;

  // Feature testing support

  var reFeaturedMethod = new RegExp('^(function|object)$', 'i');

  // Test for properties of host objects that are never callable (e.g. document nodes, elements)

  var isRealObjectProperty = function(o, p) {
    return !!(typeof o[p] == 'object' && o[p]);
  };

  API.isRealObjectProperty = isRealObjectProperty;

  var isHostMethod = function(o, m) {
    var t = typeof o[m];
    return !!((reFeaturedMethod.test(t) && o[m]) || t == 'unknown');
  };

  API.isHostMethod = isHostMethod;

  var isHostObjectProperty = function(o, p) {
    var t = typeof o[p];
    return !!(reFeaturedMethod.test(t) && o[p]);
  };

  API.isHostObjectProperty = isHostObjectProperty;

  // Test multiple API properties

  var areFeatures = function() {
    var i = arguments.length;
    while (i--) {
      if (!API[arguments[i]]) {
        return false;
      }
    }
    return true;
  };

  API.areFeatures = areFeatures;

  // for-in filter

  var isOwnProperty = function(o, p) {
    var prop = o.constructor.prototype[p];
    return typeof prop == 'undefined' || prop !== o[p];
  };

  API.isOwnProperty = isOwnProperty;

  var canCall = !!Function.prototype.call;

  var bind, bindDeferred;

  if (canCall) {
    bind = function(fn, context) {
      var prependArgs = Array.prototype.slice.call(arguments, 2);

      if (prependArgs.length) {
        return function() {
          fn.apply(context, Array.prototype.concat.apply(prependArgs, arguments));
        };
      }
      return function() {
        fn.apply(context, arguments);
      };
    };

    bindDeferred = function(fn, context, delay) {
      var timeout;

      fn = bind.apply(this, [fn, context].concat(Array.prototype.slice.call(arguments, 3)));
      return function() {
        if (timeout) {
          global.clearTimeout(timeout);
          timeout = 0;
        }
        var args = Array.prototype.slice(arguments, 0);
        timeout = global.setTimeout(function() {
          fn.apply(this, args)
        }, delay);
      };
    };

    API.bind = bind;
    API.bindDeferred = bindDeferred;
  }

  if (isRealObjectProperty(this, 'document')) {
    doc = this.document;
  }
  <%If bObjects Or bAjax Then%>
  var inherit = (function() {
    var Fn = function() {};
    return function(fnSub, fnSuper) {
      Fn.prototype = fnSuper.prototype;
      fnSub.prototype = new Fn();
      fnSub.superConstructor = fnSuper;
      fnSub.prototype.constructor = fnSub;
    };
  })();
  API.inherit = inherit;
  <%End If%>
  <%If bArray Or bDOM Then%>
  // Converts array-like objects to arrays
  function toArray(o) {
    var a = [];
    var i = o.length;
    a.length = i;
    while (i--) { a[i] = o[i]; }
    return a;
  }

  API.toArray = toArray;
  <%End If%>
  <%If bArray Then%>
  // Array section

  // Native implementations of push/pop are inconsistent

  var push = function(a) {
    var i = 1, l = arguments.length;
    var len = a.length >>> 0;
    while (i < l) {
      a[len] = arguments[i++];
      len = len + 1 >>> 0;
    }
    return a.length;
  };

  API.push = push;

  var pop = function(a) {
    var v, len = a.length >>> 0;
    if (len) {
      v = a[--len];
      delete a[len];
    }
    a.length = len;
    return v;
  };

  API.pop = pop;

  // FIXME: elt may not be undefined for sparse arrays, build array of present indeces, loop through

  var indexOf;

  if (Array.prototype.indexOf) {
    indexOf = function(a, elt) {
      return a.indexOf(elt);
    };
  } else {   
    indexOf = function(a, elt) {   
      var len = a.length >>> 0; 
      var from = Number(arguments[1]) || 0;  
   
      from = (from < 0) ? Math.ceil(from) : Math.floor(from);  
   
      if (from < 0) {
        from += len;  
      }
  
      for (; from < len; from++) {
        if (a[from] === elt) {
          return from;
        }   
      }
      return -1;
    };
  }  

  API.indexOf = indexOf;

  <%If bFilter Then%>
  var filter;
  <%End If%>
  <%If bMap Then%>
  var map;
  <%End If%>
  <%If bSome Then%>
  var some;
  <%End If%>
  <%If bEvery Then%>
  var every;
  <%End If%>
  <%If bForEach Then%>
  var forEach, forEachProperty;
  <%End If%>

  <%If bFilter Then%>
  if (Array.prototype.filter) {
    filter = function(a, fn, context) { return a.filter(fn, context); };
  }
  else {
    // Note: Array.prototype.reverse is not tested as it is from JS 1.1
    if (canCall) {
      filter = function(a, fn, context) {
        var i = a.length, r = [], c = 0;
        context = context || a;
        // Didn't want to use in operator and for in loop does not preserve order
        while (i--) {
          if (typeof a[i] != 'undefined') {
            if (fn.call(context, a[i], i, a)) { r[c++] = a[i]; }
          }
        }
        return r.reverse();
      };
    }
  }

  API.filter = filter;
  <%End If 'Filter%>
  <%If bForEach Then%>
  if (canCall) {
    forEachProperty = function(o, fn, context) {
      var prop;
      context = context || o;
      if (arguments[4]) { // Contiguous array
        for (var i = 0, l = o.length; i < l; i++) {
          fn.call(context, o[i], i, o);
        }
      } else {
        for (prop in o) { if (isOwnProperty(o, prop)) { fn.call(context, o[prop], arguments[3] ? +prop : prop, o); } }
      }
    };
  }

  API.forEachProperty = forEachProperty;

  if (Array.prototype.forEach) {
    forEach = function(a, fn, context) { a.forEach(fn, context); };
  } else if (forEachProperty) {
    forEach = function(a, fn, context) { return forEachProperty(a, fn, context, true, arguments[3]); };
  }

  API.forEach = forEach;
  <%End If 'ForEach%>
  <%If bMap Then%>
  if (Array.prototype.map) {
    map = function(a, fn, context) { return a.map(fn, context); };
  }
  else {
    if (canCall) {
      map = function(a, fn, context) {
        var i = a.length, r = [];
        context = context || a;
        while (i--) { if (typeof a[i] != 'undefined') { r[i] = fn.call(context, a[i], i, a); } }
        return r.reverse();
      };
    }
  }

  API.map = map;
  <%End If 'Map%>
  <%If bEvery Then%>
  if (Array.prototype.every) {
    every = function(a, fn, context) { return a.every(fn, context); };
  }
  else {
    if (canCall) {
      every = function(a, fn, context) {
        var i = a.length;
        context = context || a;
        while (i--) { if (typeof a[i] != 'undefined') { if (!fn.call(context, a[i], i, a)) { return false; } } }
        return true;
      };
    }
  }

  API.every = every;
  <%End If 'Every%>
  <%If bSome Then%>
  if (Array.prototype.some) {
    some = function(a, fn, context) { return a.some(fn, context); };
  }
  else {
    if (canCall) {
      some = function(a, fn, context) {
        var i = a.length;
        context = context || a;
        while (i--) { if (typeof a[i] != 'undefined') { if (fn.call(context, a[i], i, a)) { return true; } } }
        return false;
      };
    }
  }

  API.some = some;
  <%End If 'Some%>
  <%End If 'Array%>
  <%If bDOM Or bScroll Or bEvent Then%>
  var getDocumentWindow;
  <%End If 'DOM or Scroll Or Event%>
  var elementUniqueId = (function() {
    var it = 0;
    return function(el) { return el.uniqueID || (el.uniqueID = '_api' + it++); };
  })();

  API.elementUniqueId = elementUniqueId;

  var attachDocumentReadyListener, bReady, documentReady, documentReadyListener, readyListeners = [];
  var canAddDocumentReadyListener, canAddWindowLoadListener, canAttachWindowLoadListener;

  if (doc) {
    canAddDocumentReadyListener = isHostMethod(doc, 'addEventListener');
    canAddWindowLoadListener = isHostMethod(this, 'addEventListener');
    canAttachWindowLoadListener = isHostMethod(this, 'attachEvent');

    //if (canAddDocumentReadyListener || canAddWindowLoadListener || canAttachWindowLoadListener) {
      bReady = false;
      documentReady = function() { return bReady; };
      documentReadyListener = function(e) {
        if (!bReady) {
          bReady = true;
          var i = readyListeners.length;
          var m = i - 1;
          // NOTE: e may be undefined (not always called by event handler)
          while (i--) { readyListeners[m - i](e); }
        }
      };

      attachDocumentReadyListener = function(fn, docNode) {
        var addListeners = function(win) {
          if (canAddDocumentReadyListener) {
            docNode.addEventListener('DOMContentLoaded', documentReadyListener, false);
          }
          if (canAddWindowLoadListener) {
            global.addEventListener('load', documentReadyListener, false);
          } else if (canAttachWindowLoadListener) {
            global.attachEvent('onload', documentReadyListener);
          } else {
            var oldOnLoad = global.onload;              
            global.onload = function(e) { if (oldOnLoad) { oldOnLoad(e); } documentReadyListener(); };
          }
        };
        docNode = docNode || global.document;
        if (docNode == global.document) {
          if (!readyListeners.length) {
            addListeners(global);
          }
          readyListeners[readyListeners.length] = fn;
          return true;
        }
        if (getDocumentWindow) {
          var win = getDocumentWindow(docNode);
          if (win) {
            addListeners(win);
            return true;
          }
        }
        return false;
      };

      API.documentReady = documentReady;
      API.documentReadyListener = documentReadyListener;
      API.attachDocumentReadyListener = attachDocumentReadyListener;
    //}
  }
  <%If bDOM Or bForm Then%>
  var hasAttribute;
  <%End If%>
  <%If bForm Then%>
  var addOption, addOptions, getOptionValue, formChanged, inputValue, inputChanged, removeOptions, serializeFormUrlencoded, urlencode;
  <%End If%>
  <%If bImage Then%>
  var changeImage;
  <%If bPreload Then%>
  var clonePreloadedImage, preloadImage, preloaded = [];
  <%End If%>
  <%End If%>
  <%If bCollections Then%>
  var getAnchor, getAnchors, getForm, getForms, getImage, getImages, getLink, getLinks;
  var getDOMCollectionFactory, getDOMCollectionItemFactory;
  <%End If%>
  <%If bHTML Then%>
  var addElementHtml, elTemp, htmlToNodes, select, selectsBroken, setElementHtml, setElementOuterHtml, setSelectHtml, setTempHtml, transferTempHtml;
  <%End If%>
  <%If bGetHTML Then%>
  var constructElementHtml, getDocumentHtml, getElementHtml, getElementOuterHtml, reAmp, reCollapsibleAttributes, reLT, reGT, reSelfClosing, reQuot;
  <%End If%>
  <%If bScript Then%>
  var addElementScript, addScript, setElementScript;
  <%End If%>
  <%If bDOM Or bAudio Or bFlash Or bHTML Or bOffset or bPreload Then%>
  var createElement, isXmlParseMode;
  <%End If%>
  <%If bDOM Then%>
  // DOM section

  var commonElementsByTagName, disableElements, emptyNode, getAttribute, getAttributeProperty, getChildren, getEBI, getEBTN, getHeadElement, getFrameById, getIFrameDocument, removeAttribute, reUserBoolean, reURI, reSpan;
  var attributeAliases = {'for':'htmlFor', accesskey:'accessKey', codebase:'codeBase', frameborder:'frameBorder', framespacing:'frameSpacing', nowrap:'noWrap', maxlength:'maxLength', 'class':'className', readonly:'readOnly', longdesc:'longDesc', tabindex:'tabIndex', rowspan:'rowSpan', colspan:'colSpan', ismap:'isMap', usemap:'useMap', cellpadding:'cellPadding', cellspacing:'cellSpacing'};
  var attributesBad, numericAttributesBad, encTypeAttributeBad, valueHasAttributeBad;
  var camelize, reNotEmpty, reCamel = new RegExp('([^-]*)-(.)(.*)');
  <%If bSetAttribute Or bHTML Then%>
  var findReplacedElement;
  <%End If%>
  <%If bSetAttribute Then%>
  var createElementWithAttributes, createElementWithProperties, createAndAppendElementWithAttributes, createAndAppendElementWithProperties, setAttribute, setAttributeProperty, setAttributeProperties, createAndAppendElementWithAttributesFactory, setAttributes, setAttributesFactory;
  <%End If%>
  <%If bText Then%>
  var addElementText, getElementText, setElementText, trim;
  <%End If%>
  <%End If%>
  <%If bDOM Or bScroll Or bEvent Then%>

  if (doc) {
    getDocumentWindow = (function() {
      if (isRealObjectProperty(doc, 'parentWindow')) {
        return function(docNode) {
          return (docNode || global.document).parentWindow;
        };
      }
      if (isRealObjectProperty(doc, 'defaultView') && doc.defaultView == this) { // defaultView is not always window/global object (e.g. IceBrowser, Safari 2)
        return function(docNode) {
          return (docNode || global.document).defaultView;
        };
      }
      if (isRealObjectProperty(doc, '__parent__')) { // IceBrowser
        return function(docNode) {
          return (docNode || global.document).__parent__;
        };
      }
    })();
  }

  API.getDocumentWindow = getDocumentWindow;
  <%End If%>
  <%If bEvent Then%>
  var purgeListeners;
  <%End If 'Event%>
  <%If bDOM Or bScroll Or bRegion Or bAdjacent Or bOverlay Or bFX Then%>
  function getElementSize(el) { return [el.offsetHeight || 0, el.offsetWidth || 0, el.clientHeight || 0, el.clientWidth || 0, el.scrollHeight || 0, el.scrollWidth || 0]; }

  API.getElementSize = getElementSize;
  <%End If%>
  <%If bDOM Or bForm Or bStyle Or bEvent Or bHTML Or bFlash Or bOffset Then%>

  API.emptyNode = emptyNode = function(node) {
    while (node.firstChild) {
      node.removeChild(node.firstChild);
    }
  };

  function getElementDocument(el) {
    if (el.ownerDocument) {
      return el.ownerDocument;
    }
    if (el.parentNode) {
      while (el.parentNode) {
        el = el.parentNode;
      }
      if (el.nodeType == 9 || (!el.nodeType && !el.tagName)) {
        return el;
      }
      // FIXME: This is stupid, untangle attachListenerFactory
      if (el.document && typeof el.tagName == 'string') {
        return el.document;
      }
    }
    return null;
  }

  API.getElementDocument = getElementDocument;

  <%End If%>
  <%If bDOM Or bStyle Or bDispatch Or bHTML Or bFlash Or bOffset Then%>
  function getElementParentElement(el) {
    return (el.parentNode && (el.parentNode.tagName || el.parentNode.nodeType == 1))?el.parentNode:(el.parentElement || null);
  }

  API.getElementParentElement = getElementParentElement;

  function getElementNodeName(el) {
    var nn = (el.tagName || el.nodeName).toLowerCase();
    return (!nn.indexOf('html:'))?nn.substring(5):nn;
  }

  API.getElementNodeName = getElementNodeName;
  <%End If%>
  <%If bPlugin Then%>
  // Plugin section

  var getEnabledPlugin;

  if (isRealObjectProperty(this, 'navigator')) {
    getEnabledPlugin = function(mimeType, title, win) {
      var plugin;
      var nav = (win || global).navigator;
      if (nav) {
        if (mimeType && isHostMethod(nav, 'mimeTypes') && typeof nav.mimeTypes.length == 'number' && nav.mimeTypes.length) {
          if (nav.mimeTypes[mimeType] && nav.mimeTypes[mimeType].enabledPlugin) { plugin = nav.mimeTypes[mimeType].enabledPlugin; }
        }
        else {
          if (title && isHostMethod(nav, 'plugins') && typeof nav.plugins.length == 'number' && nav.plugins.length) {
            plugin = nav.plugins[title];
          }
        }
      }
      return (plugin)?(plugin.description || '[Unknown]'):null;
    };

    API.getEnabledPlugin = getEnabledPlugin;
  }
  <%End If 'Plugin%>
  <%If bCookie Or bLocationQuery Then%>
  var decode = (function() {
    var fn = (isHostMethod(global, 'decodeURIComponent'))?global.decodeURIComponent:((isHostMethod(global, 'escape'))?global.escape:null);
    if (fn) { return function(c) { return fn(c); }; }
  })();

  var encode = (function() {
    var fn = (isHostMethod(global, 'encodeURIComponent'))?global.encodeURIComponent:((isHostMethod(global, 'escape'))?global.escape:null);
    if (fn) { return function(c) { return fn(c); }; }
  })();
  <%End If 'Cookie or LocationQuery%>
  <%If bLocationQuery Then%>
  // Location Query section

  var aPair, aQuery, iQuery, reQuery, query, getQuery;

  if (decode && isHostMethod(global, 'location') && typeof global.location.search == 'string') {
    query = {};
    reQuery = new RegExp('\\+', 'g');
    aQuery = global.location.search.substring(1).split('&');
    iQuery = aQuery.length;	
    while (iQuery--) {
      aPair = aQuery[iQuery].split('=');
      if (aPair.length == 2) {
        aPair[0] = decode(aPair[0]);
        aPair[1] = decode(aPair[1].replace(reQuery, ' '));
        if (aPair[1]) { query[aPair[0]] = (query[aPair[0]])?[query[aPair[0]], aPair[1]].join(','):aPair[1]; }
      }
    }

    getQuery = API.getQuery = function(n, defaultValue) { return query[n] || ((typeof defaultValue == 'undefined')?null:defaultValue); };
  }
  <%End If 'Location Query%>
  <%If bDOM Or bHTML Then%>
  <%If bSetAttribute Or bHTML Then%>
  var transferListeners;
  // Finds new element created by outerHTML replacement

  findReplacedElement = function(el, parent, uid) {
    var m;
    m = parent.childNodes.length;
    while (m--) {
      if (parent.childNodes[m].id == el.id) {
        if (typeof transferListeners == 'function') { transferListeners(el, parent.childNodes[m]); }
        el = parent.childNodes[m];
        break;
      }
    }
    if (el.id == uid) { el.id = ''; }
    return el;
  };
  <%End If 'SetAttribute Or HTML%>
  function elementCanHaveChildren(el) {
    return typeof el.canHaveChildren == 'undefined' || el.canHaveChildren;
  }
  <%End If 'DOM or HTML%>
  <%If bStyleSheets Then%>
  var addStyleRule, setActiveStyleSheet;
  <%End If%>
  <%If bStyle Or bStyleSheets Then%>
  var canAdjustStyle, isStyleCapable, iStyle, styles;
  <%End If%>
  <%If bDOM Or bEvent Or bForm Or bStyle Or bFlash Or bAudio Or bOffset Or bViewport Or bHTML Then%>
  var allElements, getAnElement, getHtmlElement, isDescendant;
  if (doc) {

    if (isHostObjectProperty(doc, 'all')) {
      allElements = (function() {
        return function(el, bFilter) {
          var i, a, n, r;
          if (!bFilter) {
            return el.all;
          }
          else {
            a = toArray(el.all);
            i = a.length;
            r = [];

            while (i--) {
              // Code duplicated for performance
              n = a[i];
              if ((n.nodeType == 1 && n.tagName != '!') || (!n.nodeType && n.tagName)) {
                r[r.length] = a[i];
              }
            }
            return r.reverse();
          }
        };
      })();
    }

    // Returns the HTML element by default or optionally the first element it finds.
    getHtmlElement = function(docNode, bAnyElement) {
      var h, all;
      docNode = docNode || global.document;
      h = isRealObjectProperty(docNode, 'documentElement')?docNode.documentElement:((typeof getEBTN == 'function')?getEBTN('html', docNode)[0]:null);
      if (!h && allElements) {
        all = allElements(docNode); // Don't bother to filter for this
        h = all[(all[0].tagName == '!')?1:0];
        if (h && !bAnyElement && h.tagName.toLowerCase() != 'html') { h = null; }
      }
      return h;
    };

    API.getHtmlElement = getHtmlElement;

    // Returns any element
    getAnElement = function(docNode) {
      return getHtmlElement(docNode, true);
    };

    API.getAnElement = getAnElement;

    html = getAnElement();
    if (html && typeof html.parentNode != 'undefined') {
      isDescendant = function(el, elDescendant) {
        var parent = elDescendant.parentNode;
        while (parent && parent != el) {
          parent = parent.parentNode;
        }
        return parent == el;
      };
    }

    API.isDescendant = isDescendant;
  }
  <%End If%>
  <%If bDOM Or bForm Or bHTML Or bFlash Or bAudio Then%>
  if (doc) {
  <%End If%>
  <%If bDOM Or bForm Then%>
    attributesBad = !!(html && isHostMethod(html, 'getAttribute') && html.getAttribute('style') && typeof html.getAttribute('style') == 'object');
    if (!attributesBad && isHostMethod(doc, 'createElement')) {

      // TODO: Rename to missingAttributesBad--specs disagree with established quasi-standards (return null for missing attributes)

      numericAttributesBad = (function() {
        var el = doc.createElement('td');
        if (el && isHostMethod(el, 'getAttribute')) {
          return el.getAttribute('colspan') !== null;
        }
      })();

      encTypeAttributeBad = (function() {
        var el = doc.createElement('form');
        el.setAttribute('enctype', 'application/x-www-form-urlencoded');
        el.removeAttribute('enctype');
        return el.getAttribute('enctype') !== null;
      })();

      valueHasAttributeBad = (function() {
        var el = doc.createElement('input');
        el.type = 'checkbox';
        el.checked = true;
        return (typeof el.hasAttribute != 'undefined' && el.hasAttribute('value'));
      })();
    }
    hasAttribute = (function() {
      var attributeSpecified, v;
      if (html && isHostMethod(html, 'hasAttribute')) {
        return function(el, name) {
		var re, nameLower = name.toLowerCase();
		var alias = attributeAliases[nameLower];
		var valueType = typeof el[alias];

		if (numericAttributesBad) {
			if (reSpan.test(nameLower)) {

				// Some agents (e.g. Blackberry browser) return '' for missing span attributes

				if (!el.getAttribute(nameLower)) {
					return false;
				}

				// Check outer HTML as last resort (IE8 standards mode known to take this fork)

				if (typeof el.outerHTML == 'string') {
					re = new RegExp('^[^>]*\\s+' + name + '=([\'"])?\\w+\\1?', 'i');
					return re.test(el.outerHTML);
				}
			} else if (valueType == 'number' && !el.getAttribute(nameLower)) {
				return false;
			} else if (reUserBoolean.test(nameLower)) {
				var b = el['default' + nameLower.substring(0, 1).toUpperCase() + name.substring(1)];
				if (typeof b == 'boolean') { // XML documents will not feature these boolean properties
					return b;
				}
			}
		}
		if (encTypeAttributeBad && nameLower == 'enctype') {
			// TODO: Consolidate
			if (typeof el.outerHTML == 'string') {
				re = new RegExp('^[^>]*\\s+' + name + '=([\'"])?\\w+\\1?', 'i');
				return re.test(el.outerHTML);
			}
			return !!(el.attributes.enctype && el.attributes.enctype.specified);
		}
		if (valueHasAttributeBad && nameLower == 'value' && typeof el.outerHTML == 'string') {
			re = new RegExp('^[^>]*\\s+value=([\'"])?\\w*\\1?', 'i');
			return re.test(el.outerHTML);					
		}
		return el.hasAttribute(name);
        };
      }
      if (html && isHostMethod(html, 'attributes')) {
        attributeSpecified = function(el, name) {
          v = el.attributes[name];
          return !!(v && v.specified);
        };
        if (attributesBad) {
          return function(el, name) {

		// MSXML document

		var doc = arguments[2] || getElementDocument(el);
		if (doc && typeof(doc.selectNodes) != 'undefined') { return attributeSpecified(el, name); } // XML document
		var value, re, nameLower = name.toLowerCase();

		// NOTE: encType is a non-standard alias found only in broken MSHTML DOM's (only applies to attributes collection)

		var alias = nameLower == 'enctype' ? 'encType' : attributeAliases[nameLower];
					
		if (alias && alias.toLowerCase() == nameLower) {
			name = alias;
		}

		// NOTE: Broken MSHTML DOM is case-sensitive here with custom attributes

		if (el.attributes) {
			value = el.attributes[name] || el.attributes[nameLower];
		}
		if (value) {
			if (reSpan.test(nameLower) && value.value == '1') {
				re = new RegExp('^[^>]*\\s+' + name + '=([\'"])?\\w*\\1?', 'i');
				return re.test(el.outerHTML);
			}

			// NOTE: enctype and value attributes never specified

			if (value.specified) {
				return true;
			}

			if (typeof el[name] == 'boolean') {
				if (reUserBoolean.test(nameLower)) {
					return el['default' + nameLower.substring(0, 1).toUpperCase() + name.substring(1)];
				}
				return el[name];
			}

			// TODO: Consolidate

			if (nameLower == 'value' && ((/^input$/i.test(el.tagName) && /^text$/i.test(el.type)))) {
				return !!(el.defaultValue || el.defaultValue != el.value);
			}

			// TODO: Consolidate

			if (/^(enctype|value)$/.test(nameLower) && typeof el.outerHTML == 'string') {
				re = new RegExp('^[^>]*\\s+' + name + '=([\'"])?\\w*\\1?', 'i');
				return re.test(el.outerHTML);
			}
		}
		return false;
          };
        }
        return attributeSpecified;
      }
    })();

    API.hasAttribute = hasAttribute;
    <%End If 'DOM or Form%>
    <%If bDOM Then%>

    disableElements = function() {
      var b, i = arguments.length;
      if (i > 1 && typeof arguments[i - 1] == 'boolean') {
        b = arguments[i - 1];
        i--;
      }
      while (i--) { arguments[i].disabled = !b; }
    };

    API.disableElements = disableElements;

    getEBI = (function() {
      function idCheck(el, id) {
        return (el && el.id == id)?el:null;
      }
      if (isHostMethod(doc, 'getElementById')) {
        return function(id, docNode) { return idCheck((docNode || global.document).getElementById(id), id); };
      }
      if (isHostMethod(doc, 'all')) {
        return function(id, docNode) { return idCheck((docNode || global.document).all[id], id); };
      }
    })();

    API.getEBI = getEBI;

    getFrameById = function(id, win) {
      if (!win) {
        win = global;
      }
      var frame = win.frames[id];
      if (!frame && getEBI) {
        frame = getEBI(id, win.document);
        if (frame && isHostObjectProperty(frame, 'contentWindow')) {
          frame = frame.contentWindow;
        } else {
          frame = null;
        }
      }
      return frame;
    };

    API.getFrameById = getFrameById;

    getIFrameDocument = function(el, win) {
      return el.contentDocument || (el.contentWindow || getFrameById(el.name, win) || el).document || null;
    };

    API.getIFrameDocument = getIFrameDocument;
	
    commonElementsByTagName = (function() {
      if (allElements) {
        return function (el, t) {
          return(t == '*' && el.all)?allElements(el, true):el.getElementsByTagName(t);
        };
      }
      return function (el, t) { return el.getElementsByTagName(t); };
    })();

    // Returns an array or array-like host object.
    getEBTN = (function() {
      var els;
      if (isHostMethod(doc, 'getElementsByTagName')) {
        els = doc.getElementsByTagName('*');      // Test "*" parameter, which fails in some agents (e.g. IE5, Safari 1)
        if (els && (els.length || allElements)) { // Need document.all as fallback for agents that cannot handle a "*" parameter (Safari 1 is excluded by this test.)
          return function(t, docNode) {
            return commonElementsByTagName(docNode || global.document, t);
          };
        }
      }
      if (isHostObjectProperty(doc, 'all') && isHostMethod(doc.all, 'tags')) {
        return function(t, docNode) {
          return (docNode || global.document).all.tags(t);
        };
      }
    })();

    API.getEBTN = getEBTN;

    if (getEBTN) {
      getHeadElement = function(docNode) {
        return getEBTN('head', docNode || global.document)[0] || null;
      };
    }

    API.getHeadElement = getHeadElement;

    camelize = function(name) {
      if (reCamel.test(name)) {
        var m = name.match(reCamel);
        return (m)?([m[1], m[2].toUpperCase(), m[3]].join('')):name;
      }
      return name;
    };

    if (html && isHostMethod(html, 'removeAttribute')) {
      removeAttribute = function(node, name) {
        var nameLower = name.toLowerCase();
        var alias = attributeAliases[nameLower];

        if (attributesBad) {
          // NOTE: encType alias does not apply here

          if (alias && alias.toLowerCase() == nameLower) {
            name = alias;
          } else {
            name = camelize(name);
          }
        }
        alias = alias || nameLower;
        if (typeof node[alias] == 'boolean') {
          node[alias] = false;
        } else {
          node.removeAttribute(name);
        }
      };
    }

    reUserBoolean = new RegExp('^(checked|selected)$');
    reSpan = new RegExp('^(row|col)?span$');
    reURI = new RegExp('^(href|src|data|usemap|longdesc|codebase|classid|profile|cite)$');

    API.removeAttribute = removeAttribute;

    // Returns null if attribute is not present

    getAttribute = (function() {
      var att, alias, nameC, originalName, nn, reEvent, reNewLine, reFunction;

      if (html && isHostMethod(html, 'getAttribute') && hasAttribute) {
        if (attributesBad) {
            reEvent = new RegExp('^on');
            reNewLine = new RegExp('[\\n\\r]', 'g');
            reFunction = new RegExp('^function [^\\(]*\\(\\) *{(.*)} *$');

            return function(el, name) { // Optional third argument speeds up by skipping getElementDocument
              var doc = arguments[2] || getElementDocument(el);
              if (doc && typeof(doc.selectNodes) != 'undefined') { return el.getAttribute(name); } // XML document
              if (hasAttribute(el, name)) {
                originalName = name;
                name = name.toLowerCase();
                alias = attributeAliases[name];
                if (!alias) {
                  if (reUserBoolean.test(name)) {
                    return el['default' + name.substring(0, 1).toUpperCase() + name.substring(1)] ? '' : null;
                  }
                  if (name == 'style') { return (el.style)?(el.style.cssText || ''):''; }
                  if (reURI.test(name)) { return el.getAttribute(name, 2); }
                  if (reEvent.test(name) && el[name]) {
                    att = el[name].toString();
                    if (att) {
                      att = att.replace(reNewLine, '');
                      if (reFunction.test(att)) { return att.replace(reFunction, '$1'); }
                    }
                    return null;
                  }
                  nn = el.tagName.toLowerCase();
                  if (nn == 'select' && name == 'type') { return null; }
                  if (nn == 'form' && el.getAttributeNode) {
                    att = el.getAttributeNode(name);
                    return (att && att.nodeValue)?att.nodeValue:null;
                  }
                }
                nameC = camelize(alias || name);
                if (typeof el[nameC] == 'unknown') {
                  return '[unknown]';
                } else {
                  if (reURI.test(nameC)) {
                    return el.getAttribute(nameC, 2);
                  }
                  if (typeof el[nameC] == 'boolean') {
                    return (el[nameC])?'':null;
                  }
                  if (typeof el[nameC] == 'undefined') { // No property, custom attribute
                    return el.getAttribute(originalName); // Case sensitive
                  }
                  if (name == 'value' && el.tagName.toLowerCase() == 'input' && el.type.toLowerCase() == 'text') {
                    return el.defaultValue;
                  }
	          return (typeof el[nameC] != 'string' && el[nameC] !== null && el[nameC].toString)?el[nameC].toString():el[nameC];
                }
              }
              return null;
            };
        }
        return function(el, name) {
          var nameLower = name.toLowerCase();
          var alias = attributeAliases[nameLower] || (nameLower.indexOf('-') != -1 && camelize(nameLower)) || nameLower;

          if (typeof el[alias] == 'boolean') {
            if (reUserBoolean.test(nameLower)) {
              return el['default' + nameLower.substring(0, 1).toUpperCase() + nameLower.substring(1)] ? '' : null;
            }
            return el[alias] ? '' : null;
          }

          if (numericAttributesBad && isHostMethod(el, 'hasAttribute')) {
            return hasAttribute(el, name) ? el.getAttribute(name) : null;
          }
          return el.getAttribute(name);
        };
      }
    })();

    API.getAttribute = getAttribute;

    var testAttributePath = '/favicon.ico';

    if (getAttribute) {
      var elA, badReflections, anchorHrefResolves = (function() {
        var el = doc.createElement('a');

        if (el && isHostMethod(el, 'setAttribute')) {
          el.setAttribute('href', testAttributePath);
          return el.href != testAttributePath;
        }
      })();
	
      if (anchorHrefResolves && isHostMethod(doc, 'createElement')) {
        badReflections = (function() {
          var el, result = {};
          var testReflection = function(tagName, propertyName, el) {
            var attributeName = propertyName.toLowerCase();

            el = el || doc.createElement(tagName);
            if (el && isHostMethod(el, 'setAttribute')) {
              el.setAttribute(attributeName, testAttributePath);
              result[attributeName] = el[propertyName] == testAttributePath;
            }
          };

          testReflection('form', 'action');
          el = doc.createElement('img');
          testReflection('img', 'useMap', el);
          testReflection('img', 'src', el);
          testReflection('img', 'longDesc', el);
          testReflection('link', 'href');
          testReflection('head', 'profile');
          el = doc.createElement('object');
          testReflection('object', 'codeBase', el);
          testReflection('object', 'classid', el);
          testReflection('object', 'data', el);
          testReflection('blockquote', 'cite');
          testReflection('area', 'href');
          return result;
        })();
        elA = doc.createElement('a');
      }

      // For use with HTML DOM's only

      getAttributeProperty = function(el, name) {
        var nameLower = name.toLowerCase();
        var alias = attributeAliases[nameLower] || camelize(nameLower);
        var elHref = elA;

        switch (typeof el[alias]) {
        case 'boolean':				
          return reUserBoolean.test(nameLower) ? el['default' + nameLower.substring(0, 1).toUpperCase() + nameLower.substring(1)] : el[alias];
        case 'undefined':

          // Missing expando or event handlers in some browsers (e.g. FF)

          return getAttribute(el, nameLower);
        default:
          if (hasAttribute(el, name)) {
            if (anchorHrefResolves && elA && (reURI.test(nameLower) || nameLower == 'action') && badReflections[nameLower] && !(/^a$/i).test(el.tagName)) {
            
              var doc = arguments[2] || getElementDocument(el);
              if (doc && doc != global.document && isHostMethod(doc, 'createElement')) {
                elHref = doc.createElement('a');
              }

              elHref.setAttribute('href', getAttribute(el, nameLower));
              return elHref.href;
            }
            return nameLower == 'value' ? getAttribute(el, nameLower) : el[alias];
          }
          return null;
        }
      };

      API.getAttributeProperty = getAttributeProperty;
    }

    // Note: returns element as some attributes (e.g. name, type) will create a new element
    // Ex. el = setAttribute(el, 'name', 'newname');
    <%If bSetAttribute Then%>
    setAttribute = (function() {
      var div, nn, nameC, reEvent, reNamed, setAttributeByReplacement;

      if (html && isHostMethod(html, 'setAttribute')) {
        if (attributesBad) {
          setAttributeByReplacement = function(el, name, value) {
            var re, uid, pn = el.parentNode;
            if (pn && isHostMethod(pn, 'childNodes') && typeof el.outerHTML == 'string') {
              uid = elementUniqueId(el);
              el.id = el.id || uid;
              re = new RegExp(name + '=[\'"]{0,1}[a-zA-Z0-9_]+[\'"]{0,1}', 'i');
              // should loop through attributes to build outer tag
              el.outerHTML = el.outerHTML.replace(re, ' ').replace('>',' ' + name + '="' + value + '">');
              
              if (el.parentNode !== pn) {
                el = findReplacedElement(el, pn, uid);
              }
            }
            else {
              el[name] = value;
            }
            return el;
          };

          reEvent = new global.RegExp('^on');
          reNamed = new RegExp('^(a|img|form|input|select|button|textarea|iframe)$');

          if (isHostMethod(global.document, 'createElement')) {
            div = global.document.createElement('div');
          }
          return function(el, name, value) {
            var doc = getElementDocument(el);
            if (doc && typeof(doc.selectNodes) != 'undefined') { el.setAttribute(name, value); return el; } // XML document
            name = name.toLowerCase();
            nn = el.tagName.toLowerCase();
            switch(name) {
            case 'style':
              if (el.style) { el.style.cssText = value; }
              break;
            case 'checked':
            case 'selected':
              el['default' + name.substring(0, 1).toUpperCase() + name.substring(1)] = value.toLowerCase() == name || !value;
              break;
            case 'defer':
            case 'disabled':
            case 'multiple':
            case 'readonly':
            case 'ismap':
              el[name] = (value.toLowerCase() == name || !value);
              break;
            case 'type':
              if (nn != 'select') { // no such attribute, but there is a property
                if (nn == 'input' && (el.parentNode || (el.attributes && el.attributes.type && el.attributes.type.specified)))  {
                  el = setAttributeByReplacement(el, 'type', value); // Can only set property once
                }
                else {
                  el.type = value;
                }
              }
              break;
            case 'name':
              var isNamed = reNamed.test(nn);
              var divAppend = (doc == global.document) ? div : (doc && doc.createElement('div'));
              if (el.parentNode === null && isNamed && divAppend) {
                divAppend.appendChild(el); // Causes IE to add name to DOM collections
              }
              el = setAttributeByReplacement(el, 'name', value);
              if (isNamed && divAppend && el.parentNode == divAppend) {
                divAppend.removeChild(el);
              }
              break;
            default:
              if (reEvent.test(name)) {
                el[name] = new Function(value);
              } else {
                nameC = camelize(attributeAliases[name] || name);
                if (typeof el[nameC] == 'undefined') { // Custom attribute
                  el.setAttribute(name, value); // Case sensitive
                } else {
                  el[nameC] = value;
                }
              }					
            }
            return el;
          };
        }
        return function(el, name, value) {
          var nameLower = name.toLowerCase();
          var alias = attributeAliases[nameLower] || nameLower;

          if (typeof el[alias] == 'boolean') {
            var b = !value || nameLower == value.toLowerCase();
            if (reUserBoolean.test(nameLower)) {
              if (b) {
                el.setAttribute(nameLower, nameLower);
              } else {
                el.removeAttribute(nameLower);
              }
            } else {
              el[alias] = b;
            }
          } else {
            if (nameLower == 'value' && typeof el.defaultValue == 'string') {
              el.defaultValue = value;
            } else {
              el.setAttribute(name, value);
            }
          }
          return el;
        };
      }
    })();

    API.setAttribute = setAttribute;

    if (setAttribute) {
      setAttributeProperty = function(el, name, value) {
        var nameLower = name.toLowerCase();
        var alias = attributeAliases[nameLower] || camelize(nameLower);

        if (typeof value == 'string' && typeof el[alias] == 'undefined' && alias == nameLower) {

			// Expando (implemented as a custom attribute)

			el.setAttribute(nameLower, value);
        } else {
			if (nameLower == 'value') {
				setAttribute(el, 'value', value);
			} else if (numericAttributesBad && typeof el[alias] == 'number') {
				setAttribute(el, nameLower, value + '');
			} else if (reUserBoolean.test(nameLower)) {
				if (value) {
					setAttribute(el, nameLower, '');
				} else {
					removeAttribute(el, nameLower);
				}
			} else {
				el[alias] = value;
			}
        }
        return el;
      };

      API.setAttributeProperty = setAttributeProperty;
    }

    <%End If%>

    if (html) {
      getChildren = (function() {
        if (isHostObjectProperty(html, 'children')) {
          return function(el) {
            var a, c, i, elC;

            if (arguments[1]) {
              return el.children;
            }

            // Filter comment nodes

            a = [];
            c = el.children;
            for (i = c.length; i--;) {
              elC = c[i];
              if ((elC.nodeType == 1 && elC.tagName != '!') || (!elC.nodeType && elC.tagName)) {
                a[a.length] = elC;
              }
            }
            return a.reverse();
          };
        }
        if (isHostMethod(html, 'childNodes')) {
          return function(el) {
            var n, nl = el.childNodes, r = [];
            var i = nl.length;

            while (i--) {
              // Code duplicated for performance
              n = nl[i];
              if ((n.nodeType == 1 && n.tagName != '!') || (!n.nodeType && n.tagName)) {
                r.push(nl[i]);
              }
            }
            return r.reverse();
          };
        }
      })();
    }

    API.getChildren = getChildren;

    reNotEmpty = new RegExp('[^\\t\\n\\r ]');

    API.isEmptyTextNode = function(n) {
      return !reNotEmpty.test(n.data);
    };
    <%End If 'DOM%>

    <%If bDOM Or bAudio Or bHTML Or bFlash Or bOffset Or bPosition Or bSize Or bPresent Or bPreload Then%>
    var isXmlParseModeDocument;

    <%If bXHTMLSupport Then%>
    isXmlParseMode = function(docNode) {
      var i, content, hasCENS, metaTags, xml;
      docNode = docNode || global.document;
      if (typeof isXmlParseModeDocument != 'undefined' && docNode == global.document) {
        return isXmlParseModeDocument;
      }
      if (typeof docNode.contentType == 'string') {
        return docNode.contentType.indexOf('xml') != -1;
      }
      else {
        hasCENS = isHostMethod(docNode, 'createElementNS');
        if (!hasCENS) {
          return false;
        }
        if (isHostMethod(docNode, 'getElementsByTagName')) { // Documents served as text/html should have Content-Type meta tag
          metaTags = docNode.getElementsByTagName('meta');
          i = metaTags.length;
          if (i && isHostMethod(metaTags[0], 'getAttribute')) {
            xml = true;
            while (i-- && xml) {
              content = metaTags[i].getAttribute('http-equiv');
              if (content === '') {
                return false;
              }
              if (content == 'Content-Type') {
                content = metaTags[i].getAttribute('content');
                if (content) {
                  xml = (content.indexOf('html') == -1);
                }
              }
            }
            return xml;
          }
          return hasCENS; // no meta tags to analyze--use object inference as last resort
        }
      }
    };

    if (API.disableXmlParseMode) {
      isXmlParseMode = function(docNode) {
        return false;
      };
    }
    <%Else%>
    isXmlParseMode = function(docNode) {
      return false;
    };
    <%End If%>

    isXmlParseModeDocument = isXmlParseMode();

    API.isXmlParseMode = isXmlParseMode;

    createElement = (function() {
      if (isHostMethod(doc, 'createElement')) {
        return (function() {
          if (isXmlParseModeDocument && isHostMethod(doc, 'createElementNS')) {
            return function(tag, docNode) {
              return (docNode || global.document).createElementNS('http://www.w3.org/1999/xhtml', 'html:' + tag);
            };
          }
          return function(tag, docNode) {
            return (docNode || global.document).createElement(tag);
          };
        })();
      }
    })();

    API.createElement = createElement;
    <%End If%>
    <%If bSetAttribute Then%>
    if (createElement && setAttribute) {
      setAttributesFactory = function(setAttribute) {
        return function(el, attributes) {
            var att;

            // TODO: Clone attributes object!

            // Do type first

            if (typeof attributes.type != 'undefined' && isOwnProperty(attributes, 'type')) {
              el.setAttribute('type', attributes.type);
              delete attributes.type;
            }

            var name = attributes.name;

            // Set name second as it may require MSHTML workaround

            if (name) {
              el = setAttribute(el, 'name', name);
              if (el.tagName.toLowerCase() == 'iframe' && isHostObjectProperty(el, 'contentWindow')) {
                el.contentWindow.name = name;
              }
              delete attributes.name;
            }

            for (att in attributes) {
              if (isOwnProperty(attributes, att)) { el = setAttribute(el, att, attributes[att]); }
            }
            return el;
        };
      };

      API.setAttributes = setAttributes = setAttributesFactory(setAttribute);
      API.setAttributeProperties = setAttributeProperties = setAttributesFactory(setAttributeProperty);

      createElementWithAttributes = function(tag, attributes, docNode) {
        var el = createElement(tag, docNode || global.document);
        if (el) {
          el = setAttributes(el, attributes);
        }
        return el;
      };

      API.createElementWithAttributes = createElementWithAttributes;

      createElementWithProperties = function(tag, properties, docNode) {
        var el = createElement(tag, docNode || global.document);
        if (el) {
          el = setAttributeProperties(el, properties);
        }
        return el;
      };

      API.createElementWithProperties = createElementWithProperties;

      if (html && isHostMethod(html, 'appendChild')) {

        // Optional docNode argument is redundant, but faster and more robust when used
        // TODO: advisor message if mismatch between docNode and appendTo

        createAndAppendElementWithAttributesFactory = function(setAttributes) {
          return function(tag, attributes, appendTo, docNode) {
            if (!docNode) {
              docNode = getElementDocument(appendTo);
            }
            if (docNode) {
              var el = createElement(tag, docNode);
              if (el) {
                el = setAttributes(el, attributes);
                appendTo.appendChild(el);
              }
              return el;
            }
            return null;
          };
        };
        createAndAppendElementWithAttributes = API.createAndAppendElementWithAttributes = createAndAppendElementWithAttributesFactory(setAttributes);
        createAndAppendElementWithProperties = API.createAndAppendElementWithProperties = createAndAppendElementWithAttributesFactory(setAttributeProperties);
      }
    }
    <%End If 'Set Attribute%>
    <%If bCollections Then%>
    getDOMCollectionFactory = function(name, tag, fnFilter) {
      if (isHostMethod(doc, name)) {
        return function(docNode) { return (docNode || global.document)[name]; };
      }
      if (getEBTN && (!fnFilter || typeof filter == 'function')) {
        return function(docNode) {
          var col, i;

          if (typeof tag == 'string') {
            col = getEBTN(tag, docNode);
          }
          else {
            col = [];
            i = tag.length;
            while (i--) {
              col = col.concat(toArray(getEBTN(tag[i], docNode)));
            }
          }
          return (fnFilter)?filter(col, fnFilter):col;
        };
      }
    };

    getDOMCollectionItemFactory = function(name, tag, fnCollection) {
      if (isHostMethod(doc, name)) {
        return function(i, docNode) { return (docNode || global.document)[name][i]; };
      }
      if (getEBI) {
        return function(i, docNode) {
          var el, col, j, nn;
          if (typeof i == 'string') {
            el = getEBI(i, docNode);
            if (el && (!el.name || el.name == i)) {
              if (typeof tag == 'string') {
                if (getElementNodeName(el) == tag) { return el; }
              }
              else {
                j = tag.length;
                nn = getElementNodeName(el);
                while (j--) {
                  if (nn == tag[j]) { return el; }
                }
              }
            }
          }
          col = fnCollection();
          if (typeof i == 'string') {
            j = col.length;
            while (j--) {
              if (col[j].name == i || (!col[j].name && col[j].id == i)) {
                return col[j];
              }
            }
            return null;
          }
          return col[i] || null;
        };
      }
    };

    getImages = API.getImages = getDOMCollectionFactory('images', 'img');
    if (getImages) {
      getImage = API.getImage = getDOMCollectionItemFactory('images', 'img', getImages);
    }

    getForms = API.getForms = getDOMCollectionFactory('forms', 'form');
    if (getForms) {
      getForm = API.getForm = getDOMCollectionItemFactory('forms', 'form', getForms);
    }

    getAnchors = API.getAnchors = getDOMCollectionFactory('anchors', 'a', function(el) { return typeof el.href != 'unknown' && !el.href; });
    if (getAnchors) {
      getAnchor = API.getAnchor = getDOMCollectionItemFactory('anchors', 'a', getAnchors);
    }

    getLinks = API.getLinks = getDOMCollectionFactory('links', ['a', 'area'],  function(el) { return typeof el.href == 'unknown' || el.href; });
    if (getLinks) {
      getLink = API.getLink = getDOMCollectionItemFactory('links', ['a', 'area'], getLinks);
    }
    <%End If%>
    <%If bImage Then%>
    // Image section

    changeImage = function(el, src) {
      el.src = src;
    };

    API.changeImage = changeImage;

    <%If bPreload Then%>
    if (this.Image) {
      preloadImage = function(uri, h, w) {
        var p = new global.Image();
        p.src = uri;
        p.height = h;
        p.width = w;
        preloaded[preloaded.length] = p;
        return preloaded.length - 1;
      };

      API.preloadImage = preloadImage;

      if (createElement) {
        clonePreloadedImage = function(handle) {
          var img = createElement('img');
          var p = preloaded(handle);
          img.src = p.src;
          img.height = p.height;
          img.width = p.width;
          return img;
        };

        API.clonePreloadedImage = clonePreloadedImage;
      }
    }

    changeImage = function(el, src) {
      if (typeof src == 'number') {
        if (preloaded[src]) {
          el.src = preloaded[src].src;
        }
      }
      else {
        el.src = src;
      }
    };

    API.changeImage = changeImage;
    <%End If 'Preload%>
    <%End If 'Image%>
    <%If bForm Then%>
    // Form section

    if (hasAttribute) {
      getOptionValue = function(o) {    
        return (o.value || (hasAttribute(o, 'value')?o.value:o.text)); 
      };
    }

    API.getOptionValue = getOptionValue;

    if (isHostMethod(global, 'Option')) {
      addOption = function(el, text, value) {
        var o = new global.Option(), len = el.options.length;
        o.text = text;
        if (typeof value != 'undefined') { o.value = value; }
        if (el.options.add) {
          el.options.add(o, el.options.length);
        }
        if (len == el.options.length) {
          el.options[el.options.length] = o;
        }
        return o;
      };

      API.addOption = addOption;

      addOptions = function(el, options) {
        var opt;
        for (opt in options) { if (isOwnProperty(options, opt)) { addOption(el, options[opt], opt); } }
      };

      API.addOptions = addOptions;
    }

    removeOptions = function(el) {
      el.options.length = 0;
      var l = el.options.length;		
      while (l--) { el.options[l] = null; }
    };

    API.removeOptions = removeOptions;

    urlencode = (function() {
      var f = function(s) {
      return encodeURIComponent(s).replace(/%20/g,'+').replace(/(.{0,3})(%0A)/g,
        function(m, a, b) {return a+(a=='%0D'?'':'%0D')+b;}).replace(/(%0D)(.{0,3})/g,
        function(m, a, b) {return a+(b=='%0A'?'':'%0A')+b;});
      };

      if (typeof encodeURIComponent != 'undefined' && String.prototype.replace && f('\n \r') == '%0D%0A+%0D%0A') {
         return f;
      }
    })();

    API.urlencode = urlencode;

    if (getOptionValue) {
    inputValue = function(el, bDefault) {
      var a, o, t = el.type;

      if (t && !t.indexOf('select')) {
        a = [];
        for (var j = 0, jlen = el.options.length; j < jlen; j++) {
          o = el.options[j];
          if (o[(bDefault)?'defaultSelected':'selected']) {
            a[a.length] = getOptionValue(o);
          }
        }
        if (a.length == 1) { a = a[0]; }
        return a;
      }
      switch(t) {
      case 'checkbox':
      case 'radio':
        return (el[(bDefault)?'defaultChecked':'checked'])?el.value || 'on':'';
      default:
        return el[(bDefault)?'defaultValue':'value'];
      }
    };

    API.inputValue = inputValue;

    inputChanged = function(el) {
      var i;
      var d = inputValue(el, true);
      var v = inputValue(el);
      
      if (typeof d == 'string') {
        return (d == v);
      }
      i = d.length;
      while (i--) {
        if (d[i] != v[i]) { return true; }
      }
      return false;
    };

    API.inputChanged = inputChanged;

    formChanged = function(el) {
      var i, els = el.elements;

      i = els.length;
      while (i--) {
        if (inputChanged(els[i])) { return true; }
      }
      return false;
    };
    }

    <%If bSerialize Then%>
    if (urlencode && getOptionValue) {
      serializeFormUrlencoded = function(f) {
        var e, // form element
            n, // form element's name
            t, // form element's type
            o, // option element
            es = f.elements,
            c = []; // the serialization data parts

        var reCheck = new RegExp('^(checkbox|radio)$');
        var reText = new RegExp('^(text|password|hidden|textarea)$');

        function add(n, v) {
          c[c.length] = urlencode(n) + "=" + urlencode(v);
        }

        for (var i=0, ilen=es.length; i<ilen; i++) {
          e = es[i];
          n = e.name;
          if (n && !e.disabled) {
            t = e.type;
            if (!t.indexOf('select')) {
              // The 'select-one' case could reuse 'select-multiple' case
              // The 'select-one' case code is an optimization for
              // serialization processing time.
              if (t == 'select-one' || e.multiple === false) {
                if (e.selectedIndex >= 0) {
                  add(n, getOptionValue(e.options[e.selectedIndex]));
                }
              }
              else {
                for (var j = 0, jlen = e.options.length; j < jlen; j++) {
                  o = e.options[j];
                  if (o.selected) {
                    add(n, getOptionValue(o));
                  }
                }
              } 
            }
            else if (reCheck.test(t)) {
              if (e.checked) {
                add(n, e.value || 'on');
              }          
            }
            else if (reText.test(t)) {
              add(n, e.value);
            }
          }
        }
        return c.join('&');
      };
    }
    API.serializeFormUrlencoded = serializeFormUrlencoded;
    <%End If 'Serialize%>
    <%End If 'Form%>
    <%If bText Then%>
    // Text section

    if (String.prototype.trim) {
      trim = function(text) {
        return text.trim();
      };
    } else {
      if (String.fromCharCode(160).replace(/\s/, '').length) {
        trim = function(text) {
          return text.replace(/^[\s\xA0](\s|\xA0)*/, '').replace(/(\s|\xA0)*[\s\xA0]$/, '');
        };
      } else {
        trim = function(text) {
          return text.replace(/^\s\s*/, '').replace(/\s*\s$/, '');
        };
      }
    }

    if (html) {
      getElementText = (function() {
        if (typeof html.textContent == 'string') { return function(el) { return el.textContent; }; }
        if (typeof html.innerText == 'string') { return function(el) { return el.innerText; }; }
        if (isRealObjectProperty(html, 'firstChild')) {
          return function(el) {
            var text = [];
            var c = el.firstChild;
            while (c) {
              if (c.nodeType == 3 || c.nodeType == 4) {
                if (reNotEmpty.test(c.data)) { text[text.length] = c.data; }
              }
              else {
                if (c.nodeType == 1) { text[text.length] = getElementText(c); }
              }
              c = c.nextSibling;
            }
            return text.join('');
          };
        }
      })();

      API.getElementText = getElementText;

      setElementText = (function() {
        var reLT, reGT, reAmp;
        if (typeof html.innerText == 'string') { return function(el, text) { el.innerText = text; }; }
        if (isHostMethod(html, 'removeChild') && isHostMethod(doc, 'createTextNode')) {
          return function(el, text) {
            var docNode = getElementDocument(el);
            while (el.firstChild) { el.removeChild(el.firstChild); }
            el.appendChild(docNode.createTextNode(text));
          };
        }
        if (typeof html.innerHTML == 'string') {
          reLT = new RegExp('<', 'g');
          reGT = new RegExp('>', 'g');
          reAmp = new RegExp('&', 'g');
          return function(el, text) { el.innerHTML = text.replace(reAmp, "&amp;").replace(reLT, "&lt;").replace(reGT, "&gt;"); };
        }
      })();

      API.setElementText = setElementText;
    }
    if (setElementText && getElementText) {
      addElementText = function(el, text) { setElementText(el, getElementText(el) + text); };

      API.addElementText = addElementText;
    }
    <%End If 'Text%>
    <%If bHTML Then%>
    // HTML section

    if (html && typeof html.innerHTML == 'string') {
      if (createElement && !isXmlParseMode() && typeof html.outerHTML == 'string' && isHostMethod(html, 'childNodes')) {
        select = createElement('select');
        if (select && isHostMethod(select, 'insertAdjacentHTML') && typeof select.canHaveChildren == 'boolean') {
          select.innerHTML = '<option>T</option>';
          selectsBroken = (!select.options.length);
        }
      }

      if (selectsBroken) {
        setSelectHtml = function(el, html) {
          var uid = elementUniqueId(el);
          el.id = el.id || uid;
          var pn = el.parentNode;
          el.innerHTML = '';
          el.outerHTML = el.outerHTML.replace('>', '>' + html + '</select>');					
          if (el.parentNode !== pn) {
            el = findReplacedElement(el, pn, uid);
          }
          return el;
        };
      }

      setTempHtml = (function() {
        var nn;
        var reScriptFirst = new RegExp('^[^<]*<script', 'i');

        function preProcess(html, docNode) {
          switch(nn) {
          case 'table':
            elTemp = createElement('div', docNode);
            return '<table>' + html + '</table>';
          case 'caption':
          case 'colgroup':
          case 'col':
          case 'thead':
          case 'tbody':
          case 'tfoot':
            elTemp = createElement('div', docNode);
            return ['<table><', nn, '>', html, '</', nn, '></table>'].join('');
          case 'form':
            elTemp = createElement('div', docNode);							
          }
          return html;
        }

        function postProcess(html) {
          switch(nn) {
          case 'table':
            return elTemp.firstChild;
          case 'caption':
          case 'colgroup':
          case 'col':
          case 'thead':
          case 'tbody':
          case 'tfoot':
            return elTemp.firstChild.firstChild;
          default:
            return elTemp;
          }
        }

        // In Opera 7.23, insertAdjacentHTML on the documentElement is a false flag
        // Test created DIV when possible as it is more direct

        if (isHostMethod(createElement && createElement('div') || html, 'insertAdjacentHTML')) {
          return function(html, bAppend) {
            nn = getElementNodeName(elTemp);
            if (!bAppend && reScriptFirst.test(html) && !isXmlParseMode()) { html = '&nbsp;' + html; }
            html = preProcess(html);
            elTemp.insertAdjacentHTML('afterBegin', html);
            elTemp = postProcess(html);
          };
        }

        return function(html, bAppend) {
          nn = getElementNodeName(elTemp);
          if (!bAppend && reScriptFirst.test(html) && !isXmlParseMode()) { html = '&nbsp;' + html; }
          html = preProcess(html);
          elTemp.innerHTML = html;
          elTemp = postProcess(html);
        };
      })();

      if (isHostMethod(html, 'removeChild') && createElement && isRealObjectProperty(html, 'firstChild')) {
        transferTempHtml = function(el, html, docNode, bAppend) {
          var nn = getElementNodeName(el);
          if (nn == 'head') { nn = 'div'; }
          elTemp = createElement(nn, docNode);
          if (elTemp) {
            setTempHtml(html, bAppend);
            while (elTemp.firstChild) {
              el.appendChild(elTemp.firstChild);
            }
            elTemp = null;
          }
        };

        addElementHtml = function(el, html, docNode) {
          if (elementCanHaveChildren(el)) {
            transferTempHtml(el, html, getElementDocument(el), true);
          }
        };

        API.addElementHtml = addElementHtml;
      }

      htmlToNodes = function(html, docNode) {
        var c;
        elTemp = createElement('div', docNode);
        if (elTemp) {
          setTempHtml(html);
          c = elTemp.childNodes;
          elTemp = null;
        }
        return c;
      };

      API.htmlToNodes = htmlToNodes;

      setElementHtml = (function() {				
        if (transferTempHtml) {
          return function(el, html) {
            if (setSelectHtml && getElementNodeName(el) == 'select') {
              return setSelectHtml(el, html);
            }
            if (elementCanHaveChildren(el)) {
              //if (typeof purgeListeners == 'function') { purgeListeners(el, true, true); } // Purge children only
              while (el.firstChild) {
                el.removeChild(el.firstChild);
              }
              transferTempHtml(el, html, getElementDocument(el));
            }
            return el;
          };
        }
      })();

      API.setElementHtml = setElementHtml;

      setElementOuterHtml = (function() {
        if (typeof html.outerHTML == 'string') {
          return function(el, html) {
            //if (typeof purgeListeners == 'function') { purgeListeners(el, true); }
            el.outerHTML = html;
            return el;
          };
        }
        if (isHostMethod(html, 'insertBefore') && isRealObjectProperty(html, 'firstChild')) {
          return function(el, html) {
            var nodeNew;
            var docNode = getElementDocument(el);
            var parent = getElementParentElement(el);
            var next = el.nextSibling;

            //if (typeof purgeListeners == 'function') { purgeListeners(el); }
            elTemp = createElement('div', docNode);
            if (elTemp && parent) {
              setTempHtml(html, docNode);
              parent.removeChild(el);
              nodeNew = elTemp.firstChild;
              if (next) {
                parent.insertBefore(elTemp.firstChild, next);
              }
              else {
                parent.appendChild(elTemp.firstChild);
              }
              elTemp = null;
              return nodeNew;
            }
            return el;
          };
        }
      })();

      API.setElementOuterHtml = setElementOuterHtml;
    }
    <%If bGetHTML Then%>
    if (html && isRealObjectProperty(html, 'firstChild') && typeof html.nodeType == 'number' && getAttribute && hasAttribute) {
      reSelfClosing = new RegExp('^(br|hr|img|meta|link|input|base|param|col|area)$');
      reCollapsibleAttributes = new RegExp('^(checked|selected|disabled|multiple|ismap|readonly)$');
      reLT = new RegExp('<', 'g');
      reGT = new RegExp('>', 'g');
      reAmp = new RegExp('&', 'g');
      reQuot = new RegExp('"', 'g');

      constructElementHtml = function(el, bOuter, bXHTML, docNode) {
        var i, nn, name, value, result, selfClose = (bXHTML)?' />':'>';
        var attributes = [], attribute;

        switch (el.nodeType) {
          case 1:
            nn = getElementNodeName(el);
            result = [];
            if (el.attributes && el.attributes.length) {
              i = el.attributes.length;
              attributes.length = i;

              while (i--) {
                attribute = el.attributes[i];
                if (attribute) {
                  name = (attribute.nodeName || attribute.name || '').toLowerCase();
                  if (name) {
                    value = getAttribute(el, name, docNode); // Third argument skips getElementDocument call in getAttribute
                    if (value === '' && reCollapsibleAttributes.test(name) && hasAttribute(el, name)) { // Last test in case implementation returns empty string instead of null for missing attributes
                      value = name;
                    }
                    if (value !== null) { attributes[i] = [' ', name, '="', value.replace(reAmp, '&amp;').replace(reLT, '&lt;').replace(reGT, '&gt;').replace(reQuot, '&quot;'), '"'].join(''); }
                  }
                }
              }
            }
						
            if (reSelfClosing.test(nn)) {
              result = (bOuter)?['<', nn].concat(attributes, selfClose):[''];
            }
            else {
              result = [];
              if (nn == '!') { return result; } // IE5 thinks comments are elements
              if (el.childNodes && el.childNodes.length) {
                i = el.childNodes.length;
                while (i--) {
                  result = constructElementHtml(el.childNodes[i], true, bXHTML, docNode).concat(result);
                }
                result = (bOuter)?['<', nn].concat(attributes, '>', result, '</', nn, '>'):result;
              }
              else {
                if (nn == 'style') {
                  if (el.styleSheet && el.styleSheet.cssText) {
                    result = [el.styleSheet.cssText];
                  }
                }
                else {
                  if (el.innerText) {
                    result = [el.innerText];
                  }
                  else {
                    if (el.text) { result = [el.text]; }
                  }
                }
                result = (bOuter)?['<', nn].concat(attributes, '>', result, '</', nn, '>'):[''];
              }
            }
            return result;
          case 3:
            return (reNotEmpty.test(el.nodeValue))?[el.nodeValue]:[''];
          case 4:
            return ['<![CDATA[', el.nodeValue, ']]>'];
          case 8:
            return ['<!--', el.nodeValue, '-->'];
          case 10:
            return [el.nodeValue];
          default:
            return [];
        }
      };

      // Native properties used only if requested and actual document types match

      getElementHtml = function(el, bXHTML, bUseNative) {
        var docNode = getElementDocument(el);
	var isXML = isXmlParseMode(docNode);
        if (typeof el.innerHTML == 'string' && bUseNative && bXHTML === isXML) {
          return el.innerHTML;
        }
        if (typeof bXHTML == 'undefined') {
          bXHTML = isXML;
        }
        return constructElementHtml(el, false, bXHTML, docNode).join('');
      };

      API.getElementHtml = getElementHtml;

      getElementOuterHtml = function(el, bXHTML, bUseNative) {
        var docNode = getElementDocument(el);
	var isXML = isXmlParseMode(docNode);
        if (typeof el.outerHTML == 'string' && bUseNative && bXHTML === isXML) {
          return el.outerHTML;
        }
        if (typeof bXHTML == 'undefined') {
          bXHTML = isXML;
        }
        return constructElementHtml(el, true, bXHTML, docNode).join('');
      };

      API.getElementOuterHtml = getElementOuterHtml;

      getDocumentHtml = function(bXHTML, bUseNative, docNode) {
        docNode = docNode || global.document;
        var sHTML, el = getHtmlElement(docNode);

        if (el) {
          sHTML = getElementOuterHtml(el);
        }
        return sHTML;
      };

      API.getDocumentHtml = getDocumentHtml;
    }
    <%End If 'Get HTML%>
    <%End If 'HTML%>
    <%If bStyleSheets Then%>
    // Style sheets section

    addStyleRule = (function() {
      if (getEBTN && createElement && html && isHostMethod(html, 'appendChild')) {
        var addRule = (function() {
          var el = createElement('style');
          if (el) {
            if (isHostMethod(global.document, 'styleSheets')) { // Could conceivably be callable like document.images
              return function(selector, rule, el, docNode) {
                var ss;
                if (docNode.styleSheets && docNode.styleSheets.length) {
                  ss = docNode.styleSheets[docNode.styleSheets.length - 1];
                  if (ss.addRule) {
                    ss.addRule(selector, rule);
                  }
                  else {
                    if (typeof ss.cssText == 'string') { // IE Mac, which throws "permission denied" on insertRule
                      ss.cssText = selector + ' {' + rule + '}';
                    }
                    else {
                      if (ss.insertRule) { // old Mozilla versions, which don't support cssText property for style sheet objects
                        ss.insertRule(selector + ' {' + rule + '}', ss.cssRules.length);
                      }
                    }
                  }
                }
              };
            }
            // NOTE: This branch used to be first. Moved for the sake of Mac IE (which could prove to be a mistake)
            if (elementCanHaveChildren(el) && isHostMethod(global.document, 'createTextNode')) {
              return function(selector, rule, el, docNode) {
                var html = getHtmlElement(docNode);
                var scrollHeight = html.scrollHeight;
                el.appendChild(docNode.createTextNode(selector + ' {' + rule + '}'));
                // Some browsers (e.g. Opera 7.23 render the text nodes (!)
                if (html.scrollHeight != scrollHeight) {
                  if (el.parentNode.offsetHeight) {
                    el.parentNode.removeChild(el);
                    return false;
                  }
                }
              };
            }
            if (typeof el.innerText == 'string') { return function(selector, rule, el) { el.innerText += selector + ' {' + rule + '}'; }; }
            el = null;
          }
        })();
        if (addRule) {
          return function(selector, rule, media, docNode) {
            var el, result;
            var h = getEBTN("head", docNode);
            if (h[0]) {
              el = createElement("style", docNode);
              if (el) {
                el.setAttribute("type", "text/css");
                el.setAttribute("media", media || 'screen');
                h[0].appendChild(el);
                result = addRule(selector, rule, el, docNode || global.document);
                el = null;
                return result;
              }
            }
          };
        }
      }
    })();

    API.addStyleRule = addStyleRule;

    if (html && getAttribute && getEBTN) {
      setActiveStyleSheet = function(id, docNode) {
        var a, i, l, t;
        a = getEBTN('link', docNode);
        i = 0;
        l = a.length;
        while (i < l) {
          t = a[i].getAttribute('title');
          if (t && a[i].getAttribute('rel') && a[i].getAttribute('rel').indexOf('style') != -1) {
            a[i].disabled = true;
            if (t.toLowerCase() == id) { a[i].disabled = false; }
          }
          i++;
        }
      };

      API.setActiveStyleSheet = setActiveStyleSheet;
    }
    <%End If 'Style sheets%>
    <%If bDOM Or bForm Or bHTML Or bFlash Or bAudio Then%>
  }
  <%End If%>
  <%If bBorder Or bOffset Or bViewport Or (bMaximize Or (bCenter And bSize)) Then%>
  var getElementBordersOrigin = function(el) {
    return [el.clientTop || 0, el.clientLeft || 0];
  };

  API.getElementBordersOrigin = getElementBordersOrigin;
  <%End If%>
  <%If bStyle Or bStyleSheets Then%>
  // MS has been known to implement elements as ActiveX objects
  // (e.g. anchors that link to news resources)
  isStyleCapable = !!(html && isRealObjectProperty(html, 'style'));
  if (isStyleCapable) {
    // These flags dictate which style-related functions should be initialized
    canAdjustStyle = {};
    styles = ['display', 'visibility', 'position'];
    iStyle = 3;
    while (iStyle--) {
      canAdjustStyle[styles[iStyle]] = typeof html.style[styles[iStyle]] == 'string';
    }
    API.canAdjustStyle = function(style) { return canAdjustStyle[style]; };
  }
  <%End If%>
  <%If bStyle Then%>
  // Style section
  var floatStyle, getCascadedStyle, getKomputedStyle, getInlineStyle, getObjectStyle, getOverrideStyle, getStyle, getStylePixels, setStyle, setStyles;
  var getPositionedParent, isPositionable, isPresent, isVisible;
  <%If bPosition Then%>
  var positionElement;
  <%End If%>
  <%If bSize Then%>
  var adjustElementSize, sizeElement, sizeElementOuter;
  <%End If%>
  <%If bSize And bPosition Then%>
  var positionAndSizeElement, positionAndSizeElementOuter;
  <%End If%>
  var colorHex, hexByte, hexNibble, hexRGB;
  var rePixels = new RegExp('^(-)?[\\d\\.]*px$', 'i');
  var reOtherUnits = new RegExp('^(-)?[\\d\\.]*(em|pt|cm|in)$', 'i');
  var reColor = new RegExp('color', 'i');
  var reRGB = new RegExp('rgb[a]*\\((\\d*),[\\s]*(\\d*),[\\s]*(\\d*)[),]', 'i');
  var reTransparent = new RegExp('^rgba\\(\\d+,\\s*,\\d+,\\s*\\d,\\s*0\\)$', 'i');
  var colors = { aqua:'00FFFF', green:'008000', navy:'000080', silver:'C0C0C0', black:'000000', gray:'808080', olive:'808000', teal:'008080', blue:'0000FF', lime: '00FF00', purple:'800080', white:'FFFFFF', fuchsia:'FF00FF', maroon:'800000', red:'FF0000', yellow:'FFFF00' };

  <%If bOpacity Then%>
  var setOpacity, getOpacity, opacityStyles = ['WebkitOpacity', 'KhtmlOpacity', 'MozOpacity', 'opacity'];
  <%End If%>
  <%If bClass Then%>
  var addClass, hasClass, removeClass;
  <%End If%>
  <%If bBorder Or bMargin Then%>
  var sideNames = ['Top', 'Left', 'Bottom', 'Right'];
  <%End If%>
  <%If bBorder Then%>
  var getElementBorder, getElementBorders;
  <%End If%>
  <%If bMargin Then%>
  var getElementMargin, getElementMargins, getElementMarginsOrigin;
  <%End If%>
  if (html) {
    if (isStyleCapable) {
      <%If bPosition Then%>
      positionElement = (function() {
        var px = (typeof html.style.top == 'number')?0:'px';
        return function(el, y, x) {
          if (y !== null) { el.style.top = y + px; }
          if (x !== null) { el.style.left = x + px; }
        };
      })();

      API.positionElement = positionElement;
      <%End If%>
      <%If bSize Then%>
      sizeElement = (function() {
        var px = (typeof html.style.height == 'number')?0:'px';
        return function(el, h, w) {
          if (h !== null && h >= 0) { el.style.height = h + px; } // >= 0 check does not belong in here (not this function's responsibility)
          if (w !== null && w >= 0) { el.style.width = w + px; }
        };
      })();

      API.sizeElement = sizeElement;

      adjustElementSize = function(el, dim) {
         if (el.offsetHeight != dim[0]) {
           dim[0] -= (el.offsetHeight - dim[0]);
           if (dim[0] >= 0) { el.style.height = dim[0] + 'px'; }
         }
         if (el.offsetWidth != dim[1]) {
           dim[1] -= (el.offsetWidth - dim[1]);
           if (dim[1] >= 0) { el.style.width = dim[1] + 'px'; }
         }
         return dim;
      };

      sizeElementOuter = function(el, dim) {
        sizeElement(el, dim);
        adjustElementSize(el, dim);
      };

      API.sizeElementOuter = sizeElementOuter;

      <%End If%>
      <%If bSize And bPosition Then%>
      positionAndSizeElement = function(el, r) {
        positionElement(el, r[0], r[1]);
        sizeElement(el, r[2], r[3]);
      };

      positionAndSizeElementOuter = function(el, r) {
        positionAndSizeElement(el, r);
        adjustElementSize(el, [r[2], r[3]]);
      };

      API.positionAndSizeElement = positionAndSizeElement;
      API.positionAndSizeElementOuter = positionAndSizeElementOuter;
      <%End If%>
      floatStyle = (typeof html.style.cssFloat == 'string')?'cssFloat':'styleFloat';

      getObjectStyle = function(o, style) {
        if (style == 'float') { style = floatStyle; }
        return (o)?o[style] || null:null;
      };

      getCascadedStyle = (function() {
        if (isRealObjectProperty(html, 'currentStyle')) {
          return function(el, style) {
            return getObjectStyle(el.currentStyle, style);
          };
        }
      })();

      API.getCascadedStyle = getCascadedStyle;

      getKomputedStyle = (function() {
        var rePositioned = new RegExp('^(absolute|fixed)$');
        var rePixelConvert = new RegExp('^(height|width|left|top|right|bottom|margin.+|border.+|padding.+)$', 'i');

        if (isRealObjectProperty(doc, 'defaultView') && isHostMethod(doc.defaultView, 'getComputedStyle')) {
          return function(el, style) {
            var docNode = getElementDocument(el);
            var s = docNode.defaultView.getComputedStyle(el, null);
            return getObjectStyle(s, style);
          };
        }
        if (getCascadedStyle) {
          return function(el, style) {
            var floatS, parent, position, styleInline, styleRuntime;
            var value = getCascadedStyle(el, style);
            if (value == 'inherit') {
              parent = getElementParentElement(el);
              if (parent) {
                return getKomputedStyle(parent, style);
              }
            }
            switch(style) {
            case 'float':
              position = getKomputedStyle(el, 'position');
              return (position && rePositioned.test(position))?'none':value;
            case 'display':
              if (value != 'none') {

                // FIXME: Lose this (display bit)

                parent = getElementParentElement(el);
                while (parent) {
                  if (getCascadedStyle(parent, 'display') == 'none') {
                    return 'none';
                  }
                  parent = getElementParentElement(parent);
                }
                position = getKomputedStyle(el, 'position');
                if (position && rePositioned.test(position)) {
                  value = 'block';
                }
                else {
                  floatS = getCascadedStyle(el, 'float');
                  if (floatS && floatS != 'none') {
                    value = 'block';
                  }
                }
              }
              return value;
            }

            if (rePixels.test(value)) { return value; }
            if (reOtherUnits.test(value)) {
              if (rePixelConvert.test(style)) {
                if (parseFloat(value)) {
                  if (isRealObjectProperty(el, 'runtimeStyle')) {
                    styleInline = el.style.left;
                    styleRuntime = el.runtimeStyle.left;
                    el.runtimeStyle.left = el.currentStyle.left;
                    el.style.left = value;
                    value = el.style.pixelLeft;
                    el.style.left = styleInline;
                    el.runtimeStyle.left = styleRuntime;
                    return value + 'px';
                  }
                }
                else {
                  return '0px';
                }
              }
              return null;
            }
            return ((value == 'auto' && style != 'overflow') || value == 'inherit')?null:value;
          };
        }
      })();

      API.getComputedStyle = getKomputedStyle;

      getInlineStyle = function(el, style) {
        var value = getObjectStyle(el.style, style);
        if (typeof value == 'number') { value += 'px'; }
	return value;
      };

      API.getInlineStyle = getInlineStyle;

      getOverrideStyle = (function() {
        if (isRealObjectProperty(doc, 'defaultView') && isHostMethod(doc.defaultView, 'getOverrideStyle')) {
          return function(el, style) {
            var s = getElementDocument(el).defaultView.getOverrideStyle(el, null);
            return getObjectStyle(s, style);
          };
        }
        if (isRealObjectProperty(html, 'runtimeStyle')) {
          return function(el, style) {
            return getObjectStyle(el.runtimeStyle, style);
          };
        }
      })();

      API.getOverrideStyle = getOverrideStyle;

      <%If bOpacity Then%>
      setOpacity = (function(el) { 
        var i, s, so;
        var reOpacity = new RegExp('alpha\\(opacity=[^\\)]+\\)', 'i');
        var fn = function(el, o) { el.style[s] = o; };

        i = opacityStyles.length;
        while (i--) {
          if (typeof el.style[opacityStyles[i]] == 'string') {
            s = opacityStyles[i];
            return fn;
          }
        }

        if (typeof el.style.filter == 'string') {
          return function(el, o) {
            so = el.style;
            //var f;

            //if (typeof el.filters != 'undefined') {
              if (el.currentStyle && !el.currentStyle.hasLayout) { so.zoom = 1; }
              //f = el.filters.alpha;
              //if (typeof f != 'undefined') {
              //  f.enabled = o == 1;
              //  f.opacity = o * 100;
              //}
              //else {
                if (!reOpacity.test(so.filter)) {
                  so.filter += ' alpha(opacity=' + (o * 100) + ')';
                }
                else {
                  so.filter = so.filter.replace(reOpacity, (o >= 0.9999)?'':'alpha(opacity=' + (o * 100) + ')');
                }
              //}
            //}
          };
        }
      })(html);

      API.setOpacity = setOpacity;

      getOpacity = (function(el) {
        var i, s, reOpacity = new RegExp('opacity\\s*=\\s*([^\\)]*)', 'i');
        var fn = function(el) {
          var o = el.style[s];
          if (o) { return parseFloat(o); }
          if (getKomputedStyle) {
            o = getKomputedStyle(el, 'opacity');
            if (o !== null) { return parseFloat(o); }
          }
          return 1;
        };
        
        i = opacityStyles.length;
        while (i--) {
          if (typeof el.style[opacityStyles[i]] == 'string') {
            s = opacityStyles[i];
            return fn;
          }
        }

        if (typeof html.style.filter == 'string' && getCascadedStyle) {
          return (function() {
            var m;
//            if (html.filters) {
//              return function(el) {
//                return (typeof el.filters.alpha != 'undefined' && el.filters.alpha.enabled)?el.filters.alpha.opacity / 100:1;
//              };
//            }				
            return function(el) {
              var style = getCascadedStyle(el, 'filter');
              if (style) {
                m = style.match(reOpacity);
                return (m)?parseFloat(m[1]) / 100:1;
              }
              return 1;
            };				
          })();
        }


      })(html);

      API.getOpacity = getOpacity;
      <%End If 'Opacity%>
      hexNibble = function(d) {
        return '0123456789ABCDEF'.substring(d, d + 1);
      };

      hexByte = function(d) {
        return hexNibble(Math.floor(d / 16)) + hexNibble(d % 16);
      };

      hexRGB = function(rgb) {
        return [hexByte(rgb[0]), hexByte(rgb[1]), hexByte(rgb[2])].join('');
      };

      colorHex = function(color) {
        var m = reRGB.exec(color);
        if (m) { return ['#', hexByte(parseInt(m[1], 10)), hexByte(parseInt(m[2], 10)), hexByte(parseInt(m[3], 10))].join(''); }
        if (reTransparent.test(color)) { return 'transparent'; }
        return (colors[color])?'#' + colors[color]:null;
      };

      getStyle = (function() {
        var get = (function() {
          if (getKomputedStyle) {
            return function(el, style) {
              var styleO, styleI, styleC;

              if (getOverrideStyle) {
                styleO = getOverrideStyle(el, style);
              }
              if (styleO) { return styleO; }
              styleC = getKomputedStyle(el, style);
              if (styleC) {
                return styleC;
              }
              else {
                styleI = getInlineStyle(el, style);
                styleC = getCascadedStyle && getCascadedStyle(el, style); // Computed value is changed to null for some rules in IE (e.g. font-size:1em)
                if (styleC) {
                  return styleC;
                }
                return ((style == 'display')?'none':styleI) || null;
              }
            };
          }
          return function(el, style) {
            var parent, s = getInlineStyle(el, style);

            // TODO: Lose this (display bit)

            if (style == 'display' && (s != 'none')) {
              parent = getElementParentElement(el);
              while (parent) {
                if (parent.style.display == 'none') {
                  return 'none';
                }
                parent = getElementParentElement(parent);
              }
            }				
            return s;
          };
        })();

        return function(el, style) {
          var value = get(el, style);

          return (reColor.test(style))?colorHex(value) || value:value;
        };
      })();

      API.getStyle = getStyle;

      setStyle = function(el, style, value) {       
        if (style == 'float') { style = floatStyle; }
        el.style[style] = value;
      };

      API.setStyle = setStyle;

      setStyles = function(el, styles) {
        var s;

        for (s in styles) { if (isOwnProperty(styles, s)) { setStyle(el, s, styles[s]); } }
      };

      API.setStyles = setStyles;

      getStylePixels = function(el, style) {
        var p = getStyle(el, style);
        if (rePixels.test(p)) { return parseFloat(p); }
        if (reOtherUnits.test(p) && !parseFloat(p)) { return 0; } // 0pt
        return null;
      };

      API.getStylePixels = getStylePixels;

      <%If bBorder Then%>
      getElementBorder = function(el, border) {
        var b = getStylePixels(el, 'border' + border + 'Width');
        if (b === null) {
          switch(border) {
            case 'Left':
            case 'Right':
              return el.clientLeft || 0;
            case 'Top':
            case 'Bottom':
              return el.clientTop || 0;				
          }
        }
        return b;
      };

      API.getElementBorder = getElementBorder;

      getElementBordersOrigin = function(el) {
        return [el.clientTop || getElementBorder(el, 'Top'), el.clientLeft || getElementBorder(el, 'Left')];
      };

      API.getElementBordersOrigin = getElementBordersOrigin;

      getElementBorders = (function() {
        var i;
        return function(el) {
          var borders = {};
          i = sideNames.length;
          while (i--) { borders[sideNames[i]] = getElementBorder(el, sideNames[i]); }
          return borders;
        };
      })();

      API.getElementBorders = getElementBorders;
      <%End If%>
      <%If bMargin Then%>
      getElementMargin = function(el, margin) {
        return getStylePixels(el, 'margin' + margin) || 0;
      };

      API.getElementMargin = getElementMargin;

      getElementMarginsOrigin = function(el, margin) {
        return [getElementMargin(el, 'Top'), getElementMargin(el, 'Left')];
      };

      API.getElementMarginsOrigin = getElementMarginsOrigin;

      getElementMargins = (function() {
        var i;
        return function(el) {
          var margins = {};
          i = sideNames.length;
          while (i--) { margins[sideNames[i]] = getElementMargin(el, sideNames[i]); }
          return margins;
        };
      })();

      API.getElementMargins = getElementMargins;
      <%End If%>

      getPositionedParent = function(el) {
        var style;
        if (getStyle(el, 'position') != 'fixed' && isRealObjectProperty(el, 'offsetParent')) {
          do {
            el = el.offsetParent;
            if (el) { style = getStyle(el, 'position'); }
          }
          while (el && (!style || style == 'static'));
          return el;
        }
      };

      API.getPositionedParent = getPositionedParent;

      // Determines if an element is logically, rather than empirically visible
      // Display rules of the element or its parents are irrelevant, except that display:none rules obscure even logical visibility in some agents.
      // As with all rules, other than display, it is not possible to get consistent, accurate results for elements that are not part of the layout.
      // For compatibility with agents that cannot compute styles, initially mirror cascaded visibility:hidden rules inline.

      isVisible = function(el) {
        return getStyle(el, 'visibility') != 'hidden';
      };

      API.isVisible = isVisible;

      // For compatibility with agents that cannot compute styles, initially mirror cascaded display:none rules of the element and its parents inline.
      // When the compatibility directions for isVisible and isPresent are followed, empirical visibility can be accurately determined in all agents by isVisible(el) && isPresent(el)

      isPresent = function(el) {
        return getStyle(el, 'display') != 'none';
      };

      API.isPresent = isPresent;

      isPositionable = function(el) {
         var style = getStyle(el, 'position');
         return (style)?(style != 'static'):false;
      };

      API.isPositionable = isPositionable;

      <%If bClass Then%>
      addClass = function(el, className) {
        var re;
        if (!el.className) {
          el.className = className;
        }
        else {
          re = new RegExp('(^|\\s)' + className + '(\\s|$)');
          if (!re.test(el.className)) { el.className += ' ' + className; }
        }
      };

      API.addClass = addClass;
	
      removeClass = function(el, className) {
        var re, m;
        if (el.className) {
          if (el.className == className) {
            el.className = '';
          }
          else {		
            re = new RegExp('(^|\\s)' + className + '(\\s|$)');
            m = el.className.match(re);
            if (m && m.length == 3) { el.className = el.className.replace(re, (m[1] && m[2])?' ':''); }
          }
        }
      };

      API.removeClass = removeClass;

      hasClass = function(el, className) {
        return (new RegExp('(^|\\s)' + className + '(\\s|$)')).test(el.className);
      };

      API.hasClass = hasClass;
      <%If bDOM Then%>
      API.findAncestor = function(el, tagName, className) { 
        el = getElementParentElement(el); 

        while (el && (tagName && getElementNodeName(el) != tagName || 
className && !hasClass(el, className))) { 
          el = getElementParentElement(el); 
        } 
        return el;
      };
      <%End If 'DOM%>
      <%End If 'Class%>
    }
  }
  <%End If 'Style%>
  <%If bFlash Then%>
  // Flash Section

  if (doc) {
    if (html && getEnabledPlugin && attachDocumentReadyListener && isHostMethod(doc, 'getElementById') && ((createElement && isHostMethod(html, 'appendChild')) || typeof html.outerHTML == 'string')) {
      (function() {
        var activeX, canAdjustVisibility, canAdjustDisplay, versionFull, version, versionMinor, versionRevision;
        var queue = [];
        var queueFailed = [];
        var reStartComment = new RegExp('<!--\\[if !IE\\]>-->', 'g');
        var reEndComment = new RegExp('<!--<!\\[endif\\]-->', 'g');

        if (typeof canAdjustStyle != 'undefined') {
          canAdjustVisibility = canAdjustStyle.visibility;
          canAdjustDisplay = canAdjustStyle.display;
	}

        function varEscape(s) { var re = new RegExp('&', 'g'); s = s.replace(re, '%26'); re = new RegExp('"', 'g'); s = s.replace(re, global.escape('&quot;')); re = new RegExp('\\+', 'g'); s = s.replace(re, '%2B'); return s; }
        function error(id) { if (typeof API.onflasherror == 'function') { API.onflasherror(id); } }
        function makeParameter(name, value) { return '<param name="' + name + '" value="' + value + '">'; }
        function makeAttribute(name, value) { return name + '=' + '"' + value + '"'; }
        function versionCheck(major, minor, revision) {
          if (version == major) {
            if (versionMinor > minor) { return true; }
            if (versionMinor == minor) { return (versionRevision >= revision); }
          }
          return (version > major);
        }
        function detect() {
          var aVer, i, obj, found, re, result;
          version = 0;
          var pluginDesc = getEnabledPlugin('application/x-shockwave-flash', 'Shockwave Flash');
          if (pluginDesc) {
            re = new RegExp('(\\d+)\\.(\\d+)');
            result = pluginDesc.match(re);
            if (result && result.length == 3) {
              versionFull = result[0];
              version = parseInt(result[1], 10);
              versionMinor = parseInt(result[2], 10);
              if (pluginDesc.indexOf("r") > 1) { versionRevision = parseInt(pluginDesc.substring(pluginDesc.indexOf("r") + 1), 10); versionFull += ' r' + versionRevision; }
            }
          }
          if (!version && isHostMethod(global, 'ActiveXObject')) {
            for (i = 25; i >= 6 && !version; i--) {
              found = false;
              try {
                obj = new global.ActiveXObject("ShockwaveFlash.ShockwaveFlash." + i);
                found = (typeof obj != 'undefined');
                // first public version of v6 for Windows
                versionFull = "WIN 6,0,21,0";
                // throws if AllowScriptAccess does not exist (introduced in 6.0r47)		
                obj.AllowScriptAccess = "always";
                versionFull = obj.GetVariable("$version");
              }
              catch(e) {
              }
              if (found) { version = i; }
            }
            if (!version) {			
              try {
                obj = new global.ActiveXObject("ShockwaveFlash.ShockwaveFlash.3");
                // will work for 4.X or 5.X
                versionFull = obj.GetVariable("$version");
                // adjusted when full version is parsed
                version = 5;					
              }
              catch (E) {
              }
              if (!version) {
                try {
                  obj = new global.ActiveXObject("ShockwaveFlash.ShockwaveFlash.3");
                  version = 3;
                }
                catch(ee) {
                }					
              }
            }
            if (version) {
              activeX = true;
              if (versionFull) {
                aVer = versionFull.split(',');
                if (aVer.length == 4) {
                  if (aVer[0].lastIndexOf(' ') != -1) { aVer[0] = aVer[0].substring(aVer[0].lastIndexOf(' ') + 1); }
                  version = parseInt(aVer[0], 10);
                  versionMinor = parseInt(aVer[1], 10);
                  versionRevision = parseInt(aVer[2], 10);
                }
              }
            }
          }
        }
        function fixFlashScript() { // Short-circuit Adobe's botched memory leak cleanup
          global.__flash_unloadHandler = function(){};
          global.__flash_savedUnloadHandler = function(){};
        }
        function fixIELeaks() {
          if (isHostMethod(global.document, 'getElementsByTagName')) {
            var objects = global.document.getElementsByTagName('object');
            if (objects) {
              var i = 0;
              var l = objects.length;
              var x;
              while (i < l) {
                for (x in objects[i]) {
                  if (typeof objects[i][x] == 'function') {
                    objects[i][x] = null;
                  }
                }
                i++;
              }
            }
          }
        }
	function add(file, id, options) {
          var params, v;
          var paramNames = ['allowScriptAccess', 'swLiveConnect', 'bgColor', 'align', 'wMode', 'deviceFont', 'sAlign', 'scale', 'base', 'allowFullScreen', 'allowNetworking', 'seamlessTabbing'];
          var paramDefaults = {menu:true, loop:true, quality:'high', swLiveConnect:false, wMode:'window', allowFullScreen:false, allowNetworking:'all', seamlessTabbing:true, scale:'showall', deviceFont:false};
          var i = 0;
          var l = paramNames.length;
          while (i < l) {
            v = options[paramNames[i]];
            if (typeof v == 'string') { v = v.toLowerCase(); }
            if (typeof v != 'undefined' && v != paramDefaults[paramNames[i]]) {
              params = params || {};
              if (typeof v == 'boolean') { v = (v)?'true':'false'; }
              params[paramNames[i].toLowerCase()] = v;
            }
            i++;
          }
          if (options.variables) {
            params = params || {};
            params.flashvars = (typeof options.variables == 'object')?options.variables.value():options.variables;
          }
          queue[queue.length] = {file:file, id:id, 'class':options['class'], title:options.title, height:options.height, width:options.width, parameters:params};
	}
        function removeElement(el) {
          if (canAdjustDisplay) { el.style.display = 'none'; }
	}
	function fallbackHTML(el) {
          var h, re, match;
          if (typeof el.innerHTML == 'string' && typeof el.outerHTML == 'string') {
            h = el.innerHTML;
            re = new RegExp('[\\n\\r]', 'g');
            h = h.replace(re, '');
            re = new RegExp('<object[^>]*>(.*)</object>', 'i');
            match = h.match(re);
            if (match && match.length == 2) {
              match[1] = match[1].replace(reStartComment, '').replace(reEndComment, '');
              if (match[1].length) { el.outerHTML = match[1]; }
            }
            removeElement(el);
          }
        }
        attachDocumentReadyListener(function() {
          var html = getHtmlElement();
          var createObjects;
          var canReplaceElements = createElement && isHostMethod(html, 'replaceChild');
          if (typeof html.outerHTML != 'string' || isXmlParseMode()) {
            createObjects = true;
          }
          var mimeType = 'application/x-shockwave-flash';
          var classID = 'clsid:D27CDB6E-AE6D-11cf-96B8-444553540000';
          var downloadURI = 'http://www.adobe.com/go/getflashplayer';
          var el, elNext, elParent, obj, objHTML, item, paramTags, paramAttributes, paramElement, innerObjects, elInnerObject, fallbackElements, elChild;
          var i, l, j, m, o;

          var fnErrorFactory = function(id) {
            return function() { error(id); };
          };

          function appendParamElement(el, name, value) {
            paramElement = createElement('param');
            if (paramElement) {
              paramElement.setAttribute('name', name);
              paramElement.setAttribute('value', value);
              el.appendChild(paramElement);
            }
          }
          i = 0;
          l = queueFailed.length;
          if (html && canReplaceElements && isHostMethod(global.document, 'getElementsByTagName') && isHostMethod(html, 'appendChild') && isHostMethod(html, 'getAttribute')) {
            while (i < l) {
              el = global.document.getElementById(queueFailed[i]);
              if (el) {
                if (getElementNodeName(el) == 'object' && (el.getAttribute('type') == mimeType || el.getAttribute('classid') == classID)) {
                  innerObjects = el.getElementsByTagName('object');
                  if (innerObjects && innerObjects[0]) { elInnerObject = innerObjects[0]; }
                  if (elInnerObject) {
                    fallbackElements = [];
                    if (elInnerObject.firstChild) {
                      elChild = elInnerObject.firstChild;
                      while (elChild) {
                        if (getElementNodeName(elChild) != 'param' && elChild.nodeType != 8) { fallbackElements[fallbackElements.length] = elChild; }
                        elChild = elChild.nextSibling;
                      }
                    }
                    if (fallbackElements.length && el.parentNode) {
                      elParent = el.parentNode;
                      elNext = el.nextSibling;
                      elParent.removeChild(el);
                      j = 0;
                      m = fallbackElements.length;
                      if (elNext) {
                        while (j < m) { elParent.insertBefore(fallbackElements[j++], elNext); }
                      }
                      else {
                        while (j < m) { elParent.appendChild(fallbackElements[j++]); }
                      }
                    }
                    else {
                      removeElement(el);
                    }
                  }
                  else {
                    fallbackHTML(el);
                  }
                }
              }
              i++;
            }			
          }
          else {
            while (i < l) {
              el = global.document.getElementById(queueFailed[i++]);
              if (el) { fallbackHTML(el); }
            }
          }
          i = 0;
          l = queue.length;
          while (i < l) {
            item = queue[i++];
            item.height = (item.height || 1);
            item.width = (item.width || 1);
            item['class'] = item['class'] || '';
            item.title = item.title || '';
            if (activeX) {
              paramTags = [];
              objHTML = '<object id="' + item.id + '" classid="' + classID + '" width="' + item.width + '" height="' + item.height + '" class="' + item['class'] + '" title="' + item.title + '" style="visibility:visible" onerror="if (typeof API.onflasherror == \'function\') { API.onflasherror(\'' + item.id + '\'); }"><param name="movie" value="' + item.file + '">';
              if (createObjects) {
                obj = createElement('object');
                obj.classid = classID;
                if (canAdjustVisibility) { obj.style.visibility = 'visible'; }
                o = {id:item.id, height:item.height, width:item.width, className:item['class'], title:item.title};
                for (j in o) {
                  if (isOwnProperty(o, j)) {
                    obj[j] = o[j];
                  }
                }
                appendParamElement(obj, 'movie', item.file);
              }
              if (item.parameters) {
                for (j in item.parameters) {
                  if (isOwnProperty(item.parameters, j)) {
                    paramTags[paramTags.length] = makeParameter(j, item.parameters[j]);
                    if (obj) { appendParamElement(obj, j, item.parameters[j]); }
                  }
                }
              }
              objHTML += paramTags.join('');
              objHTML += '</object>';
              if (obj) {
                obj.onerror = fnErrorFactory(item.id);
              }
            }
            else {
              if (item.parameters && !isXmlParseMode()) { // use non-standard EMBED element if nested parameter tags (older Safari browsers choke on these) and not an XHTML document
                paramAttributes = [];
                objHTML = '<embed name="' + item.id + '" id="' + item.id + '" class="' + item['class'] + '" src="' + item.file + '" height="' + item.height + '" width="' + item.width + '" type="' + mimeType + '" pluginspage="' + downloadURI + '"' + ' style="visibility:visible"';
                if (createObjects) {
                  obj = createElement('embed');
                  if (canAdjustVisibility) { obj.style.visibility = 'visible'; }
                  o = {id:item.id, height:item.height, width:item.width, 'class':item['class'], src:item.file, 'type':mimeType, pluginspage:downloadURI};
                  for (j in o) {
                    if (isOwnProperty(o, j)) {
                      obj.setAttribute(j, o[j]);
                    }
                  }
                }
                for (j in item.parameters) {
                  if (isOwnProperty(item.parameters, j)) {
                    paramAttributes[paramAttributes.length] = makeAttribute(j, item.parameters[j]);
                    if (obj) { obj.setAttribute(j, item.parameters[j]); }
                  }
                }
                objHTML += ' ' + paramAttributes.join(' ') + '></embed>';
              }
              else {
                objHTML = '<object id="' + item.id + '" class="' + item['class'] + '" title="' + item.title + '" type="' + mimeType + '" data="' + item.file + '" height="' + item.height + '" width="' + item.width + '" style="visibility:visible"><param name="pluginurl" value="' + downloadURI + '">';
                if (createObjects) {
                  obj = createElement('object');

                  if (canAdjustVisibility) { obj.style.visibility = 'visible'; }
                  o = {'type':mimeType, data:item.file, height:item.height, width:item.width, 'class':item['class'], title:item.title, id:item.id};
                  for (j in o) {
                    if (isOwnProperty(o, j)) {
                      obj.setAttribute(j, o[j]);
                    }
                  }
                  if (item.parameters) {
                    paramTags = [];
                    for (j in item.parameters) {
                      if (isOwnProperty(item.parameters, j)) {
                        paramTags[paramTags.length] = makeParameter(j, item.parameters[j]);
                        if (obj) { appendParamElement(obj, j, item.parameters[j]); }
                      }
                    }
                    objHTML += paramTags.join('');
                  }
                  appendParamElement(obj, 'pluginurl', downloadURI);
                }
                objHTML += '</object>';
              }
            }
            el = global.document.getElementById(item.id);
            if (el) {
              // EOLAS patent dispute (need flag to indicate intervention not needed)
              //if (!item.parameters && getElementNodeName(el) == 'object' && (el.getAttribute('type') != mimeType || el.getAttribute('classid') != classID)) { // Don't replace perfectly good Flash object
              //  if (canAdjustVisibility) { el.style.visibility = 'visible'; }
              //}
              //else {
                if (!createObjects || !el.parentNode) {
                  el.outerHTML = objHTML;				
                }
                else {
                  el.parentNode.replaceChild(obj, el);
                }
              //}
            }
            obj = null;
          }
          html = null;
        });

        API.getFlashVersion = function() {
          if (typeof version == 'undefined') { detect(); }
          if (version) { return { major:version, minor:versionMinor, revision:versionRevision, full:versionFull }; }
        };

        API.createFlash = function(file, id, options) {
          var queued, oldVersion;
          options = options || {};
          if (typeof version == 'undefined') { detect(); }
          if (options.skipCheck) {
            add(file, id, options);
            queued = true;
          }
          else {
            if (version) {
              if (versionCheck(options.versionRequired || 0, options.versionRequiredMinor || 0, options.versionRequiredRevision || 0)) {
                add(file, id, options);
                queued = true;
              }
              else {
                if (options.expressInstall && versionCheck(6, 0, 65)) {
                  var installURI = options.expressInstallURI || 'playerProductInstall.swf';
                  add(installURI, {height:(options.height >= 137)?options.height:137, width:(options.width >= 214)?options.width:214, variables:'MMredirectURL=' + varEscape(global.location) + '&MMplayerType=' + ((activeX)?'ActiveX':'PlugIn') + '&MMdoctitle=' + varEscape(global.document.title), allowScriptAccess:'sameDomain', swLiveConnect:true});
                  queued = true;
                }
                else {
                  queueFailed[queueFailed.length] = id;
                  oldVersion = true;
                }
              }
            }
          }
          if (queue.length == 1 && version > 7 && activeX && isHostMethod(global, 'attachEvent')) {
            global.attachEvent('onunload', fixIELeaks);
            global.attachEvent('onbeforeunload', fixFlashScript);
          }
          if ((queued || oldVersion) && canAdjustVisibility && typeof addStyleRule == 'function') {
            addStyleRule('#' + id, 'visibility:hidden');				
          }
          return queued;
        };

        API.FlashVariables = function() {
          var serialized = '';
          function addSerial(name, value) {
            serialized += ((serialized)?'&':'') + name + '=' + varEscape(value);
          }
          this.value = function() { return serialized; };
          this.clear = function() { serialized = ''; };
          this.add = function(name, value) { addSerial(name, value); };
          this.addBookmark = function(name) { if (global.location.hash) { addSerial(name, global.location.hash.substring(1)); } };
          if (typeof getQuery == 'function') { this.addQuery = function(name) { if (getQuery(name)) { addSerial(name, getQuery(name)); } }; }
        };
      })();
    }
  }
  <%End If 'Flash%>
  <%If bStatusBar Then%>
  // Status section
  var setStatus, setDefaultStatus;

  if (typeof global.status == 'string' && isHostMethod(global, 'setTimeout')) {
    setStatus = (function() {
      var re = new RegExp("'", 'g');
      return function(s) {
        if (typeof global != 'undefined') { // Mozilla unload bug
          var fn = function() { if (typeof global != 'undefined') { global.status = s; } };
          fn.toString = function() { return "if (typeof global != 'undefined') { global.status = '" + s.replace(re, "\\'") + "'; }"; };
          global.setTimeout(fn, 10);
        }
      };
    })();

    API.setStatus = setStatus;
  }

  if (typeof global.defaultStatus == 'string') {
    setDefaultStatus = function(s) { global.defaultStatus = s; };

    API.setDefaultStatus = setDefaultStatus;    
  }
  <%End If 'Status bar%>
  <%If bCookie Then%>
  // Cookie section

  var cookieCheck, cookiesEnabled, deleteCookie, getCookie, setCookie;
  var reEncodeRegExp = new RegExp('([\\.])', 'g');
  <%If bCrumb Then%>
  var deleteCookieCrumb, getCookieCrumb, setCookieCrumb;
  <%End If%>
  function encodeRegExp(s) {
    return s.replace(reEncodeRegExp, '\\$1');
  }

  if (encode && decode && doc && typeof doc.cookie == 'string') {
    setCookie = function(name, value, expires, path, secure, docNode) {
      var date, sExpires = '';
      path = path || '/';
      if (typeof expires == 'undefined') { expires = 30; }
      if (expires) {
        if (typeof expires == 'number') {
          date = new Date();
          date.setTime(date.getTime() + (expires * 86400000));
          expires = date;
        }
        sExpires = '; expires=' + expires.toUTCString();
      }
      (docNode || global.document).cookie = encode(name) + '=' + encode(value) + sExpires + '; path=' + path + ((secure)?'; secure':'');
    };

    API.setCookie = setCookie;

    getCookie = function(name, defaultValue, encoded, docNode) {
      var re = new RegExp('( |;|^)' + encodeRegExp(encode(name)) + '=([^;]+)');
      var value = (docNode || global.document).cookie.match(re);
      return (value !== null)?((encoded)?value[2]:decode(value[2])):((typeof defaultValue == 'undefined')?null:defaultValue);
    };

    API.getCookie = getCookie;

    deleteCookie = function(name, path, docNode) {
      setCookie(name, '', -1, path, null, docNode);
    };

    API.deleteCookie = deleteCookie;

    cookiesEnabled = function() {
      if (typeof cookieCheck == 'undefined') {
        setCookie('_cookietest', '1');
        cookieCheck = (getCookie('_cookietest', '0') == '1');
        deleteCookie('_cookietest');
      }
      return cookieCheck;
    };

    API.cookiesEnabled = cookiesEnabled;
    <%If bCrumb Then%>
    setCookieCrumb = function(name, crumb, value, path, docNode) {
      var re, sCrumbs = getCookie(name, null, true, docNode);

      if (sCrumbs !== null) {
        re = new RegExp('(&|^)' + encodeRegExp(encode(crumb)) + '=[^&]*&?');
        if (re.test(sCrumbs)) {
          sCrumbs = sCrumbs.replace(re, encode(crumb) + '=' + encode(value));
        }
        else {
          sCrumbs += '&' + encode(crumb) + '=' + encode(value);
        }
      }
      else {
        sCrumbs = encode(crumb) + '=' + encode(value);
      }
      (docNode || global.document).cookie = encode(name) + '=' + sCrumbs + '; path=' + (path || '/');
    };

    API.setCookieCrumb = setCookieCrumb;

    getCookieCrumb = function(name, crumb, defaultValue, docNode) {
      var sCrumbs = getCookie(name, null, true, docNode);
      var value = null;
      var re;

      if (sCrumbs !== null) {
        re = new RegExp('(&|^)' + encodeRegExp(encode(crumb)) + '=([^&]*)&?');
        var match = re.exec(sCrumbs);
        if (match) { value = decode(match[1]); }
      }
      return (value !== null && value.length)?value:((typeof defaultValue == 'undefined')?null:defaultValue);
    };

    API.getCookieCrumb = getCookieCrumb;

    deleteCookieCrumb = function(name, crumb, docNode) {
      setCookieCrumb(name, crumb, '', null, docNode);
    };

    API.deleteCookieCrumb = deleteCookieCrumb;
    <%End If 'Crumb%>
  }

  <%End If 'Cookie%>
  <%If bEvent Then%>
  // Events section

  var attachListener, attachDocumentListener, attachWindowListener, detachListener, detachDocumentListener, detachWindowListener;
  var cancelPropagation, cancelDefault, getEventTarget, getEventTargetRelated, getKeyboardKey, getMouseButtons, isEventSupported;
  var normalizedListeners = {}, originalListeners = {}, supportedEvents = {};
  var fnId = 0;

  if (isHostMethod(doc, 'createElement')) {
    isEventSupported = function(eventName, el) {
      eventName = 'on' + eventName;
      var eventKey = eventName + (el && el.tagName || '');

      if (typeof supportedEvents[eventKey] == 'undefined') {
        supportedEvents[eventKey] = true;
        el = el || global.document.createElement('div');
        if (el && isHostMethod(el, 'setAttribute')) {
          if (typeof el[eventName] == 'undefined') {
            el.setAttribute(eventName, 'window.alert(" ");');
            supportedEvents[eventKey] = isHostMethod(el, eventName);
          }
        }
      }
      return supportedEvents[eventKey];
    };
  }

  API.isEventSupported = isEventSupported;
  // These two functions are to clean up leaks created by closures in user code
  // They are attached to the unload event of the window in browsers that do not support addEventListener

  // IE5+ (or any browser that supports attachEvent, but not addEventListener)

  function cleanup() {
    var i = API.attachedListeners.length;
    while (i--) {
      API.attachedListeners[i].el.detachEvent('on' + API.attachedListeners[i].ev, API.attachedListeners[i].fn);
    }
    API.attachedListeners = null;
    //API.eventContexts = null; // Other unload events may fire after this and need their context (attaching unload listeners needs further abstraction)
    global.detachEvent('onunload', cleanup);
  }
  <%If bDOM0 Then%>
  // Legacy (DOM0) browsers

  function cleanupLegacy() {
    var i = API.attachedListeners.length;
    while (i--) {
      API.attachedListeners[i].el['on' + API.attachedListeners[i].ev] = null;
    }
    API.attachedListeners = null;
    //API.eventContexts = null;
    global.onunload = null;
  }
  <%End If 'DOM0%>

  var uniqueTargetHandle = 0;

  function getTargetId(el) {
    if (el.tagName) { // IE document nodes change unique ID's constantly (?)
      return elementUniqueId(el);
    }
    else {
      if (el == global) { return '_apiwin'; } // Don't pollute primary global namespace (window listeners)
      return (el._targetId = el._targetId || ('_api' + uniqueTargetHandle++)); // Use expando for documents
    }
  }

  function addNormalizedListener(el, ev, fnId, fnNormalized, fnOriginal, context) {
    var uid = getTargetId(el);
    if (!normalizedListeners[uid]) { normalizedListeners[uid] = {}; }
    if (!normalizedListeners[uid][ev]) { normalizedListeners[uid][ev] = {}; }
    normalizedListeners[uid][ev][fnId] = fnNormalized;
    originalListeners[fnId] = { fn:fnOriginal, context:context };
  }

  function getNormalizedListener(el, ev, fnId) {
    var uid = getTargetId(el);
    return (normalizedListeners[uid] && normalizedListeners[uid][ev] && normalizedListeners[uid][ev][fnId]);
  }

  function removeNormalizedListener(el, ev, fnId) {
    var uid = getTargetId(el);
    if (normalizedListeners[uid] && normalizedListeners[uid][ev]) {
      normalizedListeners[uid][ev][fnId] = null;
    }
  }
  <%If bDOM0 Then%>
  var fnCombineListener = function(fn1, fn2) { var r1, r2; r1 = fn1(); r2 = fn2(); return (r1 !== false && r2 !== false); };
  function combineNormalizedListeners(el, ev) {
    var fn, index, listeners, uid = getTargetId(el);
    if (normalizedListeners[uid] && normalizedListeners[uid][ev]) {
      listeners = normalizedListeners[uid][ev];
      for (index in listeners) {
        if (isOwnProperty(listeners, index) && listeners[index]) {
          fn = (fn)?fnCombineListener(listeners[index], fn):listeners[index];
        }
      }
    }
    return fn || null;
  }
  <%End If 'DOM0%>
  API.eventContexts = []; // Keeps normalized event closures clean of DOM references
  var eventContextHandle = 0;

  var attachListenerFactory = function(d) {
    return (function() {
      var normalizeFunction = (function() {
        if (Function.prototype.call) {
          return function(fn, handle) {
            return function(e) { return fn.call(API.eventContexts[handle].context, e || API.eventContexts[handle].globalContext.event); };
          };
        }
        else {    
          return function(fn, handle) {
            return function(e) { var context = API.eventContexts[handle].context; context.__mylibevent = fn; var r = context.__mylibevent(e || API.eventContexts[handle].globalContext.event); context.__mylibevent = null; return r; };
          };
        }
      })();

      var attach;
      if (isHostMethod(d, 'addEventListener')) {
        return function(d, ev, fn, context) {
          var fnNormalized = (context)?function(e) { return fn.call(context, e); }:fn;
          if (!fn._fnId) {
            fn._fnId = ++fnId;
          }
          addNormalizedListener(d, ev, fn._fnId, fnNormalized, fn, context);
          return d.addEventListener(ev, fnNormalized, false);
        };
      }

      if (isHostMethod(d, 'attachEvent')) {
        attach = function(d, ev, fn, fnNormalized, context) {
          if (!API.attachedListeners) {
            API.attachedListeners = [];
            global.attachEvent('onunload', cleanup);
          }
          addNormalizedListener(d, ev, fn._fnId, fnNormalized, fn, context);
          d.attachEvent('on' + ev, fnNormalized);
          if (!(ev == 'unload' && d == global)) { API.attachedListeners[API.attachedListeners.length] = { el:d, ev:ev, fn:fnNormalized }; }
          d = null;
        };
      }
      <%If bDOM0 Then%>
      else {
        attach = function(d, ev, fn, fnNormalized, context) {
          if (!API.attachedListeners) {
            API.attachedListeners = [];
            global.onunload = (function(oldOnunload) { return function(e) { e = e || global.event; if (typeof oldOnunload == 'function') { oldOnunload(e); } cleanupLegacy(e); }; })(global.onunload);
          }
          addNormalizedListener(d, ev, fn._fnId, fnNormalized, fn, context);
          d['on' + ev] = combineNormalizedListeners(d, ev);
          if (!(ev == 'unload' && d == global)) { API.attachedListeners[API.attachedListeners.length] = { el:d, ev:ev }; }
          d = null;
        };
      }
      <%End If 'DOM0%>

      if (attach) {
      return function(d, ev, fn, context) {
        var globalContext, docNode = getElementDocument(d);
        if ((docNode || d) == global.document) {
          globalContext = global;
        }
        else {
          if (getDocumentWindow) {
            globalContext = (docNode && getDocumentWindow(docNode)) || getDocumentWindow(d) || d; // element, document or window
          }
        }
        if (globalContext) {
          API.eventContexts[eventContextHandle] = { context:context || d, globalContext:globalContext };
          var fnNormalized = normalizeFunction(fn, eventContextHandle++);
          if (!fn._fnId) {
            fn._fnId = ++fnId;
          }
          if (!getNormalizedListener(d, ev, fn._fnId)) {
            attach(d, ev, fn, fnNormalized, context);
          }
          return true;
        }
        return false;
      };
      }
    })();
  };

  var detachListenerFactory = function(d) {
     var detach = (function() {
       if (isHostMethod(d, 'removeEventListener')) {
         return function(d, ev, fn) {
           d.removeEventListener(ev, fn, false);
         };
       }
       if (isHostMethod(d, 'detachEvent')) {
         return function(d, ev, fn) {
           d.detachEvent('on' + ev, fn);
         };
       }
       <%If bDOM0 Then%>
       return function(d, ev, fn) {
         d['on' + ev] = combineNormalizedListeners(d, ev);
       };
       <%End If 'DOM0%>
     })();
     if (detach) {
       return function(d, ev, fn) {
         var fnNormalized;
         if (fn._fnId) {
           fnNormalized = getNormalizedListener(d, ev, fn._fnId);
           if (fnNormalized) {
             removeNormalizedListener(d, ev, fn._fnId);
             detach(d, ev, fnNormalized);
           }
         }
         else {
           detach(d, ev, fn);
         }
       };
     }
  };

  function attachSpecificListenerFactory(obj) {
    var fnAttach = attachListenerFactory(obj);
    return fnAttach && function(ev, fn, objAlt, context) { return fnAttach(objAlt || obj, ev, fn, context); };
  }

  function detachSpecificListenerFactory(obj) {
    var fnDetach = detachListenerFactory(obj);
    return fnDetach && function(ev, fn, objAlt) { return fnDetach(objAlt || obj, ev, fn); };
  }

  if (attachListenerFactory) {

  if (html) {
    attachListener = attachListenerFactory(html);
    if (attachListener) { detachListener = detachListenerFactory(html); }

    API.attachListener = attachListener;
    API.detachListener = detachListener;
  }

  if (doc) {
    attachDocumentListener = attachSpecificListenerFactory(doc);
    if (attachDocumentListener) { detachDocumentListener = detachSpecificListenerFactory(doc); }

    API.attachDocumentListener = attachDocumentListener;
    API.detachDocumentListener = detachDocumentListener;
  }

  attachWindowListener = attachSpecificListenerFactory(this);
  if (attachWindowListener) { detachWindowListener = detachSpecificListenerFactory(this); }

  }

  API.attachWindowListener = attachWindowListener;
  API.detachWindowListener = detachWindowListener;
  <%If bSetAttribute Or bHTML Then%>
  // Called when outerHTML replaces an element (e.g. setting inner HTML of a select or the type or name attribute of an input in IE)
  // Attaches all listeners from the old (and now orphaned) element to the replacement

  transferListeners = function(elFrom, elTo) {
    var index, j, original, uid = elementUniqueId(elFrom), uidTo = elementUniqueId(elTo), nl = normalizedListeners[uid];

    if (nl && uid != uidTo) { // Second check for safety
      for (index in nl) {
        if (isOwnProperty(nl, index)) {
          for (j in nl[index]) {
            if (isOwnProperty(nl[index], j) && nl[index][j]) {
              original = originalListeners[j];
              if (original) {
                detachListener(elFrom, index, original.fn);
                attachListener(elTo, index, original.fn, original.context);
              }
            }            
          }
        }
      }
    }
  };
  <%End If%>
  purgeListeners = function(el, bChildren, bChildrenOnly) {
    var index, j, original, uid = elementUniqueId(el), nl = normalizedListeners[uid];

    if (!bChildrenOnly) {
      if (nl) {
        for (index in nl) {
          if (isOwnProperty(nl, index)) {
            for (j in nl[index]) {
              if (isOwnProperty(nl[index], j) && nl[index][j]) {
                original = originalListeners[j];
                if (original) {
                  detachListener(el, index, original.fn);
                }
              }            
            }
          }
        }
      }
    }
    if (bChildren && el.childNodes) {
      index = el.childNodes.length;
      while (index--) {
        if (el.childNodes[index].nodeType == 1) { purgeListeners(el.childNodes[index], true); }
      } 
    }
  };

  API.purgeListeners = purgeListeners;
  <%If bContextClick Or bHelp Or bMousewheel Or bRollover Or bDrag Then%>
  var callInContext = (function() {
    if (Function.prototype.call) {
      return function(fn, context, arg1, arg2) {
        return fn.call(context, arg1, arg2);
      };
    }
    return function(fn, context, arg1, arg2) {
      context.__mylibevent = fn;
      var r = context.__mylibevent(arg1, arg2);
      context.__mylibevent = null;
      return r;
    };
  })();
  <%End If%>
  <%If bContextClick Or bHelp Or bMousewheel Or bRollover Then%>
  var assistedEvents = {}, assistedEventListeners = {};

  function hasAssistedEventListeners(el, ev) {
    var uid = elementUniqueId(el);
    return !!(assistedEventListeners[uid] && assistedEventListeners[uid][ev]);
  }

  function addAssistedEventListeners(el, ev, listeners) {
    var uid = elementUniqueId(el);
    assistedEventListeners[uid] = assistedEventListeners[uid] || {};
    if (!assistedEventListeners[uid][ev]) {
      assistedEventListeners[uid][ev] = listeners;
      return true;
    }
    return false;
  }

  function removeAssistedEventListeners(el, ev) {
    var listeners, uid = elementUniqueId(el);
    if (assistedEventListeners[uid] && assistedEventListeners[uid][ev]) {
      listeners = assistedEventListeners[uid][ev];
      assistedEventListeners[uid][ev] = null;
    }
    return listeners;
  }

  function detachAssistedEventListeners(el, ev) {
    var index, listeners = removeAssistedEventListeners(el, ev);
    if (listeners) {
      for (index in listeners) {
        if (isOwnProperty(listeners, index)) {
          detachListener(el, index, listeners[index]);
        }
      }
    }
  }

  <%End If%>
  <%If bContextClick Then%>
  var attachContextClickListener, contextClickListenerFactory, contextEventType, detachContextClickListener;
  <%End If%>
  <%If bMousewheel Then%>
  var attachMousewheelListener, detachMousewheelListener, getMousewheelDelta, mousewheelListenerFactory;
  <%End If%>
  <%If bHelp Then%>
  var attachHelpListener, detachHelpListener, helpEventType;
  <%End If%>
  <%If bRollover Then%>
  var attachRolloverListeners, detachRolloverListeners, rolloverStatus, rolloverListener, rolloverListenerWithParentCheck;
  <%End If%>
  // Event normalization
  if (attachListener) {
    getKeyboardKey = function(e) {
      return (e.type == 'keypress')?e.charCode || e.keyCode || e.which:e.which || e.keyCode;
    };

    API.getKeyboardKey = getKeyboardKey;

    cancelPropagation = function(e) {
      if (e.stopPropagation) { e.stopPropagation(); } else { e.cancelBubble = true; }
    };

    API.cancelPropagation = cancelPropagation;

    cancelDefault = function(e) {
      if (e.preventDefault) { e.preventDefault(); }
      if (global.event) { global.event.returnValue = false; }
      return false;
    };

    API.cancelDefault = cancelDefault;

    getMouseButtons = function(e) {
      var b = {};
      if (typeof e.which != 'undefined') {
        b.left = (e.which == 1);
        b.middle = (e.which == 2);
        b.right = (e.which == 3);
      }
      else {
        b.left = (e.button & 1);
        b.middle = (e.button & 4);
        b.right = (e.button & 2);
      }
      return b;
    };

    API.getMouseButtons = getMouseButtons;

    getEventTarget = function(e) {
      return (e.target)?((e.target.nodeType == 3)?e.target.parentNode:e.target):e.srcElement;
    };

    API.getEventTarget = getEventTarget;

    getEventTargetRelated = function(e) {
      if (e.relatedTarget) { return (e.relatedTarget.nodeType == 3)?e.relatedTarget.parentNode:e.relatedTarget; }
      if (e.srcElement) {
        if (e.srcElement == e.fromElement) { return e.toElement; }
        if (e.srcElement == e.toElement) { return e.fromElement; }
      }
      return null;
    };

    API.getEventTargetRelated = getEventTargetRelated;
    <%If bContextClick Or bHelp Or bMousewheel Then%>
    // Assisted events
    <%End If%>
    <%If bContextClick Then%>
    contextClickListenerFactory = function(fn) {
      return function(e) {
        if ((getMouseButtons(e).right || e.type == 'contextmenu')) {
          if (typeof contextEventType == 'undefined') { contextEventType = e.type; }
          if (contextEventType == e.type) { callInContext(fn, this, e); }
          return cancelDefault(e);
        }
      };
    };

    attachContextClickListener = (function() {
      function attach(el, fn, context) {
        if (!hasAssistedEventListeners(el, 'contextclick')) {
	  attachListener(el, 'mouseup', fn, context);
          attachListener(el, 'contextmenu', fn, context);
          addAssistedEventListeners(el, 'contextclick', { mouseup:fn, contextmenu:fn });
        }
      }
      return function(el, fn, context) {
        attach(el, contextClickListenerFactory(fn), context);
      };
    })();

    detachContextClickListener = function(el, fn) {
      detachAssistedEventListeners(el, 'contextclick');
    };

    assistedEvents.ContextClick = { attach:attachContextClickListener, detach:detachContextClickListener };
    API.attachContextClickListener = attachContextClickListener;
    API.detachContextClickListener = detachContextClickListener;
    <%End If%>
    <%If bMousewheel Then%>

    getMousewheelDelta = function(e) {
      return (e.detail)?-(e.detail) / 3:e.wheelDelta / 120;
    };

    API.getMousewheelDelta = getMousewheelDelta;

    mousewheelListenerFactory = function(fn) {
      return function(e) {
        callInContext(fn, this, e, getMousewheelDelta(e));
        return cancelDefault(e);
      };
    };

    //if (!isEventSupported || isEventSupported('DOMMouseScroll') || isEventSupported('mousewheel')) {
      attachMousewheelListener = (function() {
        function attach(el, fn, context) {
          if (!hasAssistedEventListeners(el, 'mousewheel')) {
            attachListener(el, 'mousewheel', fn, context);
            attachListener(el, 'DOMMouseScroll', fn, context);
            addAssistedEventListeners(el, 'mousewheel', { mousewheel:fn, DOMMouseScroll:fn });
          }
        }
        return function(el, fn, context) {
          attach(el, mousewheelListenerFactory(fn), context);
        };
      })();
    
      detachMousewheelListener = function(el) {
        detachAssistedEventListeners(el, 'mousewheel');
      };

      assistedEvents.Mousewheel = { attach:attachMousewheelListener, detach:detachMousewheelListener };
    //}
    API.attachMousewheelListener = attachMousewheelListener;
    API.detachMousewheelListener = detachMousewheelListener;
    <%End If%>
    <%If bHelp Then%>
    attachHelpListener = function(el, fn, context) {
      var fn1, fn2;
      if (!hasAssistedEventListeners(el, 'help')) {
        fn1 = function(e) {
          helpEventType = helpEventType || 'help';
          if (helpEventType == 'help') { callInContext(fn, this, e); }
          return cancelDefault(e);
        };
        fn2 = function(e) {
          helpEventType = helpEventType || 'keydown';
          if (getKeyboardKey(e) == 112) { if (helpEventType == 'keydown') { callInContext(fn, this, e); } return cancelDefault(e); }
        };
        attachListener(el, 'help', fn1, context);
        attachListener(el, 'keydown', fn2, context);
        addAssistedEventListeners(el, 'help', { help:fn1, keydown:fn2 });
      }
    };

    detachHelpListener = function(el, fn) {
      detachAssistedEventListeners(el, 'help');
    };

    assistedEvents.Help = { attach:attachHelpListener, detach:detachHelpListener };

    API.attachHelpListener = attachHelpListener;
    API.detachHelpListener = detachHelpListener;
    <%End If%>
    <%If bRollover Then%>
    if (typeof setStatus != 'undefined') {
      rolloverStatus = function(el, b) { return (b && el.title)?setStatus(el.title):setStatus(''); };
    }

    rolloverListener = function(fnOver, fnOut, bSetStatus, el) {
      return function(e) {
        var over = e.type == 'mouseover' || e.type == 'focus';
        callInContext((over)?fnOver:fnOut, this, e);
        if (bSetStatus && rolloverStatus) { rolloverStatus(el, over); }
      };
    };

    rolloverListenerWithParentCheck = function(fnOver, fnOut, bSetStatus, el) {
      return function(e) {
        var relatedTarget = getEventTargetRelated(e);
        var target = getEventTarget(e);
        var over = e.type == 'mouseover' || e.type == 'focus';	
        var isAncestorOfRelatedTarget = el != relatedTarget && (relatedTarget && isDescendant(el, relatedTarget));
        var isAncestorOfTarget = target && el != target && isDescendant(el, target);
        if (isAncestorOfRelatedTarget && isAncestorOfTarget) {
          return;
        }
        if (relatedTarget == el && isAncestorOfTarget || target == el && isAncestorOfRelatedTarget) {
          return;
        }
        callInContext((over)?fnOver:fnOut, this, e);
        if (bSetStatus && rolloverStatus) { rolloverStatus(el, over); }
      };
    };

    if (isDescendant) {
    attachRolloverListeners = function(el, fnOver, fnOut, context, bAddFocusListeners, bSetStatus) {
      var listener = (typeof getEBTN != 'undefined' && getEBTN('*', el).length)?rolloverListenerWithParentCheck(fnOver, fnOut, bSetStatus, el):rolloverListener(fnOver, fnOut, bSetStatus, el);
      var listeners = { mouseover:listener, mouseout:listener };
      attachListener(el, 'mouseover', listener, context);
      attachListener(el, 'mouseout', listener, context);
      if (bAddFocusListeners) {
        attachListener(el, 'focus', listener, context);
        attachListener(el, 'blur', listener, context);
        listeners.focus = listeners.blur = listener;
      }
      addAssistedEventListeners(el, 'roll', listeners);
    };

    API.attachRolloverListeners = attachRolloverListeners;

    detachRolloverListeners = function(el, fn) {
      detachAssistedEventListeners(el, 'roll');
    };

    API.detachRolloverListeners = detachRolloverListeners;
    }
    <%End If%>
  }
  <%End If 'Event%>
  var getBodyElement, getContainerElement;
  <%If bStyle Then%>
  <%If bPresent Then%>
  var defaultDisplay, presentElement, toggleElementPresence;
  <%End If%>
  <%If bShow Then%>
  var showElement, toggleElement;
  <%End If%>
  <%If bPosition Then%>
  var getElementPositionStyle;
  <%End If%>
  <%If bSize Then%>
  var getElementSizeStyle;
  <%End If%>
  <%End If 'Style%>
  <%If bScroll Then%>
  var getScrollPosition, getScrollPositionMax, getElementScrollPosition, getElementScrollPositionMax, setScrollPosition, setElementScrollPosition;
  <%End If%>
  <%If bViewport Then%>
  var getScrollElement, getViewportSize, getViewportClientRectangle, getViewportScrollRectangle, getViewportScrollSize;
  <%End If%>
  <%If bDispatch Then%>
  var fireEvent;
  <%End If%>
  <%If bMousePosition Then%>
  var getMousePosition;
  <%End If%>
  <%If bDirectX Then%>
  var applyDirectXTransitionFilter, playDirectXTransitionFilter;
  <%End If%>
  <%If bImport Then%>
  var addElementNodes, importNode, setElementNodes;
  <%End If%>
  <%If bSize Then%>
  var ensureSizable;
  <%End If%>
  <%If bAdjacent Or bDrag Or bRegion Then%>
  var contained = function(pos1, dim1, pos2, dim2) {
    return ((pos1[0] >= pos2[0]) && (pos1[0] <= pos2[0] + dim2[0]) && (pos1[1] >= pos2[1]) && (pos1[1] <= pos2[1] + dim2[1]) && (pos1[0] + dim1[0] <= pos2[0] + dim2[0]) && (pos1[1] + dim1[1] <= pos2[1] + dim2[1]));
  };
  var overlaps = function(pos1, dim1, pos2, dim2) {
    return (((pos1[1] >= pos2[1]) && (pos1[1] <= pos2[1] + dim2[1])) || ((pos1[1] < pos2[1]) && (pos1[1] + dim1[1] > pos2[1]))) && (((pos1[0] >= pos2[0]) && (pos1[0] <= pos2[0] + dim2[0])) || ((pos1[0] < pos2[0]) && (pos1[0] + dim1[0] > pos2[0])));
  };	
  <%End If%>
  <%If bDrag Or bAdjacent Or bMaximize Or bFullScreen Then%>
  var constrainPosition = function(c, co, dim, constraint) {
    if (co[0] < constraint[0]) { c[0] += (constraint[0] - co[0]); }
    if (co[1] < constraint[1]) { c[1] += (constraint[1] - co[1]); }
    if (co[0] + dim[0] > constraint[0] + constraint[2]) { c[0] += (constraint[0] + constraint[2] - (co[0] + dim[0])); }
    if (co[1] + dim[1] > constraint[1] + constraint[3]) { c[1] += (constraint[1] + constraint[3] - (co[1] + dim[1])); }
  };
  <%End If%>
  <%If bDrag And bSize Then%>
  var constrainSize = function(c, co, pos, constraint) {
    if (co[0] + pos[0] > constraint[0] + constraint[2]) { c[0] += (constraint[0] + constraint[2] - (co[0] + pos[0])); }
    if (co[1] + pos[1] > constraint[1] + constraint[3]) { c[1] += (constraint[1] + constraint[3] - (co[1] + pos[1])); }
  };
  <%End If%>
  <%If bRegion Then%>
  var elementContained, elementContainedInElement, elementOverlaps, elementOverlapsElement;
  <%End If%>
  <%If bOffset And bPosition And bSize Then%>
  var absoluteElement, ensurePositionable, getElementPositionedChildPosition, relativeElement;
  <%If bAdjacent Then%>
  var adjacentElement;
  <%End If%>
  <%If bOverlay Then%>
  var overlayElement;
  <%End If%>
  <%End If%>
  <%If bCenter Then%>
  var centerElement;
  <%End If%>
  <%If bCenter Or bMaximize Then%>
  var getWorkspaceRectangle;
  <%End If%>
  <%If (bCenter And bSize) Or bMaximize Then%>
  var addSideBarDocument, adjustFixedPosition, arrangeSideBars, autoHideRollover, autoHideRolloutListener, autoHideRolloverListener, autoHideSideBar, changeSideBarSide, constrainElementPositionToViewport, constrainPositionToViewport, getAutoHideRectangle, showSideBar, sideBar, unSideBar;
  <%End If%>
  <%If bMaximize Then%>
  var maximize, maximizeElement, restoreElement;
  <%End If%>
  <%If bFullScreen Then%>
  var fullScreenElement;
  <%End If%>
  <%If bCoverDocument Then%>
  var coverDocument;
  <%End If%>
  <%If bOffset Then%>
  var getElementPosition;
  <%End If%>
  <%If bFX Then%>
  var effects, spring;
  <%End If%>
  <%If bDrag Then%>
  var attachDrag, detachDrag, initiateDrag, attachedDrag = {};
  <%End If%>
  if (attachDocumentReadyListener) {
    attachDocumentReadyListener(function() {
      var body, containerElement;

      getBodyElement = function(docNode) {
        docNode = docNode || global.document;
        if (isRealObjectProperty(docNode, 'body')) { return docNode.body; }
        if (typeof getEBTN == 'function') { return getEBTN('body', docNode)[0] || null; }
        return null;
      };

      API.getBodyElement = getBodyElement;

      body = getBodyElement();

      // Returns documentElement or body as best deemed appropriate
      // Result is ambiguous in all but modern browsers, so don't assume too much from it.
      getContainerElement = function(docNode) {
        docNode = docNode || global.document;
        return (docNode.documentElement && (!docNode.compatMode || docNode.compatMode.indexOf('CSS') != -1))?docNode.documentElement:getBodyElement(docNode);
      };

      API.getContainerElement = getContainerElement;

      containerElement = getContainerElement();
      <%If bSize Then%>
      var computedSizeBad;
      <%End If%>
      <%If bPosition Then%>
      var computedPositionBad;
      <%End If%>
      <%If bSize Or bPosition Then%>
      var div, div2;
      <%End If%>
      <%If bScroll Then%>
      // Scroll section

      function normalizeScroll(t, l, p) {
        if (t) {
          if (t > p[0]) { t = p[0]; }
          if (t < 0) { t = 0; }
        }
        if (l) {
          if (l > p[1]) { l = p[1]; }
          if (l < 0) { l = 0; }
        }
        return [t, l];
      }

      function findWindow(docNode) {        
        if (!docNode || docNode == global.document) {
          return global;
        }
        return (getDocumentWindow)?getDocumentWindow(docNode):null;
      }
		
      getScrollPosition = (function() {
        if (typeof global.pageXOffset == 'number') {
          return function(docNode) {
            var win = findWindow(docNode);
            return (win)?[win.pageYOffset, win.pageXOffset]:null;
          };
        }

        function findScroll(o) {
          return (o && (o.scrollTop || o.scrollLeft)) && (getScrollPosition = API.getScrollPosition = function() { return [o.scrollTop, o.scrollLeft]; })();
        }

        function findScrollChanged(o, docNode) {
          return (o.scrollTop != docNode._scrollPositionSetLast[0] || o.scrollLeft != docNode._scrollPositionSetLast[1]) && (getScrollPosition = API.getScrollPosition = function() { return [o.scrollTop, o.scrollLeft]; })();
        }

        if (global.document.expando || typeof global.document.expando == 'undefined') {
          return function(docNode) {
            var b = getBodyElement(docNode);
            var c = getContainerElement(docNode);

            docNode = docNode || global.document;
            if (!docNode._scrollPositionSetLast) {
              docNode._scrollPositionSetLast = [];
            }
            return ((typeof docNode._scrollPositionSetLast[0] == 'number' && (findScrollChanged(c, docNode) || findScrollChanged(b, docNode))) || findScroll(docNode.documentElement) || findScroll(b)) || [0, 0];
          };
        }
      })();

      API.getScrollPosition = getScrollPosition;

      setScrollPosition = (function() {
        var pos, sp;

        var scroll = (function() {
          if (isHostMethod(global, 'scrollTo')) {
            return function(t, l, docNode) {
              var win = arguments[3] || findWindow(docNode); // Fourth argument is for internal optimization (scrolling effects)

              if (win) { win.scrollTo(pos[1], pos[0]); }
            };
          }
          // Ambiguous branch for agents that do not support window.scrollTo
          if (global.document.expando || typeof global.document.expando == 'undefined') {
            if ((containerElement && typeof containerElement.scrollTop == 'number') || (body && typeof body.scrollTop == 'number')) {
              return function(t, l, docNode) {
                var b = getBodyElement(docNode);
                var c = getContainerElement(docNode);

                docNode = docNode || global.document;
                if (!docNode._scrollPositionSetLast) {
                  docNode._scrollPositionSetLast = [];
                }
                if (b) { // b implies c
                  c.scrollTop = b.scrollTop = docNode._scrollPositionSetLast[0] = t;
                  c.scrollLeft = b.scrollLeft = docNode._scrollPositionSetLast[1] = l;
                }
              };
            }
          }				
        })();
        if (scroll) {
          return function(t, l, docNode, isNormalized) {
            pos = (!getScrollPositionMax || isNormalized || (!t && !l))?[t, l]:normalizeScroll(t, l, getScrollPositionMax(docNode));
            if (pos[0] === null || pos[1] === null) {
              sp = getScrollPosition(docNode);
              if (pos[0] === null) { pos[0] = sp[0]; }
              if (pos[1] === null) { pos[1] = sp[1]; }
            }
            scroll(pos[0], pos[1]);
          };
        }
      })();

      API.setScrollPosition = setScrollPosition;

      getScrollPositionMax = (function() {
        if (typeof global.scrollMaxX != 'undefined') {
          return function(docNode) {
            var win = findWindow(docNode);
            return (win)?[win.scrollMaxY, win.scrollMaxX]:null;
          };
        }
      })();

      API.getScrollPositionMax = getScrollPositionMax;

      getElementScrollPosition = function(el) {
        return [el.scrollTop || 0, el.scrollLeft || 0];
      };

      API.getElementScrollPosition = getElementScrollPosition;

      setElementScrollPosition = function(el, t, l, isNormalized) {
        var pos = (isNormalized || (!t && !l))?[t, l]:normalizeScroll(t, l, getElementScrollPositionMax(el));
        if (pos[0] !== null) { el.scrollTop = pos[0]; }
        if (pos[1] !== null) { el.scrollLeft = pos[1]; }
      };

      API.setElementScrollPosition = setElementScrollPosition;

      getElementScrollPositionMax = function(el) {
        var d = getElementSize(el);
        return [d[4] - d[2], d[5] - d[3]];
      };

      <%End If 'Scroll%>
      <%If bViewport Then%>
      // Viewport section

      getScrollElement = function(docNode) {
        docNode = docNode || global.document;
        var body = getBodyElement(docNode);
        var se = getContainerElement(docNode);

        if (body && se != body && se.clientWidth === 0 && typeof body.scrollWidth == 'number') { // IE5.x
          se = body;
        }
        return se;
      };

      API.getScrollElement = getScrollElement;

      getViewportSize = (function() {
        var containerElement = getScrollElement();
        var scrollbarThickness = 0;
        var viewportClientIncludesBorders, viewportClientIncludesMargins, containerClientHeightIsDocumentHeight;

        // Experimental simplified replacement is at http://www.cinsoft.net/viewport.asp

        if (typeof global.window.document.clientHeight == 'number') {
          return function(win) {
            win = win || global; return [win.document.clientHeight, win.document.clientWidth];
          };
        }

        if (containerElement && typeof containerElement.clientHeight != 'undefined' && containerElement.clientHeight) {
          return function(win) {
            win = win || global;
            var cb, cm; // Container element borders and margins
            var containerElement = getScrollElement(win.document); // Changed from getContainerElement to fix IE5
            var containerClientWidth = containerElement.clientWidth;

            if (typeof getElementBorders == 'function') {
              cb = getElementBorders(containerElement);
              if (cb) {
                containerClientWidth += cb.Left + cb.Right;
              }
            }
            if (typeof getElementMargins == 'function') {
              cm = getElementMargins(containerElement);
            }

            var clientWidth, clientHeight, scrollbarHorizontalPresent;
            var globalInnerWidth = global.innerWidth;
            var containerWidthWithoutScrollbar = containerClientWidth;

            // Can only detect viewport width includes container margins if vertical scrollbar is present
            // As designed, test doesn't matter if vertical scrollbar is not present
            if (cm && (cm.Left || cm.Right)) {
              if (!viewportClientIncludesMargins) { viewportClientIncludesMargins = ((cm.Left || cm.Right) && containerClientWidth == containerElement.offsetWidth && containerElement.offsetWidth != globalInnerWidth); }
              if (viewportClientIncludesMargins) { containerWidthWithoutScrollbar += cm.Left + cm.Right; }
            }
            if (!scrollbarThickness && globalInnerWidth && globalInnerWidth > containerWidthWithoutScrollbar) { scrollbarThickness = globalInnerWidth - containerWidthWithoutScrollbar; }
            viewportClientIncludesBorders = !((containerElement.offsetWidth || 0) - containerClientWidth);
            clientWidth = containerElement.clientWidth;
            if (viewportClientIncludesBorders && cb && (cb.Left || cb.Right)) {
              clientWidth += cb.Left + cb.Right;
            }
            if (viewportClientIncludesMargins && cm && (cm.Left || cm.Right)) {
              clientWidth += cm.Left + cm.Right;
            }
            clientHeight = containerElement.clientHeight;
            if (viewportClientIncludesBorders && cb && (cb.Top || cb.Bottom)) {
              clientHeight += cb.Top + cb.Bottom;
            }
            if (viewportClientIncludesMargins && cm && (cm.Top || cm.Bottom)) {
              clientHeight += cm.Top + cm.Bottom;
            }
            scrollbarHorizontalPresent = !(scrollbarThickness && containerElement.scrollWidth - clientWidth <= scrollbarThickness);
            containerClientHeightIsDocumentHeight = ((cb)?cb.Top + cb.Bottom:0) + ((cm)?cm.Top + cm.Bottom:0) + containerElement.clientHeight == containerElement.scrollHeight;

            if (containerClientHeightIsDocumentHeight && !scrollbarThickness && containerClientWidth > globalInnerWidth) {
               var body = getBodyElement(win.document);
               return [body.clientHeight, containerElement.clientWidth];           
            }

            return [(win.innerHeight && scrollbarThickness && ((containerClientHeightIsDocumentHeight || ((scrollbarHorizontalPresent) && win.innerHeight - clientHeight >= scrollbarThickness))))?(win.innerHeight - ((scrollbarHorizontalPresent)?scrollbarThickness:0)):clientHeight, clientWidth];
          };
        }

        // Includes scrollbars if present
		
        if (typeof global.innerHeight != 'undefined') {
          return function(win) {
            win = win || global; return [win.innerHeight, win.innerWidth];
          };
        }
      })();

      API.getViewportSize = getViewportSize;
      <%End If 'Viewport%>
      <%If bViewport Or bOffset Then%>
      var htmlOffsetsOrigin, html = getHtmlElement();
      var viewportToHtmlOrigin, htmlToViewportOrigin;

      if (html && isHostMethod(global.document, 'getBoxObjectFor') && typeof getElementBordersOrigin == 'function' && typeof getElementMarginsOrigin == 'function') {
        (function() {
          var m = getElementMarginsOrigin(html);
          var b = getElementBordersOrigin(html);

          var rect = global.document.getBoxObjectFor(html);

          if (!rect) { return; } // Embedded Gecko browsers

          if ((m[0] || m[1] || b[0] || b[1]) && (rect.y == m[0] + b[0] && rect.x == m[1] + b[1])) { // Gecko
            htmlOffsetsOrigin = function(docNode) {
              var x, y;
              var html = getHtmlElement(docNode);
              var borders = getElementBordersOrigin(html);
              var margins = getElementMarginsOrigin(html);
              y = borders[0] + margins[0];
              x = borders[1] + margins[1];
              return [y, x];
            };
          }
          else { // Mozilla
            if (rect.x || rect.y) {
              htmlOffsetsOrigin = function(docNode) {
                docNode = docNode || global.document;
                var html = getHtmlElement(docNode);
                var rect = docNode.getBoxObjectFor(html);
                return [rect.x, rect.y];
              };
            }			
          }

          if (htmlOffsetsOrigin) {
            viewportToHtmlOrigin = function(pos, docNode) {
              var o = htmlOffsetsOrigin(docNode);
              o[0] += pos[0];
              o[1] += pos[1];
              return o;
            };

            htmlToViewportOrigin = function(pos, docNode) {
              var o = htmlOffsetsOrigin(docNode);
              o[0] = pos[0] - o[0];
              o[1] = pos[1] - o[1];
              return o;
            };

            API.viewportToHtmlOrigin = viewportToHtmlOrigin;
            API.htmlToViewportOrigin = htmlToViewportOrigin;
          }
        })();
      }
      <%End If 'Viewport or Offset%>
      <%If bViewport Then%>
      var getTopRenderedElement = function(docNode) {
         var se = getHtmlElement(docNode);
         if (!se || se.clientWidth === 0) {
           se = getBodyElement(docNode);
         }
         return se;
      };

      var scrollElement = getTopRenderedElement();
      if (scrollElement) {
      getViewportScrollSize = (function() {
        var cm, addMargin;
        if (typeof getElementMarginsOrigin == 'function') {
          cm = getElementMarginsOrigin(containerElement);
          // IE quirk with scrollWidth/Height + HTML element margin
          addMargin = (scrollElement.offsetWidth == cm[0] + scrollElement.scrollWidth);
        }

        if (typeof scrollElement.scrollWidth != 'undefined') {			
          return function(docNode) {
            var se = getTopRenderedElement(docNode);
            return [se.scrollHeight + ((addMargin)?cm[0]:0), se.scrollWidth + ((addMargin)?cm[1]:0)];
          };
        }
        if (typeof global.document.width != 'undefined') {
          return function(docNode) {
            docNode = docNode || global.document;
            return [docNode.height, docNode.width];
          };
        }
        if (typeof scrollElement.offsetWidth != 'undefined') {
          return function(docNode) {
            var ce = getTopRenderedElement(docNode);
            return [ce.offsetHeight, ce.offsetWidth];
          };
        }
      })();

      API.getViewportScrollSize = getViewportScrollSize;

      if (getViewportScrollSize) {
        getViewportScrollRectangle = function(docNode) {
          var rect, r = [0, 0];
          var d = getViewportScrollSize(docNode);
          var body = getBodyElement(docNode);
          var html = getHtmlElement(docNode);
          if (htmlToViewportOrigin) {
            r = htmlToViewportOrigin(r, docNode);
          }
          // Adjustment for Mozilla with body margin
          docNode = docNode || global.document;
          if (isHostMethod(docNode, 'getBoxObjectFor') && docNode.width && body && typeof body.clientWidth == 'undefined') {
            rect = docNode.getBoxObjectFor(html);
            if (rect && rect.width && rect.width != docNode.width) {
              d[0] += (rect.height - body.offsetHeight);
              d[1] += (rect.width - body.offsetWidth);
            }
          }				
          r[2] = d[0];
          r[3] = d[1];
          return r;
        };

        API.getViewportScrollRectangle = getViewportScrollRectangle;
        }
      }
      <%If bScroll Then%>
      if (!getScrollPositionMax && getViewportScrollSize && getDocumentWindow) {
        getScrollPositionMax = function(docNode) {
          var sp = getViewportScrollSize(docNode);
          var v = getViewportSize(getDocumentWindow(docNode));
          //var se = getScrollElement(docNode);

          //sp[0] -= se.clientHeight;
          //sp[1] -= se.clientWidth;
          sp[0] -= v[0];
          sp[1] -= v[1];
          return sp;
        };
        API.getScrollPositionMax = getScrollPositionMax;
      }
      <%End If 'Scroll%>
      if (typeof getDocumentWindow == 'function') {
        getViewportClientRectangle = function(docNode) {
          var r;
          var sp = (typeof getScrollPosition == 'function')?getScrollPosition(docNode):[0, 0];
          r = [sp[0], sp[1]];
          if (htmlToViewportOrigin) { r = htmlToViewportOrigin(r, docNode); }
          var d = getViewportSize(getDocumentWindow(docNode));
          r[2] = d[0];
          r[3] = d[1];
          return r;
        };
        API.getViewportClientRectangle = getViewportClientRectangle;
      }
      scrollElement = null;
      <%End If 'Viewport%>
      <%If bScroll Then%>
      if (setScrollPosition) {			
        API.setScrollPositionTop = function(docNode, options, fnDone) { setScrollPosition(0, null, docNode, null, options, fnDone); };
        API.setScrollPositionLeft = function(docNode, options, fnDone) { setScrollPosition(null, 0, docNode, null, options, fnDone); };
        if (getScrollPositionMax) {
          API.setScrollPositionBottom = function(docNode, options, fnDone) { setScrollPosition(getScrollPositionMax(docNode)[0], null, docNode, true, options, fnDone); };
          API.setScrollPositionRight = function(docNode, options, fnDone) { setScrollPosition(null, getScrollPositionMax(docNode)[1], docNode, true, options, fnDone); };
        }
	API.setScrollPositionRelative = function(t, l, docNode, options, fnDone) {
          var sp = getScrollPosition(docNode);
          if (t !== null) { t += sp[0]; }
          if (l !== null) { l += sp[1]; }
          setScrollPosition(t, l, docNode, false, options, fnDone);
        };
      }

      API.setElementScrollPositionTop = function(el, options, fnDone) {
        setElementScrollPosition(el, 0, null, null, options, fnDone);
      };

      API.setElementScrollPositionLeft = function(el, options, fnDone) {
        setElementScrollPosition(el, null, 0, null, options, fnDone);
      };

      API.setElementScrollPositionBottom = function(el, options, fnDone) {
        setElementScrollPosition(el, getElementScrollPositionMax(el)[0], null, true, options, fnDone);
      };

      API.setElementScrollPositionRight = function(el, options, fnDone) {
        setElementScrollPosition(el, null, getElementScrollPositionMax(el)[1], true, options, fnDone);
      };

      API.setElementScrollPositionRelative = function(el, t, l, options, fnDone) {
        var sp = getElementScrollPosition(el);
        if (t !== null) { t += sp[0]; }
        if (l !== null) { l += sp[1]; }
        setElementScrollPosition(el, t, l, false, options, fnDone);
      };
      <%End If 'Scroll%>
      <%If bOffset Then%>
      // Offset section

      getElementPosition = (function() {
        var b;
        var scrollerOffsetSubtractsBorder, offsetAbsoluteExcludesBodyBorder, nestedElementsOffsetFromBody, nestedInlineOffsetIncludesScroll, offsetIncludesBorder, offsetIncludesBodyBorder;

        if (typeof isStyleCapable == 'boolean' && isStyleCapable && createElement && body && body.appendChild && body.removeChild) {
          // Feature tests for browser quirks
          var divOuter = createElement('div');
          var divInner = createElement('div');

          if (divInner && divOuter) {
            // Windows Safari indicates false positive for this test
            scrollerOffsetSubtractsBorder = (function() {
              setStyles(divOuter, {position:'absolute', visibility:'hidden', left:'0', top:'0', padding:'0', border:'solid 1px black', 'overflow':'auto'});
              setStyles(divInner, {position:'static', left:'0', top:'0'});
              divOuter.appendChild(divInner);
              body.appendChild(divOuter);
              b = divInner.offsetLeft == -1;
              body.removeChild(divOuter);
              divOuter.removeChild(divInner);
              return b;
            })();

            // Windows Safari oddity
            offsetAbsoluteExcludesBodyBorder = (function() {
              var bbl = getElementBordersOrigin(body)[1];
              if (bbl) {
                body.appendChild(divOuter);
                b = divOuter.offsetLeft == -bbl;
                body.removeChild(divOuter);
                return b;
              }
            })();

            // All but IE
            nestedElementsOffsetFromBody = (function() {
              setStyles(divOuter, {position:'static', height:'0', width:'0', border:'none'});
              setStyles(divInner, {height:'0', width:'0'});
              divOuter.appendChild(divInner);
              body.appendChild(divOuter);
              b = divInner.offsetParent === body;
              body.removeChild(divOuter);
              divOuter.removeChild(divInner);				
              return b;
            })();

            // Opera oddity
            if (isHostMethod(global.document, 'createTextNode')) {
              nestedInlineOffsetIncludesScroll = (function() {
                var span = createElement('span');
                var tn = global.document.createTextNode('Initializing...');
                span.appendChild(tn);
                divInner.appendChild(span);
                setStyles(divOuter, {overflow:'auto'});
                divOuter.appendChild(divInner);
                body.appendChild(divOuter);
                var o = span.offsetTop;
                divOuter.scrollTop = 1;
                b = o != span.offsetTop;
                body.removeChild(divOuter);
                return b;
              })();
            }

            // Opera oddity
            offsetIncludesBorder = (function() {
              setStyles(divOuter, {position:'absolute', visibility:'hidden', left:'0', top:'0', padding:'0', border:'solid 1px'});
              setStyles(divInner, {position:'absolute', left:'0', top:'0', margin:'0'});
              divOuter.appendChild(divInner);
              body.appendChild(divOuter);
              b = divInner.offsetLeft == 1;
              body.removeChild(divOuter);
              divOuter.removeChild(divInner);
              return b;
            })();

            var bodyBorderWidth = getStylePixels(body, 'borderLeftWidth');

            if (bodyBorderWidth) {
              offsetIncludesBodyBorder = (function() {
                divOuter = API.createElement('div');
                setStyles(divOuter, {position:'static', visibility:'hidden', padding:'0', border:'0'});
                if (body.firstChild) {
                  body.insertBefore(divOuter, body.firstChild);
                } else {
                  body.appendChild(divOuter);
                }
                b = divOuter.offsetLeft == bodyBorderWidth;
                body.removeChild(divOuter);
                return b;
              })();
            }

            divInner = divOuter = null;
          }
        }

        function scrollFix(el, body) {
          var scrollerPos, scrollerOverflow, borders, p = [0, 0, 0, 0];
          var pos = getStyle(el, 'position');

          if (pos != 'fixed') { // TODO: Check before calling
            while (el.parentNode && el.parentNode !== body) {
              el = el.parentNode;
              scrollerPos = getStyle(el, 'position') || 'static';
              scrollerOverflow = getStyle(el, 'overflow');
              if (!((scrollerPos == 'static' && pos == 'absolute') || pos == 'fixed')) {
                if ((el.scrollTop || el.scrollLeft) && scrollerOverflow != 'visible') {
                  p[0] -= (el.scrollTop || 0);
                  p[1] -= (el.scrollLeft || 0);
                  if (scrollerOffsetSubtractsBorder) {
                    borders = getElementBordersOrigin(el);
                    p[2] += borders[0];
                    p[3] += borders[1];
                  }
                }
              }
            }
          }
          return p;
        }

        function positionOffset(el, elContainer, noScrollFix) {
          var x = 0, y = 0, body, borders, pos;
          var scrollPos, sf = [0, 0, 0, 0];
          var elOriginal = el;
          var docNode = getElementDocument(el);

          if (docNode) {
            body = getBodyElement(docNode);
          }

          // Fixed position in Opera has no offsetParent
          if (!el.offsetParent && typeof getElementPositionStyle == 'function') {
            return getElementPositionStyle(el, null);
          }

          if (el.offsetParent === body) {
            if (elContainer && nestedElementsOffsetFromBody) {
              var po = positionOffset(elContainer);
              y = -po[0];
              x = -po[1];
            }
          }
          if (elContainer && (offsetIncludesBorder || (nestedElementsOffsetFromBody && el.offsetParent == body))) {
            borders = getElementBordersOrigin(elContainer);
            y -= borders[0];
            x -= borders[1];
          }
          if (typeof getStyle == 'function') {
            var d = getStyle(el, 'display');
            sf = scrollFix(el, body);
            if (noScrollFix) {
              if (nestedInlineOffsetIncludesScroll && d == 'inline') {
                y -= sf[0];
                x -= sf[1];
              }
            }
            else {
              if ((!nestedInlineOffsetIncludesScroll || (!d || d != 'inline'))) {
                y += sf[0];
                x += sf[1];					
              }
            }
            if (scrollerOffsetSubtractsBorder) {
              y += sf[2];
              x += sf[3];
            }
          }

          // TODO: Convert internal typeof checks to resolved references (API.*) as can allow global identifier collisions in partial builds

          if (typeof getStyle == 'function' && docNode && typeof getScrollPosition == 'function') {
            pos = getStyle(el, 'position');

            if (pos == 'fixed') {
              scrollPos = getScrollPosition(docNode);
              x += scrollPos[1];
              y += scrollPos[0];
            }
          }

          do {
            if (el !== body || (el.offsetLeft > 0 && el.offsetTop > 0)) {
              if (el.offsetLeft) { x += el.offsetLeft; }
              if (el.offsetTop) { y += el.offsetTop; }
            }

            if (!offsetIncludesBorder && el !== elOriginal && (!offsetIncludesBodyBorder || el !== body)) {
              b = getElementBordersOrigin(el);
              y += b[0];
              x += b[1];
            }

            if ((pos == 'absolute' || pos == 'fixed') && el.offsetParent === body) {
              if (offsetAbsoluteExcludesBodyBorder) {
                b = getElementBordersOrigin(body);
                y += b[0];
                x += b[1];
              }
              el = null;
            } else {
              el = el.offsetParent;
            }
          }
          while (el && el !== elContainer);
          return [y, x];
        }

        if (isHostMethod(global.document, 'getBoxObjectFor')) {
          return function(el, elContainer, noScrollFix) {
            var pos, borders, parentNode, sf, sp, stylePos;
            var posContainer = (elContainer)?getElementPosition(elContainer):[0, 0];
            var docNode = getElementDocument(el);
            var body = getBodyElement(docNode);
            var rect = docNode.getBoxObjectFor(el);

            if (!rect) { return positionOffset(el, elContainer, noScrollFix); } // Embedded Gecko browsers
				
            pos = [rect.y, rect.x];
            if (typeof getStyle == 'function') {
              parentNode = el;
              while (parentNode && parentNode.nodeType == 1 && stylePos != 'fixed') {
                stylePos = getStyle(parentNode, 'position');
                parentNode = parentNode.parentNode;
              }
              if (stylePos == 'fixed') {
                sp = (typeof getScrollPosition == 'function')?getScrollPosition(docNode):[0, 0];
                pos[0] += sp[0];
                pos[1] += sp[1];
                if (htmlToViewportOrigin) { pos = htmlToViewportOrigin(pos, docNode); }
              }
              else {
                if (!noScrollFix) {
                  sf = scrollFix(el, body);
                  pos[0] += sf[0] + sf[2];
                  pos[1] += sf[1] + sf[3];
                }
              }
            }
            borders = getElementBordersOrigin(el);
            return [pos[0] - borders[0] - posContainer[0], pos[1] - borders[1] - posContainer[1]];
          };
        } 
        if (body && isHostMethod(body, 'getBoundingClientRect')) {
          return function(el, elContainer, noScrollFix) {
            if (elContainer) {
              return positionOffset(el, elContainer, noScrollFix);
            }
            else {
              var x, y;
              var rect = el.getBoundingClientRect();
              var docNode = getElementDocument(el);
              var body = getBodyElement(docNode);
              var ce = getHtmlElement(docNode);
              var sp = [0, 0];

              y = rect.top;				
              x = rect.left;

              if (ce) {
                if (body && ce != body && ce.clientWidth === 0 && typeof body.clientTop == 'number') {
                  ce = body;
                }
                if (ce.clientTop) { y -= ce.clientTop; }
                if (ce.clientLeft) { x -= ce.clientLeft; }
                if (ce.scrollTop || ce.scrollLeft) { sp = [ce.scrollTop, ce.scrollLeft]; }
              }
              if (typeof getScrollPosition == 'function') {
                sp = getScrollPosition(docNode);
              }
              y += sp[0];
              x += sp[1];
              return [y, x];
            }
          };
        }
        return positionOffset;
      })();

      API.getElementPosition = getElementPosition;
      <%If bScroll Then%>
      if (setScrollPosition) {
        API.setScrollPositionToElement = function(el, offset, options, fnDone) {
          var docNode, p;
          if (isHostMethod(el, 'scrollIntoView') && !offset && !options) {
            el.scrollIntoView();
          }
          else {
            docNode = getElementDocument(el);
            p = getElementPosition(el);
            if (viewportToHtmlOrigin) { p = viewportToHtmlOrigin(p, docNode); }
            offset = offset || [];
            setScrollPosition(p[0] - (offset[0] || 0), p[1] - (offset[1] || 0), docNode, false, options, fnDone);
          }
        };

        API.setScrollPositionCenterElement = function(el, options, fnDone) {
          var vs = getViewportSize(getElementDocument(el));
          var es = getElementSize(el);
          API.setScrollPositionToElement(el, [Math.round((vs[0] - es[0]) / 2), Math.round((vs[1] - es[1]) / 2)], options, fnDone);
        };
      }

      API.setElementScrollPositionToElement = function(el, elTo, offset, options, fnDone) {
        var p;
        offset = offset || [];
        p = (getPositionedParent(elTo) === el)?getElementPositionedChildPosition(elTo, el):getElementPosition(elTo, el);
        setElementScrollPosition(el, p[0] - (offset[0] || 0), p[1] - (offset[1] || 0), false, options, fnDone);
      };

      API.setElementScrollPositionCenterElement = function(el, elTo, options, fnDone) {
        var h, w, d;
        d = getElementSize(el);
        h = d[2];
        w = d[3];
        d = getElementSize(elTo);
        setElementScrollPosition(el, elTo, [Math.round((h - d[0]) / 2), Math.round((w - d[1]) / 2)], false, options, fnDone);
      };
      <%End If 'Scroll%>
      <%End If 'Offset%>
      <%If bDispatch Then%>
      fireEvent = (function() {
        var el = body || html;
        if (el) {
          if (isHostMethod(el, 'dispatchEvent') && isHostMethod(global.document, 'createEvent') && getDocumentWindow) {
            return function(el, ev, evType, e) {
              var docNode = getElementDocument(el);
              var win = getDocumentWindow(docNode);
              var evt = docNode.createEvent(evType || 'MouseEvents');
              if (evt) {
                if (e && evt.initMouseEvent) {
                  evt.initMouseEvent(ev, false, true, win, 0, e.screenX, e.screenY, e.clientX, e.clientY, e.ctrlKey, e.altKey, e.shiftKey, e.metaKey, e.button, null);
                }
                evt.initEvent(ev, false, false);
                el.dispatchEvent(evt);
              }
            };
          }
          if (isHostMethod(el, 'fireEvent')) {
            return function(el, ev) { el.fireEvent('on' + ev); };
          }
        }
      })();

      API.dispatchEvent = fireEvent;
      <%End If%>
      <%If bMousePosition Then%>
      getMousePosition = (function() {
        var sp, ce, body;

        return function(e) {						
          if (typeof e.pageX == 'number') {
            getMousePosition = API.getMousePosition = function(e) { return [e.pageY, e.pageX]; };
            return getMousePosition(e);
          }
          if (typeof e.clientX == 'number' && typeof getScrollPosition == 'function') {
            getMousePosition = API.getMousePosition = function(e, docNode) {
              docNode = docNode || getElementDocument(getEventTarget(e));
              if (docNode) {
                body = getBodyElement(docNode);
                ce = getContainerElement(docNode);
                if (body && ce != body && ce.clientWidth === 0 && typeof body.scrollWidth == 'number') {
                  ce = body; // TODO: call getScrollElement here instead
                }
                sp = getScrollPosition(docNode);
                return [e.clientY + sp[0] - (ce.clientTop || 0), e.clientX + sp[1] - (ce.clientLeft || 0)];
              }
            };
            return getMousePosition(e);
          }
        };
      })();

      API.getMousePosition = getMousePosition;
      <%End If%>
      <%If bDrag Then%>
      if (attachListener) {
      attachDrag = (function() {
        var i, c, m;
        var elDrag, elDragHandle, docNode, win, mode, ondrag, ondraginit, ondragterminate, ondragstart, ondragover, ondragout, ondrop, ghost, speed, accelerate, revert, axes, constrain, constraint, keyboardOnly, callbackContext;
        var targets, targetPositions, targetDimensions, targetsOver, targetObstacles, obstaclesFatal, collision;
        var mouse, dim, pos, dimO, posO, scrollPos, oldStyle = {};
        var initialized;
        var oldMouseDown, oldKeyDown, oldKeyUp;
        var oldSpeed;

        function callback(c, co) {
          var targetsOut;
          if (targets) {
            if (mode == 'move') {
              targetsOut = [];
              i = targetsOver.length;

              while (i--) {
                if (!overlaps(co, dimO, targetPositions[targetsOver[i]], targetDimensions[targetsOver[i]])) {
                  targetsOut[targetsOut.length] = i;
                }
              }
              if (targetsOut.length) {
                if (ondragout) { callInContext(ondragout, callbackContext, targetsOut); }
              }
              targetsOver = [];
              i = targets.length;
              while (i--) {
                if (overlaps(co, dimO, targetPositions[i], targetDimensions[i])) {
                  targetsOver[targetsOver.length] = i;
                }
              }
              if (targetsOver.length) {
                if (ondragover) { callInContext(ondragover, callbackContext, c, targetsOver, m); }
                if (targetObstacles) { if (obstaclesFatal) { collision = true; } return false; }
              }
            }				
          }
          if (constrain) {
            switch(mode) {
            case 'move':
              if (!contained(co, dimO, [constraint[0], constraint[1]], [constraint[2], constraint[3]])) {
                constrainPosition(c, co, dimO, constraint);
              }
              break;
            case 'size':
              if (!contained(posO, co, [constraint[0], constraint[1]], [constraint[2], constraint[3]])) {
                constrainSize(c, co, posO, constraint);
              }
            }
          }
          return !ondrag || !callInContext(ondrag, callbackContext, c, co, m);
        }

        function initializeMove() {
          initialized = true;
          if (ghost && typeof setOpacity == 'function') { setOpacity(elDrag, ghost); }

          if (!isPositionable(elDrag)) {
            absoluteElement(elDrag);
            pos = getElementPositionStyle(elDrag);
          }
			
          if (targets) {
            targetsOver = [];
            targetPositions = [];
            targetDimensions = [];
            i = targets.length;
            while (i--) {
              if (isRealObjectProperty(targets[i], 'offsetParent')) { // Must be part of document
                targetPositions[i] = getElementPosition(targets[i]);
                targetDimensions[i] = getElementSize(targets[i]);
              }
            }
          }
        }
	
        function initializeSize() {
          ensureSizable(elDrag);
          initialized = true;
        }

        function size(e) {
          var co;
          if (!initialized) { if (ondragstart) { callInContext(ondragstart, callbackContext); } initializeSize(); }
          m = getMousePosition(e, docNode);
          if (m) {
            c = [(axes == 'horizontal')?null:(dim[0] + (m[0] - mouse[0])), (axes == 'vertical')?null:(dim[1] + (m[1] - mouse[1]))];
            if (constrain) { co = [(axes == 'horizontal')?null:(dimO[0] + (m[0] - mouse[0])), (axes == 'vertical')?null:(dimO[1] + (m[1] - mouse[1]))]; }
            if (callback(c, co)) {
              if (c[0] < 0) { c[0] = 0; }
              if (c[1] < 0) { c[1] = 0; }
              sizeElement(elDrag, c[0], c[1]);
            }
          }
          return cancelDefault(e);
        }

        function scroll(e) {
          if (!initialized) {
            if (ondragstart) { callInContext(ondragstart, callbackContext); }
            initialized = true;
          }
          m = getMousePosition(e, docNode);
          if (m) {
            c = [(axes == 'horizonal')?null:(scrollPos[0] + (m[0] - mouse[0])), (axes == 'vertical')?null:(scrollPos[1] + (m[1] - mouse[1]))];
            if (callback(c)) {
              setElementScrollPosition(elDrag, c[0], c[1]);
            }
          }
          return cancelDefault(e);
        }

        var finish;

        function drag(e) {
          var co;
          if (!initialized) { if (ondragstart) { callInContext(ondragstart, callbackContext); } initializeMove(); }
          m = getMousePosition(e, docNode);
          if (m) {
            c = [(axes == 'horizontal')?null:(pos[0] + (m[0] - mouse[0])), (axes == 'vertical')?null:(pos[1] + (m[1] - mouse[1]))];
            if (targets || constrain) { co = [(axes == 'horizontal')?null:(posO[0] + (m[0] - mouse[0])), (axes == 'vertical')?null:(posO[1] + (m[1] - mouse[1]))]; }
            if (callback(c, co)) {
              positionElement(elDrag, c[0], c[1]);
            }
            else {
              if (collision) { finish(); }
            }
          }
          return cancelDefault(e);
        }

        finish = function() {
          if (ondragterminate) { callInContext(ondragterminate, callbackContext); }
          if (!keyboardOnly) {
            detachListener(docNode, 'mousemove', (mode == 'size')?size:(mode == 'scroll')?scroll:drag);
            detachListener(docNode, 'mouseup', finish);
          }
          docNode.onmousedown = oldMouseDown;
          docNode.onkeydown = oldKeyDown;
          docNode.onkeyup = oldKeyUp;
          if (initialized) {
            if (!ondrop || !callInContext(ondrop, callbackContext, targetsOver)) {
              if (revert) {
                setStyles(elDrag, { position:oldStyle.position, left:oldStyle.left, top:oldStyle.top, width:oldStyle.width, height:oldStyle.height });
                if (mode == 'scroll') { setElementScrollPosition(elDrag, scrollPos[0], scrollPos[1]); }
              }
            }
            if (mode == 'move' && ghost && typeof setOpacity == 'function') { setOpacity(elDrag, 1); }
          }
          docNode = null;
          win = null;
          elDrag = null;
          elDragHandle = null;
          targetsOver = [];
          initialized = false;
        };

        function key(e) {	
          if (win) { e = e || win.event; } // DOM0 used for arrow keys (should be changed)
          if (!e) { return true; }
          var k = getKeyboardKey(e);
          var co = [];

          switch(mode) {
          case 'size':
            if (!initialized) { initializeSize(); }
            c = getElementSizeStyle(elDrag);
            if (constrain) { co = getElementSize(elDrag); }
            break;
          case 'scroll':
            initialized = true;
            c = getElementScrollPosition(elDrag);
            break;
          case 'move':
            if (!initialized) { initializeMove(); }
            c = getElementPositionStyle(elDrag);
            if (targets || constrain) { co = getElementPosition(elDrag); }
          }

          if (e.type == 'keydown') {
            switch (k) {
            case 37:
              c[1] -= speed;
              co[1] -= speed;
              break;
            case 38:
              c[0] -= speed;
              co[0] -= speed;
              break;
            case 39:
              c[1] += speed;
              co[1] += speed;
              break;
            case 40:
              c[0] += speed;
              co[0] += speed;
              break;
            case 13:
              finish();
            }
            if (k != 13) {
              speed += accelerate;
              if (axes == 'vertical') { c[1] = null; }
              if (axes == 'horizontal') { c[0] = null; }
              if (callback(c, co)) {
                switch(mode) {
                case 'size':
                  if (c[0] < 0) { c[0] = 0; }
                  if (c[1] < 0) { c[1] = 0; }
                  sizeElement(elDrag, c[0], c[1]);
                  break;
                case 'scroll':
                  setElementScrollPosition(elDrag, scrollPos[0] + c[0] - mouse[0], scrollPos[1] + c[1] - mouse[1]);
                  break;
                case 'move':
                  positionElement(elDrag, c[0], c[1]);
                }
              }
              else {
                if (collision) { finish(); }
              }
            }
          }
          else {
            speed = oldSpeed;
          }
          return cancelDefault(e);			
        }
        function cancel(e) { // DOM0 used for document mousedown event
          if (win) { e = e || win.event; }
          if (e) { cancelDefault(e); }
          return false;
        }
        function start(e, el, options, elHandle) {
          var d, mb, parent;

          keyboardOnly = options.keyboardOnly;

          mb = getMouseButtons(e);
          if (!keyboardOnly && (mb.right || mb.middle || mb.left) && !getMouseButtons(e)[options.button || 'left']) { return true; }

          //if (!keyboardOnly && !getMouseButtons(e)[options.button || 'left']) { return true; }
          elDrag = el;
          docNode = getElementDocument(el);
          win = (getDocumentWindow)?getDocumentWindow(docNode):null;
          if (!win && docNode == global.document) { win = global; } // TODO: Should generalize this logic in getDocumentWindow
          elDragHandle = elHandle;
          callbackContext = options.callbackContext || elDrag;
          ondraginit = options.ondraginit;
          ondragterminate = options.ondragterminate;
          ondragstart = options.ondragstart;
          ondrag = options.ondrag;
          ondragover = options.ondragover;
          ondragout = options.ondragout;
          ondrop = options.ondrop;
          if (typeof getElementPosition == 'function') {
            targets = options.targets;
            constrain = options.constrain;
          }
          else {
            targets = constrain = false;
          }
          targetObstacles = options.targetObstacles;
          collision = false;
          obstaclesFatal = options.obstaclesFatal;
          revert = options.revert;
          axes = options.axes;			
          ghost = options.ghost;
          if (typeof ghost == 'undefined') { ghost = 0.5; }
          mode = options.mode || 'move';
          speed = oldSpeed = options.speed || 10;
          accelerate = options.accelerate || 1;

          if (constrain) {
            parent = getPositionedParent(el);
            if (parent) {
              d = getElementSize(parent);
              constraint = [0, 0, d[2], d[3]];
            }
            else {
              if (getViewportClientRectangle) { constraint = getViewportClientRectangle(); }
            }
          }
          oldStyle.position = elDrag.style.position;
          oldStyle.left = elDrag.style.left;
          oldStyle.top = elDrag.style.top;
          oldStyle.width = elDrag.style.width;
          oldStyle.height = elDrag.style.height;
          pos = getElementPositionStyle(elDrag);

          if (mode == 'size') { dim = getElementSizeStyle(elDrag); }
          if (targets || constrain) {
            posO = getElementPosition(elDrag);
            dimO = getElementSize(elDrag);
          }
          if (mode == 'scroll') { scrollPos = getElementScrollPosition(elDrag); }
          mouse = getMousePosition(e);
          if (!keyboardOnly) {
            attachListener(docNode, 'mousemove', (mode == 'size')?size:(mode == 'scroll')?scroll:drag);
            attachListener(docNode, 'mouseup', finish);
          }
          oldMouseDown = docNode.onmousedown;
          docNode.onmousedown = cancel;
          oldKeyDown = docNode.onkeydown;
          docNode.onkeydown = key;
          oldKeyUp = docNode.onkeyup;
          docNode.onkeyup = key;
          if (ondraginit) { callInContext(ondraginit, callbackContext, e); }
          return cancelDefault(e);
        }
        return function(el, elHandle, options) {
          options = options || {};
          var mode = options.mode || 'move';
          var listener, elTarget = elHandle || el;
          var uid = elementUniqueId(elTarget);
          if (!attachedDrag[uid] && (mode == 'move' && (isPositionable(el) || typeof absoluteElement == 'function') || (mode == 'size' && typeof getElementSizeStyle == 'function') || mode == 'scroll')) {
            listener = function(e) {
              if (elTarget == elDrag) { return; }
              if (elDrag) { finish(); } start(e, el, options, elHandle);
            };
            attachListener(elTarget, 'mousedown', listener);
            attachedDrag[uid] = listener;
            return true;
          }
          return false;
        };
      })();

      API.attachDrag = attachDrag;

      detachDrag = function(el, elHandle) {
        var elTarget = elHandle || el;
        var uid = elementUniqueId(elTarget);
        if (attachedDrag[uid]) {
          detachListener(elTarget, 'mousedown', attachedDrag[uid]); 
          attachedDrag[uid] = null;
        }
      };

      API.detachDrag = detachDrag;
      }

      if (typeof fireEvent == 'function') {
        initiateDrag = function(el, elHandle, e) {
          fireEvent(elHandle || el, 'mousedown', null, e);
        };

        API.initiateDrag = initiateDrag;
      }
      <%End If 'Drag%>
      <%If bAudio Then%>
      //Audio Section

      var i, l, j, m;
      var audioFileTypeSupported, clearTimeout, clearTimeoutMusic, clearSpeaker, isPlayingAudio, playAudio, speaker, speakerMusic, stopAudio, timeout, timeoutMusic;
      var mimeTypes, mimeTypesMusic, mimeTypesSupported, mimeTypesSupportedMusic;

      if (createElement) {
        mimeTypes = {wav:['audio/x-wav', 'audio/wav'], au:'audio/basic', snd:'audio/basic', aif:['audio/aiff', 'audio/x-aiff'], aiff:['audio/aiff', 'audio/x-aiff'], aifc:['audio/aiff', 'audio/x-aiff'], gsm:'audio/x-gsm'};
        mimeTypesMusic = {mid:['audio/mid', 'audio/x-midi', 'audio/midi'], midi:['audio/mid', 'audio/midi', 'audio/x-midi'], mp3:['audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3'], mp4:'audio/mp4', m3u:['audio/mpegurl', 'audio/x-mgegurl'], m3url:['audio/mpegurl', 'audio/x-mgegurl']};
        mimeTypesSupported = {};
        mimeTypesSupportedMusic = {};

        clearTimeout = function() {
          global.clearTimeout(timeout);
          timeout = 0;
        };

        clearTimeoutMusic = function() {
          global.clearTimeout(timeoutMusic);
          timeoutMusic = 0;
        };

        clearSpeaker = function(el) {
          var body = getBodyElement();
          el.src = '';
          if (el.data) {
            body.removeChild(el);
            el.data = '';
            body.appendChild(el);
          }
        };

        audioFileTypeSupported = function(ext) {
          if (mimeTypesSupported.defaultType || mimeTypesSupportedMusic.defaultType) { return mimeTypesSupported[ext] || mimeTypesSupportedMusic[ext]; }
          return true;
        };

        stopAudio = function() {
          if (timeout) { clearTimeout(); clearSpeaker(speaker); }
          if (timeoutMusic) { clearTimeoutMusic(); clearSpeaker(speakerMusic); }
        };

        isPlayingAudio = function() {
          return !!(timeout || timeoutMusic);
        };

        playAudio = (function() {
          function supported(ext) {
            return mimeTypesSupported[ext] || mimeTypesSupportedMusic[ext];
          }

          function fileExtension(file) {
            var re = new RegExp('\\.([^\\.]*)$');		
            var result = file.match(re);
            return (result && result.length == 2)?result[1].toLowerCase():null;
          }

          function choose(files) {
            var chosen, ext;
            i = 0;
            l = files.length;
            while (i < l && !chosen) {
              ext = fileExtension(files[i]);
              if (ext && supported(ext)) { chosen = files[i]; }
              i++;
            }
            return chosen;
          }

          function isMusic(ext) {
            return !!mimeTypesMusic[ext];
          }

          function createSpeaker(mimeType) {
            var el = createElement('object');
            var elParam = createElement('param');
            if (el && elParam) {
              elParam.name = 'autostart';
              elParam.value = 'true';
              el.appendChild(elParam);
              elParam = createElement('param');
              elParam.name = 'autoplay';
              elParam.value = 'true';
              el.appendChild(elParam);
              el.type = mimeType;
              el.height = '0';
              el.width = '0';
              if (typeof setStyles == 'function') { setStyles(el, { visibility:'hidden', position:'absolute', left:'0', top:'0', height:'0', width:'0' }); }
              elParam = null;
              return el;
            }
          }

          function setTimeout(time, music, cb) {
            return global.setTimeout(function() { clearSpeaker((music)?speakerMusic:speaker); if (music) { clearTimeoutMusic(); } else { clearTimeout(); } if (cb) { cb(); } }, time || 10000);
          }

          function populateSupportedFileTypes(mimeTypes, mimeTypesSupported) {
            var index;
            for (index in mimeTypes) {
              if (isOwnProperty(mimeTypes, index)) {
                if (typeof mimeTypes[index] == 'string') {
                  if (getEnabledPlugin(mimeTypes[index])) { mimeTypesSupported[index] = mimeTypes[index]; }
                }
                else {
                  j = 0;
                  m = mimeTypes[index].length;
                  while (j < m && !mimeTypesSupported[index]) {
                    if (getEnabledPlugin(mimeTypes[index][j])) { mimeTypesSupported[index] = mimeTypes[index][j]; }
                    j++;
                  }
                }
                if (!mimeTypesSupported.defaultType && mimeTypesSupported[index]) { mimeTypesSupported.defaultType = mimeTypesSupported[index]; }
              }
            }
          }

          function initiate(time, music, cb) {
            if (music) {
              if (timeoutMusic) { clearTimeoutMusic(); }
              timeoutMusic = setTimeout(time, true, cb);
            }
            else {
              if (timeout) { clearTimeout(); }
              timeout = setTimeout(time, false, cb);
            }
          }

          function populateNamespace() {
            API.stopAudio = stopAudio;
            API.isPlayingAudio = isPlayingAudio;
            API.audioFileTypeSupported = audioFileTypeSupported;
          }

          if (body && isHostMethod(body, 'appendChild') && isHostMethod(body, 'removeChild') && isRealObjectProperty(global, 'navigator') && ((isHostMethod(global.navigator, 'plugins') && typeof global.navigator.plugins.length == 'number' && global.navigator.plugins.length) || (isHostMethod(global.navigator, 'mimeTypes') && typeof global.navigator.mimeTypes.length == 'number' && global.navigator.mimeTypes.length))) {
            populateSupportedFileTypes(mimeTypes, mimeTypesSupported);
            populateSupportedFileTypes(mimeTypesMusic, mimeTypesSupportedMusic);

            if (mimeTypesSupported.defaultType || mimeTypesSupportedMusic.defaultType) {
              if (mimeTypesSupported.defaultType) {
                speaker = createSpeaker(mimeTypesSupported.defaultType);
                if (speaker && !API.deferAudio) {
                  body.appendChild(speaker);
                }
              }

              if (mimeTypesSupportedMusic.defaultType) {
                speakerMusic = createSpeaker(mimeTypesSupportedMusic.defaultType);
                if (speakerMusic && !API.deferAudio) {
                  body.appendChild(speakerMusic);
                }
              }

              if (speaker || speakerMusic) { populateNamespace(); }
						
              return function(files, time, cb, ext, volume) {
                var el, file = (typeof files == 'string')?files:choose(files);
                var body = getBodyElement();
                var mimeType, music;
                if (file) {
                  ext = ext || fileExtension(file);
                  if (ext) {		
                    music = isMusic(ext);
                    mimeType = (music)?mimeTypesSupportedMusic[ext]:mimeTypesSupported[ext];
                    if (mimeType) {
                      el = (music && speakerMusic)?speakerMusic:speaker;
                      if (el) {
                        if (el.parentNode) { body.removeChild(el); }
                        el.type = mimeType;
                        el.data = file;
                        body.appendChild(el);
                        initiate(time, music, cb);
                        return true;
                      }
                    }
                  }	
                }				
                return false;
              };
            }
            return;
          }

          // Note: IE requires DOM module

          var head, deferred, convertVolume, addSpeakers;

          if (!isXmlParseMode() && typeof getHeadElement == 'function') {
            head = getHeadElement();
            if (head && isHostMethod(head, 'appendChild')) {
              convertVolume = function(volume) {
                return (volume)?(-2000 * ((100 - volume) / 100)):-10000;
              };

              API.preloadAudio = function(file) {
                var el = createElement('bgsound');
                if (el) {
                  el.src = file;
                  el.volume = -10000;
                  head.appendChild(el);
                  el = null;
                }
              };

              API.adjustVolume = function(volume) {
                speakerMusic.volume = speaker.volume = convertVolume(volume);
              };
						
              speaker = createElement('bgsound');
              speakerMusic = createElement('bgsound');

              if (speaker || speakerMusic) { populateNamespace(); }

              addSpeakers = function() {
                if (speaker) { head.appendChild(speaker); }
                if (speakerMusic) { head.appendChild(speakerMusic); }
              };

              if (API.deferAudio) {
                deferred = true;
              } else {
                addSpeakers();
              }

              return function(files, time, cb, ext, volume) {
                if (deferred) {
                  addSpeakers();
                  deferred = false;
                }
                var file = (typeof files == 'string')?files:files[0];
                ext = ext || fileExtension(file);
                var music = isMusic(ext);
                var el = (music && speakerMusic)?speakerMusic:speaker;
                if (el) {
                  el.src = file;
                  if (typeof volume != 'undefined') { el.volume = convertVolume(volume); }
                  initiate(time, music, cb);
                  return true;
                }
              };
            }
          }
        })();
        if (speaker || speakerMusic) { API.playAudio = playAudio; }
      }
      <%End If 'Audio%>

      <%If bImport Then%>
      // Import Section

      if (html && createElement && getAttribute && setAttribute && isHostMethod(global.document, 'createTextNode') && isHostMethod(global.document, 'childNodes') && isHostMethod(html, 'appendChild') && typeof html.nodeType == 'number') {
        importNode = function(node, bImportChildren, docNode) {
          var i, l, name, nodeNew, nodeChild, value;

          docNode = docNode || global.document;
          switch (node.nodeType) {
          case 1:
            nodeNew = createElement(getElementNodeName(node), docNode);
            if (nodeNew) {

              // FIXME: make sure to do TYPE attribute first

              if (node.attributes && node.attributes.length) {
                i = node.attributes.length;
                while (i--) {
                  if (node.attributes[i].specified) {
                    name = node.attributes[i].nodeName;
                    value = getAttribute(node, node.attributes[i].nodeName);
                    if (value !== null) { nodeNew = setAttribute(nodeNew, name, value); }
                  }
                }
              }
              if (bImportChildren && node.childNodes && node.childNodes.length) {
                l = node.childNodes.length;						
                for (i = 0; i < l; i++) {
                  nodeChild = importNode(node.childNodes[i], bImportChildren, docNode);
                  if (nodeChild) {
                    if (nodeChild.nodeType != 1) {
                      if (elementCanHaveChildren(nodeNew) && (reNotEmpty.test(nodeChild.data) || getElementNodeName(nodeNew) == 'pre')) {
                        nodeNew.appendChild(nodeChild);
                      }
                      else {
                        if (getElementNodeName(nodeNew) == 'script' && typeof setElementScript == 'function') {
                          setElementScript(nodeNew, nodeChild.nodeValue);
                        }
                      }
                    }
                    else {
                      if (elementCanHaveChildren(nodeNew)) {
                        nodeNew.appendChild(nodeChild);
                      }
                    }
                  }
                }
              }
              return nodeNew;
            }
            break;
          case 3:
            return docNode.createTextNode(node.nodeValue);
          }
        };

        API.importNode = importNode;

        setElementNodes = function(el, elNewNodes) {
          if (elNewNodes) {
            //if (typeof purgeListeners == 'function') { purgeListeners(el, true, true); } // Purge children only
            while (el.firstChild) {
              el.removeChild(el.firstChild);
            }
            while (elNewNodes.firstChild) { el.appendChild(elNewNodes.firstChild); }
            return true;
          }
          return false;
        };

        API.setElementNodes = setElementNodes;

        addElementNodes = function(el, elNewNodes) {
          elNewNodes = importNode(elNewNodes, true, getElementDocument(el));
          while (elNewNodes.firstChild) { el.appendChild(elNewNodes.firstChild); }
        };

        API.addElementNodes = addElementNodes;
      }
      <%End If 'Import%>
      <%If bRegion Then%>
      elementContained = function(el, pos, dim) {
        return contained(getElementPosition(el), getElementSize(el), pos, dim);
      };

      elementContainedInElement = function(el, el2) {
        return contained(getElementPosition(el), getElementSize(el), getElementPosition(el2), getElementSize(el2));
      };

      API.elementContainedInElement = elementContainedInElement;

      elementOverlaps = function(el, pos, dim) {
        return (overlaps(getElementPosition(el), getElementSize(el), pos, dim));
      };

      elementOverlapsElement = function(el, el2) {
        return (overlaps(getElementPosition(el), getElementSize(el), getElementPosition(el2), getElementSize(el2)));
      };

      API.elementOverlapsElement = elementOverlapsElement;
      <%End If 'Region%>
      <%If bStyle Then%>
      if (canAdjustStyle) {
        <%If bSize Or bPosition Then%>
        // Defect test for getElementPositionStyle and getElementSizeStyle (Opera 9 is a known offender)
        if (body && getKomputedStyle && isHostMethod(body, 'appendChild') && typeof createElement == 'function') {
          div = createElement('div');
          if (div) {
            setStyles(div, {height:'0', width:'0', padding:'0', top:'0', left:'0', position:'absolute', visibility:'hidden', border:'solid 1px'});
            body.appendChild(div);
            computedSizeBad = (getKomputedStyle(div, 'height') == '2px');
            div2 = createElement('div');
            if (div2) {
              setStyles(div2, {margin:'0', position:'absolute'});
              div.appendChild(div2);
              computedPositionBad = (getKomputedStyle(div2, 'left') == '1px');
              body.removeChild(div);
              div2 = null;
            }
            div = null;
          }
        }
        <%End If%>
        // Returns dimensions suitable to pass to sizeElement
        // Works for browsers incapable of computing styles or broken in that regard
        <%If bSize Then%>
        getElementSizeStyle = function(el) {
          var dim = [];

          dim[0] = getStylePixels(el, 'height');
          dim[1] = getStylePixels(el, 'width');
          if ((dim[0] === null || dim[1] === null || computedSizeBad)) {
            if (typeof el.offsetHeight == 'number') {
              dim[0] = el.offsetHeight;
              dim[1] = el.offsetWidth;
              el.style.height = dim[0] + 'px';
              el.style.width = dim[1] + 'px';
              adjustElementSize(el, dim);
            }
            else {
              return null;
            }
          }
          return dim;
        };

        API.getElementSizeStyle = getElementSizeStyle;

        ensureSizable = function(el, display) {
          var d;
          if (typeof el.height != 'number') {
            d = getStyle(el, 'display');
            if (!d || d == 'inline') {
              if (typeof presentElement == 'function') {
                presentElement(el, true);
                if (el.style.display == 'inline') {
                  el.style.display = display || 'block';
                }
                return true;
              }
              return false;
            }
          }
          return true;
        };
        <%End If%>
        <%If bPosition Then%>
        // Returns coordinates suitable to pass to positionElement
        // Works for browsers incapable of computing styles or broken in that regard

        getElementPositionStyle = (function() {
          var fix;

          if (body && typeof body.offsetLeft == 'number') {
            fix = function(el, y, x) {
              var oldX = el.offsetLeft;
              var oldY = el.offsetTop;
              positionElement(el, y, x);
              if (oldX != el.offsetLeft) { x -= (el.offsetLeft - oldX); }
              if (oldY != el.offsetTop) { y -= (el.offsetTop - oldY); }
              if (oldX != x || oldY != y) { positionElement(el, y, x); }
              return [y, x];
            };
          }

          return function(el, posParent) {
            var pos = getStyle(el, 'position');
            var x = getStylePixels(el, 'left');
            var y = getStylePixels(el, 'top');

            if (x !== null && y !== null && (!computedPositionBad || isPositionable(el))) {
              return (computedPositionBad && fix && (x + 'px' != el.style.left || y + 'px' != el.style.top))?fix(el, y, x):[y, x];
            }

            // Calculate offset from root element or positioned parent

            if (isRealObjectProperty(el, 'offsetParent') && typeof getElementPosition == 'function') {
              posParent = (typeof posParent == 'undefined')?getPositionedParent(el):posParent;
              if (!posParent && pos == 'relative') {
                x = y = 0;
              } else {
                var p = (posParent)?getElementPosition(el, posParent, true, posParent):getElementPosition(el, null, true, posParent);
                y = p[0];
                x = p[1];
              }
            } else {
              if (isPositionable(el)) {
                x = y = 0;
              }
              else {
                return null;
              }
            }
            return (fix)?fix(el, y, x):[y, x];
          };
        })();

        API.getElementPositionStyle = getElementPositionStyle;
        <%End If%>
        <%If bPresent Then%>
        defaultDisplay = (function() {
          var reBlockDisplay, blockDisplay = 'ADDRESS|BLOCKQUOTE|BODY|DD|DIV|DL|DT|FIELDSET|FORM|IFRAME|I?FRAME|FRAMESET|H\\d|OL|P|UL|CENTER|DIR|HR|MENU|PRE', otherDisplayTypes = {};
          var elTable, el;

          if (body && getKomputedStyle && isHostMethod(body, 'appendChild') && typeof createElement == 'function') {
            el = createElement('div');
            if (el) {
              setStyles(el, {position:'absolute', left:'0', top:'0'});
              el.style.position = 'absolute';
              body.appendChild(el);
              elTable = createElement('table');
              if (elTable) {
                el.appendChild(elTable);
                if (getKomputedStyle(elTable, 'display') == 'block') {
                  blockDisplay += '|TABLE|TBODY|TH|TFOOT|TR|TD|COL.*|CAPTION|LI';
                }
                else {
                  otherDisplayTypes = {li:'list-item', table:'table', tbody:'table-row-group', tr:'table-row', td:'table-cell', th:'table-header-group', tfoot:'table-footer-group', caption:'table-caption', colgroup:'table-column-group', col:'table-column'};
                }
                body.removeChild(el);
                elTable = null;
                el = null;
              }
            }
          }
          reBlockDisplay = new RegExp('^(' + blockDisplay + ')$', 'i');
          return function(nn) {
            if (reBlockDisplay.test(nn)) { return 'block'; }
            return otherDisplayTypes[nn] || 'inline';
          };
        })();

        if (canAdjustStyle.display) {
          presentElement = function(el, b, display) {
            var d;

            if (typeof b == 'undefined') { b = true; }
            if (b) {
              if (display) {
                el.style.display = display;
              }
              else {
                el.style.display = '';
                if (getKomputedStyle) {
                  d = getKomputedStyle(el, display);
                  if (d && d != 'none') { return; }
                }
                el.style.display = defaultDisplay(getElementNodeName(el));
              }
            }
            else {
              el.style.display = 'none';
            }
          };
        }

        API.presentElement = presentElement;

        toggleElementPresence = function(el, display) {
          presentElement(el, !isPresent(el), display);
        };

        API.toggleElementPresence = toggleElementPresence;

        <%End If%>
        <%If bShow Then%>
        if (canAdjustStyle.visibility) {
          showElement = function(el, b, options) {
            if (typeof b == 'undefined') { b = true; }
            options = options || {};
            if (b && typeof presentElement != 'undefined') {
              if (options.skipPresenceCheck || getStyle(el, 'display') == 'none') {
                presentElement(el, options.display);
              }
            }
            el.style.visibility = (b)?'visible':'hidden';
            if (!b && typeof presentElement !='undefined' && options.removeOnHide) { el.style.display = 'none'; }
          };

          API.showElement = showElement;

          toggleElement = function(el, options) {
            showElement(el, !isVisible(el) || !isPresent(el), options);
          };

          API.toggleElement = toggleElement;
        }
        <%End If%>
        <%If bOffset And bPosition And bSize Then%>
        if (canAdjustStyle.position) {
          relativeElement = function(el, posParent) {
            var pos;
            posParent = (typeof posParent == 'undefined')?getPositionedParent(el):posParent;
            var p = getStyle(el, 'position');
            if (p != 'relative') {
              if (posParent) {
                pos = getElementPosition(el, posParent);
                positionElement(el, pos[0], pos[1]);
              }
              else {
                positionElement(el, 0, 0);
              }
              el.style.position = 'relative';
            }
          };

          API.relativeElement = relativeElement;

          absoluteElement = function(el, posParent) {
            posParent = (typeof posParent == 'undefined')?getPositionedParent(el):posParent;
            var pos = getElementPosition(el, posParent);
            var dim = getElementSizeStyle(el);
            var margins = (typeof getElementMarginsOrigin == 'function')?getElementMarginsOrigin(el):[0, 0];

            if (dim) { sizeElement(el, dim[0], dim[1]); }
            if (pos) { positionElement(el, pos[0] - margins[0], pos[1] - margins[1]); }
            el.style.position = 'absolute';
          };

          API.absoluteElement = absoluteElement;
        }
	
        ensurePositionable = function(el, posParent, position) {
          var p = getStyle(el, 'position');
          if (!p || p == 'static') {
            if (canAdjustStyle.position) {
              ((!position || position == 'absolute')?absoluteElement:relativeElement)(el, posParent);
              return true;
            }
            return false;
          }
          return true;
        };

        getElementPositionedChildPosition = function(el, elParent) {
          return (getStyle(el, 'position') == 'relative')?getElementPosition(el, elParent, true):getElementPositionStyle(el, elParent);
        };
        <%If bAdjacent Then%>
        adjacentElement = function(el, elAdj, side) {
          var p, dim, dimAdj, constraint;
          var adjParent, dimParent;
          var parent = getPositionedParent(el);
          var docNode = getElementDocument(el);
          var m = (typeof getElementMarginsOrigin == 'function')?getElementMarginsOrigin(el):[0, 0];
          // TODO: if el is fixed, check if elAdj is contained in document rectangle (adjust for scroll position)
          var fixed = getStyle(el, 'position') == 'fixed';

          if (!ensurePositionable(el)) { return false; }
          if (parent) {
            adjParent = getPositionedParent(elAdj);
            if (adjParent === parent) {
              p = getElementPositionedChildPosition(elAdj, adjParent);
            }
            else {
              return false;
            }
            if (typeof dimParent.clientWidth == 'number') {
              constraint = [0, 0, dimParent.clientHeight, dimParent.clientWidth];
            }
          }
          else {
            p = getElementPosition(elAdj);
            if (typeof getViewportClientRectangle == 'function') { constraint = getViewportClientRectangle(docNode); }
          }

          dim = getElementSize(el);
          dimAdj = getElementSize(elAdj);

          if (constraint) {
            switch(side) {
            // TODO: check if will be contained on other side
            case 1:
              if (!contained([p[0], p[1] + dimAdj[1] + dim[1]], dim, [constraint[0], constraint[1]], [constraint[2], constraint[3]])) { side = 3; }
              break;
            case 2:
              if (!contained([p[0] + dimAdj[0] + dim[0], p[1]], dim, [constraint[0], constraint[1]], [constraint[2], constraint[3]])) { side = 0; }
              break;
            case 3:
              if (!contained([p[0], p[1] - dim[1]], dim, [constraint[0], constraint[1]], [constraint[2], constraint[3]])) { side = 1; }
              break;
            case 0:
              if (!contained([p[1] - dim[1], p[1]], dim, [constraint[0], constraint[1]], [constraint[2], constraint[3]])) { side = 2; }
            }

            if (side == 1 || side == 2) {
              p[1] += dimAdj[side % 2];
            }
            else {
              p[0] -= dimAdj[side % 2];
            }

            if (!contained(p, dim, [constraint[0], constraint[1]], [constraint[2], constraint[3]])) {
              constrainPosition(p, [p[0], p[1]], dim, constraint);
            }
          }

          if (fixed) {
            if (htmlToViewportOrigin) { p = htmlToViewportOrigin(p, docNode); }
            var sp = (typeof getScrollPosition == 'function')?getScrollPosition(docNode):[0, 0];
            p[0] -= sp[0];
            p[1] -= sp[1];
          }
          positionElement(el, p[0] - m[0], p[1] - m[1]);
          return side;
        };

        API.adjacentElement = adjacentElement;
        <%End If 'Adjacent%>
        <%If bOverlay Then%>
        overlayElement = function(el, elOver, cover) {
          var pos, dim;
          var m = (typeof getElementMarginsOrigin == 'function')?getElementMarginsOrigin(el):[0, 0];
          var parent = getPositionedParent(el);
          var parentOver = getPositionedParent(elOver);

          if (!ensurePositionable(el, parent)) { return false; }
          if (parent) {
            if (parent === parentOver) {
              pos = getElementPositionedChildPosition(elOver, parentOver);
            }
            else {
              return false;
            }
          }
          else {
            // TODO: if el is fixed, check if over is in viewport, else fail
            pos = getElementPosition(elOver);
            var posStyle = getStyle(el, 'position');
            if (posStyle == 'fixed') {
              if (typeof getScrollPosition != 'undefined') {
                var docNode = getElementDocument(el);
                var sp = getScrollPosition(docNode);
                pos[0] -= sp[0];
                pos[1] -= sp[1];
              }
            }
          }
          if (cover) {
            dim = getElementSize(elOver);
            sizeElement(el, dim[0], dim[1]);
            adjustElementSize(el, dim);
          }
          positionElement(el, pos[0] - m[0], pos[1] - m[1]);
          return true;
        };

        API.overlayElement = overlayElement;
        <%End If 'Overlay%>
        <%End If 'Offset and Position and Size%>
        <%If bViewport And bPosition Then%>
        <%If bCenter Or bMaximize Then%>
        <%IF bSize Then%>
        if (getViewportClientRectangle) {
        getWorkspaceRectangle = function(docNode, elExclude) {
          docNode = docNode || global.document;
          var s, side, dim, el, index, r = getViewportClientRectangle(docNode);

          s = docNode._sideBars;
          if (s) {
            for (index in s) {
              if (isOwnProperty(s, index)) {
                el = s[index].el;
                if (el != elExclude) {
                  side = s[index].side;
                  dim = getElementSize(el);
                  if (isVisible(el) && !s[index].autoHide) {
                    switch(side) {
                      case 'top':
                        r[0] += dim[0];
                        r[2] -= dim[0];
                        break;
                      case 'left':
                        r[1] += dim[1];
                        r[3] -= dim[1];
                        break;
                      case 'bottom':
                        r[2] -= dim[0];
                        break;
                      case 'right':
                        r[3] -= dim[1];
                    }
                  }
                }
              }
            }
          }
          return r;
        };
        }
        API.getWorkspaceRectangle = getWorkspaceRectangle;
        <%Else%>
        getWorkspaceRectangle = getViewportClientRectangle;
        <%End If 'Size%>
        <%End If 'Center or Maximize%>

        <%If (bCenter And bSize) Or bMaximize Then%>
        if (getWorkspaceRectangle) {
        adjustFixedPosition = function(pos, docNode) {
          var sp = (typeof getScrollPosition == 'function')?getScrollPosition(docNode):[0,0];
          pos[0] -= sp[0];
          pos[1] -= sp[1];
          if (viewportToHtmlOrigin) {
             pos = viewportToHtmlOrigin(pos, docNode);
          }
        };

        // Side bars

        getAutoHideRectangle = function(el, side, r, bOut) {
          var dim = getElementSize(el);
          var r2 = [r[0], r[1], r[2], r[3]];
          var border = getElementBordersOrigin(el)[0] || 4;
          var docNode = getElementDocument(el);

          if (getStyle(el, 'position') == 'fixed') {
                adjustFixedPosition(r2, docNode);
          }

          switch (side) {
          case 'top':
            r2[2] = dim[0];
            if (!bOut) { r2[0] -= (dim[0] - border); }
            break;
          case 'left':
            r2[3] = dim[1];
            if (!bOut) { r2[1] -= (dim[1] - border); }
            break;
          case 'bottom':
            r2[0] = r2[0] + r2[2] - dim[0];
            r2[2] = dim[0];
            if (!bOut) { r2[0] += (dim[0] - border); }
            break;
          case 'right':
            r2[1] = r2[1] + r2[3] - dim[1];
            r2[3] = dim[1];
            if (!bOut) { r2[1] += (dim[1] - border); }
          }
          return r2;
        };

        arrangeSideBars = function(docNode) {
          docNode = docNode || global.document;
          var a, index, j, me, s, uid;
          var r = getViewportClientRectangle(docNode);
          var sb = docNode._sideBars;

          if (sb) {
            a = [];
            for (index in sb) {
              if (isOwnProperty(sb, index)) {
                a[a.length] = sb[index];
              }
            }
            docNode._sideBars = null;
            j = a.length;
            for (index = 0; index < j; index++) {
              s = a[index];
              if (s) {
                if (s.autoHide) { s.el.style.visibility = 'hidden'; }
                sideBar(s.el, s.side);
                uid = elementUniqueId(s.el);
                if (s.autoHide) {
                  var pos = getAutoHideRectangle(s.el, s.side, r);
                  positionAndSizeElementOuter(s.el, pos);
                  s.el.style.visibility = 'visible';
                  docNode._sideBars[uid].autoHide = true;
                  docNode._sideBars[uid].options = s.options;
                }
              }
            }            
          }
          me = API.maximizedElements;
          if (me) {
            r = getWorkspaceRectangle(docNode);
            for (index in me) {
              if (isOwnProperty(me, index) && me[index] && typeof me[index] == 'object' && me[index].mode != 'full') {
                maximize(me[index].el, r, docNode);
              }
            }
          }
        };

        API.arrangeSideBars = arrangeSideBars;

        unSideBar = function(el) {
          var index, sb, uid = elementUniqueId(el);
          var docNode = getElementDocument(el);

          if (docNode && docNode._sideBars && docNode._sideBars[uid]) {
            sb = docNode._sideBars[uid];
            docNode._sideBars[uid] = null;
            arrangeSideBars(docNode);
            for (index in sb) {
              if (isOwnProperty(sb, index)) {
                if (sb[index]) {
                  return true;
                }
              }
            }
            docNode._sideBars = null; // Clear expando when empty
          }
        };

        API.unSideBar = unSideBar;

        showSideBar = function(el, b, options) {
          var docNode = getElementDocument(el);

          showElement(el, b, options, function() { global.setTimeout(function() { arrangeSideBars(docNode, options); }, 0); });
          if (!showElement.async) {
            arrangeSideBars(docNode, options);
          }
        };

        API.showSideBar = showSideBar;

        if (typeof attachRolloverListeners == 'function') {
          autoHideRollover = function(el, b) {
            var pos, r, sb;
            var uid = elementUniqueId(el);
            var docNode = getElementDocument(el);

            if (docNode && docNode._sideBars && docNode._sideBars[uid]) {
              r = getViewportClientRectangle(docNode);
              sb = docNode._sideBars[uid];
              pos = getAutoHideRectangle(el, sb.side, r, b);
              positionElement(el, pos[0], pos[1], sb.options);
            }
          };

          var autoHideTimeouts = {};

          autoHideRolloverListener = function(e) {
            var uid = elementUniqueId(this);
            if (autoHideTimeouts[uid]) { global.clearTimeout(autoHideTimeouts[uid]); }
            autoHideRollover(this, true);
          };

          autoHideRolloutListener = function(e) {
            var that = this;
            var uid = elementUniqueId(this);
            if (autoHideTimeouts[uid]) { global.clearTimeout(autoHideTimeouts[uid]); }
            autoHideTimeouts[uid] = global.setTimeout(function() { autoHideRollover(that, false); }, 500);
          };

          autoHideSideBar = function(el, b, options) {
            if (arguments.length == 1) { b = true; }
            var index, sb, sbs;
            var docNode = getElementDocument(el);
            var uid = elementUniqueId(el);
            if (docNode && docNode._sideBars) {
              sbs = docNode._sideBars;
              sb = sbs[uid];
              for (index in sbs) {
                if (isOwnProperty(sbs, index)) {
                  if (sbs[index].autoHide && sbs[index].side == sb.side) {
                    return false; // One auto-hide side bar per edge
                  }
                }
              }
              sb.options = options;
              if (sb.autoHide != b) {
                sb.autoHide = b;
                ((b)?attachRolloverListeners:detachRolloverListeners)(el, autoHideRolloverListener, autoHideRolloutListener);
                arrangeSideBars(docNode);
                return true;
              }
            }
            return false;
          };
          API.autoHideSideBar = autoHideSideBar;
        }

        addSideBarDocument = function(docNode) { // returns numeric handle to out-of-closure storage for document references
          if (!API.sideBarDocuments) {
            API.sideBarDocuments = [];
            API.sideBarDocuments.dontdebug = true; // Keeps debug hooks out of the object
            if (typeof attachWindowListener == 'function' && getDocumentWindow) {
              attachWindowListener('unload', function() { API.sideBarDocuments = null; }, getDocumentWindow(docNode));
            }
          }
          API.sideBarDocuments[API.sideBarDocuments.length] = docNode;
          return API.sideBarDocuments.length - 1;
        };

	sideBar = function(el, sSide) {
          var dim, docNode, fixed, h, r, win;
          var uid = elementUniqueId(el);
          if (typeof ensurePositionable == 'undefined' || ensurePositionable(el)) {
            if (el.style.position == 'relative') { el.style.position = 'absolute'; }
            docNode = getElementDocument(el);
            if (!docNode || (typeof docNode.expando == 'boolean' && !docNode.expando)) { return false; }
            fixed = getStyle(el, 'position') == 'fixed';
            el.style.margin = '0';
            r = getWorkspaceRectangle(docNode, el);
            
            if (!docNode._sideBars) {
              if (typeof docNode._sideBars == 'undefined' && getDocumentWindow && typeof attachWindowListener == 'function') {
                win = getDocumentWindow(docNode);
                h = addSideBarDocument(docNode);
                attachWindowListener('resize', function() {
                  arrangeSideBars(API.sideBarDocuments[h]);
                }, win);
                win = null;
              }
              docNode._sideBars = {};
            }

            if (docNode._sideBars[uid]) {
              if (docNode._sideBars[uid] == sSide) { return false; }
              docNode._sideBars[uid].side = sSide;
            }
            else {
              docNode._sideBars[uid] = { el:el, side:sSide };
            }

            dim = getElementSize(el);

            switch(sSide) {
            case 'top':
              r[2] = dim[0];
              break;
            case 'left':
              r[3] = dim[1];
              break;
            case 'right':
              r[1] = r[1] + r[3] - dim[1];
              r[3] = dim[1];
              break;
            case 'bottom':
              r[0] = r[0] + r[2] - dim[0];
              r[2] = dim[0];
            }

            if (getStyle(el, 'position') == 'fixed') {
                adjustFixedPosition(r, docNode);
            }
            positionAndSizeElementOuter(el, r);
            docNode = null;
            return true;
          }
          return false;
	};

        API.sideBar = sideBar;

        changeSideBarSide = function(el, sSide) {
          var docNode = getElementDocument(el);
          var uid = elementUniqueId(el);
          if (docNode && docNode._sideBars && docNode._sideBars[uid] && docNode._sideBars[uid].side != sSide) {
            docNode._sideBars[uid] = null;
            arrangeSideBars(docNode);
            sideBar(el, sSide);
            return true;
          }
          return false;
        };

        API.changeSideBarSide = changeSideBarSide;
        }
        <%End If '(Center And Size) or Maximize%>
        <%If bCenter Then%>
        if (getWorkspaceRectangle) {				
          centerElement = function(el) {
            if (typeof ensurePositionable == 'undefined' || ensurePositionable(el)) {
              if (el.style.position == 'relative') { el.style.position = 'absolute'; }
              var docNode = getElementDocument(el);
              var fixed = getStyle(el, 'position') == 'fixed';
              var sp = (!fixed || typeof getScrollPosition == 'undefined')?[0, 0]:getScrollPosition(docNode);
              var m = (typeof getElementMarginsOrigin == 'function')?getElementMarginsOrigin(el):[0, 0];
              var p = getWorkspaceRectangle(docNode);
              var dim = [p[2], p[3]];
              p[0] += ((dim[0] - el.offsetHeight) / 2) - m[0] - sp[0];
              p[1] += ((dim[1] - el.offsetWidth) / 2) - m[1] - sp[1];
              if (htmlToViewportOrigin && !fixed) { p = htmlToViewportOrigin(p, docNode); }
              positionElement(el, p[0], p[1]);
              return true;
            }
            return false;
          };

          API.centerElement = centerElement;
        }
        <%End If 'Center%>
        <%If bSize Then%>
        <%If bMaximize Then%>
        if (getWorkspaceRectangle) {
          maximize = function(el, r, docNode) {
              var pos, d = el.style.display;
              el.style.display = 'none';
              el.style.display = d;
              pos = getStyle(el, 'position');
              if (pos == 'relative') { el.style.position = 'absolute'; }
              if (pos == 'fixed') {
                adjustFixedPosition(r, docNode);
              }
              //positionAndSizeElementOuter(el, r);
              positionElement(el, -10000, -10000); // Avoid flash of scrollbars in IE for bordered elements
              sizeElement(el, r[2], r[3]);
              adjustElementSize(el, [r[2], r[3]]);
              positionElement(el, r[0], r[1]);
          };
          maximizeElement = function(el) {
            if (typeof ensurePositionable == 'undefined' || ensurePositionable(el)) {
              var docNode = getElementDocument(el);
              var uid = elementUniqueId(el);

              if (!API.maximizedElements) {
                API.maximizedElements = {};
                API.maximizedElements.dontdebug = true; // Keeps debug hooks out of the object
                if (typeof attachWindowListener == 'function' && getDocumentWindow) {
                  attachWindowListener('unload', function() { API.maximizedElements = null; }, getDocumentWindow(docNode));
                }
              }
              if (API.maximizedElements[uid]) { return false; } // Already maximized
              API.maximizedElements[uid] = { position:el.style.position,left:el.style.left,top:el.style.top,height:el.style.height,width:el.style.width,el:el };

              el.style.margin = '0';
              maximize(el, getWorkspaceRectangle(docNode), docNode);
              return true;
            }
            return false;
          };
          API.maximizeElement = maximizeElement;
        }
        <%End If 'Maximize%>
        <%If bFullscreen Or bMaximize Then%>

        constrainPositionToViewport = function(pos, docNode) {
          constrainPosition(pos, [pos[0], pos[1]], [0, 0], getViewportClientRectangle(docNode || global.document));
        };

        constrainElementPositionToViewport = function(el) {
          var pos = getElementPositionStyle(el);
          var docNode = getElementDocument(el);
          constrainPosition(pos, [pos[0], pos[1]], getElementSize(el), getViewportClientRectangle(docNode));
          positionElement(el, pos[0], pos[1]);
        };

        API.constrainPositionToViewport = constrainPositionToViewport;
        API.constrainElementPositionToViewport = constrainElementPositionToViewport;

        restoreElement = function(el) { // Also restores full screen
          if (!API.maximizedElements) { return; }
          var docNode = getElementDocument(el);
          var uid = elementUniqueId(el);
          var me = API.maximizedElements[uid];

          if (me) {
            el.style.position = me.position;
            el.style.left = me.left;
            el.style.top = me.top;
            el.style.height = me.height;
            el.style.width = me.width;

            if (me.scrollPosition) { // Full screen saves 
              setScrollPosition(me.scrollPosition[0], me.scrollPosition[1], docNode);
            }

            if (el.style.position != 'fixed' && el.style.position != 'relative') { // Might be "faux fixed" (IE6 and quirks mode), so constrain to viewport
              constrainElementPositionToViewport(el);
            }

            if (me.mode == 'full') {
              var index;
              var ce = getContainerElement(docNode);
              var body = getBodyElement(docNode);
              var o = API.maximizedElements[uid];

              for (index in o.ceStyles) {
                if (isOwnProperty(o.bodyStyles, index)) {
                  if (ce != body) { body.style[index] = o.bodyStyles[index]; }
                  ce.style[index] = o.ceStyles[index];
                }
              }
            }

            API.maximizedElements[uid] = null;
          }
        };

        API.restoreElement = restoreElement;
        <%End If 'Maximize Or Full Screen%>
        <%If bFullscreen Then%>
        fullScreenElement = function(el) {
          var body, ce, index, styles, uid = elementUniqueId(el);
          var docNode = getElementDocument(el);

          if (!API.maximizedElements) { // FIXME: Duplication
            API.maximizedElements = {};
            API.maximizedElements.dontdebug = true; // Keeps debug hooks out of the object
            if (typeof attachWindowListener == 'function' && getDocumentWindow) {
              attachWindowListener('unload', function() { API.maximizedElements = null; }, getDocumentWindow(docNode));
            }
          }

          if (!API.maximizedElements[uid]) {
            if (typeof ensurePositionable == 'undefined' || ensurePositionable(el, null, 'absolute')) {
              ce = getContainerElement(docNode);
              body = getBodyElement(docNode);
              styles = { overflow:'hidden', padding:'0', margin:'0', height:'100%' };

              API.maximizedElements[uid] = { position:el.style.position,left:el.style.left,top:el.style.top, height:el.style.height, width:el.style.width, scrollPosition:getScrollPosition(docNode), mode:'full' };
              API.maximizedElements[uid].bodyStyles = {};
              API.maximizedElements[uid].ceStyles = {};
              for (index in styles) {
                if (isOwnProperty(styles, index)) {
                  if (ce != body) { API.maximizedElements[uid].bodyStyles[index] = body.style[index]; }
                  API.maximizedElements[uid].ceStyles[index] = ce.style[index];
                }
              }

              setStyles(ce, styles);
              setStyles(body, styles);
              setScrollPosition(0, 0, docNode);
              setStyles(el, { position:'absolute', top:'0', left:'0', right:'0', bottom:'0', height:'100%', width:'100%' });
             return true;
            }
          }
          return false;
        };

        API.fullScreenElement = fullScreenElement;
        <%End If 'Full-screen%>
        <%If bCoverDocument Then%>
        if (getViewportScrollRectangle) {
          coverDocument = function(el) {
            if (typeof ensurePositionable == 'undefined' || ensurePositionable(el, null, 'absolute')) {
              var docNode = getElementDocument(el);
              var r;
              el.style.display = 'none';
              r = getViewportScrollRectangle(docNode);
              el.style.display = 'block';
              positionElement(el, r[0], r[1]);
              sizeElement(el, r[2], r[3]);
              adjustElementSize(el, [r[2], r[3]]);
              return true;
            }
            return false;
          };

          API.coverDocument = coverDocument;
        }
        <%End If 'Cover Document%>
        <%End If 'Size%>
        <%End If 'Viewport and Position%>
      }
      <%If bFX Then%>
      // Special Effects

      if (!canAdjustStyle) { return; }

      var EffectTimer, recordInlineStyles, restoreInlineStyles;
      var clip, drop;
      var oldPositionElement, oldCenterElement, oldMaximizeElement, oldRestoreElement, oldChangeImage, oldSetElementHtml, oldSetElementNodes, oldShowElement, oldSizeElement;
      var ensurePresent = function(el, display) {
        if (!isPresent(el)) {
          if (typeof presentElement == 'function') {
            presentElement(el, true, display);
            return isPresent(el);
          }
          return false;
        }
        return true;
      };

      EffectTimer = function(options) {
        var el, fn, bIn, dir, rpt, revert, duration, ease, cb, cbBounce, cbBeforeDone, pt, ptTemp, fps, interval, started, f, t, p, e, a;
        var myOptions = options || {};

        function processFunctions(prog, endCode) {
          fn(el, prog, pt, endCode);
        }

        function clearInterval() {
          global.clearInterval(interval);
          interval = 0;
        }

        function finish(interrupt) {			
          clearInterval();
          if ((!cbBeforeDone || !cbBeforeDone(el, interrupt)) && (interrupt || revert)) { processFunctions((bIn)?t:f, (revert)?3:2); }
          if (cb) { cb(el, interrupt); }
        }

        function repeat() {
          if (--rpt) {
            if (dir == 'inandout' || dir == 'outandin') { bIn = !bIn; }
            started = new Date();
          }
          else {
            finish();
          }
        }

        function bounce() {
          if ((dir == 'inandout' && bIn) || (dir == 'outandin' && !bIn)) {
            processFunctions(e * (t - f));
            bIn = !bIn;
            if (cbBounce) { cbBounce(el, rpt); }
            started = new Date();
          }
          else {
            finish();
          }			
        }

        function process() {
          p = ((new Date() - started) / duration);
          if (p > 1) { p = 1; }
          e = p;
          if (!bIn) { e = 1 - e; }
          if (ease && p < 1) { e = ease(e); }
          processFunctions(e * (t - f));
          if (p == 1) {
            if (dir == 'in' || dir == 'out' || (dir == 'inandout' && !bIn) || (dir == 'outandin' && bIn)) {
              repeat();
            }
            else {
              bounce();
            }
          }
        }

        function interrupt() {
          finish(true);
        }

        function getOption(options, name) {
          return (typeof options[name] == 'undefined')?myOptions[name]:options[name];
        }

        function fnCombineEffect(fn1, fn2) {
          return function(el, prog, pt, endCode) { fn1(el, prog, pt, endCode); fn2(el, prog, pt, endCode); };
        }

        this.start = function(element, options, fnDone, fnBounce, fnBeforeDone) {
          var index;
          if (interval) { interrupt(); }
          options = options || {};
          el = element;
          f = getOption(options, 'from') || 0;
          t = getOption(options, 'to') || 1;
          dir = (options.dir || 'in').toLowerCase();
          bIn = dir != 'out' && dir != 'outandin';
          duration = getOption(options, 'duration');
          ease = getOption(options, 'ease');
          cb = fnDone;
          cbBounce = fnBounce;
          cbBeforeDone = fnBeforeDone;
          pt = {};
          ptTemp = getOption(options, 'effectParams');
          if (ptTemp) { // Copy effect workspace
            for (index in ptTemp) {
              if (isOwnProperty(ptTemp, index)) {
                pt[index] = ptTemp[index];
              }
            }
          }
          revert = getOption(options, 'revert');
          a = getOption(options, 'effects');
          if (typeof a != 'function') {
            index = a.length;
            while (index--) { fn = (fn)?fnCombineEffect(fn, a[index]):a[index]; }
          }
          else {
            fn = a;
          }
          fps = getOption(options, 'fps') || 30;
          started = new Date();
          rpt = getOption(options, 'repeat') || 1;
          interval = global.setInterval(process, 1000 / fps);
          processFunctions((bIn)?f:t, 1);
        };

        this.stop = function(complete) { if (complete) { bIn = (dir == 'in' || dir == 'outandin'); interrupt(); } else { finish(); } };
        this.busy = function() { return !!interval; };
      };

      API.EffectTimer = EffectTimer;

      recordInlineStyles = function(el, styles, scratch) {
        var i = styles.length;
        while (i--) { scratch[styles[i]] = el.style[styles[i]]; }
      };
	
      restoreInlineStyles = function(el, styles, scratch) {
        var i = styles.length;	
        while (i--) { el.style[styles[i]] = scratch[styles[i]]; }
      };

      if (typeof showElement == 'function') {
        oldShowElement = showElement;

	showElement = API.showElement = (function() {
          var activeEffects = {};
          var cb = {};

          function finish(el, b, options) {
            if (!b && (options && options.removeOnHide) && typeof presentElement == 'function') { presentElement(el, false); }
          }

          return function(el, b, options, fnDone) {
            var effect, fnDoneInternal, fnBeforeDone, uid;

            options = options || {};

            uid = elementUniqueId(el);
            if (activeEffects[uid]) {
              activeEffects[uid].stop(true);
              presentElement(el, options.display);
            }

            if (options.effects) {
              effect = new EffectTimer();
              options.dir = (b)?'in':'out';
              options.revert = true;
              cb[uid] = fnDone;
              if (ensurePresent(el, options.display)) {
                fnDoneInternal = function(el, interrupt) {
                  finish(el, b, options);
                  effect = null;
                  activeEffects[uid] = null;
                  if (cb[uid]) { cb[uid](el, b); }
                };
                fnBeforeDone = function(el, interrupt) {
                  if (!b && !interrupt) { oldShowElement(el, false); }
                };
                activeEffects[uid] = effect;
                effect.start(el, options, fnDoneInternal, null, fnBeforeDone);
              }
            }
            else {
              oldShowElement(el, b, options);
              if (fnDone) { fnDone(); }
            }
            return el;
          };
	})();

        toggleElement = API.toggleElement = function(el, options, fnDone) {
          return showElement(el, !isVisible(el) || !isPresent(el), options, fnDone);
        };

        showElement.async = true;
        toggleElement.async = true;
      }

      if (typeof sizeElement == 'function') {
        oldSizeElement = sizeElement;
        sizeElement = (function() {
          var activeEffects = {};
          var cb = {};
          return function(el, h, w, options, fnDone) {
            var effect, fnDoneInternal, pt, uid;
            if (options && options.duration) {
              uid = elementUniqueId(el);
              if (activeEffects[uid]) { activeEffects[uid].stop(true);}
              effect = new EffectTimer();
              options.effects = effects.grow;
              pt = options.effectParams || {};
              pt.targetSize = [h, w];
              options.effectParams = pt;
              cb[elementUniqueId(el)] = fnDone;
              fnDoneInternal = function() {
                effect = null;
                activeEffects[uid] = null;
                if (cb[uid]) { cb[uid](el); }
              };
              activeEffects[uid] = effect;
              effect.start(el, options, fnDoneInternal);
            }
            else {
              oldSizeElement(el, h, w);
              if (fnDone) { fnDone(el); }
            }			
          };
        })();
        sizeElement.async = true;
        API.sizeElement = sizeElement;
      }

      if (typeof positionElement == 'function') {      
        oldPositionElement = positionElement;

        positionElement = (function() {
          var activeEffects = {};
          var cb = {};
          return function(el, t, l, options, fnDone) {
            var effect, fnDoneInternal, pt, uid;
            if (options && options.duration) {
              uid = elementUniqueId(el);
              if (activeEffects[uid]) { activeEffects[uid].stop(true);}
              effect = new EffectTimer();
              options.effects = effects.move;
              pt = options.effectParams || {};
              pt.targetPosition = [t, l];
              options.effectParams = pt;
              cb[uid] = fnDone;
              fnDoneInternal = function(el, interrupt) {
                effect = null;
                activeEffects[uid] = null;
                if (cb[uid]) { cb[uid](el, interrupt); }
              };
              activeEffects[uid] = effect;
              effect.start(el, options, fnDoneInternal);
            }
            else {
              oldPositionElement(el, t, l);
              if (fnDone) { fnDone(el); }
            }
          };				
        })();

        positionElement.async = true;
        API.positionElement = positionElement;
      }

      effects = {};

      if (typeof setOpacity == 'function') {
        effects.fade = function(el, p, scratch, endCode) {
          if (endCode) {
            if (endCode > 2) {
                p = (typeof scratch.targetOpacity != 'undefined')?0:1;
            }
            if (endCode == 2) { p = 1; }
            if (endCode == 1) {
              scratch.opacity = getOpacity(el) || 1;
              if (scratch.opacity >= 0.9999) { scratch.opacity = 1; }
              if (canAdjustStyle.visibility) { el.style.visibility = 'visible'; }
            }
          }
          p = (typeof scratch.targetOpacity != 'undefined')?scratch.opacity + (scratch.targetOpacity - scratch.opacity) * p:scratch.opacity * p;
          setOpacity(el, (p >= 1)?0.9999:p); // Some versions of Firefox blink on 1
        };
      }

      drop = function(side, pos, dim, p) {
        var y, x, h, w;
        y = pos[0];
        x = pos[1];
        h = dim[0];
        w = dim[1];
        switch(side) {					
        case 'left':
          x = ((x + w) - (p * w));
          break;
        case 'top':
          y = ((y + h) - (p * h));
          break;
        case 'diagonalsw':
          y = ((y + h) - (p * h)); 
          x = ((x - w) + (p * w)); 
          break;
        case 'diagonalnw':
          y = ((y - h) + (p * h)); 
          x = ((x - w) + (p * w)); 
          break;
        case 'diagonalse':
          y = ((y + h) - (p * h)); 
          x = ((x + w) - (p * w)); 
          break;
        case 'diagonalne':
          y = ((y - h) + (p * h)); 
          x = ((x + w) - (p * w));
          break;
        case 'bottom':
          y = ((y - h) + (p * h));
          break;
        default:
          x = ((x - w) + (p * w));
        }
	return [y, x];
      };

      clip = function(side, dim, p) {
        var h = dim[0];
        var w = dim[1];
        switch(side) {
        case 'top':
          return "rect(0px " + w + "px " + Math.round(p * h) + "px 0px)";
        case 'left':
          return "rect(0px " + Math.round(p * w) + "px " + h + "px 0px)";
        case 'zoom':
          return "rect(" + Math.round(((1 - p) / 2) * h) + "px " + Math.round((p / 2) * w + w / 2) + "px " + Math.round((p / 2) * h + h / 2) +  "px " + Math.round(((1 - p) / 2) * w) + "px)";
        case 'horizontal':
          return "rect(" + (Math.round(((1 - p) / 2) * h)) + "px " + w + "px " + Math.round((p / 2) * h + h / 2) + "px 0px)";
        case 'vertical':
          return "rect(0px " + Math.round((p / 2) * w + w/2) + "px " + h +  "px " + (Math.round(((1 - p) / 2) * w)) + "px)";
        case 'diagonalnw':
          return "rect(" + Math.round((1 - p) * h) + "px " + w + "px " + h + "px " + Math.round((1 - p) * w) + "px)";
        case 'diagonalne':
          return "rect(" + Math.round((1 - p) * h) + "px " + Math.round(p * w) + "px " + h + "px 0px)";
        case 'diagonalsw':
          return "rect(0px " + w + "px " + Math.round(p * h) + "px " + Math.round((1 - p) * w) + "px)";
        case 'diagonalse':
          return "rect(0px " + Math.round(p * w) + "px " + Math.round(p * h) + "px 0px)";
        case 'bottom':
          return "rect(" + Math.round((1 - p) * h) + "px " + w + "px " + h + "px 0px)";
        default:
          return "rect(0px " + w + "px " + h + "px " + Math.round((1 - p) * w) + "px)";
        }
      };

      if (typeof oldPositionElement == 'function') {
        effects.drop = (function() {
          var posNew;
          return function(el, p, scratch, endCode) {
            if (endCode) {
              if (endCode > 2) {
                restoreInlineStyles(el, ['top', 'left', 'position'], scratch);
                return;
              }
              if (endCode == 1) {
                recordInlineStyles(el, ['top', 'left', 'position'], scratch);
                if (typeof ensurePositionable == 'undefined' || ensurePositionable(el)) {
                  if (!scratch.dimOuter) { scratch.dimOuter = getElementSize(el); }
                  if (!scratch.pos) { scratch.pos = getElementPositionStyle(el); }
                }
                else {
                  scratch.pos = null;
                }
                if (canAdjustStyle.visibility) { el.style.visibility = 'visible'; }
              }
            }
            if (scratch.pos) {
              posNew = drop(scratch.side, scratch.pos, scratch.dimOuter, p);
              oldPositionElement(el, posNew[0], posNew[1]);
            }
          };
        })();
      }

      if (typeof oldSizeElement == 'function') {
        effects.grow = (function() {
          var axes, h, w;
          var reUnits = new RegExp('(.+)(em|px|pt|%)');

          function getFont(el) {
            var match;
            var font = getInlineStyle(el, 'fontSize') || getStyle(el, 'fontSize');

            if (font) {
              match = font.match(reUnits);
            }

            return match && { size:parseFloat(match[1]), unit:match[2] };
          }

          return function(el, p, scratch, endCode) {
            if (endCode) {
              if (endCode > 2) {
                restoreInlineStyles(el, ['overflow', 'fontSize', 'height', 'width'], scratch);
                return;
              }
              if (endCode == 1) {
                recordInlineStyles(el, ['overflow', 'fontSize', 'height', 'width'], scratch);
                el.style.overflow = 'hidden';
                if (ensureSizable(el)) {
                  if (!scratch.dim) { scratch.dim = getElementSizeStyle(el); }
                }
                else {
                  scratch.dim = null;
                }
                if (getKomputedStyle) { scratch.font = getFont(el); }
                if (canAdjustStyle.visibility) { el.style.visibility = 'visible'; }
              }
            }
			
            if (scratch.dim) {
              if (scratch.targetSize) {
                h = (scratch.dim[0] + (scratch.targetSize[0] - scratch.dim[0]) * p);
                w = (scratch.dim[1] + (scratch.targetSize[1] - scratch.dim[1]) * p);
              }
              else {
                axes = scratch.axes;
                h = (!axes || axes == 1)?scratch.dim[0] * p:null;
                w = (!axes || axes == 2)?scratch.dim[1] * p:null;
                if (!axes && scratch.font && p >= 0) { el.style.fontSize = (scratch.font.size * p) + scratch.font.unit; }
              }
              oldSizeElement(el, (h < 0)?null:h, (w < 0)?null:w);
            }			
          };
	})();

        effects.fold = function(el, p, scratch, endCode) {
          if (endCode == 1) { scratch.axes = scratch.axes || 2; }
          effects.grow(el, p, scratch, endCode);
        };
      }

      // TODO: Detect clip style

      if (API.unclipElement) { // Add-on as function has conditional compilation, which fouls up minification
        effects.clip = (function() {
          return function(el, p, scratch, endCode) {
            if (endCode) {
              if (endCode > 2) {
                restoreInlineStyles(el, ['overflow', 'position'], scratch);
                API.unclipElement(el);
                return;
              }
              if (endCode == 1) {
                recordInlineStyles(el, ['overflow', 'position'], scratch);
                el.style.overflow = 'hidden';
                if (typeof ensurePositionable == 'function') { ensurePositionable(el); }
                if (!scratch.dimOuter) { scratch.dimOuter = getElementSize(el); }
                if (canAdjustStyle.visibility) { el.style.visibility = 'visible'; }
              }
            }
            el.style.clip = clip(scratch.side, scratch.dimOuter, p);
          };
        })();

        effects.zoom = function(el, p, scratch, endCode) {
          if (endCode == 1) { scratch.side = 'zoom'; }
          effects.clip(el, p, scratch, endCode);
        };

        effects.horizontalBlinds = function(el, p, scratch, endCode) {
          if (endCode == 1) { scratch.side = 'horizontal'; }
          effects.clip(el, p, scratch, endCode);
        };

        effects.verticalBlinds = function(el, p, scratch, endCode) {
          if (endCode == 1) { scratch.side = 'vertical'; }
          effects.clip(el, p, scratch, endCode);
	};

        if (typeof oldPositionElement == 'function') {
          effects.slide = (function() {
            var posNew;
            return function(el, p, scratch, endCode) {
              if (endCode) {
                if (endCode > 2) {
                  restoreInlineStyles(el, ['overflow', 'top', 'left', 'position'], scratch);
                  API.unclipElement(el);
                  return;
                }
                if (endCode == 1) {
                  recordInlineStyles(el, ['overflow', 'top', 'left', 'position'], scratch);
                  el.style.overflow = 'hidden';
                  if (typeof ensurePositionable == 'undefined' || ensurePositionable(el)) {
                    if (!scratch.dimOuter) { scratch.dimOuter = getElementSize(el); }
                    if (!scratch.pos) { scratch.pos = getElementPositionStyle(el); }
                  }
                  else {
                    scratch.pos = null;
                  }
                  if (canAdjustStyle.visibility) { el.style.visibility = 'visible'; }
                }
              }
              if (scratch.pos) {
                posNew = drop(scratch.side, scratch.pos, scratch.dimOuter, p);
                oldPositionElement(el, posNew[0], posNew[1]);
                el.style.clip = clip(scratch.side, scratch.dimOuter, p);
              }			
            };
          })();
        }
      }
      <%If bScrollFX Then%>
      // Scrolling effects

      var oldSetScrollPosition, oldSetElementScrollPosition;

      var setScrollPositionCommon = (function() {
        var activeEffects = {}, cb = {}, fnDoneInternal;

        return function(pos, el, isNormalized, options, fnDone, elWheel) {
          var effect, pt, uid = elementUniqueId(el);
          elWheel = elWheel || el;
          if (options) {
            if (activeEffects[uid]) {
              activeEffects[uid].stop(true);
            }
            pt = {};
            effect = new EffectTimer();
            pt.targetScroll = pos;
            cb[uid] = fnDone;
            fnDoneInternal = function(el, interrupt) {
              if (options.wheelInterrupts && typeof detachMousewheelListener == 'function') {
                detachMousewheelListener(elWheel);
              }
              activeEffects[uid] = null;
              if (cb[uid]) { cb[uid](el, interrupt); }
            };
            options.effectParams = pt;
            if (options.wheelInterrupts && typeof attachMousewheelListener == 'function') {
              attachMousewheelListener(elWheel, function() { effect.stop(); });
            }
            activeEffects[uid] = effect;
            effect.start(el, options, fnDoneInternal);
          }
        };
      })();

      if (typeof setScrollPosition == 'function') {
        oldSetScrollPosition = setScrollPosition;
        setScrollPosition = API.setScrollPosition = function(t, l, docNode, isNormalized, options, fnDone) {
          var pos = (!getScrollPositionMax || isNormalized || (!t && !l))?[t, l]:normalizeScroll(t, l, getScrollPositionMax(docNode));
          if (options) {
            options.effects = effects.scroll;
            setScrollPositionCommon(pos, docNode || global.document, isNormalized, options, fnDone, getContainerElement(docNode));
          }
          else {
            oldSetScrollPosition(pos[0], pos[1], docNode, true);
          }
        };

        effects.scroll = function(docNode, e, scratch, endpoint) {
          if (endpoint) {
            if (endpoint > 2) {
              oldSetScrollPosition(scratch.scrollPos[0], scratch.scrollPos[1], docNode, true);
              return;
            }
            if (endpoint == 1) {
              scratch.scrollPos = getScrollPosition(docNode);
              if (getDocumentWindow) { scratch.win = getDocumentWindow(docNode); }
              if (scratch.targetScroll[0] === null) { scratch.targetScroll[0] = scratch.scrollPos[0]; }
              if (scratch.targetScroll[1] === null) { scratch.targetScroll[1] = scratch.scrollPos[1]; }
            }
          }
          oldSetScrollPosition((scratch.targetScroll[0] - scratch.scrollPos[0]) * e + scratch.scrollPos[0], (scratch.targetScroll[1] - scratch.scrollPos[1]) * e + scratch.scrollPos[1], docNode, true, scratch.win);
        };
      }

      if (typeof setElementScrollPosition == 'function') {
        oldSetElementScrollPosition = setElementScrollPosition;
        setElementScrollPosition = API.setElementScrollPosition = function(el, t, l, isNormalized, options, fnDone) {
          var pos = (isNormalized || (!t && !l))?[t, l]:normalizeScroll(t, l, getElementScrollPositionMax(el));
          if (options) {
            options.effects = effects.scrollElement;
            setScrollPositionCommon(pos, el, isNormalized, options, fnDone);
          }
          else {
            oldSetElementScrollPosition(el, pos[0], pos[1], true);
          }
        };

        effects.scrollElement = function(el, e, scratch, endpoint) {
          if (endpoint) {
            if (endpoint > 2) {
              oldSetElementScrollPosition(el, scratch.scrollPos[0], scratch.scrollPos[1], true);
              return;
            }
            if (endpoint == 1) {
              scratch.scrollPos = getElementScrollPosition(el);
            }
          }
          oldSetElementScrollPosition(el, (scratch.targetScroll[0] - scratch.scrollPos[0]) * e + scratch.scrollPos[0], (scratch.targetScroll[1] - scratch.scrollPos[1]) * e + scratch.scrollPos[1], true);
        };
      }
      <%End If 'Scroll FX%>

      if (typeof oldPositionElement == 'function') {
        effects.move = function(el, p, scratch, endCode) {
          if (endCode) {
            if (endCode > 2) {
              if (scratch.pos) { oldPositionElement(el, scratch.pos[0], scratch.pos[1]); }
              return;
            }
            if (endCode == 1) {
              if (typeof ensurePositionable == 'undefined' || ensurePositionable(el)) {
                if (!scratch.pos) { scratch.pos = getElementPositionStyle(el); }
                if (scratch.pos) {
                  if (scratch.targetPosition[0] === null) { scratch.targetPosition[0] = scratch.pos[0]; }
                  if (scratch.targetPosition[1] === null) { scratch.targetPosition[1] = scratch.pos[1]; }
                }
              }
              else {
                scratch.pos = null;
              }
            }
          }
          if (scratch.pos) { oldPositionElement(el, (scratch.pos[0] + ((scratch.targetPosition[0] - scratch.pos[0]) * p)), (scratch.pos[1] + ((scratch.targetPosition[1] - scratch.pos[1]) * p))); }
	};

        if (typeof maximizeElement == 'function') {
          oldMaximizeElement = maximizeElement;
          oldRestoreElement = restoreElement;
          maximizeElement = API.maximizeElement = function(el, options, fnDone) {
            var l, t, h, r, w, oldT, oldL, oldH, oldW, oldV, oldP;
            if (options) {
              oldT = el.style.top;
              oldL = el.style.left;
              oldH = el.style.height;
              oldW = el.style.width;
              oldV = el.style.visibility;
              oldP = el.style.position;
              el.style.visibility = 'hidden';
              r = oldMaximizeElement(el);
              if (oldP == el.style.position) {
                t = getStylePixels(el, 'top');
                l = getStylePixels(el, 'left');
                h = getStylePixels(el, 'height');
                w = getStylePixels(el, 'width');
                el.style.top = oldT;
                el.style.left = oldL;
                el.style.height = oldH;
                el.style.width = oldW;
                el.style.visibility = oldV;
                positionElement(el, t, l, options, fnDone);
                sizeElement(el, h, w, options, fnDone);
              }
              else {
                el.style.visibility = oldV;
                if (fnDone) { fnDone(el); }
              }
            }
            else {
              r = oldMaximizeElement(el);
              if (fnDone) { fnDone(el); }
            }
            return r;
          };
          maximizeElement.async = true;
          restoreElement = API.restoreElement = function(el, options, fnDone) {
            var a, l, t, h, r, w, oldT, oldL, oldH, oldW, oldV, oldP;
            if (options) {
              oldT = el.style.top;
              oldL = el.style.left;
              oldH = el.style.height;
              oldW = el.style.width;
              oldV = el.style.visibility;
              oldP = el.style.position;
              el.style.visibility = 'hidden';
              r = oldRestoreElement(el);
              if (oldP == el.style.position) {
                t = getStylePixels(el, 'top');
                l = getStylePixels(el, 'left');
		a = getElementSizeStyle(el);
		h = a[0];
		w = a[1];
                el.style.top = oldT;
                el.style.left = oldL;
                el.style.height = oldH;
                el.style.width = oldW;
                el.style.visibility = oldV;
                positionElement(el, t, l, options, fnDone);
                sizeElement(el, h, w, options, fnDone);
              }
              else {
                el.style.visibility = oldV;
                if (fnDone) { fnDone(el); }
              }
            }
            else {
              r = oldRestoreElement(el);
              if (fnDone) { fnDone(el); }
            }
            return r;
          };
          restoreElement.async = true;
        }

        if (typeof centerElement == 'function') {
          oldCenterElement = centerElement;
          centerElement = API.centerElement = function(el, options, fnDone) {
            var l, t, oldL, oldT, oldV, oldP;
            if (options) {
              oldT = el.style.top;
              oldL = el.style.left;
              oldV = el.style.visibility;
              oldP = el.style.position;
              el.style.visibility = 'hidden';
              oldCenterElement(el);
              t = getStylePixels(el, 'top');
              l = getStylePixels(el, 'left');
              el.style.top = oldT;
              el.style.left = oldL;
              el.style.visibility = oldV;
              if (oldP == el.style.position) {
                positionElement(el, t, l, options, fnDone);
                return;
              }
            }
            oldCenterElement(el);
            if (fnDone) { fnDone(el); }
          };
          centerElement.async = true;

          if (effects.grow && typeof overlayElement == 'function' && typeof showElement == 'function') {
            spring = function(el, elFrom, b, options, callback) {
              var pos, posOld, optionsNew = { duration:options.duration, ease:options.ease, removeOnHide:options.removeOnHide };
              if (options.effects && typeof options.effects == 'function') {
                optionsNew.effects = [options.effects];
              }
              else {
                optionsNew.effects = (options.effects || []).concat([effects.grow]);
              }
              if (b) {
		pos = getElementPositionStyle(el);
                overlayElement(el, elFrom);
		if (options.springMode == 'center') {
			centerElement(el, { duration:options.duration, ease:options.ease });
		}
		else {
			positionElement(el, pos[0], pos[1], { duration:options.duration, ease:options.ease });
		}
              }
              else {
                posOld = getElementPositionStyle(el);
                el.style.visibility = 'hidden';
                overlayElement(el, elFrom);
                pos = getElementPositionStyle(el);
                positionElement(el, posOld[0], posOld[1]);
                el.style.visibility = 'visible';
                positionElement(el, pos[0], pos[1], { duration:options.duration, ease:options.ease, revert:true });
              }
              showElement(el, b, optionsNew, callback);
            };

            API.spring = spring;
          }
        }

        effects.shake = function(el, p, scratch, endCode) {
          if (endCode) {
            if (endCode > 2) {
              restoreInlineStyles(el, ['top', 'left', 'position'], scratch);
              return;
            }
            if (endCode == 1) {
              recordInlineStyles(el, ['top', 'left', 'position'], scratch);
              if (typeof ensurePositionable == 'undefined' || ensurePositionable(el)) {
                if (!scratch.pos) { scratch.pos = getElementPositionStyle(el); }
              }
              else {
                scratch.pos = null;
              }
              scratch.severity = scratch.severity || 5;
              if (canAdjustStyle.visibility) { el.style.visibility = 'visible'; }
            }
          }
          if (scratch.pos) { oldPositionElement(el, scratch.pos[0] + (!scratch.axes || scratch.axes == 1)?(scratch.severity - Math.floor(Math.random() * (scratch.severity * 2 + 1))):0, scratch.pos[1] + (!scratch.axes || scratch.axes == 2)?(scratch.severity - Math.floor(Math.random() * (scratch.severity * 2 + 1))):0); }
	};
      }

      API.effects = effects;
      <%If bEase Then%>
      API.ease = {};

      API.ease.sine = function(p) {
        return (Math.sin(p * Math.PI / 2));
      };

      API.ease.cosine = function(p) {
        return ((-Math.cos(p * Math.PI) / 2) + 0.5);
      };

      API.ease.tan = function(p) {
        var tan = Math.tan;
        return (tan(1*(2*p-1))/tan(1)+1)/2;
      };

      API.ease.flicker = function(p) {
        return ((-Math.cos(p * Math.PI) / 4) + 0.75) + Math.random() * 0.25;
      };

      API.ease.wobble = function(p) {
        return (-Math.cos(p * Math.PI * (9 * p)) / 2) + 0.5;
      };

      API.ease.square = function(p) {
        return(Math.pow(p, 2));
      };

      API.ease.circle = function(p) {
        return Math.sqrt(1 - Math.pow((p - 1), 2));
      };

      API.ease.pulsate = function(p) {
        return (0.5 + Math.sin(17 * p) / 2);
      };

      API.ease.expo = function(p) {
        return Math.pow(2, 8 * (p - 1));
      };

      API.ease.quad = function(p) {
        return Math.pow(p, 2);
      };

      API.ease.cube = function(p) {
        return Math.pow(p, 3);
      };

      // Sigmoid functions based upon work by Emmanuel Pietriga.
      // http://www.docjar.net/html/api/com/xerox/VTM/engine/AnimManager.java.html
      // Copyright (c) Xerox Corporation, XRCE/Contextual Computing, 2002.

      API.ease.sigmoid = function(p, steepness) { // Currently no way to pass second parameter to easing function
        var atan = Math.atan;
        steepness = steepness || 1;
        return (atan(steepness*(2*p-1))/atan(steepness)+1)/2;
      };

      API.ease.sigmoid2 = function(p) {
        var atan = Math.atan;
        return (atan(2*(2*p-1))/atan(2)+1)/2;
      };

      API.ease.sigmoid3 = function(p) {
        var atan = Math.atan;
        return (atan(3*(2*p-1))/atan(3)+1)/2;
      };

      API.ease.sigmoid4 = function(p) {
        var atan = Math.atan;
        return (atan(4*(2*p-1))/atan(4)+1)/2;
      };
	
      API.ease.loop = function(p) {
        return (-Math.cos(2*p*Math.PI)/2) + 0.5;
      };

      API.ease.bounce = function(p) { 
        return 1 - (Math.cos(p * 4.5 * Math.PI) * Math.exp(-p * 6)); 
      };

      // Based on Easing Equations v2.0 
      // (c) 2003 Robert Penner, all rights reserved. 
      // This work is subject to the terms in http://www.robertpenner.com/easing_terms_of_use.html

      API.ease.swingTo = function(p) { 
        var s = 1.70158; 
        return (p-=1)*p*((s+1)*p + s) + 1;
      };

      API.ease.swingToFrom = function(p) {
        var s = 1.70158; 
        if ((p/=0.5) < 1) { return 0.5*(p*p*(((s*=(1.525))+1)*p - s)); }
        return 0.5*((p-=2)*p*(((s*=(1.525))+1)*p + s) + 2); 
      };

      <%End If 'Ease%>
      <%If bOverlay And bShow Then%>
      <%If bImage Then%>
      if (typeof changeImage == 'function') {
        oldChangeImage = changeImage;
        changeImage = (function() {
          if (canAdjustStyle.visibility && canAdjustStyle.display && body && isHostMethod(body, 'cloneNode') && isHostMethod(body, 'appendChild') && isHostMethod(body, 'removeChild')) {
            return function(el, src, options, fnDone) {
              var elTemp;
              var docNode = getElementDocument(el);
              var body = getBodyElement(docNode);

              var done = function() {
                oldChangeImage(el, src);
                showElement(elTemp, false);
                body.removeChild(elTemp);
                elTemp = null;
              };

              if (options && options.effects) {
                elTemp = el.cloneNode(false);
                elTemp.id = elementUniqueId(el) + '_temporaryoverlay';
                oldChangeImage(elTemp, src);
                elTemp.style.visibility = 'hidden';
                elTemp.style.display = 'none';
                elTemp.style.position = 'absolute';
                elTemp.style.left = elTemp.style.top = '0';
                body.appendChild(elTemp);
                elTemp.style.display = 'block';
                overlayElement(elTemp, el);
                showElement(elTemp, true, options, function() { done(); if (fnDone) { fnDone(el); } });
              }
              else {
                oldChangeImage(el, src);
                if (fnDone) { fnDone(el); }
              }
            };
          }
          return function(el, src, options, fnDone) {
            oldChangeImage(el, src);
            if (fnDone) { fnDone(el); }
          };
        })();
        API.changeImage = changeImage;
      }
      <%End If 'Image%>
      <%If bHTML Then%>
      if (typeof setElementHtml == 'function' && canAdjustStyle.visibility && canAdjustStyle.display && body && isHostMethod(body, 'cloneNode') && isHostMethod(body, 'appendChild') && isHostMethod(body, 'removeChild')) {
        oldSetElementHtml = setElementHtml;
        setElementHtml = function(el, html, options, fnDone) {
          var elTemp;
          var docNode = getElementDocument(el);
          var body = getBodyElement(docNode);

          var done = function() {
            el = oldSetElementHtml(el, html);
            showElement(elTemp, false);
            body.removeChild(elTemp);
            elTemp = null;
          };

          if (options && options.effects) {
            elTemp = el.cloneNode(false);
            elTemp.id = elementUniqueId(el) + '_temporaryoverlay';
            elTemp.style.visibility = 'hidden';
            elTemp.style.display = 'none';
            elTemp.style.position = 'absolute';
            elTemp.style.left = elTemp.style.top = '0';
            body.appendChild(elTemp);
            elTemp = oldSetElementHtml(elTemp, html);
            elTemp.style.display = 'block';
            overlayElement(elTemp, el, true);
            showElement(elTemp, true, options, function() { done(); if (fnDone) { fnDone(el); } });
            return el;
          }
          else {
            el = oldSetElementHtml(el, html);
            if (fnDone) { fnDone(el); }
            return el;
          }
        };

        API.setElementHtml = setElementHtml;
      }
      <%End If 'HTML%>
      <%If bImport Then%>
      if (typeof setElementNodes == 'function' && canAdjustStyle.visibility && canAdjustStyle.display && body && isHostMethod(body, 'cloneNode') && isHostMethod(body, 'appendChild') && isHostMethod(body, 'removeChild')) {
        oldSetElementNodes = setElementNodes;
        setElementNodes = function(el, elNewNodes, options, fnDone) {
          var elTemp;
          var docNode = getElementDocument(el);
          var body = getBodyElement(docNode);

          var done = function() {
            oldSetElementNodes(el, elNewNodes);
            showElement(elTemp, false);
            body.removeChild(elTemp);
            elTemp = null;
          };

          if (options && options.effects) {
            elTemp = el.cloneNode(false);
            elTemp.id = elementUniqueId(el) + '_temporaryoverlay';
            oldSetElementNodes(elTemp, elNewNodes);
            elTemp.style.visibility = 'hidden';
            elTemp.style.display = 'none';
            elTemp.style.position = 'absolute';
            elTemp.style.left = elTemp.style.top = '0';
            body.appendChild(elTemp);
            elTemp.style.display = 'block';
            overlayElement(elTemp, el, true);
            showElement(elTemp, true, options, function() { done(); if (fnDone) { fnDone(el); } });
          }
          else {
            oldSetElementNodes(el, elNewNodes);
            if (fnDone) { fnDone(el); }
          }
        };

        API.setElementNodes = setElementNodes;
      }
      <%End If 'Import%>
      <%End If 'Overlay and Show%>
      <%End If 'FX%>
      <%End If 'Style%>
      body = containerElement = null;
    });
    <%If bDirectX Then%>
    // DirectX section

    attachDocumentReadyListener(function() {
      var body = getBodyElement();
      var oldShowElement, oldSetElementHtml, oldSetElementNodes, oldChangeImage;

      if (typeof isStyleCapable != 'undefined' && isStyleCapable && body && isRealObjectProperty(body, 'filters')) {
        applyDirectXTransitionFilter = function(el, name, duration, params) {
          var f, index, p;
          duration = duration || 1000;
          if (typeof el.filters != 'undefined') {
            if (el.currentStyle && !el.currentStyle.hasLayout) { el.style.zoom = '1'; }
            if (el.filters.length && (f = el.filters['DXImageTransform.Microsoft.' + name])) {
              f.duration = duration / 1000;
              if (params) { for (index in params) { if (isOwnProperty(params, index)) { f[index] = params[index]; } } }
              if (f.status == 2) { f.stop(); }
              f.enabled = true;
            }
            else {
              if (typeof el.style.filter == 'string') {
                p = '';
                if (params) { for (index in params) { if (isOwnProperty(params, index)) { p += ',' + index + '=' + params[index]; } } }
                el.style.filter += ((el.style.filter)?' ':'') + 'progid:DXImageTransform.Microsoft.' + name + '(duration=' + (duration / 1000) + p + ')';
              }
            }
            if (el.filters['DXImageTransform.Microsoft.' + name]) { el.filters['DXImageTransform.Microsoft.' + name].apply(); }
            return true;
          }
        };

        API.applyDirectXTransitionFilter = applyDirectXTransitionFilter;

        playDirectXTransitionFilter = function(el, name) {
          var f;
          if (typeof el.filters != 'undefined') {
            f = el.filters['DXImageTransform.Microsoft.' + name];
            if (f) {
              if (f.status == 2) { f.stop(); }
              f.play();
            }
          }
        };

        API.playDirectXTransitionFilter = playDirectXTransitionFilter;
        <%If bImage Then%>
        if (typeof changeImage == 'function') {
          oldChangeImage = changeImage;
          changeImage = (function() {
            var activeEffects = {};
            var cb = {};

            return function(el, src, options, callback) {
              var uid = elementUniqueId(el);

              if (activeEffects[uid]) {
                 global.clearTimeout(activeEffects[uid]);
                 cb[uid]();
              }
              if (options && options.directXTrans && applyDirectXTransitionFilter(el, options.directXTrans, options.duration, options.directXParams)) {
                oldChangeImage(el, src);
                playDirectXTransitionFilter(el, options.directXTrans);
                cb[uid] = function() { activeEffects[uid] = null; if (callback) { callback(el); } };
                activeEffects[uid] = global.setTimeout(cb[uid], options.duration);
              }
              else {
                oldChangeImage(el, src, options, callback);
                if (callback && typeof effects == 'undefined') { callback(el); }
              }
            };
          })();

          API.changeImage = changeImage;
        }
        <%End If 'Image%>
        <%If bHTML Then%>
        if (typeof setElementHtml == 'function') {
          oldSetElementHtml = setElementHtml;
          setElementHtml = (function() {
            var activeEffects = {};
            var cb = {};

            return function(el, html, options, callback) {
              var uid = elementUniqueId(el);

              if (activeEffects[uid]) {
                 global.clearTimeout(activeEffects[uid]);
                 cb[uid]();
              }
              if (options && options.directXTrans && applyDirectXTransitionFilter(el, options.directXTrans, options.duration, options.directXParams)) {
                el = oldSetElementHtml(el, html);
                playDirectXTransitionFilter(el, options.directXTrans);
                cb[uid] = function() { activeEffects[uid] = null; if (callback) { callback(el); } };
                activeEffects[uid] = global.setTimeout(cb[uid], options.duration);
                return el;
              }
              else {
                el = oldSetElementHtml(el, html, options, callback);
                if (callback && typeof effects == 'undefined') { callback(el); }
                return el;
              }          
            };
          })();

          API.setElementHtml = setElementHtml;
        }
        <%End If 'HTML%>
        <%If bImport Then%>
        if (typeof setElementNodes == 'function') {
          oldSetElementNodes = setElementNodes;
          setElementNodes = (function() {
            var activeEffects = {};
            var cb = {};

            return function(el, elNewNodes, options, callback) {
              var uid = elementUniqueId(el);

              if (activeEffects[uid]) {
                 global.clearTimeout(activeEffects[uid]);
                 cb[uid]();
              }
              if (options && options.directXTrans && applyDirectXTransitionFilter(el, options.directXTrans, options.duration, options.directXParams)) {
                oldSetElementNodes(el, elNewNodes);
                playDirectXTransitionFilter(el, options.directXTrans);
                cb[uid] = function() { activeEffects[uid] = null; if (callback) { callback(el); } };
                activeEffects[uid] = global.setTimeout(cb[uid], options.duration);
              }
              else {
                oldSetElementNodes(el, elNewNodes, options, callback);
                if (callback && typeof effects == 'undefined') { callback(el); }
              }
            };
          })();

          API.setElementNodes = setElementNodes;
        }
        <%End If 'Import%>
        if (typeof showElement == 'function') {
          oldShowElement = showElement;

          showElement = (function() {
            var activeEffects = {};
            var cb = {};
            function finish(el, b, options) {
              if (!b && (options && options.removeOnHide) && typeof presentElement == 'function') {
                presentElement(el, false);
              }
            }
            return function(el, b, options, callback) {
              var uid = elementUniqueId(el);
              if (activeEffects[uid]) {
                 global.clearTimeout(activeEffects[uid]);
                 cb[uid]();
              }
              if (options && options.directXTrans && applyDirectXTransitionFilter(el, options.directXTrans, options.duration, options.directXParams)) {
                oldShowElement(el, b);
                playDirectXTransitionFilter(el, options.directXTrans);
                cb[uid] = function() { activeEffects[uid] = null; finish(el, b, options); if (callback) { callback(el); } };
                activeEffects[uid] = global.setTimeout(cb[uid], options.duration);
              }
              else {
                oldShowElement(el, b, options, callback);
                if (callback && typeof effects == 'undefined') { callback(el); }
              }
            };
          })();

          toggleElement = API.toggleElement = function(el, options, fnDone) {
            // There is a bug (feature?) in IE where cascaded style overrules inline when transitioning to visible
            return showElement(el, el.style.visibility == 'hidden' || !isVisible(el) || !isPresent(el), options, fnDone);
          };

          API.showElement = showElement;
          toggleElement.async = showElement.async = oldShowElement.async;
        }
      }
      body = null;
    });
    <%End If 'DirectX%>
  }
  <%If bScript Then%>
  // Script section

  if (attachDocumentReadyListener) {
    attachDocumentReadyListener(function() {
      var add, body, div, el, findAndAddScripts, head, iMethod, methods, oldAddElementHtml, oldSetElementHtml, s, script, addScriptHtmlFailed, setScriptHtmlFailed;
      if (getHeadElement) { head = getHeadElement(); }
      if (head && isHostMethod(head, 'appendChild') && createElement) {
        methods = [];
        s = createElement('script');
        if (s) {
          add = function(method, t, docNode) {
            method(s, t, docNode);
          };

          if (isHostMethod(global.document, 'createTextNode') && elementCanHaveChildren(s)) {
            methods[methods.length] = function(s, t, docNode) {
              s.appendChild((docNode || global.document).createTextNode(t));
            };
          }

          if (typeof s.text == 'string') {
            methods[methods.length] = function(s, t) {
              s.text = t;
            };
          }

          iMethod = methods.length;
          while (!API._testscriptinsertion && iMethod--) {
            head.appendChild(s);
            add(methods[iMethod], 'this.API._testscriptinsertion = true;');
            head.removeChild(s);
          }
          if (API._testscriptinsertion) {
            setElementScript = API.setElementScript = function(el, t) {
              s = el;
              while (s.firstChild) { s.removeChild(s.firstChild); }
              add(methods[iMethod], t, getElementDocument(el));
              s = null;
            };
            addElementScript = API.addElementScript = function(el, t) {
              s = el;
              add(methods[iMethod], t, getElementDocument(el));
              s = null;
            };
            addScript = API.addScript = function(t, docNode) {
              head = getHeadElement(docNode);
              s = createElement('script');
              if (s && head) {
                head.appendChild(s);
                add(methods[iMethod], t, docNode);
                head.removeChild(s);
                s = null;
                head = null;
              }
            };
            delete API._testscriptinsertion;
          }
          s = null;
        }

        if (addScript && getEBTN && !isXmlParseMode()) {
          findAndAddScripts = function(el) {
            var i, scripts = getEBTN('script', el);
            i = scripts.length;
            while (i--) {
              if (scripts[i].text) { addScript(scripts[i].text, getElementDocument(el)); }
            }
          };

          if (typeof addElementHtml == 'function') {
            try {
              addElementHtml(head, '<script id="testaddhtmlscript" type="text/javascript">this.API._testaddhtmlscript = true;</script>');
            } catch(e) {
              addScriptHtmlFailed = true;
            }
            if (!API._testaddhtmlscript) {
              oldAddElementHtml = addElementHtml;
              addElementHtml = API.addElementHtml = function(el, html) {
                if (addScriptHtmlFailed) {
                  // TODO: Pull out inline SCRIPT's and add to HEAD before set
                }
                oldAddElementHtml(el, html);
                findAndAddScripts(el);
              };
            }
            el = getEBI('testaddhtmlscript');
            if (el) {
              head.removeChild(el);
              el = null;
            }
            delete API._testaddhtmlscript;
          }
          if (typeof setElementHtml == 'function') {
            body = getBodyElement();
            script = '<script type="text/javascript">this.API._testsethtmlscript = true;</script>';
            if (body && isHostMethod(body, 'appendChild')) {
              div = createElement('div');						
              if (div) {
                if (div.style) {
                  div.style.position = 'absolute';
                  div.style.top = '0';
                }
                body.appendChild(div);
                try {
                  setElementHtml(div, script);
                } catch(e) {
                  setScriptHtmlFailed = true;
                }
                if (!API._testsethtmlscript) {
                  oldSetElementHtml = setElementHtml;
                  setElementHtml = API.setElementHtml = function(el, html, options, callback) {
                    if (setScriptHtmlFailed) {
                      // TODO: Pull out inline SCRIPT's and add to HEAD before set
                    }
                    el = oldSetElementHtml(el, html, options, callback);
                    if (!options || typeof options.execScripts == 'undefined' || options.execScripts) { findAndAddScripts(el); }
                    return el;
                  };
                }
                delete API._testsethtmlscript;
                body.removeChild(div);
                div = null;
              }
            }
          }
        }
      }
      head = null;
    });
  }
  <%End If 'Script%>
  <%If bAjax Then%>
  // Ajax section

  var createXmlHttpRequest = (function() { 
    var i, 
      fs = [// for legacy eg. IE 5 
            function() { 
              return new global.ActiveXObject("Microsoft.XMLHTTP"); 
            }, 
            // for fully patched Win2k SP4 and up 
            function() { 
              return new global.ActiveXObject("Msxml2.XMLHTTP.3.0"); 
            }, 
            // IE 6 users that have updated their msxml dll files. 
            function() { 
              return new global.ActiveXObject("Msxml2.XMLHTTP.6.0"); 
            }, 
            // IE7, Safari, Mozilla, Opera, etc (NOTE: IE7+ native version does not support overrideMimeType or local file requests)
            function() { 
              var o = new global.XMLHttpRequest();

              // Disallow IE7+ XHR if overrideMimeType (hack) method is required

              if (API.requireMimeTypeOverride) {
                if (!isHostMethod(o, 'overrideMimeType')) {
                  o = null;
                }
              }
              return o;
            }];

    // If local Xhr required and ActiveX constructor present, check ActiveX first

    if (API.requireLocalXhr && isHostMethod(global, 'ActiveXObject')) {
      fs.reverse();
    }

    // Loop through the possible factories to try and find one that
    // can instantiate an XMLHttpRequest object that works.

    for (i=fs.length; i--; ) { 
      try { 
        if (fs[i]()) { 
          return fs[i]; 
        } 
      } 
      catch (e) {} 
    }
  })();

  API.createXmlHttpRequest = createXmlHttpRequest;
<%If bRequester Then%>
<%If bUpdater Then%>
  var updateElement;
<%End If%>
<%If bAjaxForm Then%>
  var submitAjaxForm;
<%End If%>
  if (createXmlHttpRequest && Function.prototype.apply && isHostMethod(global, 'setTimeout')) {
  API.ajax = (function() {    
    var xmlhttp, pendingRequests = 0, groupRequests = {};
    var defaultTimeoutTime = 30000;
    var fnJsonFilter, Requester;
<%If bUpdater Then%>
    var Updater;
<%End If%>
<%If bUpdater Or bAjaxForm Then%>
    var tempRequesterHandle = 0;
<%End If%>
<%If bAjaxForm Then%>
    var reQuery = new RegExp('\\?(.*)$');
<%End If%>
<%If bAjaxLink Then%>
    var ajaxLinks, doAjaxLink, isLocalAnchorLink;

    var isMailLink = function(href) {
      return !href.indexOf('mailto:');
    };

    var isNewsLink = function(href) {
      return !href.indexOf('news:');
    };

    if (getDocumentWindow) {
      isLocalAnchorLink = function(href, docNode) {
        // TODO: Use document.URL
        var win = getDocumentWindow(docNode);
        var loc = win.location.href;
        if (loc.indexOf('#') != -1) { loc = loc.substring(0, loc.indexOf('#')); }

        return !href.indexOf('#') || (loc && !href.indexOf(loc) && href.indexOf('#') != -1);
      };
    }
<%End If%>
    var parseJsonString = (function() {
      if (isRealObjectProperty(global, 'JSON') && typeof global.JSON.parse == 'function') {
        return function(s) { return global.JSON.parse(s); };
      }
      else {
        return function(s) { return (new Function('return (' + s + ')'))(); };
      }
    })();

    API.parseJson = parseJsonString;

    var empty = function() {};

    function callback(sEvent, o, args) {
      var context = o.callbackContext || o;
      var m = o['on' + sEvent];
      if (m) {
        m.apply(context, args);
      }
    }

    function sessionCallback(sEvent, o, args) {
      args = args || [];
      callback(sEvent, API.ajax, [o.id(), o.group()].concat(args));
    }

    function bindCallbacks(a, objFrom, objTo) {
      var cb;
      var i = a.length;
      while (i--) {
        cb = 'on' + a[i];
        objFrom[cb] = objTo[cb];
      }
    }

    function requestStart(requester) {
      var sGroup = requester.group();

      pendingRequests++;
      if (pendingRequests == 1) { sessionCallback('start', requester); }
      if (sGroup) {
        if (typeof groupRequests[sGroup] == 'undefined') { groupRequests[sGroup] = 0; }
        groupRequests[sGroup]++;
        if (groupRequests[sGroup] == 1) { sessionCallback('groupstart', requester); }
      }
    }

    function requestFinish(requester) {
      var sGroup = requester.group();

      pendingRequests--;
      if (sGroup) {
        groupRequests[sGroup]--;
        if (!groupRequests[sGroup]) { sessionCallback('groupfinish', requester); }
      }
      if (!pendingRequests) { sessionCallback('finish', requester); }
    }

    function update(el, requester, xmlhttp, fnUpdate, bAppend, updateOptions, fnUpdated, context) {
      var method, xml, html = xmlhttp.responseText;
      var result = html;

      if (xmlhttp.responseXML && xmlhttp.responseXML.childNodes && xmlhttp.responseXML.childNodes.length) { xml = xmlhttp.responseXML; }
      if (fnUpdate) { result = fnUpdate.call(context || requester, html, xml); }
      if (typeof result == 'string') {
        method = (bAppend)?addElementHtml:setElementHtml;
      }
      else {
        // Import is not part of required combination (DOM + HTML + Requester)
        // Combination should be (DOM + (HTML | Import) + Requester)
        if (typeof addElementNodes == 'function') {
          result = importNode(result, true, getElementDocument(result));
          method = (bAppend)?addElementNodes:setElementNodes;
        }
      }
      if (result) { method(el, result, updateOptions, fnUpdated); }
    }

    xmlhttp = createXmlHttpRequest();

    if (xmlhttp && isHostMethod(xmlhttp, 'setRequestHeader')) {
      Requester = function(sId, sGroup) {
        var timeout, evalJSON, bLocalFile;
        var xmlhttp = createXmlHttpRequest();
        var done = true;
        var that = this;
        var readyStateCallbacks = { '1':'loading', '2':'loaded', '3':'interactive' };
        var readyStateCallbacksCalled = [];
        var timeoutTime = defaultTimeoutTime;

        function stateChange() {
          var state = xmlhttp.readyState;
          if (state == 4) {
            if (!done) {
              done = true;
              xmlhttp.onreadystatechange = empty;
              global.clearTimeout(timeout);
              requestFinish(that);
              if (xmlhttp.status >= 200 && xmlhttp.status < 300 || xmlhttp.status == 1223 || (typeof xmlhttp.status == 'undefined' && xmlhttp.responseText) || (!xmlhttp.status && bLocalFile)) {
                that.dispatch('success', [xmlhttp, (evalJSON && xmlhttp.responseText)?parseJsonString(xmlhttp.responseText):null]);
              }
              else {
                that.dispatch('fail', [xmlhttp]);
              }
            }
          }
          else {
            if (!readyStateCallbacksCalled[state]) {
              that.dispatch(readyStateCallbacks[state], [xmlhttp]);
              readyStateCallbacksCalled[state] = true;
            }
          }
        }

        function abort() {
          if (!done) {
            done = true;
            global.clearTimeout(timeout);
            xmlhttp.onreadystatechange = empty;
            xmlhttp.abort();			
            requestFinish(that);
            that.dispatch('cancel', [xmlhttp]);
          }
        }

        function send(cmd, uri, postData, postDataType, bNoCache, bJSON) {
          if (done) {
            try {
              xmlhttp.open(cmd, uri, true, that.username, that.password);
            }
            catch(e) {
              //that.dispatch('error', [xmlhttp, e, uri]);
              sessionCallback('error', that, [xmlhttp, e, uri]);
              return false;
            }
            bLocalFile = !uri.indexOf('file:');
            postDataType = postDataType || 'application/x-www-form-urlencoded';
            xmlhttp.setRequestHeader("Content-Type", postDataType);
            xmlhttp.setRequestHeader("X-Requested-With", "XMLHttpRequest");
            if (bNoCache && cmd == 'GET') {
              xmlhttp.setRequestHeader('If-Modified-Since', 'Sat, 1 Jan 1990 00:00:00 GMT');
              xmlhttp.setRequestHeader('Cache-Control', 'no-cache');
            }
            that.dispatch('send', [xmlhttp, uri]);
            xmlhttp.onreadystatechange = stateChange;
            requestStart(that);
            readyStateCallbacksCalled = [];
            done = false;
            evalJSON = bJSON;
            try {
              xmlhttp.send((cmd == 'POST' || cmd == 'PUT')?postData:null);
              if (!done) { timeout = global.setTimeout(abort, timeoutTime); }
            }
            catch(E) {
              xmlhttp.onreadystatechange = empty;
              done = true;
              requestFinish(that);
              //that.dispatch('error', [xmlhttp, E, uri]);
              sessionCallback('error', that, [xmlhttp, E, uri]);
              return false;
            }
            return true;
          }
          return false;
        }
        
        this.busy = function() { return !done; };
				
        this.cancel = function() {
          abort();
        };

        if (isHostMethod(xmlhttp, 'overrideMimeType')) {
          this.overrideMimeType = function(mimeType) { xmlhttp.overrideMimeType(mimeType); };
        }
				
        this.get = function(uri, bJSON, bAllowCache) {
          return send('GET', uri, null, null, !bAllowCache, bJSON);
        };

        this.head = function(uri) {
          return send('HEAD', uri);
        };

        this.post = function(uri, data, type, bJSON) {
          return send('POST', uri, data, type, false, bJSON);
        };

        this.put = function(uri, data, type, bJSON) {
          return send('PUT', uri, data, type, false, bJSON);
        };

        this.group = function() {
          return sGroup;
        };

        this.id = function() {
          return sId;
        };

        this.setTimeoutTime = function(t) {
          timeoutTime = t;
        };
      };

      Requester.prototype.bindToObject = function(obj, bCallInContext) {
        bindCallbacks(['send', 'success', 'fail', 'cancel', 'loading', 'loaded', 'interactive'], this, obj);
        this.callbackContext = (typeof bCallInContext == 'undefined' || bCallInContext)?obj:null;
      };

      Requester.prototype.dispatch = function(sEvent, args) {
        callback(sEvent, this, args);
      };

      API.Requester = Requester;
<%If bUpdater Then%>
      if (isHostMethod(global, 'setInterval') && ((setElementHtml && addElementHtml) || (typeof setElementNodes == 'function' && typeof addElementNodes == 'function'))) {
        updateElement = function(el, uri, bAppend, updateOptions, fnUpdate, fnUpdated, requester) {
          if (!requester) { requester = new Requester('_temp' + tempRequesterHandle++); }
          var oldOnSuccess = requester.onsuccess;
          var oldOnFail = requester.onfail;
          var oldOnCancel = requester.oncancel;

          var putBackCallbacks = function() {
            requester.onsuccess = oldOnSuccess;
            requester.onfail = oldOnFail;
            requester.oncancel = oldOnCancel;
          };

          requester.onsuccess = function(xmlhttp) {
            putBackCallbacks();
            update(el, requester, xmlhttp, fnUpdate, bAppend, updateOptions, fnUpdated);
            // FIXME: dispatch and consolidate
            if (typeof requester.onsuccess == 'function') { requester.onsuccess(xmlhttp); }
            requester = null;
          };
          requester.onfail = function(xmlhttp) {
            putBackCallbacks();
            if (typeof requester.onfail == 'function') { requester.onfail(xmlhttp); }
            requester = null;
          };
          requester.oncancel = function(xmlhttp) {
            putBackCallbacks();
            if (typeof requester.oncancel == 'function') { requester.oncancel(xmlhttp); }
            requester = null;
          };
          var result = requester.get(uri);
          if (!result) {
            putBackCallbacks();
            requester = null;
          }
        };

        API.updateElement = updateElement;

        Updater = function(el, uri, frequency, append, sId, sGroup) {
          var that = this;
          var interval, paused;

          function send() {
            global.clearInterval(interval);
            paused = true;
            that.get(uri);
          }

          frequency = frequency || 30000;
          Requester.call(this, sId, sGroup);
          this.start = function() {
            if (!interval) {
              interval = global.setInterval(send, frequency);
              return true;
            }
            return false;
          };

          this.stop = function() {
            global.clearInterval(interval);
            if (this.busy()) { this.cancel(); }
            interval = null;
            paused = false;
          };

          this.active = function() {
            return !!interval;
          };

          this.next = function() {
            if (paused) {
              interval = global.setInterval(send, frequency);
              return true;
            }
            return false;
          };

          this.element = function() {
            return el;
          };

          this.appends = function() {
            return append;
          };
        };

        inherit(Updater, Requester);

        Updater.prototype.dispatch = function(sEvent, args) {
          Requester.prototype.dispatch.apply(this, sEvent, args);
          if (sEvent == 'success') {
            update(this.element(), this, xmlhttp, this.onupdate, this.appends(), this.updateOptions, this.onupdated, this.callbackContext);
            this.next();
          }
        };

        Updater.prototype.bindToObject = function(obj, bCallInContext) {
          Requester.prototype.bindToObject.call(this, obj, bCallInContext);
          this.onupdate = obj.onupdate;
          this.onupdated = obj.onupdated;
        };

        API.Updater = Updater;
      }
<%End If 'Updater%>
<%If bAjaxForm Then%>
      if (getAttribute && serializeFormUrlencoded) {
        submitAjaxForm = function(frm, bJSON, requester) {
          var data, method, action, type;

          if (!requester) { requester = new Requester('_temp' + tempRequesterHandle++); }
          data = serializeFormUrlencoded(frm);
          method = getAttribute(frm, 'method');
          // FIXME: Resolve correct global
          action = getAttribute(frm, 'action') || global.location.href;
          type = getAttribute(frm, 'enctype');
          if (action) {
            if (method && method.toUpperCase() == 'POST') {
              return requester.post(action, data, type, bJSON);
            }
            else {
              return requester.get([action.replace(reQuery, ''), '?', data].join(''), bJSON, false);
            }		
          }
        };

        API.submitAjaxForm = submitAjaxForm;

        if (typeof attachListener == 'function') {
          API.ajaxForm = function(frm, sId, sGroup, bJSON, fnSubmit) {
            var requester = new Requester(sId, sGroup);

            attachListener(frm, 'submit', function(e) {
              if (!fnSubmit || fnSubmit.call(this, e)) {
                if (submitAjaxForm(this, bJSON, requester)) {
                  return cancelDefault(e);
                }
              }
            });
            frm = null;
            return requester;
          };
        }
      }
<%End If 'AjaxForm%>
<%If bAjaxLink Then%>
      if (getAttribute && attachListener && isLocalAnchorLink) {
        doAjaxLink = function(e, el, requester, bJSON, bAllowCache) {
          var href, r = true;

          if (requester.busy()) { requester.cancel(); }
          href = getAttribute(el, 'href');
          if (href && !isLocalAnchorLink(href) && !isMailLink(href) && !isNewsLink(href) && requester.get(href, bJSON, bAllowCache)) {
            r = cancelDefault(e);
          }
          return r;
        };

        API.ajaxAllLinks = function(sId, sGroup, bJSON, bAllowCache, docNode) {
          var requester;
          var body = getBodyElement(docNode);
          if (body) {
            requester = new Requester(sId, sGroup);
            attachListener(body, 'click', function(e) {
              var el = getEventTarget(e);
              if (getElementNodeName(el) == 'a') {
                return doAjaxLink(e, el, requester, bJSON, bAllowCache);
              }
              body = null;
            });
          }
          return requester;
        };

        ajaxLinks = function(links, sId, sGroup, bJSON, bAllowCache, docNode) {
          var i, requester = new Requester(sId, sGroup);
          var fn = function(e) {
            return doAjaxLink(e, this, requester, bJSON, bAllowCache);
          };

          if (typeof links.length != 'number') { links = [links]; }
          i = links.length;
          while (i--) {
            attachListener(links[i], 'click', fn);
          }
          links = null;
          return requester;
        };

        API.ajaxLinks = ajaxLinks;

        if (typeof update == 'function') {
          API.ajaxLinksUpdate = function(elUpdate, links, sId, sGroup, bAllowCache, bAppend, updateOptions, fnUpdate, fnUpdated) {
            var requester = ajaxLinks(links, sId, sGroup, false, bAllowCache);

            requester.onsuccess = function(xmlhttp) { update(elUpdate, requester, xmlhttp, fnUpdate, bAppend, updateOptions, fnUpdated); };
          };
        }
      }
<%End If 'AjaxLink%>
      return {
        getPendingRequests:function() { return pendingRequests; },
        bindToObject:function(obj, bCallInContext) { bindCallbacks(['start', 'finish', 'error', 'groupstart', 'groupfinish'], this, obj); this.callbackContext = (typeof bCallInContext == 'undefined' || bCallInContext)?obj:null; },
        setTimeoutTime:function(t) { defaultTimeoutTime = t; },
        setJsonFilter:function(fn) { fnJsonFilter = fn; }
      };
    }
    xmlhttp = null;
  })();
  }
  <%End If%>
  <%End If 'Ajax%>
  <%If bBookmark Then%>
  // Bookmark section

  var addBookmark, addBookmarkCurrent;

  addBookmark = (function() {			
    if (isRealObjectProperty(this, 'external') && isHostMethod(this.external, 'addFavorite')) { return function(href, title, win) { (win || global).external.addFavorite(href, title); }; }
    if (isRealObjectProperty(this, 'sidebar') && isHostMethod(this.sidebar, 'addPanel')) { return function(href, title, win) { (win || global).sidebar.addPanel(title, href, ''); }; }
  })();

  API.addBookmark = addBookmark;

  if (addBookmark) {
    addBookmarkCurrent = (function() {
      if (isRealObjectProperty(this, 'document') && isHostMethod(this, 'location') && typeof this.location.protocol == 'string') {
        return function(win) {
          win = win || global;
          var loc = win.location.href;
          if (!loc.indexOf('http')) {
            addBookmark(loc, win.document.title);
          }
        };
      }
    })();

    API.addBookmarkCurrent = addBookmarkCurrent;
  }
  <%End If 'Bookmark%>
  <%If bQuery Then%>
  // Query section

  var traversedElements, traversedElements2, getEBCN, getEBXP, parseAtom, resolve, selectByXPath, xPathChildSelectorsBad;
  <%End If%>
  <%If bObjects Then%>
  var areObjectFeatures, argsToArray, index, fn, fn2, isElement, resolveQueryArgs, scrollSides = ['Top', 'Left', 'Bottom', 'Right'];
  <%End If%>
  <%If bQuery Or bObjects Then%>
  if (doc) {
    <%End If%>
    <%If bQuery Then%>
    if (isHostMethod(doc, 'evaluate')) {
      resolve = function() { return 'http://www.w3.org/1999/xhtml'; };
      getEBXP = function(s, d) {
        d = d || global.document;
        var i, q = [], r, docNode = (d.nodeType == 9)?d:(d.ownerDocument);
        r = docNode.evaluate(s, d,
                             (isXmlParseMode(docNode))?resolve:null,
                             global.XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,
                             null);
        if (!arguments[2]) {
          i = r.snapshotLength;
          while (i--) { q[i] = r.snapshotItem(i); }
          return q;
        }
        return r;
      };

      API.getEBXP = getEBXP;
    }

    parseAtom = function(s) {
      var ai, m, mv, ml;
      var o = {};

      m = s.match(/^([>\+~])/);
      if (m) {
        o.combinator = m[1];
        s = s.substring(1);
      }

      m = s.match(/^([^#\.\[:]+)/);
      o.tag = m ? m[1] : '*';

      m = s.match(/#([^\.\:]+)/);
      o.id = m ? m[1] : null;

      m = s.match(/\.([^\[\:]+)/);
      o.cls = m ? m[1] : null;

      m = s.match(/:([^\[]+)(\[|$)/);
      o.pseudo = m ? m[1] : null;

      m = s.match(/\[[^\]]+\]/g);
      if (m) {
        ml = m.length;
        o.attributes = [];
        o.attributeValues = [];
        o.attributeOperators = [];
        for (ai = 0; ai < ml; ai++) {
          var mai = m[ai];
          o.attributes[ai] = mai.substring(1, mai.length - 1);
          mai = mai.replace(/^%/, '').replace(/\]$/, '');
          mv = mai.match(/(~|!|\||\*|\$|\^)?=(["'])?([^'"]*)\1?/);
          if (mv) {
            o.attributeOperators[ai] = mv[1];
            o.attributeValues[ai] = mv[3].replace(/\x00\x00\x01/g, ']').replace(/\x00\x00\x02/g, '"').replace(/\x00\x00\x03/g, "'").replace(/\x00\x00\x04/g, '#').replace(/\x00\x00\x05/g, '.').replace(/\x00\x00\x06/g, ':').replace(/\x00\x00\x07/g, '>').replace(/\x00\x00\x08/g, '~').replace(/\x00\x00\x11/g, '+').replace(/\x00\x00\x00/g, ' ');
            o.attributes[ai] = o.attributes[ai].replace(/(~|\||\*|!|\$|\^)?=.*/, '');
          }
        }
      }
      return o;
    };

    var parsePositional = function(pseudo) {

      // TODO: Change to use switch

      if (pseudo == 'nth-of-type(even)') {
        pseudo = 'nth-of-type(2n)';
      } else if (pseudo == 'nth-of-type(odd)') {
        pseudo = 'nth-of-type(2nplus1)';
      } else if (pseudo == 'nth-last-of-type(even)') {
        pseudo = 'nth-last-of-type(2n)';
      } else if (pseudo == 'nth-last-of-type(odd)') {
        pseudo = 'nth-last-of-type(2nplus1)';
      }

      var o, matchIndex = pseudo.match(/^nth(-last)?-(child|of-type)\((-)?(\d+)?n(-|plus)?(\d+)?\)$/);
      if (matchIndex) {
        o = {};
        o.firstOrLast = !matchIndex[1];
        o.multiplier = +(matchIndex[4] || '1');
        o.multiplierNegative = matchIndex[3] == '-';
        if (matchIndex[5]) {
          o.modulus = +matchIndex[6] * (matchIndex[5] == 'plus' ? 1 : -1);
        } else {
          o.modulus = 0;
        }
        o.ofType = matchIndex[2] != 'child';
      }
      return o;
    };

    if (typeof getEBXP != 'undefined') {
      selectByXPath = function(d, a, sel, multiple) {
        var atts, m, o, s, positional, ofTypeSimple;
        var docNode = (d.nodeType == 9)?d:getElementDocument(d);
        var i = a.length;
        while (i--) {
          o = parseAtom(a[i]);
          ofTypeSimple = false;

          if (o.pseudo) {
            if (o.pseudo == 'first-of-type') {
              o.pseudo = 'nth-of-type(1)';
            } else if (o.pseudo == 'last-of-type') {
              o.pseudo = 'nth-last-of-type(1)';
            }
            positional = parsePositional(o.pseudo);
            if (positional && !positional.multiplier) {
              o.pseudo = 'nth' + (positional.firstOrLast ? '' : '-last') + '-' + (positional.ofType ? 'of-type' : 'child') + '(' + positional.modulus + ')';
              positional = null;
            }
            ofTypeSimple = /^nth-of-type\(\d+\)$/.test(o.pseudo);
          }

          // TODO: Test with leading combinator

          if (s) {
            if (o.combinator) {
              s += (o.combinator == '>')?'/':'/following-sibling::';
            } else {
              s += '//';
            }
          } else {
            s = './/';
          }
          //s = [s, ((isXmlParseMode(docNode))?'html:':''), (o.pseudo || (o.combinator && o.combinator != '>'))?'*':o.tag, (o.combinator && o.combinator != '>')?'[(name() = "' + o.tag.toLowerCase() + '" or name() = "' + o.tag.toUpperCase() + '")' + (o.combinator == '+' ? ' and (position() = 1)' : '') + ']' :''];
          s = [s, ((isXmlParseMode(docNode))?'html:':''), ((o.pseudo && (!ofTypeSimple && (!positional || !positional.ofType))) || (o.combinator && o.combinator != '>'))?'*':o.tag, (o.combinator && o.combinator != '>')?'[(name() = "' + o.tag.toLowerCase() + '" or name() = "' + o.tag.toUpperCase() + '")' + (o.combinator == '+' ? ' and (position() = 1)' : '') + ']' :''];
          if (o.cls) {
            if (o.cls.indexOf('.') == -1) {
              s[s.length] = "[contains(concat(' ', @class, ' '), ' " + o.cls + " ')]";
            } else {
              var classNames = o.cls.split('.');
              for (var z = classNames.length; z--;) {
                s[s.length] = "[contains(concat(' ', @class, ' '), ' " + classNames[z] + " ')]";
              }
            }
          }
          s = s.join('');
          var htmlChildDisclaimer = "[not(name(.) = 'html') and not(name(.) = 'HTML')]";
          if (o.pseudo) {
            switch(o.pseudo) {
            case 'target':
              var uri = docNode.URL;
              if (uri) {
                var hash = uri.match(/\#(.*)$/);
                if (hash && hash[1]) {
                  s += '[@name = "' + hash[1] + '" or @id = "' + hash[1] + '"]';
                } else {
                  return [];
                }
              } else {
                return [];
              }
              break;
            case 'root':
              //s += "[name(.) = 'html' or name(.) = 'HTML']"
              s += '[not(parent::*)]';
              break;
            case 'checked':
              s += "[(@checked) and (name(.) = 'input' or name(.) = 'INPUT')]";
              break;
            case 'enabled':
            case 'disabled':
              s += "[(" + (o.pseudo == 'enabled'?'not(@disabled)':'@disabled') + ") and (name(.) = 'input' or name(.) = 'textarea' or name(.) = 'select' or name(.) = 'button' or name(.) = 'INPUT' or name(.) = 'TEXTAREA' or name(.) = 'SELECT' or name(.) = 'BUTTON')]";
              break;
            case 'empty':
              s+= '[not(*) and not(normalize-space())]';
              break;
            case 'nth-child(even)':
              s += "[position() mod 2=0]" + htmlChildDisclaimer;
              break;
            case 'nth-child(odd)':
              s += "[position() mod 2=1]" + htmlChildDisclaimer;
              break;
            case 'last-child':
              s += "[last()]" + htmlChildDisclaimer;
              break;
            case 'only-child':
              s += "[count(../*)=1]" + htmlChildDisclaimer;
              break;
            case 'first-child':
              s += "[1]" + htmlChildDisclaimer;
              break;
            default:
              if (positional) {
                if (positional.firstOrLast) {
                  s += '[(position() - ' + positional.modulus + ') mod ' + positional.multiplier + ' = 0 and position() ' + (positional.multiplierNegative ? '<=' : '>=') + ' ' + positional.modulus + ']';
                } else {
                  s += "[(last() - position() - " + (+(positional.modulus - 1)) + ") mod " + positional.multiplier + " = 0 and position() " + (positional.multiplierNegative ? '>=' : '<=') + " (last() - " + (+(positional.modulus - 1)) + ")]";
                }
              } else {
                var matchIndex = o.pseudo.match(/nth-(child|of-type)\((\d+)\)/);
                if (matchIndex) {
                  s += '[position()=' + matchIndex[2] + ']' + htmlChildDisclaimer;
                } else if (matchIndex = o.pseudo.match(/nth-last-(child|of-type)\((\d+)\)/)) {
                  s += '[position()=last() - ' + (matchIndex[2] - 1) + ']' + htmlChildDisclaimer;
                } else {
                  matchIndex = o.pseudo.match(/contains\((.*)\)/);
                  if (matchIndex) {
                    s += '[contains(string(.), "' + matchIndex[1] + '")]';
                  }
                }
              }
            }
            s += '[self::' + o.tag + ']';
          }
          if (o.id) {
            s += ['[@id="', o.id, '"]'].join('');
          }
          if (o.attributes) {
            atts = [];
            m = o.attributes.length;
            var quoteCharacter = '"';
            while (m--) {
              if (o.attributeValues[m] && o.attributeValues[m].indexOf('"') != -1) {
                quoteCharacter = "'";
              }
              switch(o.attributeOperators[m]) {
              case '^':
                atts.push(['starts-with(@', o.attributes[m], ',', quoteCharacter, o.attributeValues[m], quoteCharacter, ')'].join(''));
                break;
              case '$':
                atts.push(['substring(@', o.attributes[m], ', string-length(@', o.attributes[m], ') - string-length(', quoteCharacter, o.attributeValues[m], quoteCharacter, ') + 1, string-length(@', o.attributes[m] ,')) = ', quoteCharacter, o.attributeValues[m], quoteCharacter].join(''));
                break;
              case '~':
                atts.push(['contains(concat(" ", @', o.attributes[m], ', " "),', quoteCharacter, ' ' + o.attributeValues[m] + ' ', quoteCharacter, ')'].join(''));
                break;
              case '!':
                atts.push(['not(@', o.attributes[m], '=', quoteCharacter, o.attributeValues[m], quoteCharacter, ')'].join(''));
                break;
              case '*':
                atts.push(['contains(@', o.attributes[m], ',', quoteCharacter, o.attributeValues[m], quoteCharacter, ')'].join(''));
                break;
              case '|':
                atts.push(['@', o.attributes[m], '=', quoteCharacter, o.attributeValues[m], quoteCharacter, ' or starts-with(@', o.attributes[m], ',', quoteCharacter, o.attributeValues[m], '-', quoteCharacter, ')'].join(''));
                break;
              case '*':
                atts.push(['contains(@', o.attributes[m], ',', quoteCharacter, o.attributeValues[m], quoteCharacter, ')'].join(''));
                break;
              default:
                atts.push((typeof o.attributeValues[m] == 'string')?['@', o.attributes[m], '=', quoteCharacter, o.attributeValues[m], quoteCharacter].join(''):['@', o.attributes[m]].join(''));
              }
            }
            s = [s, '[', atts.join(' and '), ']'].join('');
          }
        }
        var result = getEBXP(s, d, multiple), q = [];
        if (multiple) { // Multiple returns snapshot so now filter dupes
          i = result.snapshotLength;
          while (i--) {
            var el = result.snapshotItem(i);
            var uid = elementUniqueId(el);
            if (!traversedElements[uid]) { q[q.length] = el; traversedElements[uid] = true; }
          }
          return q.reverse();
        }
        return result;
      };
    }

    var getEBCS = (function() {
      var html = getAnElement();
      var els,     // candidate elements for return
      ns,          // elements to return
      o,           // selector atom object
      docNode,
      cache = {},  // cached select functions
      aCache = {}, // cached select atom functions
      qid = 0,     // query id (marks branches as traversed)
      bAll = html && isHostMethod(html, 'all');        // indicates if "all" object is featured for elements

      function getDocNode(d) {
        return (d.nodeType == 9 || (!d.nodeType && !d.tagName))?d:getElementDocument(d);
      }

      var globalDocumentLanguage;

      var documentLanguage = function(doc) {
        var el, els, lang;

        if (!doc) {
          doc = global.document;
        }
        if (globalDocumentLanguage && doc == global.document) {
          return globalDocumentLanguage;
	}
        els = getEBTN('meta');
        for (var i = els.length; i--;) {
          el = els[i];
          if (getAttribute(el, 'http-equiv') == 'Content-Language') {
            lang = getAttribute(el, 'content');
          }
	}
	if (lang && doc == global.document) {
          globalDocumentLanguage = lang;
	}
	return lang;
      };

      var elementLanguage = function(el) {
        var lang, doc = getElementDocument(el);
        var hasGetAttributeNS = isHostMethod(el, 'getAttributeNS');
        while (!lang && el && el.tagName) {
          lang = getAttribute(el, 'lang');
          if (!lang && hasGetAttributeNS) {
            lang = el.getAttributeNS('http://www.w3.org/XML/1998/namespace', 'lang');
          }
          el = el.parentNode;
        }
        return lang || documentLanguage(doc);
      };

      var previousAtom; // adjacent selectors check this to determine comparison (currently only checking for tag)
      var selectAtomFactory = function(id, tag, cls, combinator, attributes, attributeValues, attributeOperators, pseudo) {
        var ai, al, att, b, c, cj, d, el, foundSelf, i, j, k, m, r, sibling;
        return function(a, docNode, last) {
          if (attributes) { al = attributes.length; }
          r = [];
          k = a.length;

          var lastProcessedParent, childrenLength, done, elParent, elTagName, evenCounter, filteredDescendants, matchIndex;
          var matchingLastChild, uid, uidElement, traversedParents = {}, containsText, lang, positional, multiplier, modulus, multiplierNegative, firstOrLast, ofType;

          // TODO: Use switch

          if (pseudo == 'first-of-type') {
            pseudo = 'nth-of-type(1)';
          } else if (pseudo == 'last-of-type') {
            pseudo = 'nth-last-of-type(1)';
          }

          if (pseudo) {
            matchIndex = pseudo.match(/^contains\((.+)\)$/);
            if (matchIndex) {
              containsText = matchIndex[1];
            } else {
              matchIndex = pseudo.match(/^lang\((.+)\)$/);
              if (matchIndex) {
                lang = matchIndex[1].toLowerCase();
              } else {
                positional = parsePositional(pseudo);
                if (positional) {
                  multiplier = positional.multiplier;
                  multiplierNegative = positional.multiplierNegative;
                  modulus = positional.modulus;
                  firstOrLast = positional.firstOrLast;
                  ofType = positional.ofType;
                  if (!multiplier) {
                    pseudo = 'nth' + (firstOrLast ? '' : '-last') + '-' + (ofType ? 'of-type' : 'child') + '(' + modulus + ')';
                    positional = null;
                  }
                }
                if (!positional) {
                  matchIndex = pseudo.match(/nth-(child|of-type)\((\d+)\)/);
                  if (!matchIndex) {
                    matchIndex = pseudo.match(/nth-last-(child|of-type)\((\d+)\)/);
                    matchingLastChild = true;
                  }
                  ofType = matchIndex && matchIndex[1] != 'child';
                }
              }
            }
          }

          while (k--) {
            d = a[k];
            if (id && !combinator) {
              if (!d.tagName) {
                els = (el = getEBI(id, docNode)) ? [el] : [];
              } else {
                if (bAll && (el = d.all[id])) {
                  els = [el];
                } else {
                  els = getEBTN(tag, d);
                }
              }
            } else {
              switch(combinator) {
              case '>':
                els = getChildren(d, true);
                break;
              case '~':
                // TODO: This is inefficient
                els = getChildren(d.parentNode).reverse();
                foundSelf = false;
                break;
              case '+':
                sibling = d;
                do {
                  sibling = sibling.nextSibling;
                } while (sibling && sibling.nodeType != 1);
                els = sibling ? [sibling] : [];
                break;
              default:
                els = getEBTN(tag, d);
              }
            }

            if (pseudo && !lang && !containsText && (positional || ofType || pseudo.indexOf('child') != -1)) {
              filteredDescendants = [];
              i = els.length;

              lastProcessedParent = null;
              while (i--) {
                el = els[i];
                elParent = el.parentNode;
                uid = elParent && elementUniqueId(elParent);

                if (elParent && elParent != lastProcessedParent && elParent.tagName && !traversedParents[uid]) {
                  if (positional && !firstOrLast) {
                    c = getChildren(elParent).reverse();
                  } else {
                    c = getChildren(elParent, true);
                  }

                  evenCounter = j = 0;
                  childrenLength = c.length;
                  lastProcessedParent = elParent;
                  traversedParents[uid] = true;

                  done = false;
                  j = childrenLength;
                  while (j && !done) {
                    cj = c[--j];
                    done = cj.tagName != '!';
                    if (ofType) {
                      done = done && tag == cj.tagName.toLowerCase();
                    }
                  }
                  if (done) {
                    childrenLength = j + 1;
                  }
                  j = 0;
                  done = false;
                  while (j < childrenLength && !done) {
                    cj = c[j];
                    elTagName = cj.tagName;
                    if (elTagName != '!') {
                      if ((!tag || tag == '*' || elTagName.toLowerCase() == tag) && (!id || cj.id == id)) {
                        switch (pseudo) {
                        case 'nth-child(even)':
                          if (evenCounter % 2) {
                            filteredDescendants[filteredDescendants.length] = cj;
                          }
                          break;
                        case 'nth-child(odd)':
                          if (!(evenCounter % 2)) {
                            filteredDescendants[filteredDescendants.length] = cj;
                          }
                          break;
                        case 'first-child':
                          if (!evenCounter) {
                            filteredDescendants[filteredDescendants.length] = cj;
                            done = true;
                          }
                          break;
                        case 'last-child':
                          if (j == childrenLength - 1) {
                            filteredDescendants[filteredDescendants.length] = cj;
                            done = true;
                          }
                          break;
                        case 'only-child':
                          if (evenCounter == childrenLength - 1) {
                            filteredDescendants[filteredDescendants.length] = cj;
                          }
                          done = true;
                          break;
                        default:
                          if (positional) {
                            if (multiplierNegative) {
                              if ((evenCounter + 1 <= modulus) && !((evenCounter + 1 - modulus) % multiplier)) {
                                 filteredDescendants[filteredDescendants.length] = cj;
                              }
                            } else {
                              if ((evenCounter + 1 >= modulus) && !((evenCounter + 1 - modulus) % multiplier)) {
                                 filteredDescendants[filteredDescendants.length] = cj;
                              }
                            }
                          } else if (matchIndex) {
                            // TODO: Convert match index once
                            if (matchingLastChild) {
                              if (j == childrenLength - (+matchIndex[2])) {
                                filteredDescendants[filteredDescendants.length] = cj;
                                done = true;
                              }
                            } else {
                              if (evenCounter == +matchIndex[2] - 1) {
                                filteredDescendants[filteredDescendants.length] = cj;
                                done = true;
                              }
                            }
                          }
                        }
                      }
                      if (!ofType || tag == elTagName.toLowerCase()) {
                        evenCounter++;
                      }
                    }
                    j++;
                  }
                }
              }
              els = filteredDescendants;
            }

            i = els.length;
            while (i--) {
              el = els[i];
              uidElement = elementUniqueId(el);
              if (traversedElements[uidElement] == qid || (last && traversedElements2[uidElement])) { continue; }
              b = true;
              if (cls) {
                m = el.className;
                if (m) {
                  if (typeof cls == 'string') {
                    b = (' ' + m + ' ').indexOf(cls) > -1;
                  } else { // Array
                    for (var z = cls.length; z-- && b;) {
                      b = (' ' + m + ' ').indexOf(cls[z]) > -1;                      
                    }
                  }
                } else {
                  b = false;
                }
              }
              b = b && (!id || el.id == id);
              if (b) {
                if (combinator == '~') {
                  b = foundSelf && (tag == '*' || tag == el.tagName.toLowerCase());
                  if (!foundSelf && el == d) { foundSelf = true; }
                } else {
                  b = tag == '*' || tag == el.tagName.toLowerCase();
                }

                if (b && pseudo) {                  
                  switch (pseudo) {
                  case 'empty':
                    var childNodes = el.childNodes;
                    done = false;
                    for (var childNodeIndex = childNodes.length; childNodeIndex-- && !done;) {
                      var childNode = childNodes[childNodeIndex];
                      switch(childNode.nodeType) {
                        case 1:
                          done = childNode.tagName != '!';
                          break;
                        case 3:
                        case 4:
                          done = reNotEmpty.test(childNode.data);
                      }
                    }
                    b = !done;
                    break;
                  case 'root':
                    b = el.tagName.toLowerCase() == 'html';
                    break;
                  case 'enabled':
                  case 'disabled':
                    if (/^(input|textarea|button|select|option)$/i.test(el.tagName)) {
                      b = hasAttribute(el, 'disabled');
                      if (pseudo == 'enabled') {
                        b = !b;
                      }
                    } else {
                      b = false;
                    }
                    break;
                  case 'checked':
                    if (/^(input)$/i.test(el.tagName)) {
                      b = hasAttribute(el, 'checked');
                    } else {
                      b = false;
                    }
                    break;
                  case 'target':
                    var uri = (docNode.location && docNode.location.href) || docNode.URL;
                    if (uri) {
                      var hash = uri.match(/\#(.*)$/);
                      if (hash && hash[1]) {
                        b = el.name == hash[1] || el.id == hash[1];
                      } else {
                        b = false;
                      }
                    }
                    break;
                  default:
                    if (containsText) {
                      b = (el.textContent || el.innerText || '').indexOf(containsText) != -1;
                    } else if (lang) {
                      var langMatch = elementLanguage(el).toLowerCase();
                      b = lang == langMatch || !langMatch.indexOf(lang + '-');
                    }
                  }
                }
                if (b && attributes) {
                  ai = al;
                  while (ai-- && b) {
                    att = getAttribute(el, attributes[ai], docNode);
                    switch(attributeOperators[ai]) {
                    case '^':
                      b = b && att && !att.indexOf(attributeValues[ai]);
                      break;
                    case '$':
                      b = b && att && att.slice(-attributeValues[ai].length) == attributeValues[ai];
                      break;
                    case '~':
                      b = b && att && ([' ', att, ' '].join('')).indexOf([' ', attributeValues[ai], ' '].join('')) != -1;
                      break;
                    case '!':
                      b = b && att !== attributeValues[ai];
                      break;
                    case '|':
                      b = b && att && (attributeValues[ai] == att || !att.indexOf(attributeValues[ai] + '-'));
                      break;
                    case '*':
                      b = b && att && att.indexOf(attributeValues[ai]) != -1;
                      break;
                    default:
                      b = b && (typeof attributeValues[ai] == 'string')?att == attributeValues[ai]:(!hasAttribute && att) || hasAttribute(el, attributes[ai], docNode);
                    }
                  }
                }
                if (b) {
                  r[r.length] = el;
                  traversedElements[uidElement] = qid;
                  if (last) {
                    traversedElements2[uidElement] = true;
                  }
                  if (id) { break; }
                }
              }
            }
          }
          return r;
        };
      };

      var selectFactory = function(a) {
         var i, j;
       
         return function(d) {
           var classNames, className;
           i = a.length;
           j = 1;
           docNode = getDocNode(d);
           ns = [[d]];
           while (i--) {
             classNames = null;
             o = parseAtom(a[i]);
             if (!aCache['_' + a[i]]) {
               className = o.cls;
               if (className) {
                 if (className.indexOf('.') == -1) {
                    classNames = [' ', className, ' '].join('');
                 } else {
                    classNames = o.cls.split('.');
                    for (var z = classNames.length; z--;) {
                      classNames[z] = [' ', classNames[z], ' '].join('');
                    }
                 }
               }
               // TODO: Do this concatenation once
               aCache['_' + a[i]] = selectAtomFactory(o.id, o.tag.toLowerCase(), classNames, o.combinator, o.attributes, o.attributeValues, o.attributeOperators, o.pseudo);
             }
             ns[j] = aCache['_' + a[i]](ns[j - 1], docNode, !i);
             qid++;
             previousAtom = o;
             j++;
           }
           return ns[j - 1].reverse();
         };
      };

      var get = (function() {
        var el, getD, r;

        if (typeof getEBI != 'undefined' &&
            typeof getEBTN != 'undefined' &&
            typeof getChildren != 'undefined' &&
            typeof getAttribute != 'undefined' && (global.document.expando || typeof global.document.expando == 'undefined')) {
          getD = function(d, a, s, multiple) {
            if (a.length == 1 && !multiple) {
              o = parseAtom(a[0]);
              if (!o.pseudo && !o.attributes) {
                if (o.id && !o.cls && d.nodeType == 9) {
                  // Optimization for #foo
                  el = getEBI(o.id, getDocNode(d));
                  return (el && el.id == o.id && (o.tag == '*' || o.tag == el.tagName.toLowerCase()))?[el]:[];
                }
                if (!o.id && !o.cls) {
                  // Optimization for foo
                  r = getEBTN(o.tag, d);
                  // TODO: Add hidden argument to force array return
                  return (typeof r.reverse == 'function')?r:toArray(r);
                }
              }
            }
	    s = '_' + s; // avoid toString conflict

            // TODO: De-tokenize before using as property name
            if (!cache[s]) {
              cache[s] = selectFactory(a);
            }
            return cache[s](d);
          };
        }

        if (getD) {
          return function(d, a, s, multiple) {

            // TODO: Really only need to disable XPath for specific selectors
            // TODO: Pass document type flags to this, check for MSXML here, pass case sensitive flag to all but MSXML get (which is always case sensitive)

            if (selectByXPath && !xPathChildSelectorsBad) {
              get = function(d, a, s, multiple) {
                // Defer to DOM traversal for language selector

                // TODO: But not for XML documents

                return s.indexOf(':lang(') != -1 ? getD(d, a, s, multiple) : selectByXPath(d, a, s, multiple);
              };
              return get(d, a, s, multiple);
            }
            get = getD;
            return get(d, a, s, multiple);
          };
        }
      })();

      if (get) {
        return function(s, d) {
          var a = [], aSel = [], chr, i, inQuotes, r = [], used = {};

          d = d || global.document;
          s = s.replace(/^\s+/,'').replace(/\s+$/,''); // trim
          s = s.replace(/\s+,/g, ',').replace(/,\s+/g, ','); // remove spaces before and after commas
          i = s.length;
          while (i--) {
            chr = s.charAt(i);
            switch (chr) {
            case ',':
              if (inQuotes) {
                aSel[aSel.length] = chr;
              }
              else {
                a[a.length] = aSel.reverse().join('');
                aSel = [];
              }
              break;
            case ' ':
              // change quoted spaces to nulls temporarily
              // changed back in parseAtom
              aSel[aSel.length] = (inQuotes)?'\x00\x00\x00':' ';
              break;
            case ']':
              aSel[aSel.length] = (inQuotes)?'\x00\x00\x01':']';
              break;
            case '#':
              aSel[aSel.length] = (inQuotes)?'\x00\x00\x04':'#';
              break;
            case '.':
              aSel[aSel.length] = (inQuotes)?'\x00\x00\x05':'.';
              break;
            case ':':
              aSel[aSel.length] = (inQuotes)?'\x00\x00\x06':':';
              break;
            case '>':
              aSel[aSel.length] = (inQuotes)?'\x00\x00\x07':'>';
              break;
            case '~':
              aSel[aSel.length] = (inQuotes)?'\x00\x00\x08':'~';
              break;
            case '+':
              aSel[aSel.length] = (inQuotes)?'\x00\x00\x11':'+';
              break;
            case '"':
            case "'":
              var quoteCharacter;
              if (!inQuotes || quoteCharacter == chr) {
                inQuotes = !inQuotes;
                quoteCharacter = chr;
                aSel[aSel.length] = chr;
              } else {
                aSel[aSel.length] = (chr == '"')?'\x00\x00\x02':'\x00\x00\x03';
              }
              break;
            default:
              aSel[aSel.length] = chr;
            }
          }
          if (aSel.length) {
            a[a.length] = aSel.reverse().join('').replace(/:nth(-last)?-(child|of-type)\((-)?(\d+)?n\+(\d+)\)/g, ':nth$1-$2($3$4nplus$5)');
          }
          a.reverse();
          traversedElements = {};
          traversedElements2 = {};
          i = a.length;
          var multiple = i > 1;
          while (i--) {
	    a[i] = a[i].replace(/\s+/g, ' '); // collapse multiple spaces
            a[i] = a[i].replace(/([^\s])([>\+])/g, '$1 $2');
            a[i] = a[i].replace(/([^\s])([~])([^=])/g, '$1 $2$3');
            a[i] = a[i].replace(/([>\+~])\s/g, '$1');
            if (!used['_' + a[i]]) { // prevent dupes (e.g. div, div, div) // TODO: Should not used tokenized string for property name
              r = r.concat(get(d, a[i].split(' ').reverse(), a[i], multiple));
              used['_' + a[i]] = 1; // TODO: Do this concatenation once
            }
          }
          return r;
        };
      }
      html = null;
    })();

    if (getEBCS) {
      <%If bDollar Then%>
      $ = getEBCS;
      <%End If%>
      getEBCN = function(s, d) {
        var a = s.split(' ');
        for (var i = a.length; i--;) {
          a[i] = '.' + a[i];
        }
        return getEBCS(a.join(''), d);
      };

      API.getEBCS = getEBCS;
      API.getEBCN = getEBCN;
    }

    // Safari 3 bug test (tested Windows Beta version)

    if (attachDocumentReadyListener && getEBXP) {
      attachDocumentReadyListener(function() {
        xPathChildSelectorsBad = !!getEBXP('.//*[1][self::body]').length;
      });
    }
    <%End If 'Query%>
    <%If bObjects Then%>
    // Objects require getEBCS and its support functions + isOwnProperty
    // Everything else (e.g. array functions, setOpacity, serializeFormUrlencoded, etc.) is optional

    // Note: don't abuse, re-use
    //
    // Bad:
    // Q('div.foo:first-child').show().setOpacity(0.5);
    // Q('div.bar:first-child').show(false);
    //
    // Good:
    // var q = Q('div.foo:first-child').show().setOpacity(0.5);
    // q.load('div.bar:first-child').show(false);

    isElement = function(d) {
      return (d.nodeType == 1 && d.tagName != '!') || (!d.nodeType && d.tagName);
    };

    areObjectFeatures = function() {
      var i = arguments.length;

      while (i--) {
        if (!this[arguments[i]]) {
          return false;
        }
      }
      return true;
    };

    if (API.getEBCS) {
      if (Function.prototype.call) {
        argsToArray = function(args, begin) {
          return Array.prototype.slice.call(args, begin);
        };

        resolveQueryArgs = function(s, d) {
          return (typeof s == 'object' && s.elements)?s.elements():((typeof s == 'string')?getEBCS(s, d):s);
        };

        // Multiple elements
        // First argument can be a string (selector) or array
        // If first argument is a string, optional second argument is the context document or element

        Q = function(s, d) {
          var elContext, els, stack = [];

          // Called without - new - operator

          if (this == global) {
            return new Q(s, d);
          }

          this.load = function(s, d) {
            els = (typeof s == 'string')?getEBCS(s, d):s;
            elContext = (d && isElement(d))?d:null;
            return this;
          };

          this.elements = function(i) {
            return (arguments.length)?els[i] || null:els.concat([]);
          };

          this.context = function() {
            return elContext;
          };

          if (API.push && API.pop) {
            this.beginTransaction = function() {
              push(stack, els);
              els = els.concat([]);
              return this;
            };

            this.rollback = function() {
              els = pop(stack);
              return this;
            };

            this.commit = function() {
              pop(stack);
              return this;
            };
          }

          this.load(s, d);
        };

        var qPrototype = Q.prototype;

        qPrototype.areFeatures = function() {
          return areObjectFeatures.apply(this, arguments);
        };

        qPrototype.length = function() {
          return this.elements().length;
        };

        qPrototype.find = function(s) {
          return new Q(s, this.context());
        };

        if (API.htmlToNodes) {
            qPrototype.loadHtml = function(html, docNode) {
              var i, els, elContext, b, c = htmlToNodes(html, docNode);
              if (c) {
                c = toArray(c);
                i = c.length;
                while (i-- && !b) { // Make sure all are element nodes
                  b = !isElement(c[i]);
                }
                if (!b) {
                  els = c;
                  elContext = null;
                }
              }
              return this.load(els, elContext);
            };
        }

        qPrototype.copy = function() {
            return new Q(this.elements(), this.context());
        };

        qPrototype.clear = function() {
            return this.load([]);
        };

        if (API.push && API.pop) {
            qPrototype.pop = function() {
              return pop(this.elements());
            };

            if (Array.prototype.unshift) {
              qPrototype.push = function() {
                var els = this.elements();
                push.apply(els, argsToArray(arguments).unshift(els));
                return this.load(els);
              };
            }
            else {
              qPrototype.push = function() {
                var j, i = arguments.length;
                var els = this.elements();
                for (j = 0; j < i; j++) {
                  push(els, arguments[j]);
                }
                return this.load(els);
              };
            }
        }

        if (Array.prototype.splice && qPrototype.push) {
            qPrototype.addMe = function(pos) {
              var elContext = this.context();
              if (elContext) {
                if (!arguments.length) {
                  this.push(elContext);
                }
                else {
                  this.inject(pos, elContext);
                }
              }
              return this.load(this.elements());
            };
        }

        if (Array.prototype.shift) {
            qPrototype.shift = function() {
              var els = this.elements(), elContext = this.context();
              els.shift();
              return this.load(els, elContext);
            };

            qPrototype.unshift = function() {
              var els = this.elements();
              Array.prototype.unshift.apply(els, arguments);
              return this.load(els);
            };
        }

        qPrototype.slice = function(begin, end) {
            var els = this.elements(), elContext = this.context();
            els = els.slice(begin, end);
            return this.load(els, elContext);
        };

        if (API.indexOf) {
            qPrototype.indexOf = function(elt) {
              return indexOf(this.elements(), elt);
            };
        }

        if (API.filter) {
            qPrototype.filter = function(fn, context) {
              var els = this.elements(), elContext = this.context();
              els = filter(els, fn, context);
              return this.load(els, elContext);
            };

            qPrototype.odds = function() {
              return this.filter(function(el, i) {
                return i % 2;
              });
            };

            qPrototype.evens = function() {
              return this.filter(function(el, i) {
                return !(i % 2);
              });
            };
        }

        if (API.map) {
            qPrototype.map = function(fn, context) {
              return map(this.elements(), fn, context);
            };
        }

        qPrototype.append = function(s, d) {
            var els = this.elements(), elContext = this.context();
            els = els.concat(resolveQueryArgs(s, d));
            if (!d || d != elContext) { elContext = null; }
	    return this.load(els, elContext);
        };

        qPrototype.prepend = function(s, d) {
            var els = this.elements(), elContext = this.context();
            els = resolveQueryArgs(s, d).concat(els);
            if (!d || d != elContext) { elContext = null; }
	    return this.load(els, elContext);
        };

        if (API.setAttribute && API.forEach) {
            qPrototype.setAttribute = function(name, value) {
              var els = this.elements(), elContext = this.context();
              forEach(els, function(el, i) {
                els[i] = setAttribute(el, name, value);
              });
              return this.load(els, elContext);
            };
            qPrototype.setAttributeProperty = function(name, value) {
              var els = this.elements(), elContext = this.context();
              forEach(els, function(el, i) {
                els[i] = setAttributeProperty(el, name, value);
              });
              return this.load(els, elContext);
            };
        }

        if (API.some) {
          qPrototype.some = function(fn, context) {
            var els = this.elements();
            return some(els, fn, context || this);
          };
        }

        if (API.every) {
          qPrototype.every = function(fn, context) {
            var els = this.elements();
            return every(els, fn, context || this);
          };
        }

        if (API.forEach) {
          qPrototype.forEach = function(fn, context) {
            var els = this.elements(), elContext = this.context();
            forEach(els, fn, context || this, true);
            return this.load(els, elContext);
          };
        }

        var qPrototypeForEach = Q.prototype.forEach, qPrototypeEvery = Q.prototype.every;

        qPrototype.reverse = function() {
          var els = this.elements(), elContext = this.context();
          els.reverse();
          return this.load(els, elContext);
        };

        if (Array.prototype.splice) {
          qPrototype.splice = function() {
            var els = this.elements(), elContext = this.context();
            Array.prototype.splice.apply(els, arguments);
            return this.load(els, elContext);
          };

          qPrototype.inject = function(pos, s, d) {
            var els = this.elements(), elContext = this.context();
            var a = resolveQueryArgs(s, d);
            if (a.length) {
              a.unshift(pos, 0);
              Array.prototype.splice.apply(els, a);
            }
            return this.load(els, elContext);
          };

          qPrototype.snip = function(pos, count) {
            var els = this.elements(), elContext = this.context();
            els.splice(pos, count || 1);
            return this.load(els, elContext);
          };
        }

        qPrototype.first = function() {
          var els = this.elements();
          return (els.length)?els[0]:null;
        };

        qPrototype.last = function() {
          var els = this.elements();
          return (els.length)?els[els.length - 1]:null;
        };

        qPrototype.random = function() {
          var els = this.elements();
          return (els[Math.floor(Math.random() * els.length) % els.length]);
        };

        if (API.addElementHtml && qPrototypeForEach) {
          qPrototype.addHtml = function(html) {
            this.forEach(function(el) { addElementHtml(el, html); });
            return this;
          };
        }

        if (API.getElementOuterHtml && qPrototypeForEach) {
          qPrototype.toHtml = function(bXhtml) {
            var a = [];
            this.forEach(function(el, i) { a[i] = getElementOuterHtml(el, bXhtml); });
            return a.join('');
          };
        }
       
        // Element
        // First argument can be a string (id) or element
        // If first argument is a string, optional second argument is a document node

        // Note: Always test the "element" method before starting a chain
        // Example:

        // var e = E('test');
        // if (e.element) { // Method is exposed if an element is found
        //   e.show().setOpacity(0.5);
        // }

        E = function(id, docNode) {
          var el;

          // Called without - new - operator

          if (this == global) {
            return new E(id, docNode);
          }

          function element() {
            return el;
          }

          this.load = function(id, docNode) {
            el = (typeof id == 'string')?getEBI(id, docNode):id;
            this.element = (el && isElement(el))?element:null;
            return this;
          };

          this.load(id, docNode);
        };

        var ePrototype = E.prototype;

        ePrototype.areFeatures = function() {
          return areObjectFeatures.apply(this, arguments);
        };

        if (API.createElementWithAttributes) {
          ePrototype.loadNew = function(tag, attributesOrProperties, setProperties) {
            return this.load((setProperties ? createElementWithProperties : createElementWithAttributes)(tag, attributesOrProperties || {}));
          };
        }

        if (API.findAncestor) {
          ePrototype.findAncestor = function(tagName, className) {
            return findAncestor(this.element(), tagName, className);
          };
          ePrototype.loadAncestor = function(tagName, className) {
            return this.load(this.findAncestor(tagName, className));
          }
        }

        if (API.htmlToNodes) {
          ePrototype.loadHtml = function(html, docNode) {
            var el, c = htmlToNodes(html, docNode);
            if (c && c[0]) {
              el = c[0];
            }
            return this.load(el);
          };
        }

        if (API.setElementOuterHtml) {
          ePrototype.setOuterHtml = function(html, options, fnDone) {
            return this.load(setElementOuterHtml(this.element(), html, options, fnDone));
          };
        }

        ePrototype.loadNext = function() {
          var el = this.element().nextSibling;
          while (el && el.nodeType != 1) {
            el = el.nextSibling;
          }
          return this.load(el);
        };

        ePrototype.loadPrevious = function() {
          var el = this.element().previousSibling;
          while (el && el.nodeType != 1) {
            el = el.previousSibling;
          }
          return this.load(el);
        };

        if (API.importNode) {
          ePrototype.loadImport = function(elExport, bImportChildren, docNode) {
            return this.load(importNode(elExport, bImportChildren, docNode));
          };
        }

        if (API.emptyNode) {
          if (qPrototypeForEach) {
            qPrototype.empty = function() {
              this.forEach(function(el) { emptyNode(el); });
              return this;
            };
          }

          ePrototype.empty = function() {
            emptyNode(this.element());
            return this;
          };
        }

        if (API.isDescendant) {
          ePrototype.isDescendant = function(el) {
            return isDescendant(el, this.element());
          };
          ePrototype.isAncestor = function(el) {
            return isDescendant(this.element(), el);
          };
        }

        ePrototype.isTag = function(tag) {
          var el = this.element();
          return (getElementNodeName(el) == tag.toLowerCase());
        };

        ePrototype.query = function(s) {
          return new Q(s, this.element());
        };

        // Add DOM methods
        // First seven are required by getEBCS, so no testing required

        ePrototype.getAttribute = function(name) {
          return getAttribute(this.element(), name);
        };

        // Implied by getAttribute

        ePrototype.getAttributeProperty = function(name) {
          return getAttributeProperty(this.element(), name);
        };

        if (qPrototype.every) {
          qPrototype.hasAttribute = function(name) {
            return this.every(function(el) { return hasAttribute(el, name); });
          };
        }

        ePrototype.hasAttribute = function(name) {
          return hasAttribute(this.element(), name);
        };

        ePrototype.document = function() {
          return getElementDocument(this.element());
        };

        ePrototype.children = function(i) {
          var els = getChildren(this.element());
          return (arguments.length)?els[i] || null:els;
        };

        ePrototype.descendants = function(tag, i) {
          var els = getEBTN(tag || '*', this.element());

          if (typeof i == 'undefined') {
            return toArray(els);
          }
          return els[i] || null;
        };

        if (API.removeAttribute) {
          if (qPrototypeForEach) {
            qPrototype.removeAttribute = function(name) {
              this.forEach(function(el) { removeAttribute(el, name); });
              return this;
            };
          }

          ePrototype.removeAttribute = function(name) {
            removeAttribute(this.element(), name);
            return this;
          };
        }

        if (API.setAttribute) {
          ePrototype.setAttribute = function(name, value) {
            return this.load(setAttribute(this.element(), name, value));
          };
        }

        if (API.setAttributes) {
          ePrototype.setAttributes = function(attributes) {
            return this.load(setAttributes(this.element(), attributes));
          };
        }

        if (API.getElementText) {
          ePrototype.getText = function() {
            return getElementText(this.element());
          };
        }

        if (API.setElementText) {
          if (qPrototypeForEach) {
            qPrototype.setText = function(text) {
              this.forEach(function(el) { setElementText(el, text); });
              return this;
            };
          }

          ePrototype.setText = function(text) {
            setElementText(this.element(), text);
            return this;
          };
        }

        if (API.addElementText) {
          ePrototype.addText = function(text) {
            addElementText(this.element(), text);
            return this;
          };
        }

        if (API.attachListener) {
          if (qPrototypeForEach) {
            qPrototype.on = function(ev, fn, context) {
              this.forEach(function(el) { attachListener(el, ev, fn, context); });
              return this;
            };

            qPrototype.off = function(ev, fn) {
              this.forEach(function(el) { detachListener(el, ev, fn); });
              return this;
            };

            if (typeof assistedEvents != 'undefined') {
              fn = function(h) {
                return function(fn, context) {
                  this.forEach(function(el) { h(el, fn, context); });
                  return this;
                };
              };
              fn2 = function(h) {
                return function(fn, context) {
                  this.forEach(function(el) { h(el, fn, context); });
                  return this;
                };
              };
              for (index in assistedEvents) {
                if (isOwnProperty(assistedEvents, index)) {
                  Q.prototype['on' + index] = fn(assistedEvents[index].attach);
                  Q.prototype['off' + index] = fn2(assistedEvents[index].detach);
                }
              }
            }

            if (typeof attachRolloverListeners != 'undefined') {
              qPrototype.onRoll = function(fnOver, fnOut, context, bAttachFocusListeners, bSetStatus) {
                this.forEach(function(el) { attachRolloverListeners(el, fnOver, fnOut, context, bAttachFocusListeners, bSetStatus); });
                return this;
              };
            }
          }

          ePrototype.on = function(ev, fn, context) {
            attachListener(this.element(), ev, fn, context);
            return this;
          };

          ePrototype.off = function(ev, fn) {
            detachListener(this.element(), ev, fn);
            return this;
          };

          if (typeof assistedEvents != 'undefined') {
            fn = function(h) {
              return function(fn, context) {
                h(this.element(), fn, context);
                return this;
              };
            };
            fn2 = function(h) {
              return function(fn) {
                h(this.element(), fn);
                return this;
              };
            };
            for (index in assistedEvents) {
              if (isOwnProperty(assistedEvents, index)) {
                E.prototype['on' + index] = fn(assistedEvents[index].attach);
                E.prototype['off' + index] = fn2(assistedEvents[index].detach);
              }
            }
          }

          if (typeof attachRolloverListeners != 'undefined') {
            ePrototype.onRoll = function(fnOver, fnOut, context, bAttachFocusListeners, bSetStatus) {
              attachRolloverListeners(this.element(), fnOver, fnOut, context, bAttachFocusListeners, bSetStatus);
              return this;
            };
          }
        }

        if (html && isHostMethod(html, 'appendChild')) {
          ePrototype.appendTo = function(el) {
            el.appendChild(this.element());
            return this;
          };

          if (qPrototypeForEach) {
            qPrototype.appendTo = function(el) {
              this.forEach(function(elC) { el.appendChild(elC); });
              return this;
            };
          }

          ePrototype.remove = function() {
            var el = this.element();
            var parent = el.parentNode;
            if (parent) { parent.removeChild(el); }
            return this;
          };

          if (qPrototypeForEach) {
            qPrototype.remove = function() {
              var parent;
              this.forEach(function(el) { parent = el.parentNode; if (parent) { parent.removeChild(el); } });
              return this;
            };
          }
        }

        if (isHostMethod(html, 'replaceChild')) {
          ePrototype.replace = function(el) {
            var parent = el.parentNode;
            //if (API.purgeListeners) { API.purgeListeners(el, true); }
            if (parent) { parent.replaceChild(this.element(), el); }
            return this;
          };
        }

        if (isHostMethod(html, 'insertBefore')) {
          ePrototype.insertBefore = function(el) {
            var parent = el.parentNode;

            if (parent) {
              parent.insertBefore(this.element(), el);
            }
            return this;
          };

          if (qPrototypeForEach) {
            qPrototype.insertBefore = function(el) {
              var parent = el.parentNode;

              if (parent) {
                this.forEach(function(elC) {
                  parent.insertBefore(elC, el);
                });
              }
              return this;
            };
          }

          ePrototype.insertAfter = function(el) {
            var next = el.nextSibling;
            var parent = el.parentNode;

            if (parent) {
              if (next) {
                parent.insertBefore(this.element(), next);
              }
              else {
                parent.appendChild(this.element());
              }
            }
            return this;
          };

          if (qPrototypeForEach) {
            qPrototype.insertAfter = function(el) {
              var next = el.nextSibling;
              var parent = el.parentNode;

              if (parent) {
                this.forEach((next)?function(elC) { parent.insertBefore(elC, next); }:function(elC) { parent.appendChild(elC); });
              }
              return this;
            };
          }
        }

        if (isHostMethod(html, 'cloneNode')) {
          ePrototype.clone = function(bChildren) {
            return this.element().cloneNode(bChildren);
          };
          ePrototype.loadClone = function(bChildren) {
            return this.load(this.clone(bChildren));
          };
        }

        if (API.canAdjustStyle) {
          if (API.positionElement) {
            if (qPrototypeForEach) {
              qPrototype.position = function(y, x, options, fnDone) {
                this.forEach(function(el) { positionElement(el, y, x, options, fnDone); });
                return this;
              };
            }

            ePrototype.position = function(y, x, options, fnDone) {
              positionElement(this.element(), y, x, options, fnDone);
              return this;
            };
          }

          if (API.sizeElement) {
            if (qPrototypeForEach) {
              qPrototype.size = function(h, w, options, fnDone) {
                this.forEach(function(el) { sizeElement(el, h, w, options, fnDone); });
                return this;
              };
              qPrototype.sizeOuter = function(h, w) {
                this.forEach(function(el) { sizeElementOuter(el, h, w); });
                return this;
              };
            }

            ePrototype.size = function(h, w, options, fnDone) {
              sizeElement(this.element(), h, w, options, fnDone);
              return this;
            };

            ePrototype.sizeOuter = function(h, w) {
              sizeElementOuter(this.element(), h, w);
              return this;
            };
          }

          if (API.isVisible) {
            ePrototype.isVisible = function() {
              return isVisible(this.element());
            };
          }

          if (API.isPresent) {
            ePrototype.isPresent = function() {
              return isPresent(this.element());
            };
          }

          if (API.attachDocumentReadyListener) {
            attachDocumentReadyListener(function() {
              var m;

              if (API.getElementScrollPosition) {
                ePrototype.getScrollPosition = function() {
                  return getElementScrollPosition(this.element());
                };

                ePrototype.setScrollPosition = function(t, l, isNormalized, options, fnDone) {
                  setElementScrollPosition(this.element(), t, l, isNormalized, options, fnDone);
                  return this;
                };

                index = scrollSides.length;
                fn = function(n) {
                  return function() {
                    API[n](this.element());
                    return this;
                  };
                };
                while (index--) {
                 m = 'setElementScrollPosition' + index;
                 if (API[m]) {
                    E.prototype[m] = fn(m);
                  }
                }
              }

              if (API.dispatchEvent) {
                ePrototype.dispatch = function(ev, evType, e) {
                  fireEvent(this.element(), ev, evType, e);
                  return this;
                };
              }

              if (API.elementContainedInElement) {
                ePrototype.containedBy = function(el) {
                  return elementContainedInElement(this.element(), el);
                };
              }

              if (API.elementOverlapsElement) {
                ePrototype.overlaps = function(el) {
                  return elementOverlapsElement(this.element(), el);
                };
              }

              if (API.showElement) {
                if (qPrototypeForEach) {
                  qPrototype.show = function(b, options, fnDone) {
                    this.forEach(function(el) { showElement(el, b, options, fnDone); });
                    return this;
                  };
                  qPrototype.toggle = function(b, options, fnDone) {
                    this.forEach(function(el) { toggleElement(el, b, options, fnDone); });
                    return this;
                  };
                  if (API.effects) {
                    fn = function(index, show) {
                      return function(options, fnDone) {
                        options = options || {};
                        options.effects = index;
                        this.forEach(function(el) { showElement(el, show, options, fnDone); });
                        return this;
                      };
                    };
                    for (index in effects) {
                      if (isOwnProperty(effects, index) && index != 'move' && index != 'shake' && index != 'scroll' && index != 'scrollElement') {
                        Q.prototype[index + 'In'] = fn(effects[index], true);
                        Q.prototype[index + 'Out'] = fn(effects[index]);
                      }
                    }
                  }
                }

                ePrototype.show = function(b, options, fnDone) {
                  showElement(this.element(), b, options, fnDone);
                  return this;
                };

                ePrototype.toggle = function(b, options, fnDone) {
                  toggleElement(this.element(), b, options, fnDone);
                  return this;
                };

                fn = function(index, show) {
                  return function(options, fnDone) {
                    options = options || {};
                    options.effects = index;
                    showElement(this.element(), show, options, fnDone);
                    return this;
                  };
                };

                if (API.effects) {
                  for (index in effects) {
                    if (isOwnProperty(effects, index) && index != 'move' && index != 'shake' && index != 'scroll' && index != 'scrollElement') {
                      E.prototype[index + 'In'] = fn(effects[index], true);
                      E.prototype[index + 'Out'] = fn(effects[index]);
                    }
                  }

                  if (typeof spring == 'function') {
                    ePrototype.springIn = function(elFrom, options, fnDone) {
                      spring(this.element(), elFrom, true, options, fnDone);
                      return this;
                    };

                    ePrototype.springOut = function(elFrom, options, fnDone) {
                      spring(this.element(), elFrom, false, options, fnDone);
                      return this;
                    };
                  }
                }
              }
              if (API.presentElement) {
                if (qPrototypeForEach) {
                  qPrototype.present = function(b, display) {
                    this.forEach(function(el) { presentElement(el, b, display); });
                    return this;
                  };

                  qPrototype.togglePresence = function(b, display) {
                    this.forEach(function(el) { toggleElementPresence(el, b, display); });
                    return this;
                  };
                }

                ePrototype.present = function(b, display) {
                  presentElement(this.element(), b, display);
                  return this;
                };

                ePrototype.togglePresence = function(b, display) {
                  toggleElementPresence(this.element(), b, display);
                  return this;
                };
              }

              if (API.centerElement) {
                ePrototype.center = function(options, fnDone) {
                  centerElement(this.element(), options, fnDone);
                  return this;
                };
              }

              if (API.maximizeElement) {
                ePrototype.maximize = function(options, fnDone) {
                  maximizeElement(this.element(), options, fnDone);
                  return this;
                };
              }

              if (API.restoreElement) {
                ePrototype.restore = function(options, fnDone) {
                  restoreElement(this.element(), options, fnDone);
                  return this;
                };
              }

              if (API.fullScreenElement) {
                ePrototype.fullScreen = function() {
                  fullScreenElement(this.element());
                  return this;
                };
              }

              if (API.coverDocument) {
                ePrototype.coverDocument = function() {
                  coverDocument(this.element());
                  return this;
                };
              }

              if (API.overlayElement) {
                ePrototype.overlay = function(el, cover) {
                  overlayElement(this.element(), el, cover);
                  return this;
                };
              }

              if (API.adjacentElement) {
                ePrototype.adjacent = function(el, side) {
                  adjacentElement(this.element(), el, side);
                  return this;
                };
              }

              if (API.absoluteElement) {
                ePrototype.absolute = function() {
                  absoluteElement(this.element());
                  return this;
                };
              }

              if (API.relativeElement) {
                ePrototype.relative = function() {
                  relativeElement(this.element());
                  return this;
                };
              }

              if (API.applyDirectXTransitionFilter) {
                if (qPrototypeForEach) {
                  qPrototype.applyTransitionFilter = function(name, duration, params) {
                    this.forEach(function(el) { applyDirectXTransitionFilter(el, name, duration, params); });
                    return this;
                  };
                }

                ePrototype.applyTransitionFilter = function(name, duration, params) {
                  applyDirectXTransitionFilter(this.element(), name, duration, params);
                  return this;
                };

                if (qPrototypeForEach) {
                  qPrototype.playTransitionFilter = function(name) {
                    this.forEach(function(el) { playDirectXTransitionFilter(el, name); });
                    return this;
                  };
                }

                ePrototype.playTransitionFilter = function(name) {
                  applyDirectXTransitionFilter(this.element(), name);
                  return this;
                };
              }

              if (API.attachDrag) {
                ePrototype.attachDrag = function(elHandle, options) {
                  attachDrag(this.element(), elHandle, options);
                  return this;
                };

                ePrototype.detachDrag = function(elHandle) {
                  detachDrag(this.element(), elHandle);
                  return this;
                };

                if (API.initiateDrag) {
                  ePrototype.initiateDrag = function() {
                    initiateDrag(this.element());
                    return this;
                  };
                }
              }

              if (API.getElementPosition) {
                ePrototype.getPosition = function() {
                  return getElementPosition(this.element());
                };
              }

              if (API.getElementSizeStyle) {
                ePrototype.sizeStyle = function() {
                  return getElementSizeStyle(this.element());
                };
              }

              if (API.getElementPositionStyle) {
                ePrototype.positionStyle = function() {
                  return getElementPositionStyle(this.element());
                };
              }
            });
          }

          if (API.addClass) {
            if (qPrototypeForEach) {
              qPrototype.addClass = function(cls) {
                this.forEach(function(el) { addClass(el, cls); });
                return this;
              };
            }

            ePrototype.addClass = function(cls) {
              addClass(this.element(), cls);
              return this;
            };
          }

          if (API.hasClass) {
            if (qPrototypeEvery) {
              qPrototype.hasClass = function(cls) {
                return this.every(function(el) { return hasClass(el, cls); });
              };
            }

            ePrototype.hasClass = function(cls) {
              return hasClass(this.element(), cls);
            };
          }

          if (API.removeClass) {
            if (qPrototypeForEach) {
              qPrototype.removeClass = function(cls) {
                this.forEach(function(el) { removeClass(el, cls); });
                return this;
              };
            }

            ePrototype.removeClass = function(cls) {
              removeClass(this.element(), cls);
              return this;
            };
          }
        }

        if (API.getCascadedStyle) {
          ePrototype.getCascadedStyle = function(style) {
            return getCascadedStyle(this.element(), style);
          };
        }

        if (API.getComputedStyle) {
          ePrototype.getComputedStyle = function(style) {
            return getKomputedStyle(this.element(), style);
          };
        }

        if (API.getOverrideStyle) {
          ePrototype.getOverrideStyle = function(style) {
            return getOverrideStyle(this.element(), style);
          };
        }

        if (API.getStyle) {
          ePrototype.getStyle = function(style) {
            return getStyle(this.element(), style);
          };
        }

        if (API.setStyle) {
          if (qPrototypeForEach) {
            qPrototype.setStyle = function(style, value) {
              this.forEach(function(el) { setStyle(el, style, value); });
              return this;
            };
          }

          ePrototype.setStyle = function(style, value) {
            setStyle(this.element(), style, value);
            return this;
          };
        }

        if (API.setStyles) {
          if (qPrototypeForEach) {
            qPrototype.setStyles = function(styles) {
              this.forEach(function(el) { setStyles(el, styles); });
              return this;
            };
          }

          ePrototype.setStyles = function(styles) {
            setStyles(this.element(), styles);
            return this;
          };
        }

        if (API.getElementSize) {
          ePrototype.getSize = function() {
            return getElementSize(this.element());
          };
        }

        if (API.getElementBorder) {
          ePrototype.border = function(side) {
            return getElementBorder(this.element(), side);
          };
        }

        if (API.getElementBorders) {
          ePrototype.borders = function() {
            return getElementBorders(this.element());
          };
        }

        if (API.getElementMargin) {
          ePrototype.margin = function(side) {
            return getElementMargin(this.element(), side);
          };
        }

        if (API.getElementMargins) {
          ePrototype.margins = function() {
            return getElementMargins(this.element());
          };
        }

        if (API.setElementHtml) {
          if (qPrototypeForEach) {
            qPrototype.setHtml = function(html) {
              this.forEach(function(el) { setElementHtml(el, html); });
              return this;
            };
          }

          ePrototype.setHtml = function(html, options, fnDone) {
            return this.load(setElementHtml(this.element(), html, options, fnDone));
          };
        }

        if (API.addElementHtml) {
          if (qPrototypeForEach) {
            qPrototype.addHtml = function(html) {
              this.forEach(function(el) { addElementHtml(el, html); });
              return this;
            };
          }

          ePrototype.addHtml = function(html) {
            addElementHtml(this.element(), html);
            return this;
          };
        }

        if (API.setElementNodes) {
          ePrototype.setNodes = function(elNewNodes, options, fnDone) {
            setElementNodes(this.element(), elNewNodes, options, fnDone);
            return this;
          };
        }

        if (API.addElementNodes) {
          ePrototype.addNodes = function(elNewNodes) {
            addElementNodes(this.element(), elNewNodes);
            return this;
          };
        }

        if (API.getElementHtml) {
          ePrototype.html = function(bXhtml) {
            return getElementHtml(this.element(), bXhtml);
          };
        }

        if (API.getElementOuterHtml) {
          ePrototype.htmlOuter = function(bXhtml) {
            return getElementOuterHtml(this.element(), bXhtml);
          };
        }

        if (API.updateElement) {
          ePrototype.update = function(uri, bAppend, updateOptions, fnUpdate, fnUpdated, requester) {
            updateElement(this.element(), uri, bAppend, updateOptions, fnUpdate, fnUpdated, requester);
            return this;
          };
        }

        if (API.setOpacity) {
          if (qPrototypeForEach) {
            qPrototype.setOpacity = function(o) {
              this.forEach(function(el) { setOpacity(el, o); });
              return this;
            };
          }

          ePrototype.setOpacity = function(o) {
            setOpacity(this.element(), o);
            return this;
          };
        }

        if (API.getOpacity) {
          ePrototype.getOpacity = function() {
            return getOpacity(this.element());
          };
        }

        // Document

        D = function(n) {
          var node;

          if (this == global) {
            return new D(n);
          }

          this.load = function(n) {
            node = n || global.document;
            return this;
          };

          this.load(n);

          this.node = function() {
            return node;
          };
        };

        var dPrototype = D.prototype;

        dPrototype.areFeatures = function() {
          return areObjectFeatures.apply(this, arguments);
        };

        dPrototype.isXhtml = function() {
          return isXmlParseMode(this.node());
        };

        dPrototype.query = function(s) {
          return new Q(s, this.node());
        };

        dPrototype.children = function(i) {
          var els = getChildren(this.node());
          return (arguments.length)?els[i] || null:els;
        };

        dPrototype.descendants = function(tag, i) {
          var els = getEBTN(tag || '*', this.node());

          if (typeof i == 'undefined') {
            return toArray(els);
          }

          return els[i] || null;
        };

        if (API.createElementWithAttributes) {
          dPrototype.createWithAttributes = function(tag, atts) {
            return createElementWithAttributes(tag, atts, this.node());
          };
          dPrototype.createWithProperties = function(tag, props) {
            return createElementWithProperties(tag, props, this.node());
          };
        }

        if (API.createAndAppendElementWithAttributes) {
          dPrototype.createAndAppendWithAttributes = function(tag, atts, appendTo) {
            return createAndAppendElementWithAttributes(tag, atts, appendTo, this.node());
          };
          dPrototype.createAndAppendWithProperties = function(tag, props, appendTo) {
            return createAndAppendElementWithProperties(tag, props, appendTo, this.node());
          };
        }

        if (API.createElement) {
          dPrototype.create = function(tag) {
            return createElement(tag, this.node());
          };
        }

        if (API.getHtmlElement) {
          dPrototype.htmlElement = function() {
            return getHtmlElement(this.node());
          };
        }

        if (API.getHeadElement) {
          dPrototype.head = function() {
            return getHeadElement(this.node());
          };
        }

        if (API.getDocumentWindow) {
          dPrototype.window = function() {
            return getDocumentWindow(this.node());
          };
        }

        if (API.importNode) {
          dPrototype.importNode = function(elExport, bImportChildren) {
            return importNode(elExport, bImportChildren, this.node());
          };
        }

        if (API.addStyleRule) {
          dPrototype.addStyleRule = function(selector, rule, media) {
            addStyleRule(selector, rule, media, this.node());
            return this;
          };
        }

        if (API.setActiveStyleSheet) {
          dPrototype.setActiveStyleSheet = function(id) {
            setActiveStyleSheet(id, this.node());
            return this;
          };
        }

        if (API.getCookie) {
          dPrototype.getCookie = function(name, defaultValue, encoded) {
            return getCookie(name, defaultValue, encoded, this.node());
          };
          dPrototype.setCookie = function(name, value, expires, path, secure) {
            setCookie(name, value, expires, path, secure, this.node());
            return this;
          };
          dPrototype.deleteCookie = function(name, path)  {
            deleteCookie(name, path, this.node());
            return this;
          };
        }

        if (API.attachDocumentListener) {
          dPrototype.on = function(ev, fn, context) {
            attachDocumentListener(ev, fn, this.node(), context);
            return this;
          };

          dPrototype.off = function(ev, fn) {
            detachDocumentListener(ev, fn, this.node());
            return this;
          };
        }

        if (API.getLink) {
          dPrototype.links = function(i) {
            return (arguments.length)?getLink(i):getLinks();
          };
        }

        if (API.getAnchor) {
          dPrototype.anchors = function(i) {
            return (arguments.length)?getAnchor(i):getAnchors();
          };
        }

        if (API.getDocumentHtml) {
          dPrototype.html = function(bXhtml) {
            return getDocumentHtml(bXhtml, false, this.node());
          };
        }

        if (typeof attachDocumentReadyListener == 'function') {
          dPrototype.onReady = function(fn) {
            attachDocumentReadyListener(fn, this.node());
            return this;
          };

          attachDocumentReadyListener(function() {
            var m;

            if (typeof getBodyElement == 'function') {
              dPrototype.body = function() {
                return getBodyElement(this.node());
              };
            }

            if (typeof getViewportScrollSize == 'function') {
              dPrototype.scrollSize = function() {
                return getViewportScrollSize(this.node());
              };
            }

            if (typeof getViewportClientRectangle == 'function') {
              dPrototype.clientRectangle = function() {
                return getViewportClientRectangle(this.node());
              };
            }

            if (typeof getViewportScrollRectangle == 'function') {
              dPrototype.scrollRectangle = function() {
                return getViewportScrollRectangle(this.node());
              };
            }

            if (typeof getScrollPosition == 'function') {
              dPrototype.getScrollPosition = function() {
                return getScrollPosition(this.node());
              };

              dPrototype.setScrollPosition = function(t, l, isNormalized, options, fnDone) {
                setScrollPosition(t, l, isNormalized, this.node(), options, fnDone);
                return this;
              };

              fn = function(n) {
                return function() {
                  API[n](this.node());
                };
              };

              index = scrollSides.length;
              while (index--) {
                m = 'setScrollPosition' + index;
                if (API[m]) {
                  D.prototype[m] = fn(m);
                }
              }
            }
          });
        }

        // Form
        // First argument can be a string (name), number (index) or form element
        // If first argument is a string or number, optional second argument is a document node

        if (typeof getForm == 'function' && Function.prototype.call) {
          F = function(i, docNode) {
            var el;

            if (this == global) {
              return new F(i, docNode);
            }

            // Custom element/load methods get and set the element

            function element() {
              return el;
            }

            this.load = function(name, docNode) {
              el = typeof name == 'object' ? name : getForm(name, docNode);
              this.element = (el)?element:null;
              return this;
            };

            this.load(i, docNode);
          };

          // Form control

          C = function(i, docNode) {

            // Called without - new - operator

            if (this == global) {
              return new C(i, docNode);
            }

            // Uses stock E element/load methods

            E.call(this, i, docNode);
          };

          inherit(F, E);
          inherit(C, E);

          if (typeof serializeFormUrlencoded == 'function') {
            F.prototype.serialize = function() {
              return serializeFormUrlencoded(this.element());
            };
          }

          if (typeof formChanged == 'function') {
            F.prototype.changed = function() {
              return formChanged(this.element());
            };
          }

          if (typeof submitAjaxForm == 'function') {
            F.prototype.send = function(bJSON, requester) {
              submitAjaxForm(this.element(), bJSON, requester);
              return this;
            };
          }

          F.prototype.controls = function(i) {
            var j, el, a = [], els = this.element().elements;
            if (typeof i == 'undefined') {
              a = [];
              for (j = els.length; j--;) {
                el = els[j];
                if (!(/^fieldset$/i).test(el.tagName)) {
                  a[a.length] = el;
                }
              }
              return a.reverse();
            }
            return els[i];
          };

          C.prototype.getValue = function(bDefault) {
            return inputValue(this.element(), bDefault);
          };

          C.prototype.changed = function() {
            return inputChanged(this.element());
          };

          dPrototype.forms = function(i) {
            return (arguments.length)?getForm(i):getForms();
          };
        }

        // Image

        if (typeof getImage == 'function' && Function.prototype.call) {
          I = function(i, docNode) {
            var el;

            if (this == global) {
              return new I(i, docNode);
            }

            function element() {
              return el;
            }

            this.load = function(name, docNode) {
              el = (typeof name == 'string' || typeof name == 'number')?getImage(name, docNode):name;
              this.element = (el)?element:null;
              return this;
            };

            this.load(i, docNode);
          };

          inherit(I, E);

          if (API.preloadImage) {
            I.loadURI = function(uri) {
              return this.load(clonePreloadedImage(preloadImage(uri)));
            };

            I.loadPreloaded = function(handle) {
              return this.load(clonePreloadedImage(handle));
            };
          }

          if (API.changeImage) {
            I.prototype.change = function(src, options, fnDone) {
              changeImage(this.element(), src, options, fnDone);
              return this;
            };
          }

          dPrototype.images = function(i) {
            return (arguments.length)?getImage(i):getImages();
          };
        }      

        // Window

        W = function(o) {
          var win;

          if (this == global) {
            return new W(o);
          }

          this.load = function(o) {
            win = o || global;
            return this;
          };

          this.load(o);

          this.object = function() {
            return win;
          };
        };

        W.prototype.areFeatures = function() {
          return areObjectFeatures.apply(this, arguments);
        };

        if (typeof attachWindowListener == 'function') {
          W.prototype.on = function(ev, fn, context) {
            attachWindowListener(ev, fn, this.object(), context);
            return this;
          };

          W.prototype.off = function(ev, fn) {
            detachWindowListener(ev, fn, this.object());
            return this;
          };
        }

        if (typeof attachDocumentReadyListener == 'function') {
          attachDocumentReadyListener(function() {
            if (typeof getViewportSize == 'function') {
              W.prototype.viewportSize = function() {
                return getViewportSize(this.object());
              };
            }
          });
        }

        if (typeof setStatus == 'function') {
          W.prototype.setStatus = function(text) {
            setStatus(text, this.object());
            return this;
          };
        }

        if (typeof getEnabledPlugin == 'function') {
          W.prototype.getEnabledPlugin = function(mimeType, title) {
            return getEnabledPlugin(mimeType, title, this.object());
          };
        }

        if (typeof addBookmark == 'function') {
          W.prototype.addBookmark = function(uri, title) {
            addBookmark(uri, title, this.object());
            return this;
          };
        }

        if (typeof addBookmarkCurrent == 'function') {
          W.prototype.addBookmarkCurrent = function() {
            addBookmarkCurrent(this.object());
            return this;
          };
        }

        if (typeof getFrameById == 'function') {
          W.prototype.getFrameById = function(id) {
            return getFrameById(id, this.object());
          };
          W.prototype.getIFrameDocument = function(el) {
            return getIFrameDocument(el, this.object());
          };
        }
      }
    }
  <%End If 'Objects%>
  <%If bQuery Or bObjects Then%>
  }
<%End If%>
  doc = null;
  html = null;
})();
