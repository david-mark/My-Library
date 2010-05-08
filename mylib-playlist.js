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