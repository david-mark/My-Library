/* 
  My Library Keyboard add-on
  Requires Event module

  Usage:

  API.attachKeyboardListeners(el, options);

  Options:

    onchar (function) - called on key presses that result in renderable characters (backspace and enter are not always cancelable)

    onkey (function) - called on keyup/down for all keys

    onshortcutchar (optional function) - called on Ctrl + alphanumeric (or enter) combinations (not cancelable)

    onbeforeshortcutchar (optional function) - called before (on keydown) Ctrl + alphanumeric (or enter) combinations

    onnavkeypress (optional function) - called on arrow key, PageUp/Down and Esc key presses (not cross-browser)

    callbackContext (optional object) - sets the - this - object for callbacks

    suppressControlKeyAutoRepeat - prevents repeated onkey callbacks for control keys

    allowShiftCombinations

  Except as noted, all callbacks may cancel the default behavior by returning false

  Note that the onnavkeypress callback is not called in all browsers.  But it is only meant to used to cancel
  default behaviors in the odd browsers that do not allow canceling navigation keydown events (e.g. Opera).
  See the Spinner example.

  Note that the onshortcutchar callback is not called in IE when the Ctrl key is released before
  the alphanumeric.

  Test page at: http://www.cinsoft.net/mylib-keyboard.html
*/

var API, Q, E, D, global = this;

if (API && API.attachListener && Function.prototype.apply) {
	(function() {
	      var attachListener = API.attachListener;
		var cancelDefault = API.cancelDefault;

		// Tracks characters that fire keypress events

		var keyPressMap = [];

		// Keeps track of pushed keys

		var keyDownMap = [];

		// Determines auto-repeat model

		var autoRepeatModel;

		var shortcutCharactersPressed;

		// Mapping for unique extended ASCII key codes (found in old versions of WebKit)

		var extendedAsciiKeyCodes = {
			'63232': 38,
			'63233': 40,
			'63234': 37,
			'63235': 39,
			'63236': 112,
			'63237': 113,
			'63238': 114,
			'63239': 115,
			'63240': 116,
			'63241': 117,
			'63242': 118,
			'63243': 119,
			'63244': 120,
			'63245': 121,
			'63246': 122,
			'63247': 123,
			'63273': 36, 
			'63275': 35,
			'63276': 33,
			'63277': 34
		};

		function isShortcutCombination(e, key, allowShiftCombinations, allowAltCombinations) {
			return ((e.ctrlKey || e.metaKey) && (e.ctrlKey !== e.metaKey) && ((key > 47 && key < 91) || key == 13) && (allowAltCombinations || !e.altKey) && (allowShiftCombinations || !e.shiftKey));
		}

		var attachKeyboardListeners = function(el, options) {
			var onchar = options.onchar, onkey = options.onkey;
			var onshortcutchar = options.onshortcutchar;
			var onbeforeshortcutchar = options.onbeforeshortcutchar;
			var onnavkeypress = options.onnavkeypress;
			var context = options.callbackContext;
			var suppressControlKeyAutoRepeat = options.suppressControlKeyAutoRepeat;
			var allowShiftCombinations = options.allowShiftCombinations, allowAltCombinations = options.allowAltCombinations;
			var lastKeyDown, lastKeyDownRepeat = 0, lastControlKeyPress, lastControlKeyPressRepeat = 0;
			var upperCaseCharCode;

			attachListener(el, 'keypress', function(e) {
				var charCode;
				var which = e.which;
				var keyCode = e.keyCode;

				// Determine which character

				charCode = typeof which == 'number' ? which : keyCode;

				// Fix bug for browsers that report control characters

				if (e.charCode === 0 && charCode != 8 && charCode != 13) {
					charCode = 0;
				}

				// Track

				keyPressMap[charCode] = true;

				if (charCode > 31 || charCode == 13 || charCode == 8) {

					// Call character listener for printable characters

					if (onshortcutchar && isShortcutCombination(e, (upperCaseCharCode = (charCode > 96 && charCode < 123) ? charCode - 32 : charCode), allowShiftCombinations, allowAltCombinations)) {
						shortcutCharactersPressed = true;
						onshortcutchar.apply(context || this, [e, upperCaseCharCode]);
						return;
					}

					if (!e.ctrlKey && !e.altKey && !e.metaKey) {

						// Opera < 10.5 botches home, end, insert and delete

						if (lastKeyDown != charCode || (charCode != 35 && charCode != 36 && charCode != 45 && charCode != 46)) {
							if (onchar.apply(context || this, [e, charCode]) === false) {
								return cancelDefault(e);
							}
							return;
						}
					}
				} else if (!charCode && !suppressControlKeyAutoRepeat) {

					// Escape and Tab are not considered for auto-repeat detection
					// as they can cause the focus to change, possibly losing a keyup event

					if (keyCode != 27 && keyCode != 9) {
						if (lastControlKeyPress == keyCode) {
							lastControlKeyPressRepeat++;
						}
						if (typeof autoRepeatModel == 'undefined') {
							if (lastKeyDownRepeat) {
								autoRepeatModel = lastControlKeyPressRepeat ? 'both' : 'down';
							} else if (lastControlKeyPressRepeat) {
								autoRepeatModel = 'press';
							}
						}
					}

					// Call key listener for repeated control keys

					if (autoRepeatModel == 'press' && lastControlKeyPressRepeat > 1) {
						onkey.apply(context || this, [e, keyCode]);
					}

					if (keyCode != 27 && keyCode != 9) {
						lastControlKeyPress = keyCode;
					}

					if (keyCode > 36 && keyCode < 41 || (keyCode == 33 || keyCode == 34) || keyCode == 27) {
						if (onnavkeypress) {
							if (onnavkeypress.apply(context || this, [e, keyCode]) === false) {
								return cancelDefault(e);
							}
						}
					}
				}
			});

			var keyUpAndDownListener = function(e) {
				var key, duration, result;

				key = typeof e.which == 'number' ? e.which : e.keyCode;

				key = extendedAsciiKeyCodes[key] || key;

				if (e.type == 'keyup') {

					// Backspace or enter failed to fire keypress event

					if ((key == 8 && !keyPressMap[8] || key == 13 && !keyPressMap[13]) && !e.shiftKey && !e.ctrlKey && !e.metaKey && !e.altKey) {

						// Call character listener just in time

						onchar.apply(context || this, [e, key]);
					} else if (((key == 189 && !keyPressMap[45]) || (key == 190 && !keyPressMap[46])) && !e.shiftKey && !e.ctrlKey && !e.metaKey && !e.altKey) {
						onchar.apply(context || this, [e, key - 144]);					
					} else if (onshortcutchar && !shortcutCharactersPressed && isShortcutCombination(e, key, allowShiftCombinations, allowAltCombinations)) {
						onshortcutchar.apply(context || this, [e, key]);
					}

					if (keyDownMap[key]) {
						duration = new Date().getTime() - keyDownMap[key];
					}
				} else {
					var time = new Date().getTime();

					if (suppressControlKeyAutoRepeat) {
						if (keyDownMap[key]) {
							return;
						}
					} else if (lastKeyDown === key && key != 27 && key != 9) {
						lastKeyDownRepeat++;
					}

					if (autoRepeatModel == 'press') {
						lastControlKeyPressRepeat = 0;
					}

					if (lastKeyDown !== key || !lastKeyDownRepeat) {
						keyDownMap[key] = time;
					}
					lastKeyDown = key;
				}

				// Call key listener

				if (!lastKeyDownRepeat || autoRepeatModel != 'press' || e.type == 'keyup') {
					result = onkey.apply(context || this, [e, key, duration]);
				}

				if (e.type == 'keyup') {
					keyDownMap[key] = lastKeyDown = lastControlKeyPress = lastKeyDownRepeat = lastControlKeyPressRepeat = 0;
				} else if (onbeforeshortcutchar && isShortcutCombination(e, key, allowShiftCombinations, allowAltCombinations)) {
					if (onbeforeshortcutchar.apply(context || this, [e, key]) === false) {
						result = false;
					}
				}

				if (result === false) {
					return cancelDefault(e);
				}
			};

			attachListener(el, 'keyup', keyUpAndDownListener);
			attachListener(el, 'keydown', keyUpAndDownListener);

			el = null;
		};

		API.attachKeyboardListeners = attachKeyboardListeners;

		if (E && E.prototype) {
			E.prototype.onKeyboard = function(options) {
				attachKeyboardListeners(this.element(), options);
			};
		}

		if (D && D.prototype) {
			D.prototype.onKeyboard = function(options) {
				attachKeyboardListeners(this.node(), options);
			};
		}

		if (Q && Q.prototype) {
			Q.prototype.onKeyboard = function(options) {
				this.forEach(function(el) {
					attachKeyboardListeners(el, options);
				});
			};
		}
	})();
}