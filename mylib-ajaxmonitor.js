// My Library Ajax Monitor add-on
// Requires Requester module and Debug add-on

if (this.API && typeof this.API == 'object' && this.API.ajax && this.API.Requester && this.API.log) {
	(function() {
		var bMonitoringSession;
		var api = global.API;
		var log = api.log;
		var error = api.error;
		var warn = api.warn;
		var succeeded, failed, canceled, errored;
		var sessionCallback = {};
		var requestCallbacks = {};
		var requestEvents = ['success', 'fail', 'cancel', 'send'];
		var sessionEvents = ['error', 'start', 'finish', 'groupstart', 'groupfinish'];

		succeeded = failed = canceled = errored = 0;

		function logRequestMessage(sMsg, requester, xmlhttp, canceled) {
			var sId = requester.id();
			var sGroup = requester.group();
			var a = ['Request ', sMsg, ((sGroup)?' group=' + sGroup:''), ((sId)?' ID=' + sId:'')];
			if (!canceled) {
				a = a.concat([' status=', xmlhttp.status]);
			}
			log(a.join(''));
		}

		function logSessionMessage(sMsg, sGroup, sId) {
			log(['Session ', sMsg, ((sGroup)?' group=' + sGroup:''), ((sId)?' ID=' + sId:'')].join(''));
		}

		function callback(fn, o, args, context) {
			if (typeof fn == 'function') {
				fn.apply(context || o, args);
			}
		}

		function callbackRequest(sEvent, o, args) {
			var cb = requestCallbacks[o.id()];
			callback(cb['on' + sEvent], o, args, cb.context);
		}
		
		function callbackSession(sEvent, o, args) {
			callback(sessionCallback['on' + sEvent], api.ajax, args, api.ajax.callbackContext);
		}

		var monitor = {
			onsuccess:function(xmlhttp, obj) {
				succeeded++;
				logRequestMessage('Successful', this, xmlhttp);
				callbackRequest('success', this, [xmlhttp, obj]);
			},
			onfail:function(xmlhttp) {
				failed++;
				logRequestMessage('Failed', this, xmlhttp);
				callbackRequest('fail', this, [xmlhttp]);
			},
			oncancel:function(xmlhttp) {
				canceled++;
				logRequestMessage('Canceled', this, xmlhttp, true);
				callbackRequest('cancel', this, [xmlhttp]);
			},
			onsend:function(xmlhttp, sURI) {
				var sId = this.id();
				var sGroup = this.group();
				log(['Sending ', sURI, ((sGroup)?' group=' + sGroup:''), ((sId)?' ID=' + sId:'')].join(''));
				callbackRequest('send', this, [xmlhttp, sURI]);
			},
			onstart:function(sId, sGroup) {
				logSessionMessage('Started', sGroup, sId);
				callbackSession('start', this, [sId, sGroup]);
			},
			onfinish:function(sId, sGroup) {
				logSessionMessage('Finished', sGroup, sId);
				callbackSession('finish', this, [sId, sGroup]);
			},
			ongroupstart:function(sId, sGroup) {
				logSessionMessage('Group Started', sGroup, sId);
				callbackSession('groupstart', this, [sId, sGroup]);
			},
			ongroupfinish:function(sId, sGroup) {
				logSessionMessage('Group Finished', sGroup, sId);
				callbackSession('groupfinish', this, [sId, sGroup]);
			},
			onerror:function(sId, sGroup, xmlhttp, e, uri) {
				errored++;
				error(['ERROR sending to', uri, e, ((sGroup)?' group=' + sGroup:''), ((sId)?' ID=' + sId:'')].join(' '));
				callbackSession('error', this, [sId, sGroup, xmlhttp, e, uri]);
			}
		};

		api.resetTotals = function() {
			succeeded = failed = canceled = errored = 0;
			log('Ajax totals reset');
		};

		api.logTotals = function() {
			log(['Succeeded: ' + succeeded, 'Failed: ' + failed, 'Canceled: ' + canceled, 'Errored: ' + errored].join(', '));
		};

		api.getTotals = function() {
			return {successes:succeeded, failures:failed, cancels:canceled, errors:errored};
		};

		function saveCallbacks(request) {
			var id = request.id();
			var i = requestEvents.length;
			var c = requestCallbacks[id];

			if (c) {
				return false;
			}

			c = {};
			while (i--) {
				if (request['on' + requestEvents[i]]) {
					c['on' + requestEvents[i]] = request['on' + requestEvents[i]];
				}
			}
			c.context = request.callbackContext;
			requestCallbacks[id] = c;
			return true;
		}

		function saveSessionCallbacks() {
			var i = sessionEvents.length, o = api.ajax;			

			while (i--) {
				if (o['on' + sessionEvents[i]]) {
					sessionCallback['on' + sessionEvents[i]] = o['on' + sessionEvents[i]];
				}
			}
			sessionCallback.context = o.callbackContext;
		}

		api.monitorRequest = function(request) {
			if (request.id()) {
				if (saveCallbacks(request)) {
					request.bindToObject(monitor, false);
					log('Monitoring Ajax requester ID=' + request.id());
				}
				else {
					warn('Requester already monitored.');
				}
			}
		};

		api.monitorSession = function(request) {
			if (!bMonitoringSession) {
				log('Saving Ajax session');
				saveSessionCallbacks();
				log('Binding Ajax monitor');
				api.ajax.bindToObject(monitor, false);
				log('Monitoring Ajax activity');
				bMonitoringSession = true;
			}
			else {
				warn('Ajax activity already monitored.');
			}
		};
	})();
}