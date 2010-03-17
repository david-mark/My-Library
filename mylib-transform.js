/* My Library Transform add-on
   Requires array and DOM modules
   Includes additional enhancements to FX and Wrapper Object modules */

// TODO: IE toFixed bug a factor?

var API, E, Q;

if (API && API.getAnElement) {
(function() {

  // TODO: Move this bit to the core and memorize results

  var getAnElement = API.getAnElement;
  var html = getAnElement();

  var findProprietaryStyle = function(style, el) {
    if (!el) { el = getAnElement(); }
    if (el && typeof el.style[style] != 'string') {
      style = style.charAt(0).toUpperCase() + style.substring(1);
      var prefixes = ['Moz', 'O', 'Webkit', 'Khtml'];
      for (var i = prefixes.length; i--;) {
        if (typeof el.style[prefixes[i] + style] != 'undefined') {
          return prefixes[i] + style;
        }
      }
      return null;
    }
    return style.toLowerCase();
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
        el.style.filter = el.style.filter.replace(reMatrix, transform);
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
      API.setElementTransform = transformerFactory('', setTransform);
      setTransform.async = true;

      if (setTransformOrigin) {
        oldSetTransformOrigin = setTransformOrigin;
        API.setElementTransformOrigin = setTransformOrigin = transformerFactory('Origin', setTransformOrigin);
        setTransformOrigin.async = true;
      }

      API.effects.flip = function(el, p, scratch, endCode) {
        if (endCode == 1) {
          switch (scratch.axes) {
          case 1:
            scratch.transformOperations = ['flipV'];
            break;
          case 3:
            scratch.transformOperations = ['flip'];
            break;
          default:
            scratch.transformOperations = ['flipH'];
          }
        }
        transformEffect(el, p, scratch, endCode);
      };

      API.effects.scale = function(el, p, scratch, endCode) {
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

      API.effects.skew = function(el, p, scratch, endCode) {
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

      var i, transition, revealTransitions = ['flip', 'skew', 'scale', 'rotate', 'spin', 'transform'];
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
            E.prototype[transition + 'In'] = queryTransitionFactory(transition, true);
            E.prototype[transition + 'Out'] = queryTransitionFactory(transition, false);
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