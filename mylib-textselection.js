// My Library text selection add-on

var global = this, API, D, C;

if (API) {
  API.attachDocumentReadyListener(function() {
    var isHostMethod = API.isHostMethod, isHostObjectProperty = API.isHostObjectProperty, getDocumentWindow = API.getDocumentWindow;
    var getSelection, setSelection, clearSelection, selectionToRange, getControlSelection, setControlSelection, getSelectionText;
    var body, el, doc = global.document;

    if (isHostMethod(global, 'getSelection') && getDocumentWindow) {
      getSelection = function(doc) {
        return getDocumentWindow(doc).getSelection();
      };
    } else if (isHostObjectProperty(global.document, 'selection')) {
      getSelection = function(doc) {
        return (doc || global.document).selection;
      };
    }

    var rangeText = function(range) {
      if (typeof range.text == 'string') {
        return range.text;
      }
      if (isHostMethod(range, 'toString')) {
        return range.toString();
      }
    };

    if (getSelection) {
      getSelectionText = function(selection) {
        if (isHostMethod(selection, 'toString')) {
          return selection.toString();
        }
        var range = selectionToRange(selection);
        if (range) {
          return rangeText(range);
        }
        return '';
      };
      selectionToRange = function(selection) {
        if (isHostMethod(selection, 'getRangeAt')) {
          return selection.rangeCount ? null : selection.getRangeAt(0);
        }
        if (isHostMethod(selection, 'createRange')) {
           return selection.createRange();
        }
        return null;
      };
    }

    if (selectionToRange) {
      clearSelection = function(doc) {
        var range, selection = getSelection(doc);
        if (isHostMethod(selection, 'empty')) {
          selection.empty();
        } else {
          range = selectionToRange(selection);
          if (range && isHostMethod(range, 'collapse')) {
            range.collapse();
          }
        }
      };
    }

    if (clearSelection) {
      API.clearDocumentSelection = function(doc) {
        clearSelection(doc);
      };      
    }

    API.getDocumentSelectionText = function(doc) {
      return getSelectionText(getSelection(doc));
    };

    if (isHostMethod(doc, 'createElement')) {
      el = doc.createElement('input');
      body = API.getBodyElement();
      body.appendChild(el);
      if (typeof el.selectionStart == 'number') {
        getControlSelection = function(el) {
          var start = el.selectionStart, end = el.selectionEnd;
          return [start, end, el.value.substring(start, end)];
        };
        setControlSelection = function(el, start, end) {
          el.selectionStart = start;
          el.selectionEnd = end;
        };
      } else if (selectionToRange) {
        getControlSelection = function(el) {
          var documentRange, elementRange, len, start;

          if (isHostMethod(el, 'focus')) {
            el.focus();
          }
          documentRange = selectionToRange(getSelection());
          if (documentRange) {
            if (isHostMethod(documentRange, 'duplicate')) {
              elementRange = documentRange.duplicate();
              if (el.tagName == 'INPUT') {
                elementRange.expand('textedit');
              } else {
                elementRange.moveToElementText(el);
              }
              len = elementRange.text.length;
              elementRange.setEndPoint('starttostart', documentRange);
              start = len - elementRange.text.length;
              var text = documentRange.text.replace(/\r\n/g, '\n');
              return ([start, start + text.length, text]);
            }
          }
          return null;
        };

        if (isHostMethod(el, 'createTextRange')) {
          setControlSelection = function(el, start, end) {
            var selection, range = el.createTextRange();

            range.collapse();
            range.moveStart('character', start);
            range.moveEnd('character', end - start);
            range.select();
            selection = getControlSelection(el);
            if (selection[0] != start) {
              range.move('character', start - selection[0]);
              range.select();
            }
          };
        }
      }
    }

    body.removeChild(el);

    API.getControlSelection = getControlSelection;
    API.setControlSelection = setControlSelection;

    if (setControlSelection) {
      API.clearControlSelection = function(el) {
        setControlSelection(el, 0, 0);
      };
    }

    if (C && C.prototype) {
      C.prototype.setSelection = function(el, start, end) {
        setSelection(el, start, end);
        return this;
      };
      C.prototype.getSelection = function(el) {
        return getSelection(el);
      };
    }
    if (D && D.prototype) {
      D.prototype.clearSelection = function() {
        clearSelection(this.node());
        return this;
      };
      D.prototype.getSelectionText = function() {
        return getSelectionText(this.node());
      };
    }
    doc = el = null;
  });
}