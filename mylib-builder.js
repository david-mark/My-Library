var global = this;
var dependencies = { array:['every', 'filter', 'foreach', 'map', 'some'], cookie:['crumb'], dom:['query', 'script', 'setattribute', 'stylesheets', 'text', 'collections'], form:['serialize'], query:['dollar', 'objects'], event:['rollover', 'mousewheel', 'mouseposition', 'help', 'dom0', 'dispatch', 'contextclick'], plugin:['audio', 'flash'], image:['preload'], style:['class', 'border', 'margin', 'directx', 'position', 'present', 'show', 'size', 'opacity', 'fx'], fx:['ease'], 'offset':['region'], 'ajax':['requester'], 'setattribute':['import'] };
var combinationDependencies = { adjacent:['offset', 'position', 'size'], drag:['mouseposition', 'position', 'scroll'], overlay:['offset', 'position', 'size'], center:['position', 'viewport'], maximize:['position', 'size', 'viewport'], fullscreen:['position', 'size', 'viewport'], coverdocument:['position', 'size', 'viewport'], scrollfx:['scroll', 'fx'], updater:['requester', 'html'], ajaxform:['dom', 'form', 'requester'], ajaxlink:['dom', 'event', 'requester'], gethtml:['dom', 'html'] };
var updateFields = function() {
  var a, b, el, els, i, j;
  var frm = this.document.forms.builder;
  var allChecked = true;
  var atLeastOneChecked;
  if (frm) {
    els = frm.elements;
    for (j = 0; j < els.length; j++) {
      if (allChecked && els[j].type == 'checkbox' && !els[j].checked && els[j].name != 'ashtml') { allChecked = false; }
      atLeastOneChecked = atLeastOneChecked || (els[j].checked && els[j].name != 'ashtml');
      a = dependencies[els[j].name];
      if (a) {
        i = a.length;
        while (i--) {
          el = els[a[i]];
          if (el) {
            if (els[j].checked && !els[j].className) {
              el.disabled = false;
              el.className = '';
            }
            else {
              el.disabled = true;
              el.className = 'disabled';
            }
            if (el.nextSibling) { // Label
              el.nextSibling.disabled = el.disabled;
              el.nextSibling.className = el.className;
            }
          }
        }
      }
      else {
        a = combinationDependencies[els[j].name];
        if (a) {
          i = a.length;
          b = true;
          while (i--) {
            el = els[a[i]];
            b = b && (el.checked && !el.className);
          }
          if (b) {
            els[j].disabled = false;
            els[j].className = '';
          }
          else {
            els[j].disabled = true;
            els[j].className = 'disabled';
          }
          if (els[j].nextSibling) { // Label
            els[j].nextSibling.disabled = els[j].disabled;
            els[j].nextSibling.className = els[j].className;
          }
        }
      }
    }
    if (els.selectall) { els.selectall.disabled = allChecked; }
    if (els.deselectall) { els.deselectall.disabled = !atLeastOneChecked; }
    if (els.action[2] && els.action[2].id == 'testxhtml' && els.xhtmlsup) {
      els.action[2].disabled = !els.xhtmlsup.checked;
      if (els.ashtml) {
        els.ashtml.disabled = !els.xhtmlsup.checked;
        els.ashtml.className = els.ashtml.disabled ? 'disabled' : '';
        if (els.ashtml.nextSibling) {
          els.ashtml.nextSibling.disabled = els.ashtml.disabled;
          els.ashtml.nextSibling.className = els.ashtml.className;
        }
      }
    }
  }
};

updateFields.toString = function() { return 'updateFields();'; };

this.onload = function() {
  var el, doc;
  var reFeaturedMethod = new RegExp('^(function|object)$', 'i');

  function isRealObjectProperty(o, p) {
    return !!(typeof(o[p]) == 'object' && o[p]);
  }

  function isHostMethod(o, m) {
    var t = typeof(o[m]);
    return !!((reFeaturedMethod.test(t) && o[m]) || t == 'unknown');
  }

  function selectAll(b, frm) {
    var els, i;
    els = frm.elements;
    i = els.length;
    while (i--) {
      if (els[i].type == 'checkbox' && els[i].name != 'ashtml') {
        els[i].checked = b;
      }
    }
    updateFields();
  }

  if (isRealObjectProperty(this, 'document')) {
     doc = this.document;
  }

  if (doc && isHostMethod(doc, 'forms') && isHostMethod(this, 'setTimeout')) {
    var elHelpTopic;
    el = doc.forms.builder;
    if (el) {
      elHelpTopic = el.elements.helptopic;
      el.onclick = function(e) {
        var t;

        e = e || global.event;
        t = e.target || e.srcElement;
        if (t.tagName && t.tagName.toLowerCase() == 'input' && t.type == 'checkbox') {
          elHelpTopic.value = t.name; // Crutch for IE (doesn't bubble focus events)
          global.setTimeout(updateFields, 0); // Mac IE issue
        }        
      };
      el.onfocus = function(e) {
        e = e || global.event;
        var t = e.target || e.srcElement;
        if (t.tagName && t.tagName.toLowerCase() == 'input' && t.type == 'checkbox') {
          if (elHelpTopic) { elHelpTopic.value = t.name; }
        }
      };

      if (el.elements.selectall) {
        el.elements.selectall.onclick = function() {
          selectAll(true, this.form);
        };
      }
      if (el.elements.deselectall) {
        el.elements.deselectall.onclick = function() {
          selectAll(false, this.form);
        };
      }
      global.setTimeout(updateFields, 0); // Opera issue
      el = null;
    }
  }
};
