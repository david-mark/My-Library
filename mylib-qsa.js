// QSA add-on uses built-in queries
var global = this;
if (this.API && this.API.getEBCS && this.API.isHostMethod(this.document, 'querySelectorAll')) {
	(function() {
		var api = global.API, oldGetEBCS = api.getEBCS;
		var toArray, qsaEmptyInadequate, qsaOptionSelectedBroken;

                var testEmpty = function(s, d, qsaCount) {
                        var adequate, result = oldGetEBCS(s, d);
			if (result.length == qsaCount) {
				var doc = global.document, body = api.getBodyElement();
				var el = api.createElement('div');
				el.appendChild(doc.createTextNode(' '));
				var count = doc.querySelectorAll('div:empty').length;
				body.appendChild(el);
				adequate = count == doc.querySelectorAll('div:empty').length - 1;
				body.removeChild(el);
			}
			qsaEmptyInadequate = !adequate;
			return result;
		};

		var testOptionSelected = function(s, d, qsaCount) {
                        var adequate, result = oldGetEBCS(s, d);
			if (result.length == qsaCount) {
				var doc = global.document, body = api.getBodyElement();
				var el = api.createElement('option');
				el = api.setAttribute(el, 'selected');
				var elFieldset = doc.createElement('fieldset');
				var elSelect = doc.createElement('select');
				elSelect.appendChild(el);
				elFieldset.appendChild(elSelect);
				var count = doc.querySelectorAll('option[selected]').length;
				body.appendChild(elFieldset);
				adequate = count == doc.querySelectorAll('option[selected]').length - 1;
				body.removeChild(elFieldset);
			}
			qsaOptionSelectedBroken = !adequate;
			return result;
		};

		try {
			(Array.prototype.slice.call(global.document.querySelectorAll('html'), 0));
			toArray = function(a) {
				return Array.prototype.slice.call(a, 0);
			};
		} catch(e) {
			toArray = api.toArray;
		}

		this.API.getEBCS = function(s, d) {
			var result, newResult;

			if (qsaEmptyInadequate && s.indexOf(':empty') != -1 || (qsaOptionSelectedBroken && s.indexOf('[selected]') != -1)) {
				return oldGetEBCS(s, d);
			}

			try {
				result = toArray((d || global.document).querySelectorAll(s));
				if (typeof qsaEmptyInadequate == 'undefined' && s.indexOf(':empty') != -1) {
					newResult = testEmpty(s, d, result.length);
					return qsaEmptyInadequate ? newResult : result;
				}
				if (typeof qsaOptionSelectedBroken == 'undefined' && s.indexOf('[selected]') != -1) {
					newResult = testOptionSelected(s, d, result.length);
					return qsaOptionSelectedBroken ? newResult : result;
				}
				return result;
			} catch(e) {
				return oldGetEBCS(s, d);
			}
		};
		if (typeof $ == 'function') {
			$ = this.API.getEBCS;
		}
	})();
}