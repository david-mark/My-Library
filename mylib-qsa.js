// QSA add-on uses built-in queries
var global = this;
if (this.API && this.API.getEBCS && this.API.isHostMethod(this.document, 'querySelectorAll')) {
	(function() {
		var oldGetEBCS = this.API.getEBCS;
		var toArray;

		try {
			(Array.prototype.slice.call(global.document.querySelectorAll('html'), 0));
			toArray = function(a) {
				return Array.prototype.slice.call(a, 0);
			};
		} catch(e) {
			toArray = API.toArray;
		}

		this.API.getEBCS = function(s, d) {
			try {
				return toArray((d || global.document).querySelectorAll(s));
			} catch(e) {
				return oldGetEBCS(s, d);
			}
		};
		if (typeof $ == 'function') {
			$ = this.API.getEBCS;
		}
	})();
}