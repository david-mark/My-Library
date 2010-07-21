// My Library Location add-on

var API;

if (API && API.isHostObjectProperty && API.isHostObjectProperty(window, 'navigator') && API.isHostObjectProperty(window.navigator, 'geolocation') && API.isHostMethod(window.navigator.geolocation, 'getCurrentPosition')) {
	(function() {
		var savedPosition;

		function doCallback(position, callback, thisObject) {
			callback.call(thisObject || API, {
				latitude: position.coords.latitude,
				longitude: position.coords.longitude
			}, position);
		}

		API.getGeoLocation = function(callback, thisObject) {
			if (savedPosition) {
				doCallback(savedPosition, callback, thisObject);
			} else {
				window.navigator.geolocation.getCurrentPosition(function(position) {
					savedPosition = position;
					doCallback(position, callback, thisObject);
				});
			}
		};
	})();
}