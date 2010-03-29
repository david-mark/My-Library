// QSA add-on uses built-in queries
var global = this;
if (this.API && this.API.getEBCS && this.API.isHostMethod(this.document, 'querySelectorAll')) {
	(function() {
		var api = global.API, oldGetEBCS = api.getEBCS;
		var toArray, qsaEmptyInadequate, qsaOptionSelectedBroken, qsaClassNamesCaseInsensitive;

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

                var testClassNameCase = function(s, d, qsaCount) {
			var doc = global.document, el = api.createElement('div'), body = api.getBodyElement();
			el.className = 'MyLibraryAPITest';
			body.appendChild(el);
			qsaClassNamesCaseInsensitive = !!(doc.querySelectorAll('div.mylibraryapitest').length);
			body.removeChild(el);
		};

		try {
			(Array.prototype.slice.call(global.document.querySelectorAll('html'), 0));
			toArray = function(a) {
				return Array.prototype.slice.call(a, 0);
			};
		} catch(e) {
			toArray = api.toArray;
		}

		global.API.getEBCS = function(s, d) {
			var result, newResult;

			// TODO: Tokenize special characters before checks

			if (qsaClassNamesCaseInsensitive || (qsaEmptyInadequate && s.indexOf(':empty') != -1 || (qsaOptionSelectedBroken && s.indexOf('[selected]') != -1)) ||                           
			(d && (typeof d.nodeType != 'number' || d.nodeType != 9))) {
				return oldGetEBCS(s, d);
			}

			try {
				result = toArray((d || global.document).querySelectorAll(s));

				// NOTE: QSA workarounds do not take effect until the document is ready
				// Querying before the document is ready is not recommended (getEBCS method should really be deferred)
                                // TODO: Change feature tests to use orphan elements

				if (api.getBodyElement) {
					if (typeof qsaClassNamesCaseInsensitive == 'undefined') {
						testClassNameCase();
					}
					if (typeof qsaEmptyInadequate == 'undefined' && s.indexOf(':empty') != -1) {
						newResult = testEmpty(s, d, result.length);
						return qsaEmptyInadequate ? newResult : result;
					}
					if (typeof qsaOptionSelectedBroken == 'undefined' && s.indexOf('[selected]') != -1) {
						newResult = testOptionSelected(s, d, result.length);
						return qsaOptionSelectedBroken ? newResult : result;
					}
				}

				return qsaClassNamesCaseInsensitive ? oldGetEBCS(s, d) : result;
			} catch(e) {
				return oldGetEBCS(s, d);
			}
		};
		if (global['$'] == oldGetEBCS) {
			global['$'] = global.API.getEBCS;
		}
	})();
}