// Enables slide and clip effects
// Not included in main script as conditional compilation fouls up minification

if (this.API && typeof this.API == 'object') {
	this.API.unclipElement = function(el) {
		/*@cc_on 
		el.style.clip = 'rect(auto auto auto auto)';
		return;
		@cc_off @*/
		el.style.clip = 'auto';
	};
}

// Enables fixed positioning
// Not included in main script as conditional compilation fouls up minification
// Requires Offset, Position, Scroll and Event modules

var global = this;

if (this.API && typeof this.API == 'object' && this.API.attachDocumentReadyListener && this.API.attachWindowListener && this.API.canAdjustStyle && this.API.canAdjustStyle('position') && this.API.getDocumentWindow) {
	this.API.attachDocumentReadyListener(function() {
		var api = global.API;
		var attachWindowListener = api.attachWindowListener;
		var detachWindowListener = api.detachWindowListener;
		var absoluteElement = api.absoluteElement;
		var elementUniqueId = api.elementUniqueId;
		var getElementMarginsOrigin = api.getElementMarginsOrigin;
		var getElementPosition = api.getElementPosition;
		var getElementPositionStyle = api.getElementPositionStyle;
		var getPositionedParent = api.getPositionedParent;
		var getScrollPosition = api.getScrollPosition;
		var getStyle = api.getStyle;
		var htmlToViewportOrigin = api.htmlToViewportOrigin;
		var positionElement = api.positionElement;
		var viewportToHTMLOrigin = api.viewportToHTMLOrigin;
		var getElementDocument = api.getElementDocument;
		var getDocumentWindow = api.getDocumentWindow;
		var deltaY, deltaX, deltaScrollX, deltaScrollY, margins, posComp;
		var elementsFixed = {}, timeouts = {}, eventCounters = {};

		if (absoluteElement && getScrollPosition && positionElement) {
			api.fixElement = function(el, b, options, fnDone) {
				if (typeof b == 'undefined') {
					b = true;
				}
				options = options || {};
				var pos, y, x;
				var docNode = getElementDocument(el);
				var sp = getScrollPosition(docNode);
				var win = getDocumentWindow(docNode);
				var uid = elementUniqueId(el);
				var o = elementsFixed[uid];
				var bRevert = options.revert;
				var bWasFixed, fn, fnPos;

				if (!b) {
					if (!o) { // Not fixed yet
						return false;
					}

					pos = o.pos;

					deltaX = el.offsetLeft - o.offsetLeftFixed;
					deltaY = el.offsetTop - o.offsetTopFixed;

					if (o.sp) {
						sp = getScrollPosition(docNode);
						deltaScrollY = sp[0] - o.sp[0];
						deltaScrollX = sp[1] - o.sp[1];
					}

					bWasFixed = el.style.position == 'fixed';

					el.style.position = o.position;

					if (win && o.ev) {
						detachWindowListener('scroll', o.ev, win);
					}
					posComp = o.posComp;
					if (bRevert || !posComp || posComp == 'static') {
						el.style.left = o.left;
						el.style.top = o.top;
					}
					else {						
						switch(posComp) {
						case 'relative':
							if (o.pos && typeof deltaY == 'number') {
								o.pos[0] += deltaY; o.pos[1] += deltaX;
							}
							if (typeof deltaScrollY == 'number' && bWasFixed) {
								o.pos[0] += deltaScrollY; o.pos[1] += deltaScrollX;
							}
							pos = o.pos;
							break;
						case 'absolute':
							if (o.pos && typeof deltaY == 'number') {
								o.pos[0] += deltaY; o.pos[1] += deltaX;
								pos = o.pos;
								if (typeof deltaScrollY == 'number' && bWasFixed) {
									o.pos[0] += deltaScrollY; o.pos[1] += deltaScrollX;
								}
							}
							else {
								pos = getElementPositionStyle(el);
								if (htmlToViewportOrigin && o.viewportAdjust) { pos = htmlToViewportOrigin(pos, docNode); }
							}
						}
						positionElement(el, pos[0], pos[1]);
					}
					elementsFixed[uid] = null;
					return true;
				}

				if (o) { // Already fixed
					return false;
				}

				posComp = getStyle(el, 'position');

				margins = getElementMarginsOrigin ? getElementMarginsOrigin(el) : [0, 0];

				o = { position:el.style.position, left:el.style.left, top:el.style.top, posComp:posComp, offsetLeft:el.offsetLeft, offsetTop:el.offsetTop, pos:getElementPositionStyle(el), sp:getScrollPosition(docNode) };

				if (getPositionedParent(el)) {
					pos = getElementPosition(el);
					pos[0] -= margins[0];
					pos[1] -= margins[1];
				}
				else {
					switch(posComp) {
					case 'relative':
						pos = getElementPosition(el);
						pos[0] -= margins[0];
						pos[1] -= margins[1];
						break;
					case 'absolute':
						pos = getElementPositionStyle(el);
						break;
					default:
						absoluteElement(el);
						pos = getElementPositionStyle(el);
					}
				}

				y = pos[0];
				x = pos[1];

				var oldPos = [y, x];

				/*@cc_on @*/
				/*@if (@_jscript_version >= 5.7)
				try {
					el.style.position = 'fixed';
					if (el.currentStyle && el.currentStyle.position != 'fixed') throw(0);
					positionElement(el, y - sp[0], x - sp[1]);

					o.offsetLeftFixed = el.offsetLeft;
					o.offsetTopFixed = el.offsetTop;
					elementsFixed[uid] = o;

					return true;
				}
				catch(e) {
					if (!e) {
						el.style.position = '';
						el.style.position = 'absolute';
					}			
				}
				@else
				el.style.position = 'absolute'
				@end
				if (win) {
					y -= sp[0];
					x -= sp[1];

					fnPos = function() {
						var docNode = getElementDocument(el);
						var sp = getScrollPosition(docNode);

						oldPos = [y + sp[0], x + sp[1]];
						positionElement(el, y + sp[0], x + sp[1], { duration:options.duration, ease:options.ease }, function() { eventCounters[uid]--; });

						if (!positionElement.async) {
							eventCounters[uid]--;
						}
						timeouts[uid] = 0;
					};					


					fn = function() {
						if (!timeouts[uid]) {
							if (!eventCounters[uid]) {
								var pos2 = getElementPositionStyle(el);
								if (pos2[0] != oldPos[0] || pos2[1] != oldPos[1]) {
									y -= (oldPos[0] - pos2[0]);
									x -= (oldPos[1] - pos2[1]);
								}
								eventCounters[uid] = 1;
							}
							else {
		                                                eventCounters[uid]++;
							}
						}
						else {				
							global.clearTimeout(timeouts[uid]);
						}
						
						timeouts[uid] = global.setTimeout(fnPos, options.scrollTimeout || 100);
					};

					o.ev = fn;

					attachWindowListener('scroll', fn, win);
					win = null;

					positionElement(el, y + sp[0], x + sp[1]);

					elementsFixed[uid] = o;
					o.offsetLeftFixed = el.offsetLeft;
					o.offsetTopFixed = el.offsetTop;
					return true;
				}
				return false;
				@*/
				if (el.style.position != 'fixed') {
					el.style.position = 'fixed';
					if (viewportToHTMLOrigin) {
						pos = viewportToHTMLOrigin(pos, docNode);
						o.viewportAdjust = true;
					}
					positionElement(el, pos[0] - sp[0], pos[1] - sp[1]);

					elementsFixed[uid] = o;
					o.offsetLeftFixed = el.offsetLeft;
					o.offsetTopFixed = el.offsetTop;

					return true;
				}
				return false;
			};
		}
		api = null;
	});
}

/* My Library Transform add-on
   Requires Map, For Each and DOM modules
   Includes additional enhancements to FX and Wrapper Object modules */

// TODO: IE toFixed bug a factor?

var API, E, Q;

if (API && API.getAnElement && API.map) {
(function() {

  // TODO: Move this bit to the core and memorize results

  var getAnElement = API.getAnElement;
  var html = getAnElement();

  var findProprietaryStyle = function(style, el) {
    if (!el) { el = getAnElement(); }
    if (el && typeof el.style[style] != 'string') {
      style = style.charAt(0).toUpperCase() + style.substring(1);
      var prefixes = ['Moz', 'O', 'Khtml', 'Webkit', 'Ms'];
      for (var i = prefixes.length; i--;) {
        if (typeof el.style[prefixes[i] + style] != 'undefined') {
          return prefixes[i] + style;
        }
      }
      return null;
    }
    return style;
  };

  API.findProprietaryStyle = findProprietaryStyle;

  var elementUniqueId = API.elementUniqueId, isHostObjectProperty = API.isHostObjectProperty, map = API.map, forEach = API.forEach;
  var transformStyle = findProprietaryStyle('transform', html), transformOriginStyle = transformStyle + 'Origin';
  var getTransformMatrix, setTransformMatrix, getTransformOrigin, setTransformOrigin, defaultMatrix = [1, 0, 0, 1], transformStyleWriteOnly;
  var elementMatrices = {}, elementOrigins = {};
  var reMatrix = /progid:DXImageTransform.Microsoft.Matrix\s*\([^\)]+\)/, rePercent = /%$/;
  var processTransform, setTransform;

  var pi = Math.PI;

  var toRadians = function(degrees) {
    return degrees * pi / 180;
  };

  var matrixMultiply = function(matrix1, matrix2) {
    return [
      matrix1[0] * matrix2[0] + matrix1[1] * matrix2[2],
      matrix1[0] * matrix2[1] + matrix1[1] * matrix2[3],
      matrix1[2] * matrix2[0] + matrix1[3] * matrix2[2],
      matrix1[2] * matrix2[1] + matrix1[3] * matrix2[3]
    ];
  };

  var matrixFactories = {
    skew: function(degrees) {
      return [1, Math.tan(toRadians(degrees)), Math.tan(toRadians(degrees)), 1];
    },
    skewX: function(degrees) {
      return [1, 0, Math.tan(toRadians(degrees)), 1];
    },
    skewY: function(degrees) {
      return [1, Math.tan(toRadians(degrees)), 0, 1];
    },
    rotate: function(degrees) {
      var r = toRadians(degrees);
      return [Math.cos(r), Math.sin(r), -Math.sin(r), Math.cos(r)];
    },
    scale: function(scale) {
      return [scale, 0, 0, scale];
    },
    scaleX: function(scale) {
      return [scale, 0, 0, 1];
    },
    scaleY: function(scale) {
      return [1, 0, 0, scale];
    },
    flip: function(scale) {
      return [-1, 0, 0, -1];
    },
    flipH: function(scale) {
      return [-1, 0, 0, 1];
    },
    flipV: function(scale) {
      return [1, 0, 0, -1];
    }
  };

  if (transformStyle) {
    if (html && typeof html.style[transformStyle] == 'string') {
      transformStyleWriteOnly = (function() {
        var el = API.createElement('div');
        el.style[transformStyle] = 'matrix(1,0,0,1,0,0)';
        return !el.style[transformStyle];
      });
    }

    getTransformMatrix = function(el) {
      var match, matrix, invalid, transform = el.style[transformStyle];
      if (typeof transform == 'string') {
        if (transformStyleWriteOnly && (matrix = elementMatrices[elementUniqueId(el)])) {
          return matrix;
        }
        match = transform.match(/matrix\(([\.\d]+),([\.\d]+),([\.\d]+),([\.\d]+),([\.\d]+,)?([\.\d]+)?\)/i);
        if (match) {
          return map(match.slice(1, 5), function(i) {
            return +i;
          });
        }
      } else if (transform && API.isHostMethod(transform, 'getCSSMatrix')) {
        try {
          matrix = transform.getCSSMatrix();
        } catch(e) {
        }
        if (matrix) {
          forEach(['a', 'b', 'c', 'd'], function(i) {
            if (isNaN(matrix[i])) {
              invalid = true;
            }
          });
          if (!invalid) {
            return [matrix.a, matrix.b, matrix.c, matrix.d];
          }
        }
      }
      return defaultMatrix.slice(0);
    };

    setTransformMatrix = function(el, matrix) {
      if (transformStyleWriteOnly) {
        elementMatrices[elementUniqueId(el)] = matrix;
      }
      el.style[transformStyle] = ['matrix(', matrix[0].toFixed(8), ',', matrix[1].toFixed(8), ',', matrix[2].toFixed(8), ',', matrix[3].toFixed(8), ',0,0)'].join('');
    };

    setTransformOrigin = function(el, origin) {
      elementOrigins[elementUniqueId(el)] = origin;
      el.style[transformOriginStyle] = origin.reverse().join(' ');
    };

    getTransformOrigin = function(el, x, y) {
      return elementOrigins[elementUniqueId(el)] || ['50%', '50%'];
    };
  } else if (html && isHostObjectProperty(html, 'filters') && isHostObjectProperty(html, 'style') && typeof html.style.filter == 'string') {
    getTransformMatrix = function(el) {
      var filter = el.filters['DXImageTransform.Microsoft.Matrix'];
      if (filter) {
        return [filter.M11, filter.M21, filter.m12, filter.m22];
      }
      return defaultMatrix.slice(0);
    };

    setTransformMatrix = function(el, matrix, preprocessed) {
      var transform = ['progid:DXImageTransform.Microsoft.Matrix(M11=', matrix[0].toFixed(8), ',', 'M12=', matrix[2].toFixed(8), ',', 'M21=', matrix[1].toFixed(8), ',', 'M22=', matrix[3].toFixed(8), ",sizingMethod='auto expand'", ')'].join('');

      if (!preprocessed && el.currentStyle && !el.currentStyle.hasLayout) {
        el.style.zoom = '1';
      }
      var filter = el.style.filter;
      if (!filter) {
        el.style.filter = transform;
      } else if (reMatrix.test(filter)) {
        el.style.filter = filter.replace(reMatrix, transform);
      } else {
        el.style.filter += ' ' + transform;
      }
    };
  }

  if (setTransformMatrix) {
    setTransform = function(el, transform) {
      setTransformMatrix(el, processTransform(transform));
    };

    API.setElementTransformMatrix = function(el, matrix) {
      setTransformMatrix(el, matrix);
    };

    API.getElementTransformMatrix = function(el, matrix) {
      return getTransformMatrix(el);
    };

    processTransform = function(transform) {
      var matrix = defaultMatrix.slice(0), factory;

      for (var i in transform) {
        if (API.isOwnProperty(transform, i) && (factory = matrixFactories[i])) {
          matrix = matrixMultiply(matrix, factory(transform[i]));
        }
      }
      return matrix;
    };

    API.setElementTransform = setTransform;

    if (setTransformOrigin) {
      API.getElementTransformOrigin = function(el) {
        return getTransformOrigin(el);
      };

      API.setElementTransformOrigin = function(el, origin) {
        setTransformOrigin(el, origin);
      };
    }

    API.attachDocumentReadyListener(function() {
    var oldSetTransform, oldSetTransformMatrix, oldSetTransformOrigin, transformEffect, transformMatrixEffect;

    var transformerFactory = function(name, fn) {
      var activeEffects = {}, cb = {}, namedEffect = API.effects['transform' + name];

      return function(el, arg, options, fnDone) {
        var pt, uid, effect, fnDoneInternal = function() {
          activeEffects[uid] = null;
          if (cb[uid]) { cb[uid](el); }
        };
        if (options && options.duration) {
          uid = elementUniqueId(el);
          if (activeEffects[uid]) {
            activeEffects[uid].stop(true);
          }
          effect = new API.EffectTimer();
          options.effects = namedEffect;
          pt = options.effectParams || {};
          pt['target' + (name || 'Transform')] = arg;
          options.effectParams = pt;
          cb[elementUniqueId(el)] = fnDone;
          activeEffects[uid] = effect;
          effect.start(el, options, fnDoneInternal);
        } else {
          fn(el, arg);
          if (fnDone) { fnDone(el); }
        }			
      };
    };

    if (API.effects) {
      transformEffect = API.effects.transform = (function() {
        var i, transform, targetTransform, operation;
        return function(el, p, scratch, endCode) {
          if (endCode == 1) {
            if (scratch.transform) {
              scratch.matrix = processTransform(scratch.transform);
            } else if (!scratch.targetTransform) {
              transform = {};
              targetTransform = {};
              for (i = scratch.transformOperations.length; i--;) {
                operation = scratch.transformOperations[i];
                switch(operation) {
                case 'flip':
                case 'flipH':
                case 'flipV':
                  transform[operation] = true;
                  break;
                case 'scale':
                case 'scaleX':
                case 'scaleY':
                  transform[operation] = 0;
                  targetTransform[operation] = 1;
                  break;
                case 'rotate':
                  transform.rotate = 90;
                  targetTransform.rotate = 0;
                  break;
                case 'skew':
                case 'skewX':
                case 'skewY':
                  transform[operation] = 45;
                  targetTransform[operation] = 0;
                }
              }
              scratch.matrix = processTransform(transform);
              scratch.targetTransform = targetTransform;
            } else {
              scratch.matrix = getTransformMatrix(el);
            }
            scratch.targetMatrix = processTransform(scratch.targetTransform);
          }
          transformMatrixEffect(el, p, scratch, endCode);
        };
      })();

      API.effects.transformOrigin = (function() {
        var sourceOrigin, targetOrigin, test, testTarget;

        return function(el, p, scratch, endCode) {
          switch(endCode) {
          case 1:
            sourceOrigin = scratch.origin || getTransformOrigin(el);
            targetOrigin = scratch.targetOrigin;
            test = rePercent.test(sourceOrigin[0]);
            testTarget = rePercent.test(targetOrigin[0]);
            if (test && testTarget || !test && !testTarget) {
              sourceOrigin[0] = parseFloat(sourceOrigin[0]);
              targetOrigin[0] = parseFloat(targetOrigin[0]);
              scratch.originXPercent = test;
              test = rePercent.test(sourceOrigin[1]);
              testTarget = rePercent.test(targetOrigin[1]);
              if (test && testTarget || !test && !testTarget) {
                sourceOrigin[1] = parseFloat(sourceOrigin[1]);
                targetOrigin[1] = parseFloat(targetOrigin[1]);
                scratch.originYPercent = test;
                scratch.sourceOrigin = sourceOrigin;
                scratch.targetOrigin = targetOrigin;
              }
            }
            el.style.visibility = 'visible';
            break;
          case 3:
            oldSetTransformOrigin(el, scratch.origin);
            return;
          }
          targetOrigin = scratch.targetOrigin;
          if (scratch.sourceOrigin) {
            sourceOrigin = scratch.sourceOrigin;
            oldSetTransformOrigin(el, [(sourceOrigin[0] + (targetOrigin[0] - sourceOrigin[0]) * p) + (scratch.originXPercent ? '%' : ''), (sourceOrigin[1] + (targetOrigin[1] - sourceOrigin[1]) * p) + (scratch.originXPercent ? '%' : '')]);
          } else {
            oldSetTransformOrigin(el, [targetOrigin[0], targetOrigin[1]]);
          }
        };
      })();

      transformMatrixEffect = API.effects.transformMatrix = (function() {
        var i, matrix, sourceMatrix, targetMatrix;

        return function(el, p, scratch, endCode) {
          switch(endCode) {
          case 1:
              if (!scratch.matrix) {
                scratch.matrix = getTransformMatrix(el);
              }
              el.style.visibility = 'visible';
              break;
          case 3:
              oldSetTransformMatrix(el, scratch.targetMatrix, true);
              return;
          }
          matrix = [];
          sourceMatrix = scratch.matrix;
          targetMatrix = scratch.targetMatrix;

          for (i = 4; i--;) {
            matrix[i] = (sourceMatrix[i] + (targetMatrix[i] - sourceMatrix[i]) * p);
          }

          oldSetTransformMatrix(el, matrix, true);
        };
      })();

      oldSetTransformMatrix = setTransformMatrix;
      API.setElementTransformMatrix = setTransformMatrix = transformerFactory('Matrix', setTransformMatrix);
      setTransformMatrix.async = true;

      oldSetTransform = setTransform;
      API.setElementTransform = setTransform = transformerFactory('', setTransform);
      setTransform.async = true;

      if (setTransformOrigin) {
        oldSetTransformOrigin = setTransformOrigin;
        API.setElementTransformOrigin = setTransformOrigin = transformerFactory('Origin', setTransformOrigin);
        setTransformOrigin.async = true;
      }

      var flipEffect = function(el, p, scratch, endCode) {
        if (endCode == 1) {
          switch (scratch.axes) {
          case 1:
            scratch.transformOperations = ['flipV'];
            break;
          case 2:
            scratch.transformOperations = ['flipH'];
            break;
          default:
            scratch.transformOperations = ['flip'];
          }
        }
        transformEffect(el, p, scratch, endCode);
      };

      API.effects.flip = flipEffect;

      API.effects.flipH = function(el, p, scratch, endCode) {
        if (endCode == 1) {
          scratch.axes = 2;
        }
        flipEffect(el, p, scratch, endCode);
      };

      API.effects.flipV = function(el, p, scratch, endCode) {
        if (endCode == 1) {
          scratch.axes = 1;
        }
        flipEffect(el, p, scratch, endCode);
      };

      var scaleEffect = function(el, p, scratch, endCode) {
        if (endCode == 1) {
          switch (scratch.axes) {
          case 1:
            scratch.transformOperations = ['scaleY'];
            break;
          case 2:
            scratch.transformOperations = ['scaleX'];
            break;
          default:
            scratch.transformOperations = ['scale'];
          }
        }
        transformEffect(el, p, scratch, endCode);
      };

      API.effects.scale = scaleEffect;

      API.effects.scaleX = function(el, p, scratch, endCode) {
        if (endCode == 1) {
          scratch.axes = 2;
        }
        scaleEffect(el, p, scratch, endCode);
      };

      API.effects.scaleY = function(el, p, scratch, endCode) {
        if (endCode == 1) {
          scratch.axes = 1;
        }
        scaleEffect(el, p, scratch, endCode);
      };

      var skewEffect = function(el, p, scratch, endCode) {
        if (endCode == 1) {
          switch (scratch.axes) {
          case 1:
            scratch.transformOperations = ['skewY'];
            break;
          case 2:
            scratch.transformOperations = ['skewX'];
            break;
          default:
            scratch.transformOperations = ['skew'];
          }
        }
        transformEffect(el, p, scratch, endCode);
      };

      API.effects.skew = skewEffect;

      API.effects.skewX = function(el, p, scratch, endCode) {
        if (endCode == 1) {
          scratch.axes = 2;
        }
        skewEffect(el, p, scratch, endCode);
      };

      API.effects.skewY = function(el, p, scratch, endCode) {
        if (endCode == 1) {
          scratch.axes = 1;
        }
        skewEffect(el, p, scratch, endCode);
      };

      API.effects.rotate = function(el, p, scratch, endCode) {
        if (endCode == 1) {
          scratch.transformOperations = ['rotate'];
        }
        transformEffect(el, p, scratch, endCode);
      };

      API.effects.spin = (function() {
        var sourceSpin, targetSpin, rotate = matrixFactories.rotate;
        return function(el, p, scratch, endCode) {
          switch(endCode) {
          case 1:
            scratch.matrix = getTransformMatrix(el);
            if (scratch.spin) {
              scratch.matrix = matrixMultiply(scratch.matrix, rotate(scratch.spin));
            } else {
              scratch.spin = 0;
            }
            if (!scratch.targetSpin) {
              scratch.targetSpin = 360;
            }
            el.style.visibility = 'visible';
            break;
          case 3:
            oldSetTransformMatrix(el, scratch.matrix, true);
            return;
          }
          sourceSpin = scratch.spin;
          targetSpin = scratch.targetSpin;
          oldSetTransformMatrix(el, matrixMultiply(scratch.matrix, rotate(sourceSpin + (targetSpin - sourceSpin) * p)), true);
        };
      })();

      var i, transition, revealTransitions = ['flip', 'flipH', 'flipV', 'skew', 'skewX', 'skewY', 'scale', 'scaleX', 'scaleY', 'rotate', 'spin', 'transform'];
      var showElement = API.showElement, effects = API.effects;

      var transitionFactory = function(transition, show) {
          var effect = effects[transition];
          return function(options, fnDone) {
            options.effects = effect;
            showElement(this.element(), show, options, fnDone);
            return this;
          };
      };

      var queryTransitionFactory = function(transition, show) {
          var effect = effects[transition];
          return function(options, fnDone) {
            options.effects = effect;
            this.forEach(function(el) {
              showElement(el, show, options, fnDone);
            });
            return this;
          };
      };

      if (showElement) {
        if (E && E.prototype) {
          for (i = revealTransitions.length; i--;) {
            transition = revealTransitions[i];
            E.prototype[transition + 'In'] = transitionFactory(transition, true);
            E.prototype[transition + 'Out'] = transitionFactory(transition, false);
          }
        }
        if (Q && Q.prototype) {
          for (i = revealTransitions.length; i--;) {
            transition = revealTransitions[i];
            Q.prototype[transition + 'In'] = queryTransitionFactory(transition, true);
            Q.prototype[transition + 'Out'] = queryTransitionFactory(transition, false);
          }
        }
      }
    }
    });

    if (E && E.prototype) {
      E.prototype.setTransform = function(transform, options, fnDone) {
        setTransform(this.element(), transform, options, fnDone);
        return this;
      };

      E.prototype.getTransformMatrix = function() {
        return getTransformMatrix(this.element());
      };

      E.prototype.setTransformMatrix = function(transform, options, fnDone) {
        setTransformMatrix(this.element(), transform, options, fnDone);
        return this;
      };

      if (setTransformOrigin) {
        E.prototype.setTransformOrigin = function(origin, options, fnDone) {
          setTransformOrigin(this.element(), origin, options, fnDone);
          return this;
        };
      }
    }
    if (Q && Q.prototype) {
      Q.prototype.setTransform = function(transform, options, fnDone) {
        this.forEach(function(el) {
          setTransform(el, transform, options, fnDone);
        });
        return this;
      };
      Q.prototype.setTransformMatrix = function(matrix, options, fnDone) {
        this.forEach(function(el) {
          setTransformMatrix(el, matrix, options, fnDone);
        });
        return this;
      };
      if (setTransformOrigin) {
        Q.prototype.setTransformOrigin = function(origin, options, fnDone) {
          this.forEach(function(el) {
            setTransformOrigin(el, origin, options, fnDone);
          });
          return this;
        };
      }
    }
  }

  html = null;
})();
}

/* My Library Widgets add-on
   Enhanced by Set Attribute and/or Style modules and Class modules */

var API, global = this;

if (API) {
	(function() {
		var api = API, setAttribute = api.setAttribute, getAttribute = api.getAttribute, removeAttribute = api.removeAttribute, addClass = api.addClass, removeClass = api.removeClass, hasClass = api.hasClass, elementUniqueId = api.elementUniqueId;
		var setControlState, getControlState, setWaiProperty, getWaiProperty, controlStates = {};
		var setStateFactory, isStateFactory;

		var convertControlState = function(value) {
			if (/^(true|false)$/.test(value)) {
				return value == 'true';
			}
			return value;
		};

		if (setAttribute) {
			api.getControlRole = function(el, role) {
				return getAttribute(el, 'role');
			};

			api.setControlRole = function(el, role) {
				setAttribute(el, 'role', role);
			};

			api.getWaiProperty = getWaiProperty = function(el, name) {
				return getAttribute(el, 'aria-' + name);
			};

			api.setWaiProperty = setWaiProperty = function(el, name, value) {
				setAttribute(el, 'aria-' + name, value);
			};

			setControlState = function(el, name, state) {
				setWaiProperty(el, name, state.toString());
			};

			getControlState = function(el, name) {				
				return convertControlState(getWaiProperty(el, name));
			};

			api.removeWaiProperty = function(el, name) {
				removeAttribute(el, 'aria-' + name);
			};
		} else {			
			setControlState = function(el, name, state) {
				if (!controlStates[name]) {
					controlStates[name] = {};
				}
				controlStates[name][elementUniqueId(el)] = state.toString();
			};
			
			getControlState = function(el, name) {
				if (!controlStates[name]) {
					controlStates[name] = {};
				}
				return convertControlState(controlStates[name][elementUniqueId(el)]);
			};			
		}

		api.setControlState = setControlState;
		api.getControlState = getControlState;

		if (addClass || setControlState) {
			setStateFactory = function(name) {
				var re = new RegExp('\\s+\\(' + name + '\\)');

				return function(el, b) {
					if (typeof b == 'undefined') {
						b = true;
					}
					if (addClass) {
						if (b) {
							addClass(el, name);
						} else {
							removeClass(el, name);
						}
					}
					if (setControlState) {
						setControlState(el, name, b);
					}

					if (typeof el.title == 'string' && el.title) {
						el.title = el.title.replace(re, '');

						if (b) {
							el.title += ' (' + name + ')';
						}
					}
				};
			};

			isStateFactory = function(name) {
				return function(el) {
					if (hasClass) {
						return hasClass(el, name);
					}
					return getControlState(el, name);
				};
			};

			api.disableControl = setStateFactory('disabled');
			api.pressControl = setStateFactory('pressed');
			api.checkControl = setStateFactory('checked');
			api.selectControl = setStateFactory('selected');

			api.isControlDisabled = isStateFactory('disabled');
			api.isControlPressed = isStateFactory('pressed');
			api.isControlChecked = isStateFactory('checked');
			api.isControlSelected = isStateFactory('selected');
		}

		var callInContext;

		if (Function.prototype.call) {
			callInContext = function(fn, o, arg1, arg2, arg3) {
				return fn.call(o, arg1, arg2, arg3);
			};
		} else {
			callInContext = function(fn, o, arg1, arg2, arg3) {
				o._mylibWidgetCallTemp = fn;
				var result = o._mylibWidgetCallTemp(arg1, arg2, arg3);
				delete o._mylibWidgetCallTemp;
				return result;
			};
		}

		api.callInContext = callInContext;

		if (api.attachDocumentReadyListener) {

		api.attachDocumentReadyListener(function() {
			var showControl, api = API;

			var setStyle = api.setStyle, findProprietaryStyle = api.findProprietaryStyle, showElement = api.showElement, transitionStyle, transitionPropertyStyle, transitionDurationStyle, userSelectStyle, makeElementUnselectable;

			if (findProprietaryStyle) {
				userSelectStyle = findProprietaryStyle('userSelect');				
			}

			if (userSelectStyle && setStyle) {
				makeElementUnselectable = function(el, b) {
					if (typeof b == 'undefined') {
						b = true;
					}
					setStyle(el, userSelectStyle, b ? 'none' : '');
				};
			} else if (setAttribute && (typeof global.document.expando == 'undefined' || global.document.expando)) {
				makeElementUnselectable = function(el, b) {
					if (typeof b == 'undefined') {
						b = true;
					}
					setAttribute(el, 'unselectable', b ? 'on' : 'off');
				};
			}

			API.makeElementUnselectable = makeElementUnselectable;

			if (showElement) {
				if (findProprietaryStyle && (transitionStyle = findProprietaryStyle('transition'))) {
					transitionPropertyStyle = transitionStyle + 'Property';
					transitionDurationStyle = transitionStyle + 'Duration';
				
					showControl = function(el, b, options, callback) {
						if (!options) {
							options = {};
						}
						var keyClassName = options.keyClassName;
						var useCSSTransitions = options.useCSSTransitions;
						var onDone = options.ondone || callback;

						if (transitionStyle) {
							if (typeof useCSSTransitions == 'undefined') {
								useCSSTransitions = !!options.effects;
							}
						}
						if (useCSSTransitions) {
							el.style[transitionDurationStyle] = ((options.duration || 0) / 1000) + 's';
						} else {
							//el.style[transitionDurationStyle] = '0s';
							//useCSSTransitions = false;
						}
						if (b || typeof b == 'undefined') {
							el.style.visibility = 'hidden';
						}

						if (addClass) {
							if (useCSSTransitions) {
								removeClass(el, 'animated');
								if (keyClassName) {
									removeClass(el, keyClassName);
								}
								addClass(el, 'animated');
							} else {
								if (hasClass(el, 'animated')) {
									removeClass(el, 'animated');
									if (transitionDurationStyle) {
										el.style[transitionDurationStyle] = '0s';
									}
								}
							}
						}
						if (useCSSTransitions && keyClassName) {
							addClass(el, keyClassName);
						}
						global.setTimeout(function() {
							showElement(el, b, { removeOnHide:true, effects: useCSSTransitions ? null : options.effects, duration:options.duration, ease:options.ease, fps:options.fps, effectParams:options.effectParams }, function() { if (useCSSTransitions && removeClass) { removeClass(el, 'animated'); } if (onDone) { onDone(el, b); } });
							setControlState(el, 'hidden', typeof b != 'undefined' && !b);
							if (onDone && !showElement.async) {
								onDone(el, b);
							}
						}, 1);
						
					};
				} else {
					showControl = function(el, b, options, callback) {
						showElement(el, b, { removeOnHide:true, effects: options.effects, duration:options.duration, ease:options.ease, fps:options.fps, effectParams:options.effectParams }, callback);
						setControlState(el, 'hidden',  typeof b != 'undefined' && !b);
					};
				}
				showControl.async = showElement.async;
			}

			api.showControl = showControl;

			var attachDrag = api.attachDrag, detachDrag = api.detachDrag;

			if (attachDrag) {
				var controlDragStartFactory = function(el, callback, context) {
					return function() {
						if (addClass) {
							addClass(el, 'dragging');
						}
						if (callback) {
							callInContext(callback, context, el);
						}
					};
				};

				var controlDropFactory = function(el, callback, context) {
					return function() {
						if (removeClass) {
							removeClass(el, 'dragging');
						}
						if (callback) {
							callInContext(callback, context, el);
						}
					};
				};

				api.attachDragToControl = function(el, elHandle, options) {
					if (!options) {
						options = {};
					}
					attachDrag(el, elHandle, {
						ghost:false,
						ondragstart:controlDragStartFactory(el, options.ondragstart, options.callbackContext || API),
						ondrop:controlDropFactory(el, options.ondragstart, options.callbackContext || API)
					});
					if (addClass) {
						addClass(elHandle || el, 'draggable');
					}
				};
				api.detachDragFromControl = function(el, elHandle) {
					detachDrag(el, elHandle);
					if (removeClass) {
						removeClass(elHandle || el, 'draggable');
					}
				};
			}
			if (api.setElementText) {
				api.setControlContent = function(el, options) {
					if (API.setElementHtml && options.html) {
						API.setElementHtml(el, options.html);
					} else if (API.setElementNodes && options.nodes) {
						API.setElementNodes(el, options.nodes);
					} else {
						API.setElementText(el, options.text || '');
					}
				};
			}


			if (api.getWorkspaceRectangle && api.positionElement && api.getScrollPosition) {
				api.cornerControl = function(el, corner, options, callback, doc) {
					var top, left, callbackInternal;

					if (!options) {
						options = {};
					}

					// callback argument deprecated--use options.callback

					callback = options.callback || callback;

					if (!doc && API.getElementDocument) {
						doc = API.getElementDocument(el);
						if (!doc) {
							return false;
						}
					}

					var r = API.getWorkspaceRectangle(doc);

					switch(corner) {
					case 'topleft':
						top = r[0];
						left = r[1];
						break;
					case 'topright':
						top = r[0];
						left = r[1] + r[3] - el.offsetWidth;
						break;
					case 'bottomleft':
						top = r[0] + r[2] - el.offsetHeight;
						left = r[1];
						break;
					case 'bottomright':
						top =  r[0] + r[2] - el.offsetHeight;
						left = r[1] + r[3] - el.offsetWidth;
					}

					if (options.offset) {
						top += options.offset[0];
						left += options.offset[1];
					}

					if (el.style.position == 'fixed') {
						var sp = API.getScrollPosition(doc);
						top -= sp[0];
						left -= sp[1];
					}

					if (callback) {
						callbackInternal = function() {
							callInContext(callback, options.callbackContext || API);
						};
					}
					API.positionElement(el, top, left, options, callbackInternal);				

					if (callback && !API.positionElement.async) {
						callbackInternal();
					}
					return [top, left];
				};
			}
			api = null;
		});
		}

		api = null;

	})();
}

var API, global = this;

if (API && API.attachDocumentReadyListener) {
	API.attachDocumentReadyListener(function() {
			var api = API, isOwnProperty = api.isOwnProperty;
			var callbackContext, audioScheme = { 'stop':'audio/beverly_computers.wav', caution:'audio/thunder.wav', info:'audio/bird1.wav', startup:'audio/rooster.wav', shutdown:'audio/crickets.wav', toast:'audio/toast.wav' };
			var playAudio = api.playAudio, preloadAudio = api.preloadAudio, callInContext = api.callInContext;

			if (playAudio && callInContext) {
				api.playEventSound = function(name, duration, callback, extension) {
					if (audioScheme[name]) {
						playAudio(audioScheme[name], 10000, callback, extension, 100);
					}
				};
				api.addEventSound = function(name, filename) {
					audioScheme[name] = filename;
				};
				api.removeEventSound = function(name, filename) {
					delete audioScheme[name];
				};
				api.getAudioEvents = function() {
					var a = [];

					for (var i in audioScheme) {
						if (isOwnProperty(audioScheme, i)) {
							a[a.length] = i;
						}
					}
					return a;
				};
				if (api.preloadAudio) {
					api.preloadAudioScheme = function() {
						for (var i in audioScheme) {
							if (isOwnProperty(audioScheme, i)) {
								preloadAudio(audioScheme[i]);
							}
						}
					};
				}

				var playlist = [], playlistTimer, playlistIndex, playlistStopTimer, playlistPlaying, playlistStarted, playlistTrackStarted, playlistAutoRepeat;
				var onrepeat, onstop, onstart;

				api.loadPlaylist = function() {
					playlist = [];
					playlist.length = arguments.length;
					for (var i = arguments.length; i--;) {
						playlist[i] = arguments[i];
					}
					playlistIndex = 0;
				};

				api.clearPlaylist = function() {
					if (playlistPlaying) {
						API.stopPlaylist();
					}
					playlist = [];
				};

				var playTrack = function(i) {
					global.clearTimeout(playlistTimer);
					playlistStopTimer = 0;
					playlistIndex = i;
// *** Pass extension
					playAudio(playlist[i].source, playlist[i].duration, null, null, 100);
					if (onstart) {
						callInContext(onstart, callbackContext || API, i);
					}
					playlistTimer = global.setTimeout(function() {
						if (!playlistStopTimer) {
							var j = i + 1;
							if (j < playlist.length) {
								playTrack(j);
							} else if (playlistAutoRepeat) {
								if (onrepeat) {
									callInContext(onrepeat, callbackContext || API, i);
								}
								playTrack(0);
							} else {
								if (onstop) {
									callInContext(onstop, callbackContext || API);
								}
								playlistPlaying = false;
							}
						}
					}, playlist[i].duration);
					playlistTrackStarted = new Date().getTime();
					playlistPlaying = true;
				};

				api.playPlaylist = function(options) {
					if (!options) {
						options = {};
					}
					if (playlist.length) {
						if (options) {
							playlistAutoRepeat = options.autoRepeat;
							onstart = options.onstart;
							onstop = options.onstop;
							onrepeat = options.onrepeat;
							callbackContext = options.callbackContext;
							if (options.restart) {
								playlistIndex = 0;
							}
						}
						playTrack(playlistIndex);
						playlistStarted = new Date().getTime();
						return true;
					}
					return false;
				};

				api.stopPlaylist = function(onCurrentEnd) {
					global.clearTimeout(playlistTimer);
					//global.clearTimeout(playlistStopTimer);
					
					if (onCurrentEnd) {
						playlistStopTimer = 1;
					} else {
						API.stopAudio();
						playlistPlaying = false;
						playlistStopTimer = 0;
						if (onstop) {
							callInContext(onstop, callbackContext || API);
						}
					}
				};

				api.isPlaylistStoppingAfterCurrent = function() {
					return !!playlistStopTimer;
				};

				api.getPlaylist = function() {
					return playlist.slice(0);
				};

				api.getPlaylistIndex = function() {
					return playlistIndex;
				};

				api.getPlaylistDuration = function() {
					var i, duration = 0;
					for (i = playlist.length; i--;) {
						duration += playlist[i].duration;
					}
					return duration;
				};

				api.getPlaylistProgress = function() {

				};

				api.getPlaylistTrackDuration = function() {
					return playlist[playlistIndex].duration;
				};

				api.getPlaylistTrackProgress = function() {
					if (playlist.length && playlistPlaying) {
						var duration = playlist[playlistIndex].duration;
						var result = (new Date().getTime() - (playlistTrackStarted || 0)) / duration;
						return Math.min(result, 100);
					}
					return 0;
				};

				api.gotoPlaylistTrackNext = function() {
					if (playlist.length && playlistIndex < playlist.length - 1) {
						playlistIndex++;
						if (playlistPlaying) {
							playTrack(playlistIndex);
						}
						return true;
					}
					return false;
				};

				api.gotoPlaylistTrackPrevious = function() {
					if (playlist.length && playlistIndex) {
						playlistIndex--;
						if (playlistPlaying) {
							playTrack(playlistIndex);
						}
						return true;
					}
					return false;
				};

				api.gotoPlaylistTrackFirst = function() {
					if (playlist.length && playlistIndex) {
						playlistIndex = 0;
						if (playlistPlaying) {
							playTrack(playlistIndex);
						}
						return true;
					}
					return false;
				};

				api.gotoPlaylistTrackLast = function() {
					if (playlist.length && playlistIndex != playlist.length - 1) {
						playlistIndex = playlist.length - 1;
						if (playlistPlaying) {
							playTrack(playlistIndex);
						}
						return true;
					}
					return false;
				};

				api.gotoPlaylistTrack = function(i) {
					if (playlist.length && i > 0 && i <= playlist.length) {
						playlistIndex = i;
						if (playlistPlaying) {
							playTrack(playlistIndex);
						}
						return true;
					}
					return false;
				};
			}
			api = null;
	});
}

/* My Library Alert Widget
   Requires Widgets add-on
   Requires Event, Center, Scroll, Show and Size modules
   Optionally uses DOM, HTML, Class, Cover Document, Drag, Maximize and Full Screen modules and/or the Fix Element extension */

var API, global = this;
if (API && typeof API == 'object' && API.areFeatures && API.areFeatures('attachListener', 'createElement', 'setElementText', 'setControlState')) {
	API.attachDocumentReadyListener(function() {
		var api = API;
		var isHostMethod = api.isHostMethod;
		var canAdjustStyle = api.canAdjustStyle;
		var cancelDefault = api.cancelDefault;
		var createElement = api.createElement;
		var showElement = api.showElement;
		var attachListener = api.attachListener;
		var attachDocumentListener = api.attachDocumentListener;
		var getEventTarget = api.getEventTarget, getEventTargetRelated = api.getEventTargetRelated;
		var getKeyboardKey = api.getKeyboardKey;
		var attachDrag = api.attachDrag, attachDragToControl = api.attachDragToControl;
		var detachDragFromControl = api.detachDragFromControl;
		var centerElement = api.centerElement;
		var coverDocument = api.coverDocument;
                var constrainPositionToViewport = api.constrainPositionToViewport;
		var maximizeElement = api.maximizeElement;
		var restoreElement = api.restoreElement;
		var setElementText = api.setElementText;
		var positionElement = api.positionElement;
		var sizeElement = api.sizeElement;
		var fixElement = api.fixElement;
		var getChildren = api.getChildren;
		var addClass = api.addClass;
		var removeClass = api.removeClass;
		var hasClass = api.hasClass;
		var getElementPositionStyle = api.getElementPositionStyle;
		var getElementSizeStyle = api.getElementSizeStyle;
		var getElementParentElement = api.getElementParentElement;
		var getScrollPosition = api.getScrollPosition;
		var makeElementUnselectable = api.makeElementUnselectable;
		var callInContext = api.callInContext;
		var elCaption, elSizeHandle, elSizeHandleH, elSizeHandleV;
		var elCurtain, el = createElement('div');
		var elLabel = createElement('div');
		var elButton = createElement('input');
		var elFieldset = createElement('fieldset');
		var elFixButton, elIconButton, elMaximizeButton, elMinimizeButton, elCloseButton, elHelpButton, elCancelButton, elNoButton, elApplyButton, elPreviousButton;
		var body = api.getBodyElement();
		var isMaximized, showOptions, dimOptions, curtainOptions, shown;
		var preMinimizedDimensions = {};
		var onhelp, onpositive, onnegative, onindeterminate, onsave, onclose, onhide, oniconclick, onactivate, ondeactivate, onfocus, onblur, ondragstart, ondrop, onmaximize, onminimize, onrestore, onstep, callbackContext;
		var isDirty, isInBackground, isModal, focusAlert, focusTimer, isCaptionButton, presentControls, updateSizeHandle, updateSizeHandles, updateMin, updateMaxCaption, updateMaxButton, updateDrag, update, minimize, maximize, restore, sizable, maximizable, minimizable, decision, showButtons;
		var setRole = api.setControlRole, setProperty = api.setWaiProperty, removeProperty = api.removeWaiProperty, setControlContent = api.setControlContent;
		var disableControl = api.disableControl, isDisabled = api.isControlDisabled, checkControl = api.checkControl, isChecked = api.isControlChecked, showControl = api.showControl;
		var activateAlert, deactivateAlert, attachActivationListeners;
		var updatePreviousNextButtons, playAlertEventSound;
		var step, steps, autoDismissTimer;
		var playEventSound = api.playEventSound, cornerControl = api.cornerControl;

		if (playEventSound) {
			playAlertEventSound = function() {
				var eventSound, duration = showOptions.duration;

				if (!showOptions.effects) {
					duration = 0;
				}

				if (showOptions.className.indexOf('stop') != -1) {
					eventSound = 'stop';
				} else if (showOptions.className.indexOf('caution') != -1) {
					eventSound = 'caution';
				} else if (showOptions.icon !== false) {
					eventSound = 'info';
				}
				if (eventSound) {
					global.setTimeout(function() {
						playEventSound(eventSound);
					}, duration);
				}
			};
		}

		var callback = function(fn, arg1, arg2, arg3) {
			return callInContext(fn, callbackContext || API, arg1, arg2, arg3);
		};

		var captionButtonTitle = function(title, accelerator) {
			return title + (accelerator ? ' [Ctrl+' + accelerator + ']' : '');
		};

		var appendCaptionButton = function(title, accelerator) {
			var elButton = createElement('div'); 
			if (elButton) {
				elButton.title = captionButtonTitle(title, accelerator);
				elButton.className = title.toLowerCase() + ' button captionbutton';

				if (setRole) {
					setRole(elButton, 'button');
				}

				el.appendChild(elButton);
			}
			return elButton;
		};

		var appendCommandButton = function(name, before) {
			var elNewButton = createElement('input');
			if (elNewButton) {
				elNewButton.className = 'commandbutton button';
				elNewButton.type = 'button';
				elNewButton.value = name;
				if (before) {
					elFieldset.insertBefore(elNewButton, elButton);
				} else {
					elFieldset.appendChild(elNewButton);
				}
				if (attachActivationListeners) {
					attachActivationListeners(elNewButton);
				}
			}
			return elNewButton;
		};
		
		if (attachDragToControl) {
			updateDrag = function(b) {
				(b ? detachDragFromControl : attachDragToControl)(el, elCaption, { ondragstart:ondragstart, ondrop:ondrop });
			};
		}

		var fixedCurtain;
	
		var showCurtain = function(b) {
			if (b) {
				elCurtain.style.display = 'block';
				coverDocument(elCurtain);
				if (fixElement && !fixedCurtain) {
					fixElement(elCurtain);
					fixedCurtain = true;
				}
				if (addClass) {

					// TODO: Create ease classes to correspond to stock easing functions

					if (curtainOptions.ease) {
						addClass(elCurtain, 'ease');						
						addClass(elCurtain, 'in');
						removeClass(elCurtain, 'out');
					} else {
						removeClass(elCurtain, 'ease');
					}
				}
				if (addClass) {
					addClass(elCurtain, 'drawn');
				}
				curtainOptions.keyClassName = 'drawn';
				showControl(elCurtain, true, curtainOptions);
			} else {
				if (removeClass) {
					removeClass(elCurtain, 'drawn');
					if (showOptions.ease) {
						removeClass(elCurtain, 'in');
						addClass(elCurtain, 'out');
					}
				}
				showControl(elCurtain, false, curtainOptions);
				//showElement(elCurtain, false, { removeOnHide:true });
				//if (removeClass) {
				//	removeClass(elCurtain, 'animated');
				//}
			}
		};

		updateMaxCaption = function(b) {
			if (elCaption) {
				if (maximizable) {
					elCaption.title = "Double-click to " + (b ? 'restore' : 'maximize');
				} else if (elMinimizeButton) {
					elCaption.title = b ? 'Double-click to restore' : '';	
				}
			}
		};

		updateMaxButton = function(b) {
			if (addClass) {
				if (b) {
					removeClass(elMaximizeButton, 'maximizebutton');
					addClass(elMaximizeButton, 'restorebutton');
				} else {
					removeClass(elMaximizeButton, 'restorebutton');
					addClass(elMaximizeButton, 'maximizebutton');
				}
			}
			elMaximizeButton.title = captionButtonTitle(!b ? 'Maximize' : 'Restore', '.');
			if (isDisabled(elMaximizeButton)) {
				elMaximizeButton.title += ' (disabled)';
			}
		};

		updateMin = function(b) {
			if (elMinimizeButton) {
				disableControl(elMinimizeButton, b);
			}

			if (elMaximizeButton) {
				disableControl(elMaximizeButton, !b && !maximizable);
			}

			if (elMaximizeButton) {
				if (b) {
					updateMaxButton(!isMaximized);
					if (sizable && elCaption) { updateMaxCaption(!isMaximized); }
				} else {
					updateMaxButton(isMaximized);
					if (sizable && elCaption) { updateMaxCaption(isMaximized); }
				}
			}
		};

		updateSizeHandle = function(el, b) {
			el.style.visibility = (b)?'hidden':'';
		};

		updateSizeHandles = function(b) {
			if (elSizeHandle) { updateSizeHandle(elSizeHandle, b); }
			if (elSizeHandleH) { updateSizeHandle(elSizeHandleH, b); }
			if (elSizeHandleV) { updateSizeHandle(elSizeHandleV, b); }
		};

		// Called after maximize/restore

		update = function(b) {
			if (sizable) {
				updateSizeHandles(b);
			}
			if (elCaption) {
				if (sizable) {
					updateMaxCaption(b);
				}
				updateDrag(b);
			}

			if (elMaximizeButton) {
				updateMaxButton(b);
			}

			if (elFixButton) {
				disableControl(elFixButton, b);
			}
		};

		if (maximizeElement) {
			if (hasClass) {
				isCaptionButton = function(el) {
				  return hasClass(el, 'captionbutton');
				};
			} else {
				isCaptionButton = function(el) {
					return el == elMinimizeButton || el == elMaximizeButton || el == elCloseButton || el == elFixButton;
				};
			}

			presentControls = function(b) {
				var i, c, children = getChildren(el);
				i = children.length;

				while (i--) {
					c = children[i];
					if (!isCaptionButton(c) && c != elCaption && c != elIconButton) {
						c.style.display = (b || (c == elFieldset && !showButtons)) ? 'none' : '';
					}
				}
			};

			var minimizeCallback = function() {
				if (focusAlert) {
					global.setTimeout(focusAlert, 10);
				}
			};

			minimize = function(b, bEffects) {				
				if (b) {
					preMinimizedDimensions.pos = getElementPositionStyle(el);
					preMinimizedDimensions.dim = getElementSizeStyle(el);
					if (addClass) {
						removeClass(el, 'maximized');
						addClass(el, 'minimized');
					}
					if (elCaption) {
						updateDrag(false);
					}					
					if (b && onminimize) {
						callback(onminimize, el);
					}
				} else {
					if (!isMaximized) {
						if (elFixButton && isChecked(elFixButton)) {
							if (el.style.position != 'fixed') {
								constrainPositionToViewport(preMinimizedDimensions.pos);
							}
						}
						positionElement(el, preMinimizedDimensions.pos[0], preMinimizedDimensions.pos[1], dimOptions);
						sizeElement(el, preMinimizedDimensions.dim[0], preMinimizedDimensions.dim[1], dimOptions, minimizeCallback);
						if (!sizeElement.async) {
							minimizeCallback();
						}
					}
					if (removeClass) {
						removeClass(el, 'minimized');
					}
					if (elCaption) {
						updateDrag(isMaximized);
					}
				}

				presentControls(b);

				if (!b && isMaximized) {
					restoreElement(el);
					maximize(true);
				}

				if (b) {
					el.style.height = el.style.width = '';
				}
				updateMin(b);
			};

			maximize = function(b) {
				var maximizeCallback = function() {
					if (addClass) {
						(b ? addClass : removeClass)(el, 'maximized');
					}
					if (focusAlert) {
						global.setTimeout(focusAlert, 10);
					}
				};

				(b ? maximizeElement : restoreElement)(el, dimOptions, maximizeCallback);
				update(b);
				if (b && onmaximize) {
					callback(onmaximize, el);
				}
				isMaximized = b;				
				if (!maximizeElement.async) {
					maximizeCallback();
				}
			};

			restore = function() {
				var result;
				if (elMinimizeButton && minimizable && preMinimizedDimensions.dim && isDisabled(elMinimizeButton)) {
					minimize(false);					
					result = true;
				} else if (isMaximized) {
					maximize(false);
					result = true;
				} else {
					result = false;
				}
				if (result && onrestore) {
					callback(onrestore, el);
				}
				return result;
			};
			api.maximizeAlert = function() {
				if (!isMaximized) {
					maximize(true);
					return true;
				}
				return false;
			};
			api.restoreAlert = restore;
			api.minimizeAlert = function() {
				if (elMinimizeButton && minimizable && !isDisabled(elMinimizeButton)) {
					minimize(true);
					return true;
				}
				return false;
			};
		}

		function positiveCallback() {
			return !onpositive || !callback(onpositive, el);
		}

		function negativeCallback() {
			return !onnegative || !callback(onnegative, el);
		}

		function indeterminateCallback() {
			return !onindeterminate || !callback(onindeterminate, el);
		}

		function makeDecision(b) {
			switch(decision) {
			case'confirm':
			case'yesno':
			case'dialog':
				return (b ? positiveCallback : negativeCallback)();
			case'yesnocancel':
				if (typeof b == 'undefined') {
					return indeterminateCallback();
				}
				return (b ? positiveCallback : negativeCallback)();
			}
		}

		function hideAlert() {
			if (elCurtain) {
				showCurtain(false);
			}
			showElement(el, false, showOptions);
		}

		/*
		Return true from onshow/hide to take responsibility for showing/hiding the alert element
		Return false from onclose or onsave to stop the dismissal
		Returns boolean result
		*/

		function dismiss(isSaving) {
			var good, result;

			if (shown) {
				if (isSaving) {
					if (onsave && callback(onsave, el) === false) {
						return false;
					}
					isDirty = false;
				}

				if (onclose && callback(onclose, el) === false) {
					return false;
				}

				if (!onhide) {
					hideAlert();
					good = true;					
				} else {
					result = callback(onhide, el, showOptions, isMaximized);
					if (typeof result == 'undefined') {
						hideAlert();
						good = true;
					} else {
						good = result;
					}
				}
				if (good) {
					shown = false;
				}
				return !shown;				
			}
			return false;
		}

		if (showElement && centerElement && sizeElement && getScrollPosition && el && elButton && elFieldset && elLabel && body && isHostMethod(global, 'setTimeout')) {

			api.dismissAlert = dismiss;

	                api.getAlertElement = function() {
				return el;
			};

			api.isAlertOpen = function() {
				return shown;
			};

			api.isAlertModal = function() {
				return shown && !isModal;
			};

			api.setAlertTitle = function(text) {
				if (elCaption) {
					setElementText(elCaption, text);
				}
			};

			api.deactivateAlert = deactivateAlert = function() {
				if (addClass) {
					addClass(el, 'background');
				}
				if (ondeactivate) {
					callback(ondeactivate, el);
				}
				isInBackground = true;
			};
			api.activateAlert = activateAlert = function() {
				if (removeClass) {
					removeClass(el, 'background');
				}
				if (onactivate) {
					callback(onactivate, el);
				}
				isInBackground = false;
			};

			if (isHostMethod(elButton, 'focus')) {
				attachActivationListeners = function(el) {
					attachListener(el, 'focus', function(e) {
						if (focusTimer) {
							global.clearTimeout(focusTimer);
						}
						var elTarget = getEventTargetRelated(e);
						var elRelated = elTarget;
						while (elTarget && elTarget != elFieldset) {
							elTarget = getElementParentElement(elTarget);
						}
						var doActivate = true;
						if (!elTarget && onfocus) {
							doActivate = callback(onfocus, el, elRelated) !== false;
						}
						if (doActivate) {
							activateAlert();
						} else {
							this.blur();
							return cancelDefault(e);
						}
					});
					attachListener(el, 'blur', function(e) {
						if (!isModal) {
							focusTimer = global.setTimeout(function() {
								var doActivate = true;
								if (onblur) {
									doActivate = callback(onblur, el, getEventTargetRelated(e)) !== false;
								}
								if (doActivate) {
									if (!elMinimizeButton || !minimizable || !isDisabled(elMinimizeButton)) {
										deactivateAlert();
									}
								} else {
									this.focus();
									return cancelDefault(e);
								}
							}, 100);
						}
					});
				};
			}

			if (attachActivationListeners) {
				attachActivationListeners(elButton);
			}

			api.focusAlert = focusAlert = function() {
				if (shown && el.style.visibility == 'visible' && elFieldset.style.display != 'none') {
					elButton.focus();
				}
				activateAlert();
			};

			var blurIfPossible = function(el) {
				if (!el.disabled && el.style.display != 'none') {
					el.blur();
				}
			};

			api.blurAlert = function() {
				if (el.style.visibility == 'visible' && elFieldset.style.display != 'none') {
					elButton.blur();
					if (elCancelButton) {
						blurIfPossible(elCancelButton);
					}
					if (elNoButton) {
						blurIfPossible(elNoButton);
					}
					if (elApplyButton) {
						blurIfPossible(elApplyButton);
					}
					if (elPreviousButton) {
						blurIfPossible(elPreviousButton);
					}
					if (elHelpButton) {
						blurIfPossible(elHelpButton);
					}
				}
				if (deactivateAlert) {
					deactivateAlert();
				}
			};

			var flashTimer, flashCount;

			if (addClass) {
			api.flashAlert = function(n) {
				if (!n) {
					n = 3;
				}
				if (flashTimer) {
					global.clearInterval(flashTimer);
				}
				flashCount = 0;
				addClass(el, 'background');
				flashTimer = global.setInterval(function() {
					if (flashTimer) {
						flashCount++;
						((flashCount % 2) ? removeClass : addClass)(el, 'background');
						if (flashCount == n * 2 - 1) {
							global.clearInterval(flashTimer);
							flashTimer = 0;
						}
					}
				}, 400);
			};
			}

			attachListener(el, 'click', function(e) {
				var doFocus;
				if (focusTimer) {
					global.clearTimeout(focusTimer);
					focusTimer = null;
				}
				if (isInBackground) {
					activateAlert();
					doFocus = true;
				}
				var elTarget = getEventTarget(e);

				if (doFocus && focusAlert && (elTarget == this || elTarget == elLabel || elTarget == elFieldset || elTarget == elIconButton || elTarget == elCaption || elTarget == elSizeHandle || elTarget == elSizeHandleH || elTarget == elSizeHandleV)) {
					focusAlert();
				}
			});

			api.setAlertDirty = function(b, external) {
				if (decision == 'dialog' && !steps) {
					if (typeof external == 'boolean') {
						elButton.value = b ? 'Close' : 'OK';
						if (elCancelButton) {
							elCancelButton.disabled = b;
						}
					}
					if (elApplyButton) {
						elApplyButton.disabled = !b;
					}
					isDirty = b;
					return true;
				}
				return false;
			};

			api.isAlertModal = function() {
				return shown && isModal;
			};

			if (coverDocument) {
				elCurtain = createElement('div');
				elCurtain.className = 'curtain';
				elCurtain.style.display = 'none';
				elCurtain.style.visibility = 'hidden';
			}


			if (setProperty) {
				elLabel.id = 'mylibalertcontent';			
			}

			if (updateDrag) {
				elCaption = createElement('div');
				if (elCaption) {
					elCaption.className = 'movehandle';
					el.appendChild(elCaption);

					if (makeElementUnselectable) {
						makeElementUnselectable(elCaption);
					}
					
					el.style.position = 'absolute';
					
					updateDrag(false);

					if (maximize) {
						elMaximizeButton = appendCaptionButton('Maximize', '.'); 
						if (elMaximizeButton) {
							attachListener(elMaximizeButton, 'click', function(e) {
								if (maximizable || !isDisabled(this)) {
									if (!restore()) {
										maximize(true);
									}
								}
							});
						}
						attachListener(elCaption, 'dblclick', function(e) {
							if (maximizable || !isDisabled(elMaximizeButton)) {
								if (!restore()) {
									maximize(true);
								}
								return cancelDefault(e);
							}
						});
					}

					elIconButton = createElement('div');
					if (elIconButton) {
						elIconButton.className = 'icon';
						if (setRole) {
							setRole(elIconButton, 'button');
						}
						attachListener(elIconButton, 'dblclick', function() {
							if (!elCloseButton || !isDisabled(elCloseButton)) {
								dismiss(false);
							}
						});
						attachListener(elIconButton, 'click', function() {
							if (oniconclick) {
								callback(oniconclick, el);
							}
						});
						el.appendChild(elIconButton);
					}
					elCloseButton = appendCaptionButton('Close');
					if (elCloseButton) {
						attachListener(elCloseButton, 'click', function() {
							if (!isDisabled(this)) {
								dismiss(false);
							}
						});
					}
					if (getChildren && canAdjustStyle && canAdjustStyle('display') && minimize) {
						elMinimizeButton = appendCaptionButton('Minimize', ',');
						if (elMinimizeButton) {
							attachListener(elMinimizeButton, 'click', function() {
								if (!isDisabled(this)) {
									minimize(true);
								}
							});
						}
					}
					
					if (fixElement) {
						elFixButton = appendCaptionButton('Fix');
						if (elFixButton) {
							checkControl(elFixButton, false);
							attachListener(elFixButton, 'click', function(e) {
								if (!isDisabled(this)) {
									if (!isChecked(this)) {
										checkControl(this);
										if (addClass) {
											addClass(el, 'fixed');
										}
										this.title = 'Detach';
										fixElement(el, true, dimOptions);
									} else {
										checkControl(this, false);
										if (removeClass) {
											removeClass(el, 'fixed');
										}
										this.title = 'Fix';
										fixElement(el, false, dimOptions);
									}
									if (minimizable && elMinimizeButton && isDisabled(elMinimizeButton) && preMinimizedDimensions.pos) {
										preMinimizedDimensions.pos = getElementPositionStyle(el);
									}
									if (focusAlert) {
										global.setTimeout(focusAlert, 10);
									}
								}
							});
						}
					}

					if (sizeElement) {
						elSizeHandleH = createElement('div');
						if (elSizeHandleH) {
							elSizeHandleH.className = 'sizehandleh';
							el.appendChild(elSizeHandleH);
							attachDrag(el, elSizeHandleH, { mode:'size',axes:'horizontal' });
						}
						elSizeHandleV = createElement('div');
						if (elSizeHandleV) {
							elSizeHandleV.className = 'sizehandlev';
							el.appendChild(elSizeHandleV);
							attachDrag(el, elSizeHandleV, { mode:'size',axes:'vertical' });
						}
						elSizeHandle = createElement('div');
						if (elSizeHandle) {
							elSizeHandle.className = 'sizehandle';
							el.appendChild(elSizeHandle);
							attachDrag(el, elSizeHandle, { mode:'size' });
						}
					}
				}
			}

			elLabel.className = 'content';
			el.appendChild(elLabel);

			elButton.type = 'button';
			elButton.value = 'Close';
			elButton.className = 'commandbutton close';
			elFieldset.appendChild(elButton);

			elNoButton = appendCommandButton('No');
			elCancelButton = appendCommandButton('Cancel');
			elApplyButton = appendCommandButton('Apply');
			elPreviousButton = appendCommandButton('Previous', true);
			elHelpButton = appendCommandButton('Help');

			el.appendChild(elFieldset);

			el.style.position = 'absolute';
			showElement(el, false);
			positionElement(el, 0, 0);
			attachListener(elButton, 'click', function() {
				if (steps) {
					if (step < steps) {
						if (callback(onstep, step + 1, step) !== false) {
							step++;
							updatePreviousNextButtons();
						}
					} else {
						if (!decision || makeDecision(true)) {
							dismiss(true);
						}
					}
				} else {
					if (!decision || makeDecision(true)) {
						dismiss(isDirty);
					}
				}
			});
			if (elCurtain) {
				body.appendChild(elCurtain);
				if (focusAlert) {
					attachListener(elCurtain, 'click', function() {
						focusAlert();
					});
				}
			}
			body.appendChild(el);

			if (attachDocumentListener && getKeyboardKey) {
				var nextKeyCounts;
				attachDocumentListener('keydown', function(e) {
					nextKeyCounts = (shown && !isInBackground);
				});
				attachDocumentListener('keyup', function(e) {
					var elTarget, key, targetTagName;

					if (shown && !e.shiftKey && !e.metaKey && (!isInBackground || nextKeyCounts)) {
						key = getKeyboardKey(e);
						switch(key) {
						case 27:
							if (!e.ctrlKey) {
								if (!elCloseButton || !isDisabled(elCloseButton) || makeDecision()) {
									dismiss(false);
									return cancelDefault(e);
								}
							}
							break;
						case 13:
							if (!e.ctrlKey) {
								elTarget = getEventTarget(e);
								targetTagName = elTarget.tagName;

								if (elTarget.type == 'text' && /^input$/i.test(targetTagName)) {

									while (elTarget && elTarget != elFieldset) {
										elTarget = getElementParentElement(elTarget);
									}
									if (elTarget && (!decision || makeDecision(true))) {
										dismiss(isDirty);
										return cancelDefault(e);
									}
								}
							}
							break;
						default:
							if (maximize && sizable && e.ctrlKey) {
								switch(key) {
								case 190:
									if (maximizable && !restore()) {
										maximize(true);
									}
									break;
								case 188:
									if (minimizable && elMinimizeButton && !isDisabled(elMinimizeButton)) {
										minimize(true);
									}
								}
							}
						}
						nextKeyCounts = false;
					}
				});
			}

			if (elHelpButton) {
				attachListener(elHelpButton, 'click', function() {
					if (onhelp) { onhelp(); }
				});
			}

			if (elCancelButton) {
				attachListener(elCancelButton, 'click', function() {
					if (makeDecision()) {
						dismiss(false);
					}
				});
			}

			if (elNoButton) {
				attachListener(elNoButton, 'click', function() {
					if (makeDecision(false)) {
						dismiss(false);
					}
				});
			}

			if (elApplyButton) {
				attachListener(elApplyButton, 'click', function() {
					if (!onsave || callback(onsave, el) !== false) {
						isDirty = false;
						this.disabled = true;
						if (elButton.value == 'Close') {
							elButton.value = 'OK';
							if (elCancelButton) {
								elCancelButton.disabled = false;
							}
						}
					}
				});
			}

			updatePreviousNextButtons = function() {
				elPreviousButton.disabled = step == 1;
				elButton.value = step == steps ? 'Finish' : 'Next';
			};

			if (elPreviousButton) {
				attachListener(elPreviousButton, 'click', function() {
					if (steps && step) {
						if (callback(onstep, step - 1, step) !== false) {
							step--;
							updatePreviousNextButtons();
						}
					}
				});
			}
			
			api.alert = function(sText, options) {
				if (autoDismissTimer) {
					global.clearTimeout(autoDismissTimer);
					autoDismissTimer = 0;
				}

				var dummy, captionButtons, icon, title, hasTitle, oldLeft, oldTop, moveOptions;

				options = options || {};
				if (options.effects && typeof options.duration == 'undefined') {
					options.duration = 400;
				}

				showOptions = options;
				dimOptions = { duration:options.duration,ease:options.ease,fps:options.fps };
				curtainOptions = options.curtain || {};
				decision = options.decision;
				showButtons = options.buttons !== false;
				captionButtons = options.captionButtons !== false;
				icon = options.icon !== false;

				onstep = options.onstep;
				if (onstep && decision == 'dialog') {
					steps = options.steps;
					if (steps > 1) {
						step = 1;
					} else {
						steps = 0;
					}
				} else {
					steps = 0;
				}

				if (setRole) {
					setRole(el, decision == 'dialog' ? 'dialog' : 'alertdialog');
					if (decision == 'dialog') {
						removeProperty(el, 'described-by');
					} else {
						setProperty(el, 'described-by', 'mylibalertcontent');
					}
				}

				// TODO: Should add/remove extra buttons, not set display style

				if (elHelpButton) {
					onhelp = options.onhelp;
					elHelpButton.style.display = (onhelp)? '' : 'none';
				}

				if (elCancelButton) {
					elCancelButton.style.display = (decision && decision != 'yesno')? '' : 'none';
				}

				if (elPreviousButton) {
					elPreviousButton.style.display = steps ? '' : 'none';
					updatePreviousNextButtons();
				}

				if (elNoButton) {
					elNoButton.style.display = (decision == 'yesno' || decision == 'yesnocancel')? '' : 'none';
				}

				if (elCloseButton) {
					disableControl(elCloseButton, !!decision && decision != 'dialog');
				}

				if (elIconButton) {
					elIconButton.title = (decision && decision != 'dialog') ? '' : 'Double-click to close';

					if (setRole) {
						setRole(elIconButton, decision ? '' : 'button');
					}

					elIconButton.style.visibility = (!captionButtons || !icon || !addClass) ? 'hidden' : '';
				}


				// FIXME: Should do this in show callback
				var autoDismiss = +options.autoDismiss;
				if (autoDismiss) {
					autoDismissTimer = global.setTimeout(function() {
						if (autoDismissTimer && shown) {
							dismiss(false);
						}
					}, autoDismiss);
				}

				onpositive = options.onpositive;
				onindeterminate = options.onindeterminate;
				onnegative = options.onnegative;
				oniconclick = options.oniconclick;
				onfocus = options.onfocus;
				onblur = options.onblur;
				onactivate = options.onactivate;
				ondeactivate = options.ondeactivate;
				onmaximize = options.onmaximize;
				onminimize = options.onminimize;
				onrestore = options.restore;
				ondragstart = options.ondragstart;
				ondrop = options.ondrop;
				callbackContext = options.callbackContext;

				if (elCancelButton) {
					elCancelButton.disabled = false;
				}

				if (elApplyButton) {
					isDirty = false;
					elApplyButton.disabled = true;
					onsave = options.onsave;
					elApplyButton.style.display = (!steps && onsave && decision == 'dialog') ? '' : 'none';
				}				

				elButton.value = decision ? ((decision.indexOf('yes') != -1) ? 'Yes' : (steps ? 'Next' : 'OK')) : 'Close';

				if (elCaption) {
					title = options.title;
					hasTitle = typeof title == 'string';
					if (hasTitle) {
						elCaption.style.display = '';
						setElementText(elCaption, title);
					} else {
						elCaption.style.display = 'none';
					}
				}

				if (elFieldset) {
					elFieldset.style.display = showButtons ? '' : 'none';
				}

				onclose = options.onclose;
				onhide = options.onhide || arguments[3];

				var fnShow, onopen = options.onopen;
				if (!fnShow) {
					fnShow = options.onshow || arguments[2];
				}
				showElement(el, false);
				if (!isMaximized && options.shrinkWrap !== false) {
					el.style.height = '';
					el.style.width = '';
				}

				if (elCurtain) {
					var wasModal = isModal;
					isModal = options.modal;
					if (!shown || isModal != wasModal) {
						showCurtain(options.modal);
					}
				}

				el.className = (options.className || 'alert') + ' popup window';

				if (!shown) {
					oldLeft = el.style.left;
					oldTop = el.style.top;
					el.style.left = el.style.top = '0';
				}

				options.text = sText;
				setControlContent(elLabel, options);

				sizable = options.sizable !== false;

				maximizable = sizable && options.maximizable !== false;
					
				if (addClass) {
					if (maximize) {
						removeClass(el, 'nomaxminbuttons');
						(sizable ? addClass : removeClass)(el, 'maxminbuttons');
					} else {
						addClass(el, 'nomaxminbuttons');
					}

					if (captionButtons) {
						(icon ? addClass : removeClass)(el, 'iconic');
						removeClass(el, 'nocaptionbuttons');
					} else {
						addClass(el, 'nocaptionbuttons');
					}

					if (fixElement && options.fixable !== false) {
						addClass(el, 'fixable');
					}
				}
				
				el.style.display = 'block';

				if (presentControls && minimizable && elMinimizeButton && isDisabled(elMinimizeButton)) {
					presentControls(false);
					if (isMaximized) {
						restoreElement(el);
						if (maximizable) {
							maximizeElement(el, null, function() {
								if (addClass) {
									addClass(el, 'maximized');
								}
							});
						} else {
							isMaximized = false;
						}
						update(isMaximized);
					}
					updateMin(false);
				}

				if (elMaximizeButton) {
					if (sizable && maximize && maximizable) {
						disableControl(elMaximizeButton, false);
					} else {
						disableControl(elMaximizeButton);
						if (isMaximized) {
							restoreElement(el);
							isMaximized = false;
						}						
					}
					update(!!isMaximized);
				}

				if (sizable) {
					minimizable = options.minimizable !== false;
				}

				if (elMinimizeButton) {
					if (sizable && minimize && minimizable) {
						disableControl(elMinimizeButton, false);
					} else {
						disableControl(elMinimizeButton);
					}
				}

				if (updateSizeHandles) {
					updateSizeHandles(!sizable || isMaximized);
				}

				if (elFixButton) {
					elFixButton.style.visibility = (options.fixable !== false && hasTitle && captionButtons) ? '' : 'hidden';
				}

				if (elMaximizeButton) {
					elMaximizeButton.style.visibility = (sizable && hasTitle && captionButtons) ? '' : 'hidden';
				}

				if (elMinimizeButton) {
					elMinimizeButton.style.visibility = (sizable && hasTitle && captionButtons) ? '' : 'hidden';
				}

				if (elCloseButton) {
					elCloseButton.style.visibility = (hasTitle && captionButtons) ? '' : 'hidden';
				}				

				if (sizeElement) {

					// NOTE: So called shrink-wrapping cross-browser is a bad proposition

					if (options.shrinkWrap !== false) {
						if (!isMaximized) {
							// Hack for FF1
							el.style.height = '1px';
							dummy = el.offsetHeight;
							el.style.height = '';
						}

						// (Harmless) mystical incantation causes the browser to adjust the offsetHeight/Width properties
						// Assignment would likely work as well

						dummy = el.clientLeft;
					}

					var dim = getElementSizeStyle(el);
					if (dim) {
						sizeElement(el, dim[0], dim[1]);
					}
				}
				if (!shown) {
					el.style.left = oldLeft;
					el.style.top = oldTop;
				}
				if (onopen) {
					callback(onopen, el);
				}
				isInBackground = options.background;
				if (isInBackground) {
					deactivateAlert();
				}

				var fix, sp = getScrollPosition();

				var isFixedChecked = isChecked(elFixButton);

				if (fixElement) {
					if (typeof options.fixed == 'undefined') {
						fix = isFixedChecked;
					} else {
						fix = options.fixed;
					}
					fix = fix && options.fixable !== false;
					if (fix && !isFixedChecked || (!fix && isFixedChecked)) {
						if (isMaximized) {
							restoreElement(el);
						} else if (!el.style.top) {
							el.style.left = sp[0] + 'px';
							el.style.top = sp[1] + 'px';
						}
						fixElement(el, fix);
						if (elFixButton) {
							checkControl(elFixButton, fix);
						}
						if (isMaximized) {
							maximizeElement(el);
						}
					}
				}

				var position = options.position;
				var positionSlideDirections = { topleft:'nw', bottomleft:'sw', topright:'ne', bottomright:'se' };

				if (typeof position == 'string') {
					if (API.effects && options.effects == API.effects.slide && !options.effectParams) {
						options.effectParams = { side: 'diagonal' + positionSlideDirections[position] };
					}
				}

				if (position && typeof position != 'string') {
					if (el.style.position != 'fixed') {
						position[0] += sp[0];
						position[1] += sp[1];
					}
					if (!shown) {
						if (isMaximized) {
							restoreElement(el);
						}
						el.style.top = position[0] + 'px';
						el.style.left = position[1] + 'px';
						if (isMaximized) {
							maximizeElement(el);
						}
					}
				}

				if (shown || !fnShow || !callback(fnShow, el, options, isMaximized)) {
					if (shown) {
						if (options.effects) {
							moveOptions = {
								duration:options.duration,
								ease:options.ease,
								fps:options.fps
							};
						}

						//if (!elFixButton || !isChecked(elFixButton)) {
							global.setTimeout(function() {
								if (position) {
									if (typeof position == 'string') {
										cornerControl(el, position, moveOptions, focusAlert);
									} else {
										positionElement(el, position[0], position[1], moveOptions, focusAlert);
									}
								} else {
									centerElement(el, moveOptions, focusAlert);
								}
							}, 10);
						//}
						showElement(el);						
						if (focusAlert && !positionElement.async) {
							focusAlert();
						}
					} else {
						if (!isMaximized) {
							if (position) {
								if (typeof position == 'string') {
									cornerControl(el, position);
								} else {
									positionElement(el, position[0], position[1]);
								}
							} else {
								centerElement(el);
							}
						} else {
							restoreElement(el);
							var fn = function() {
								if (addClass) {
									addClass(el, 'maximized');
								}
							};
							if (position) {
								// TODO: Add positionControl function that takes an array
								if (typeof position == 'string') {
									cornerControl(el, position);
								} else {
									positionElement(el, position[0], position[1]);
								}
							}
							maximizeElement(el, null, fn);
							if (!maximizeElement.async) {
								fn();
							}
						}
						shown = true;
						showElement(el, true, options, focusAlert);
						if (focusAlert && !showElement.async) {
							focusAlert();
						}
					}
				}
				shown = true;
				if (playAlertEventSound && !options.mute) {
					playAlertEventSound(options);
				}
			};
		}
		body = api = null;
	});
}

/* My Library Toolbar Widget
   Requires DOM, Text and Event modules
   Requires Widgets add-on
   Optionally uses Class */

var API, global = this;
if (API && API.areFeatures && API.areFeatures('getEBTN', 'getChildren', 'getElementText', 'checkControl', 'emptyNode', 'attachListener')) {
	(function() {
		var api = API;
		var isHostMethod = api.isHostMethod;
		var createElement = api.createElement, getEBTN = api.getEBTN, getChildren = api.getChildren;
		var isControlChecked = api.isControlChecked, isControlDisabled = api.isControlDisabled, isControlPressed = api.isControlPressed, callInContext = api.callInContext;
		var setControlRole = api.setControlRole, checkControl = api.checkControl, disableControl = api.disableControl, pressControl = api.pressControl;
		var attachListener = api.attachListener, detachListener = api.detachListener, cancelDefault = api.cancelDefault, cancelPropagation = api.cancelPropagation, getEventTarget = api.getEventTarget, getEventTargetRelated = api.getEventTargetRelated;
		var emptyNode = api.emptyNode, getElementNodeName = api.getElementNodeName, getElementParentElement = api.getElementParentElement, getElementDocument = api.getElementDocument, getElementText = api.getElementText;
		var getToolbarButtons;

		var enhanceButton = function(el) {
			if (setControlRole) {
				setControlRole(el, 'button');
			}
			if (isControlChecked(el)) {
				checkControl(el);
			}
			if (isControlPressed(el)) {
				pressControl(el);
			}
			if (isControlDisabled(el)) {
				disableControl(el);
			}
			if (API.makeElementUnselectable) {
				API.makeElementUnselectable(el);
			}
		};

		// TODO: Delegate anchor clicks

		var anchorClick = function(e) {
			return cancelDefault(e);
		};

		var anchorFocusFactory = function(fn, context) {
			return function(e) {
				if (callInContext(fn, context, this, getEventTargetRelated(e)) === false) {
					if (isHostMethod(this, 'blur')) {
						this.blur();
					}
					return cancelDefault(e);
				}
			};
		};

		var appendButtonAnchor = function(div, caption, doc) {
			var a = createElement('a', doc);
			if (a) {
				if (caption) {
					a.appendChild(doc.createTextNode(caption));
				} else if (API.addClass) {
					API.addClass(div, 'nocaption');
				}
				a.tabIndex = 0;
				a.href= '#';
				emptyNode(div);
				div.appendChild(a);
			}
			return a;
		};

		var attachAnchorListeners = function(a, div, onfocus, context) {
			attachListener(a, 'click', anchorClick, div);
			if (onfocus) {
				attachListener(a, 'focus', anchorFocusFactory(onfocus, context || API), div);
			}
		};

		var enhanceToolbar = function(el, options, doc) {
			if (!doc) {
				doc = getElementDocument(el);
			}
			if (!options) {
				options = {};
			}

			if (doc && isHostMethod(doc, 'createTextNode')) {
				if (setControlRole) {
					setControlRole(el, 'toolbar');
				}
				var divs = getChildren(el);
				for (var i = divs.length; i--;) {
					var div = divs[i];
					var a, anchors = getEBTN('a', div);
					if (!anchors.length) {
						var caption = getElementText(div);
						if (caption) {
							a = appendButtonAnchor(div, caption, doc);
						}
					} else {
						a = anchors[0];
					}
					if (a) {
						attachAnchorListeners(a, div, options.onfocus, options.callbackContext);
					}
					enhanceButton(div);
				}

				attachListener(el, 'mousedown', function(e) {
					var el = getEventTarget(e);

					if (getElementNodeName(el) == 'a') {
						el = getElementParentElement(el);
					}
					if (getElementParentElement(el) == this && !isControlDisabled(el)) {
						pressControl(el);
					}
				});

				attachListener(el, 'mouseup', function(e) {
					var el = getEventTarget(e);

					if (getElementNodeName(el) == 'a') {
						el = getElementParentElement(el);
					}
					if (getElementParentElement(el) == this && !isControlDisabled(el)) {
						pressControl(el, false);
					}
				});

				attachListener(el, 'click', function(e) {
					var i, divs, result, el = getEventTarget(e), elRelated;

					if (options.radio) {
						var buttons = getToolbarButtons(this);
						for (i = buttons.length; i--;) {
							if (isControlChecked(buttons[i])) {
								elRelated = buttons[i];
							}
						}
					}

					if (getElementNodeName(el) == 'a') {
						el = getElementParentElement(el);
					}
					if (el != this && !isControlDisabled(el)) {
						if (el && options.onclick) {
							result = callInContext(options.onclick, options.callbackContext || API, this, el, elRelated);
						}
						if (result !== false) {
							if (options.radio) {
								divs = getChildren(this);

								for (i = divs.length; i--;) {
									var div = divs[i];
									if (div != el) {
										checkControl(div, false);
									}
								}							
								if (el) {
									checkControl(el);
								}
							}
						}
						return cancelDefault(e);
					}					
				});

				var oncustomize = options.oncustomize;

				if (oncustomize) {
					attachListener(el, 'dblclick', function(e) {
						var el = getEventTarget(e);

						if (el == this) {
							callInContext(oncustomize, options.callbackContext || API, this);

							return cancelDefault(e);
						}
					});

				}

				el = divs = null;
			}
		};

		api.enhanceToolbar = enhanceToolbar;

		var cancelDrag = function(e) {
			return cancelPropagation(e);
		};

		api.attachDocumentReadyListener(function() {
		var api = global.API, attachDragToControl = api.attachDragToControl, detachDragFromControl = api.detachDragFromControl;
		if (attachDragToControl) {
			api.attachDragToToolbar = function(el, elHandle, options) {
				attachDragToControl(el, elHandle);
				var divs = getChildren(el);
				for (var i = divs.length; i--;) {
                                  attachListener(divs[i], 'mousedown', cancelDrag);
                                }
			};
			api.detachDragFromToolbar = function(el, elHandle) {
				detachDragFromControl(el, elHandle);
				var divs = getChildren(el);
				for (var i = divs.length; i--;) {
                                  detachListener(divs[i], 'mousedown', cancelDrag);
                                }
			};
		}
		api = null;
		});

		var addToolbarButton;

		if (createElement && createElement('div')) {
			api.addToolbarButton = addToolbarButton = function(el, options, doc) {
				if (!doc) {
					doc = global.document;
				}
				var elButton = createElement('div', doc);
				elButton.className = options.className || 'button';
				var a = appendButtonAnchor(elButton, options.text || '', doc);
				attachAnchorListeners(a, elButton, options.onfocus, options.callbackContext);

				if (options.title) {
					elButton.title = options.title;
				}
				if (options.id) {
					elButton.id = options.id;
				}
				enhanceButton(elButton);
				el.appendChild(elButton);
				return elButton;
			};

			api.removeToolbarButton = function(el, elButton) {
				el.removeChild(elButton);
			};

			api.createToolbar = function(options, doc) {
				if (!doc) {
					doc = global.document;
				}
				if (!options) {
					options = {};
				}
				var el = createElement(options.tagName || 'div', doc);
				el.className = options.className || 'toolbar panel';
				if (options.id) {
					el.id = options.id;
				}
				var buttons = options.buttons;
				if (buttons) {
					var l = buttons.length;
					for (var i = 0; i < l; i++) {
						addToolbarButton(el, buttons[i], doc);
					}
				}
				enhanceToolbar(el, options, doc);
				return el;
			};

			api.getToolbarButtons = getToolbarButtons = function(el) {
				return getChildren(el);
			};
		}
		api = null;
	})();
}

/* My Library Sidebar Widget
   Requires DOM module
   Requires Widgets add-on
   Optionally uses Class */

var API, global = this;
if (API && API.areFeatures && API.areFeatures('createElement', 'attachDocumentReadyListener')) {
	API.attachDocumentReadyListener(function() {
		var api = API, getBodyElement = api.getBodyElement, showElement = api.showElement, createElement = api.createElement;
		var body = getBodyElement();
		var oppositeSides = { left:'right', right:'left', top:'bottom', bottom:'top' };
		var attachListener = api.attachListener, getElementParentElement = api.getElementParentElement, callInContext = api.callInContext;
		var appendSideBarButton;

		if (createElement && attachListener) {
			appendSideBarButton = function(elSideBar, v, fn) {
				var elButton = createElement('input');

				if (elButton) {
					elButton.type = 'button';
					elButton.className = 'commandbutton';
					elButton.value = v;
					elSideBar.appendChild(elButton);

					attachListener(elButton, 'click', function() {
						return fn(getElementParentElement(this), this);
					});
					elButton = elSideBar = null;
					return true;
				}
				return false;
			};
		}

		if (body && API.isHostMethod(body, 'appendChild') && api.sideBar) {
                        api.enhanceSideBar = function(el, options, doc) {
				var body = getBodyElement(doc);

				if (!options) {
					options = {};
				}

				var side = options.side || 'left';

				if (body) {
					el.style.position = 'absolute';
					el.className = options.className || 'sidebar panel';
					if (side == 'left' || side == 'right') {
						el.className += ' vertical';
					}
					el.className += ' ' + side;
					body.appendChild(el);
					API.sideBar(el, side, options);
					return el;
				}
				return null;
			};
			if (appendSideBarButton) {
				api.createSideBar = function(options, doc) {
					if (!options) {
						options = {};
					}
					var el = createElement('div');
					if (el) {
						API.setControlContent(el, options);
						if (options.buttons) {
							var onclose = options.onclose;

							if (API.showSideBar) {
							appendSideBarButton(el, 'Close', function() {
					                  API.showSideBar(el, false, {
					                    effects:options.effects,
					                    side:options.side,
					                    duration:options.duration,
					                    ease:options.ease,
                                                            fps:options.fps,
					                    removeOnHide:true
					                  });
					                  API.unSideBar(el);
					                  if (onclose) {
                                                            callInContext(onclose, options.callbackContext || API, el);
                                                          }
					                });
                                                        }

							var onautohidecollision = options.onautohidecollision, onautohide = options.onautohide;

							if (API.autoHideSideBar) {
                                                            appendSideBarButton(el, 'Auto-hide', function(el, elButton) {
					                    if (API.autoHideSideBar(el, true, { duration:options.duration, ease:options.ease, fps:options.fps })) {
						                      el.className += ' autohide';
						                      elButton.disabled = true;
						                      if (onautohide) {
                                                                        callInContext(onautohide, options.callbackContext || API, el);
                                                                      }
                                                            } else {
                                                              var doAlert = true;

                                                              if (onautohidecollision) {
								doAlert = callInContext(onautohidecollision, options.callbackContext || API, el) !== false;
					                      }
                                                              if (doAlert && API.isHostMethod(global, 'alert')) {
                                                                global.alert('Only one sidebar per edge may be hidden.');
                                                              }
					                    }
                                                          });
                                                        }
						}
						return API.enhanceSideBar(el, options, doc);
					}
					return null;
				};
			}
			if (showElement) {
				var oldShowSideBar = api.showSideBar;

				api.showSideBar = function(el, b, options) {
					if (options && options.side && options.effects && API.effects && options.effects == API.effects.slide && !options.effectParams) {
						options.effectParams = { side:oppositeSides[options.side] };
					}
					oldShowSideBar(el, b, options);
				};
			}
			api.destroySideBar = function(el) {
				API.unSideBar(el);
				var elParent = API.getElementParentElement(el);
				if (elParent) {
					elParent.removeChild(el);
				}
			};
		}

		api = body = null;
	});
}

/* My Library Toast Widget
   Requires DOM module
   Requires Widgets add-on
   Optionally uses Class */

var API, global = this;
if (API && API.areFeatures && API.areFeatures('createElement', 'attachDocumentReadyListener', 'getElementDocument')) {
	API.attachDocumentReadyListener(function() {
		var i, api = API, getBodyElement = api.getBodyElement, showControl = api.showControl, cornerControl = api.cornerControl, createElement = api.createElement, getElementDocument = api.getElementDocument;
		var attachListener = api.attachListener, callInContext = api.callInContext, getWorkspaceRectangle = api.getWorkspaceRectangle, getDocumentWindow = api.getDocumentWindow, playEventSound = api.playEventSound;
		var addToast, arrangeToast, arrangeToasts, enhanceToast, findToast, getToastOffset, positions = ['topleft', 'topright', 'bottomleft', 'bottomright'];
		var body = getBodyElement();

		var toaster = {};

		var populateToaster = function(toaster) {
			for (i = positions.length; i--;) {
				toaster[positions[i]] = [];
			}
			return toaster;
		};

		populateToaster(toaster);

		var getWindowDocument = function(win) {
			var doc;

			if (!win || win == global) {
				doc = global.document;
			} else {
				doc = win.document;
			}
			return doc;
		};

		var addedResizeListener, addResizeListener = function(doc) {
			API.attachWindowListener('resize', function() {
				arrangeToasts(null, doc);
			});
		};

		var getDocumentToaster = function(doc) {
			if (!doc || doc == global.document) {
				if (!addedResizeListener) {
					addResizeListener(global.document);
					addedResizeListener = true;
				}
				return toaster;
			} else {
				if (!doc.toaster && (typeof doc.expando == 'undefined' || doc.expando)) {
					addResizeListener(doc);
					doc.toaster = populateToaster({});					
				}
				return doc.toaster;
			}
		};

		if (!body || typeof body.offsetWidth != 'number') {
			return;
		}		

		getToastOffset = function(position, el, doc) {
			var offset = 0, offsetW = 0, toast = getDocumentToaster(doc)[position], r = getWorkspaceRectangle(doc), viewportHeight = r[2], largestWidth = 0;
			var isTop = position.indexOf('top') != -1;
			var isRight = position.indexOf('right') != -1;

			for (var i = toast.length; i--;) {
				var toastSlice = toast[i];
				if (toastSlice.element) {
					offset += (isTop ? 1 : -1) * toastSlice.element.offsetHeight;
				} else if (toastSlice.arranging) {
					offset += (isTop ? 1 : -1) * toastSlice.arranging;
				}
				if (toastSlice.element && toastSlice.element.offsetWidth > largestWidth) {
					largestWidth = toastSlice.element.offsetWidth;
				}
				if (Math.abs(offset) + el.offsetHeight > viewportHeight) {
					offsetW += (isRight ? -1 : 1) * largestWidth;
					offset = largestWidth = 0;
				}
			}
			return [offset, offsetW];
		};

		findToast = function(el, doc) {
			var foundOne, result;

			for (var i = positions.length; i--;) {
				foundOne = false;
				var toast = getDocumentToaster(doc)[positions[i]];
				for (var j = 0, l = toast.length; j < l; j++) {
					var o = toast[j];
					if (o.element) {
						if (o.element == el) {
							result = toast[j];
						}
						foundOne = true;
					} else if (o.arranging) {
						foundOne = true;
					}
				}
				if (!foundOne) {
					toaster[positions[i]] = [];
				}
			}
			return result;
		};

		addToast = function(el, position, doc) {
			var toast = getDocumentToaster(doc)[position];

			return (toast[toast.length] = { element:el, position:position });
		};

		arrangeToast = function(position, options, doc) {
			var offset = 0, offsetW = 0, toast = getDocumentToaster(doc)[position], r = getWorkspaceRectangle(doc), viewportHeight = r[2], largestWidth = 0;
			var isTop = position.indexOf('top') != -1;
			var isRight = position.indexOf('right') != -1;

			// TODO: Remove this on next core update (positionElement will cancel effect without duration)
			options = options || { duration:1 };

			for (var i = 0, l = toast.length; i < l; i++) {
				if (toast[i].element) {
					var toastOffset = (isTop ? 1 : -1) * toast[i].element.offsetHeight;
					if (Math.abs(offset + toastOffset) > viewportHeight) {
						offsetW += (isRight ?  -1 : 1) * largestWidth;
						offset = largestWidth = 0;
						options.offset = [offset, offsetW];
					} else {
						options.offset = [offset, offsetW];
					}
					offset += toastOffset;
					toast[i].destination = cornerControl(toast[i].element, position, options);
					if (toast[i].element.offsetWidth > largestWidth) {
						largestWidth = toast[i].element.offsetWidth;
					}
				} else if (toast[i].arranging) {
					offset += (isTop ? 1 : -1) * toast[i].arranging;
				}
			}
		};

		arrangeToasts = function(options, doc) {
			for (var i = positions.length; i--;) {
				arrangeToast(positions[i], options, doc);
			}
		};

		if (body && attachListener && API.isHostMethod(body, 'appendChild') && cornerControl && showControl) {
			api.arrangeToast = arrangeToast;
			api.arrangeToasts = arrangeToasts;

                        api.enhanceToast = enhanceToast = function(el, options, win) {
				var shown, doc = win ? getWindowDocument(win) : getElementDocument(el), body = getBodyElement(doc);
				if (!win && getDocumentWindow) {
					win = getDocumentWindow(doc);
				}

				if (!win) {
					return null;
				}

				if (!options) {
					options = {};
				}

				var position = options.position;

				if (position) {
					position = position.toLowerCase().replace(/ /, '');
				} else {
					position = 'bottomleft';
				}

				if (body) {
					var toast = findToast(el, doc);
					if (toast) {
						global.clearTimeout(toast.timer);
					}

					el.style.position = 'absolute';
					el.style.visibility = 'hidden';
					el.className = options.className || 'toast panel';
					if (position.indexOf('top') != -1) {
						el.className += ' top';
					}
					body.appendChild(el);
					var showOptions = { duration: options.duration, effects:options.effects, fps:options.fps, ease:options.ease, removeOnHide:true, useCSSTransitions:false };
					if (showOptions.effects && API.effects && (showOptions.effects == API.effects.slide || showOptions.effects == API.effects.drop) && !options.effectParams) {
						showOptions.effectParams = { side:position.indexOf('top') == -1 ? 'top' : 'bottom' };
					} else if (showOptions.effects && API.effects && showOptions.effects == API.effects.fold && !options.effectParams) {
						showOptions.effectParams = { axes:1 };
					} else {
						showOptions.effectParams = options.effectParams;
					}
					var offset = getToastOffset(position, el, doc);
					var offsetWidth = el.offsetWidth;

					cornerControl(el, position, { offset:offset }, null, doc);
					if (el.offsetWidth != offsetWidth) {
						cornerControl(el, position, { offset:[offset[0], offset[1] - 1] }, null, doc);
					}

					if (options.fixed && API.fixElement) {

						// TODO: common function to extract effects options

						API.fixElement(el, true, options);
					}

					var hide = function(force, win) {
						if (shown && toast.element) {
							toast.element = null;
							if (force) {
								win.clearTimeout(toast.timer);
							}

							if (!options.onhide || callInContext(options.onhide, options.callbackContext || API) !== false) {
								toast.arranging = el.offsetHeight;

								//var pos = API.getElementPositionStyle(el);
								var pos = toast.destination;

								// FIXME: Core requires a duration to cancel ongoing effect
								if (pos) {
									API.positionElement(el, pos[0], pos[1], { duration:1 });
								}
								showControl(el, false, showOptions, function() {
									toast.arranging = false;
									arrangeToast(position, options, doc);
									if (options.autoDestroy) {
										API.destroyToast(el, win);
										el = null;
									}
								});
							}
						}
						if (!options.autoDestroy) {
							el = null;
						}
						shown = false;
					};

					attachListener(el, 'click', function() {
						if (!options.onclick || callInContext(options.onclick, options.callbackContext || API) !== false ) {
							hide(true, win);
						}						
					});

					toast = addToast(el, position, doc);
					if (!options.onshow || callInContext(options.onshow) !== false) {
						showControl(el, true, showOptions, function() {
							toast.timer = win.setTimeout(function() { hide(false, win); }, options.pause || 5000);
						});
					}

					if (playEventSound && !options.mute) {
						global.setTimeout(function() {
							playEventSound('toast');
						}, options.effects ? options.duration || 0 : 0);
					}

					shown = true;
					
					return el;
				}
				return null;
			};

			if (api.createElement && createElement('div')) {
				api.createToast = function(options, win) {
					var doc = getWindowDocument(win), body = getBodyElement(doc);
					if (!win) {
						win =  global;
					}
					if (!options) {
						options = {};
					}

					var el = createElement('div', doc);
					if (el) {
						if (API.setControlRole) {
							API.setControlRole(el, 'alertdialog');
						}

						el.style.visibility = 'hidden';
						el.style.position = 'absolute';
						el.style.left = el.style.top =  '0';
			
						API.setControlContent(el, options);
						if (options.onopen) {
							callInContext(options.onopen, options.callbackContext || API);
						}

						body.appendChild(el);
						return enhanceToast(el, options, win);
					}
					return null;
				};
				api.destroyToast = function(el, win) {
					var doc;

					if (win) {
						doc = getWindowDocument(win);
					} else {
						doc = getElementDocument(el);
						if (doc == global.document) {
							win = global;
						} else if (getDocumentWindow) {
							win = getDocumentWindow(doc);
						}
					}
					if (win) {
						var toast = findToast(el, doc), body = getBodyElement(doc);
						if (toast) {
							body.removeChild(toast.element);
							win.clearTimeout(toast.timer);
							toast.element = null;
							toast.arranging = false;
							return true;
						}
					}
					return false;
				};
			}
		}

		api = body = null;
	});
}