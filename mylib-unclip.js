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