/* My Library Widgets add-on
   Enhanced by Set Attribute and/or Class modules */

var API;
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
			api.checkControl = setStateFactory('checked');
			api.selectControl = setStateFactory('selected');

			api.isControlDisabled = isStateFactory('disabled');
			api.isControlChecked = isStateFactory('checked');
			api.isControlSelected = isStateFactory('selected');
		}
		api = null;
	})();
}