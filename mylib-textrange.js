/*

  My Library Text Range add-on

  Requires Text Selection add-on

  Usage

    docRange = API.getRange([doc]);
    newRange = API.createRange(startContainer, startOffset, endContainer, endOffset[, doc]);

  NOTE: Experimental (use at your own risk)

*/

var API, D, global = this;

if (API && API.attachDocumentReadyListener) {
  API.attachDocumentReadyListener(function() {

    var isHostMethod = API.isHostMethod, isHostObjectProperty = API.isHostObjectProperty, createElement = API.createElement, getBodyElement = API.getBodyElement, toArray = API.toArray;
    var selectionToRange = API.selectionToHostRange, getSelection = API.getHostSelection, getControlSelection = API.getControlSelection;
    var rangeText = API.getHostRangeText;

    if (selectionToRange && getSelection && getControlSelection) {
      var commonAncestorContainer = function(startContainer, endContainer) {
        var done, elEnd, elStart = startContainer;

        while (!done && elStart) {
          elEnd = endContainer;
          while (elEnd && elStart != elEnd) {
            elEnd = elEnd.parentNode;
          }
          if (elStart == elEnd) {
            if (elStart.nodeType == 3) {
              elStart = elStart.parentNode;
            }
            done = true;
          } else {
            elStart = elStart.parentNode;
          }
        }
        return elStart;
      };

      var endToEnd = 'EndToEnd', startToEnd = 'StartToEnd', startToStart = 'StartToStart', endToStart = 'EndToStart';
      var endPoints = [0, 1, 2, 3];
      var endPointNames = [startToStart, startToEnd, endToEnd, endToStart];

      // Test for bug reported to exist in Safari < 4 (startToEnd, endToStart transposed)

      if (isHostMethod(global.document, 'createRange')) {
        var testRange = global.document.createRange();
        testRange.selectNode(getBodyElement());
        if (testRange.compareBoundaryPoints(1, testRange) == -1) {
          endPoints = [0, 3, 2, 1];
        }
      }

      var findChildIndex = function(node) {
        var i = 0;

        while ((node = node.previousSibling)) {
          i++;
        }
        return i;
      };

      var reTextControl = /^(input|textarea)$/i;

      var isElementTextControl = function(el) {
        return reTextControl.test(el.tagName) && (!el.type || el.type == 'text');
      };

      var isCandidateToFindNodeAndOffset = function(el) {
        if (typeof el.canHaveChildren == 'boolean' && !el.canHaveChildren) {
          return false;
        }
        if (!el.childNodes.length) {
          return false;
        }
        if (el.childNodes.length == 1 && el.childNodes[0].nodeType != 1) {
          return false;
        }
        return true;
      };

      var textNodeOffset = function(start, after, range, rangeTemp, node) {
        var offset;

        // FIXME: see textselection.js (PRE may have issues a la TEXTAREA)

        rangeTemp.setEndPoint(start ? startToStart : endToEnd, range);
        if (after) {
          offset = rangeTemp.text.length;
        } else {
          offset = node.nodeValue.length - rangeTemp.text.length;
        }
        return offset;
      };

      var searchNodes = function(start, elParent, range, rangeTemp, elTemp) {
        var done, index, position, offset, node;

        rangeTemp.collapse(start);

        var nodes = API.toArray(elParent.childNodes), startIndex = 0, endIndex = nodes.length - 1;

        elParent.appendChild(elTemp);

        while (!done && startIndex <= endIndex) {
          index = Math.floor((startIndex + endIndex) / 2);
          elParent.insertBefore(elTemp, nodes[index]);
          rangeTemp.moveToElementText(elTemp);
          position = range.compareEndPoints(start ? startToStart : endToEnd, rangeTemp);

          if (position > 0) {
            startIndex = index + 1;
          } else if (position < 0) {
            endIndex = index - 1;
          } else {
            done = true;
          }
        }

        var prop = (position != -1 || !index) ? 'nextSibling' : 'previousSibling';
        node = elTemp;
        do {
          node = node[prop];
        } while (node && node.nodeType > 4);

        var after = position != -1 || !index;

        if (node.nodeType == 1) {
          offset = findChildIndex(node);
        } else {
          offset = textNodeOffset(start, after, range, rangeTemp, node);
        }
        return {
          node: node,
          offset: offset,
          after: after
        };
      };

      var findNodeAndOffset = function(start, range, doc) {
        var offset = 0;
        var elTemp = createElement('a', doc);
        var node = range.parentElement();

        var rangeTemp = range.duplicate(), result, done;

        if (isElementTextControl(node)) {
          return {
            node: node,
            offset: getControlSelection(node)[start ? 0 : 1]
          };
        }

        // Non-text input

        if (node.tagName.toLowerCase() == 'input') {
          return {
            node:doc || global.document,
            offset:0
          };
        }

        // Check for parentElement method bug in IE < 8 (and Compatibility View)

        if (node.nodeType == 1) {
          rangeTemp.moveToElementText(node);
          if (range.compareEndPoints(startToStart, rangeTemp) == -1 || range.compareEndPoints(endToEnd, rangeTemp) == 1) {
            node = node.parentNode;
          }
        }

        while (!done && node.nodeType == 1 && isCandidateToFindNodeAndOffset(node)) {
          result = searchNodes(start, node, range, rangeTemp, elTemp);
          if (node == result.node) {
            done = true;
          } else {
            node = result.node;
          }
          offset = result.offset;
        }

        var childNodes = node.childNodes;

        // TODO: Optimize this further (first child node)

        if (node.nodeType == 1 && childNodes.length == 1 && (childNodes[0].nodeType == 3 || childNodes[0].nodeType == 4)) {
          if (!result || !result.after) {
            node.appendChild(elTemp);
            node = node.childNodes[0];            
          } else {
            node.insertBefore(elTemp, node.childNodes[0]);
            node = node.childNodes[1];
          }

          // LEGEND element throws in IE

          try {
            rangeTemp.moveToElementText(elTemp);
          } catch(e) {
          }

          offset = textNodeOffset(start, result && result.after, range, rangeTemp, node);
        } else if (node.nodeType == 1) {
          elTemp.parentNode.removeChild(elTemp);
          elTemp = null;
          offset = findChildIndex(node);
          node = node.parentNode;
        }

        if (elTemp) {
          elTemp.parentNode.removeChild(elTemp);
        }

        return {
          node: node,
          offset: offset
        };
      };

      var compareDocumentEndPoints = function(startNodeType, toStartNodeType) {
        if (startNodeType == 9) {
          if (toStartNodeType == 9) {
            return 0;
          }
          return -1;
        }
        return null;
      };

      var Range = function(doc, startContainer, startOffset, endContainer, endOffset) {
        var body, range, that = this, specificRange = typeof startContainer != 'undefined';

        if (!specificRange) {
          range = selectionToRange(getSelection(doc));

          // Check for control range

          if (range && typeof range.length == 'number') {
            for (var i = range.length; i--;) {
              this[i] = range[i];
            }
            return;
          }
        }

        if (!range) {
          if (!doc) {
            doc = global.document;
          }

          // TODO: Check for these methods before creating constructor function
          
          if (isHostMethod(doc, 'createRange')) {
            range = doc.createRange();
          } else {
            body = getBodyElement(doc);

            if (isHostMethod(body, 'createTextRange')) {
              range = body.createTextRange();
            }

            body = null;
          }          
        }

        var isStandard = isHostObjectProperty(range, 'commonAncestorContainer');

        if (!specificRange) {
          if (isStandard) {
            startContainer = range.startContainer;
            endContainer = range.endContainer;
            startOffset = range.startOffset;
            endOffset = range.endOffset;
          } else {
            var start = findNodeAndOffset(true, range, doc);
            var end = findNodeAndOffset(false, range, doc);

            startContainer = start.node;
            startOffset = start.offset;
            endContainer = end.node;
            endOffset = end.offset;
          }
        }

        var update = function() {
          that.startContainer = startContainer;
          that.startOffset = startOffset;
          that.endContainer = endContainer;
          that.endOffset = endOffset;

          if (isStandard) {
            if (specificRange) {
              range.setEnd(endContainer, endOffset);
              range.setStart(startContainer, startOffset);
            }
            that.commonAncestorContainer = range.commonAncestorContainer;
          } else {
            if (specificRange) {
              var elParent, elTemp = createElement('a', doc);
              var rangeEnd = range.duplicate();
              var rangeTemp = range.duplicate();

              // TODO: Move this up

              var insertAndSelectTemp = function(range, start) {
                elParent.insertBefore(elTemp, start ? startContainer : endContainer);
                rangeTemp.moveToElementText(elTemp);
                range.setEndPoint(startToStart, rangeTemp);
                elParent.removeChild(elTemp);
              };

              if (startContainer.nodeType == 1) {
                range.moveToElementText(startContainer.childNodes[startOffset]);
              } else {
                elParent = startContainer.parentNode;

                // TODO: Need try-catch for LEGEND

                if (elParent) {
                  range.moveToElementText(elParent);
                  insertAndSelectTemp(range, true);               

                  // May be a problem with PRE here

                  range.moveStart('character', startOffset);
                }
              }

              if (endContainer.nodeType == 1) {
                rangeEnd.moveToElementText(endContainer.childNodes[endOffset]);
              } else {
                elParent = endContainer.parentNode;
                if (elParent) {
                  rangeEnd.moveToElementText(endContainer.parentNode);
                  insertAndSelectTemp(rangeEnd);

                  rangeEnd.moveStart('character', endOffset);
                }
              }

              range.setEndPoint(endToStart, rangeEnd);
              elTemp = rangeEnd = rangeTemp = null;
            }
            if (startContainer == endContainer) {
              that.commonAncestorContainer = startContainer;
            } else {
              that.commonAncestorContainer = commonAncestorContainer(startContainer, endContainer) || doc;
            }
          }
          that.collapsed = that.startContainer == that.endContainer && that.startOffset == that.endOffset;
        };

        if (isHostMethod(range, 'select')) {
          this.select = function() {
            return range.select();
          };
        } else {
          var selection = getSelection(doc);

          if (isHostMethod(selection, 'addRange')) {
            this.select = function() {
              var selection = getSelection(this.getDocument());
              selection.removeAllRanges();
              selection.addRange(range);
            };
          }

          selection = null;
        }

        if (isHostMethod(range, 'isPointInRange')) {
          this.isPointInRange = function(node, offset) {
            return range.isPointInRange(node, offset);
          };
        } else if (isHostMethod(range, 'inRange')) {
          this.isPointInRange = function(node, offset) {
            return range.inRange(new Range(doc, node, offset, node, node.nodeValue.length).getHostRange());
          };
        }

        this.cloneRange = function() {
          return new Range(doc, this.startContainer, this.startOffset, this.endContainer, this.endOffset);
        };

        var selectNodeContentsFactory = function(methodName) {
          return function(el) {
            specificRange = false;
            range[methodName](el);
            startContainer = endContainer = el;
            startOffset = endOffset = findChildIndex(el);
            update();
          };
        };

        if (isHostMethod(range, 'selectNodeContents')) {
          this.selectNodeContents = selectNodeContentsFactory('selectNodeContents');
        } else if (isHostMethod(range, 'moveToElementText')) {
          this.selectNodeContents = selectNodeContentsFactory('moveToElementText');
        }

        if (isHostMethod(range, 'compareBoundaryPoints')) {
          this.compareBoundaryPoints = function(how, toRange) {
            return range.compareBoundaryPoints(endPoints[how], toRange.getHostRange());
          };
        } else if (isHostMethod(range, 'compareEndPoints')) {
          this.compareBoundaryPoints = function(how, toRange) {

            var startNodeType = startContainer.nodeType;
            var endNodeType = endContainer.nodeType;
            var toStartNodeType = toRange.startContainer.nodeType;
            var toEndNodeType = toRange.endContainer.nodeType;

            var result = null;

            switch(how) {
            case 0:
              result = compareDocumentEndPoints(startNodeType, toStartNodeType);
              break;
            case 2:
              result = compareDocumentEndPoints(endNodeType, toEndNodeType);
              break;
            case 1:
              if (startNodeType == 9) {
                if (toEndNodeType == 9) {
                  return 0;
                }
                result = -1;
              }
              if (toStartNodeType == 9) {
                if (endNodeType == 9) {
                  return 0;
                }
                result = 1;
              }
              break;
            case 3:
              if (endNodeType == 9) {
                if (toStartNodeType == 9) {
                  return 0;
                }
                result = -1;
              }
              if (toEndNodeType == 9) {
                if (startNodeType == 9) {
                  return 0;
                }
                result = 1;
              }              
            }
            
            return result === null ? range.compareEndPoints(endPointNames[how], toRange.getHostRange()) : result;
          };
        }

        if (isHostMethod(range, 'detach')) {
          this.detach = function() {
            range.detach();
            range = null;
          }; 
        } else {
          this.detach = function() {
            range = null;
          };
        }

        this.setStart = function(node, offset) {
          startContainer = this.startContainer = node;
          startOffset = this.startOffset = offset;
          specificRange = true;
          update();
        };

        this.setEnd = function(node, offset) {
          endContainer = this.endContainer = node;
          endOffset = this.endOffset = offset;
          specificRange = true;
          update();
        };

        if (isHostMethod(range, 'insertNode')) {
          this.insertNode = function(node) {
            range.insertNode(node);
            startContainer = node;
            startOffset = findChildIndex(node);
            update();
          };
        } else {
          this.insertNode = function(node) {
            var elParent;

            if (startContainer.nodeType == 1) {
              startContainer.insertBefore(node, startContainer.childNodes[startOffset]);
              this.setStart(node, 0);
            } else {
              var nodeClone = startContainer.cloneNode(false);
              var text = startContainer.nodeValue;

              elParent = startContainer.parentNode;

              startContainer.nodeValue = text.slice(startOffset);
              nodeClone.nodeValue = text.substring(0, startOffset);

              elParent.insertBefore(nodeClone, startContainer);
              elParent.insertBefore(node, startContainer);

              var oldStartContainer = startContainer;
              var oldStartOffset = startOffset;

              if (node.nodeType != 1) {
                this.setStart(node, 0);
              } else {
                this.setStart(node.parentNode, findChildIndex(node));
              }

              if (oldStartContainer == endContainer) {
                this.setEnd(oldStartContainer, endOffset - oldStartOffset);
              }
            }
          };
        }

        this.getHostRange = function() {
          return range;
        };

        this.getDocument = function() {
          return doc || global.document;
        };

        update();
      };

      Range.prototype.START_TO_START = 0;
      Range.prototype.START_TO_END = 1;
      Range.prototype.END_TO_END = 2;
      Range.prototype.END_TO_START = 3;

      Range.prototype.collapse = function(toStart) {
        if (toStart) {
          this.setEnd(this.startContainer, this.startOffset);
        } else {
          this.setStart(this.endContainer, this.endOffset);
        }
      };

      Range.prototype.toString = function() {
        return rangeText(this.getHostRange());
      };

	var getSelectedControls, getRange, createRange;

      getRange = API.getRange = function(doc) {
        var range = new Range(doc);

        // Return text range only

        return (typeof range.length == 'number') ? null : range;
      };

      getSelectedControls = API.getSelectedControls = function(doc) {
        var range = new Range(doc);

        // Return control range only

        if (typeof range.length == 'number') {
          return toArray(range);
        }
        return null;
      };

      var getElementDocument = API.getElementDocument;

      createRange = API.createRange = function(startContainer, startOffset, endContainer, endOffset, doc) {
        if (!doc) {
          doc = getElementDocument(startContainer);
        }

        return new Range(doc, startContainer, startOffset, endContainer, endOffset);
      };

      if (D && D.prototype) {
        D.prototype.getRange = function() {
          return getRange(this.node());
        };

        D.prototype.getSelectedControls = function() {
          return getSelectedControls(this.node());
        };

        D.prototype.createRange = function(startContainer, startOffset, endContainer, endOffset) {
          return createRange(startContainer, startOffset, endContainer, endOffset, this.node());
        };
	}
    }
  });
}