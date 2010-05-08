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

// Enables fixed positioning
// Not included in main script as conditional compilation fouls up minification
// Requires Offset, Position, Scroll and Event modules

var global = this;

if (this.API && typeof this.API == 'object' && this.API.attachDocumentReadyListener && this.API.attachWindowListener && this.API.canAdjustStyle && this.API.canAdjustStyle('position') && this.API.getDocumentWindow) {
	this.API.attachDocumentReadyListener(function() {
		var api = global.API;
		var attachWindowListener = api.attachWindowListener;
		var detachWindowListener = api.detachWindowListener;
		var absoluteElement = api.absoluteElement;
		var elementUniqueId = api.elementUniqueId;
		var getElementMarginsOrigin = api.getElementMarginsOrigin;
		var getElementPosition = api.getElementPosition;
		var getElementPositionStyle = api.getElementPositionStyle;
		var getPositionedParent = api.getPositionedParent;
		var getScrollPosition = api.getScrollPosition;
		var getStyle = api.getStyle;
		var htmlToViewportOrigin = api.htmlToViewportOrigin;
		var positionElement = api.positionElement;
		var viewportToHTMLOrigin = api.viewportToHTMLOrigin;
		var getElementDocument = api.getElementDocument;
		var getDocumentWindow = api.getDocumentWindow;
		var deltaY, deltaX, deltaScrollX, deltaScrollY, margins, posComp;
		var elementsFixed = {}, timeouts = {}, eventCounters = {};

		if (absoluteElement && getScrollPosition && positionElement) {
			api.fixElement = function(el, b, options, fnDone) {
				if (typeof b == 'undefined') {
					b = true;
				}
				options = options || {};
				var pos, y, x;
				var docNode = getElementDocument(el);
				var sp = getScrollPosition(docNode);
				var win = getDocumentWindow(docNode);
				var uid = elementUniqueId(el);
				var o = elementsFixed[uid];
				var bRevert = options.revert;
				var bWasFixed, fn, fnPos;

				if (!b) {
					if (!o) { // Not fixed yet
						return false;
					}

					pos = o.pos;

					deltaX = el.offsetLeft - o.offsetLeftFixed;
					deltaY = el.offsetTop - o.offsetTopFixed;

					if (o.sp) {
						sp = getScrollPosition(docNode);
						deltaScrollY = sp[0] - o.sp[0];
						deltaScrollX = sp[1] - o.sp[1];
					}

					bWasFixed = el.style.position == 'fixed';

					el.style.position = o.position;

					if (win && o.ev) {
						detachWindowListener('scroll', o.ev, win);
					}
					posComp = o.posComp;
					if (bRevert || !posComp || posComp == 'static') {
						el.style.left = o.left;
						el.style.top = o.top;
					}
					else {						
						switch(posComp) {
						case 'relative':
							if (o.pos && typeof deltaY == 'number') {
								o.pos[0] += deltaY; o.pos[1] += deltaX;
							}
							if (typeof deltaScrollY == 'number' && bWasFixed) {
								o.pos[0] += deltaScrollY; o.pos[1] += deltaScrollX;
							}
							pos = o.pos;
							break;
						case 'absolute':
							if (o.pos && typeof deltaY == 'number') {
								o.pos[0] += deltaY; o.pos[1] += deltaX;
								pos = o.pos;
								if (typeof deltaScrollY == 'number' && bWasFixed) {
									o.pos[0] += deltaScrollY; o.pos[1] += deltaScrollX;
								}
							}
							else {
								pos = getElementPositionStyle(el);
								if (htmlToViewportOrigin && o.viewportAdjust) { pos = htmlToViewportOrigin(pos, docNode); }
							}
						}
						positionElement(el, pos[0], pos[1]);
					}
					elementsFixed[uid] = null;
					return true;
				}

				if (o) { // Already fixed
					return false;
				}

				posComp = getStyle(el, 'position');

				margins = getElementMarginsOrigin ? getElementMarginsOrigin(el) : [0, 0];

				o = { position:el.style.position, left:el.style.left, top:el.style.top, posComp:posComp, offsetLeft:el.offsetLeft, offsetTop:el.offsetTop, pos:getElementPositionStyle(el), sp:getScrollPosition(docNode) };

				if (getPositionedParent(el)) {
					pos = getElementPosition(el);
					pos[0] -= margins[0];
					pos[1] -= margins[1];
				}
				else {
					switch(posComp) {
					case 'relative':
						pos = getElementPosition(el);
						pos[0] -= margins[0];
						pos[1] -= margins[1];
						break;
					case 'absolute':
						pos = getElementPositionStyle(el);
						break;
					default:
						absoluteElement(el);
						pos = getElementPositionStyle(el);
					}
				}

				y = pos[0];
				x = pos[1];

				var oldPos = [y, x];

				/*@cc_on @*/
				/*@if (@_jscript_version >= 5.7)
				try {
					el.style.position = 'fixed';
					if (el.currentStyle && el.currentStyle.position != 'fixed') throw(0);
					positionElement(el, y - sp[0], x - sp[1]);

					o.offsetLeftFixed = el.offsetLeft;
					o.offsetTopFixed = el.offsetTop;
					elementsFixed[uid] = o;

					return true;
				}
				catch(e) {
					if (!e) {
						el.style.position = '';
						el.style.position = 'absolute';
					}			
				}
				@else
				el.style.position = 'absolute'
				@end
				if (win) {
					y -= sp[0];
					x -= sp[1];

					fnPos = function() {
						var docNode = getElementDocument(el);
						var sp = getScrollPosition(docNode);

						oldPos = [y + sp[0], x + sp[1]];
						positionElement(el, y + sp[0], x + sp[1], { duration:options.duration, ease:options.ease }, function() { eventCounters[uid]--; });

						if (!positionElement.async) {
							eventCounters[uid]--;
						}
						timeouts[uid] = 0;
					};					


					fn = function() {
						if (!timeouts[uid]) {
							if (!eventCounters[uid]) {
								var pos2 = getElementPositionStyle(el);
								if (pos2[0] != oldPos[0] || pos2[1] != oldPos[1]) {
									y -= (oldPos[0] - pos2[0]);
									x -= (oldPos[1] - pos2[1]);
								}
								eventCounters[uid] = 1;
							}
							else {
		                                                eventCounters[uid]++;
							}
						}
						else {				
							global.clearTimeout(timeouts[uid]);
						}
						
						timeouts[uid] = global.setTimeout(fnPos, options.scrollTimeout || 100);
					};

					o.ev = fn;

					attachWindowListener('scroll', fn, win);
					win = null;

					positionElement(el, y + sp[0], x + sp[1]);

					elementsFixed[uid] = o;
					o.offsetLeftFixed = el.offsetLeft;
					o.offsetTopFixed = el.offsetTop;
					return true;
				}
				return false;
				@*/
				if (el.style.position != 'fixed') {
					el.style.position = 'fixed';
					if (viewportToHTMLOrigin) {
						pos = viewportToHTMLOrigin(pos, docNode);
						o.viewportAdjust = true;
					}
					positionElement(el, pos[0] - sp[0], pos[1] - sp[1]);

					elementsFixed[uid] = o;
					o.offsetLeftFixed = el.offsetLeft;
					o.offsetTopFixed = el.offsetTop;

					return true;
				}
				return false;
			};
		}
		api = null;
	});
}

var API,E,Q;if(API&&API.getAnElement&&API.map){(function(){var K=API.getAnElement;var J=K();var L=function(d,c){if(!c){c=K()}if(c&&typeof c.style[d]!="string"){d=d.charAt(0).toUpperCase()+d.substring(1);var e=["Moz","O","Khtml","Webkit","Ms"];for(var b=e.length;b--;){if(typeof c.style[e[b]+d]!="undefined"){return e[b]+d}}return null}return d};API.findProprietaryStyle=L;var Z=API.elementUniqueId,a=API.isHostObjectProperty,X=API.map,S=API.forEach;var U=L("transform",J),R=U+"Origin";var P,M,W,T,G=[1,0,0,1],O;var N={},Y={};var A=/progid:DXImageTransform.Microsoft.Matrix\s*\([^\)]+\)/,H=/%$/;var C,B;var V=Math.PI;var D=function(b){return b*V/180};var F=function(c,b){return[c[0]*b[0]+c[1]*b[2],c[0]*b[1]+c[1]*b[3],c[2]*b[0]+c[3]*b[2],c[2]*b[1]+c[3]*b[3]]};var I={skew:function(b){return[1,Math.tan(D(b)),Math.tan(D(b)),1]},skewX:function(b){return[1,0,Math.tan(D(b)),1]},skewY:function(b){return[1,Math.tan(D(b)),0,1]},rotate:function(c){var b=D(c);return[Math.cos(b),Math.sin(b),-Math.sin(b),Math.cos(b)]},scale:function(b){return[b,0,0,b]},scaleX:function(b){return[b,0,0,1]},scaleY:function(b){return[1,0,0,b]},flip:function(b){return[-1,0,0,-1]},flipH:function(b){return[-1,0,0,1]},flipV:function(b){return[1,0,0,-1]}};if(U){if(J&&typeof J.style[U]=="string"){O=(function(){var b=API.createElement("div");b.style[U]="matrix(1,0,0,1,0,0)";return !b.style[U]})}P=function(f){var d,b,g,c=f.style[U];if(typeof c=="string"){if(O&&(b=N[Z(f)])){return b}d=c.match(/matrix\(([\.\d]+),([\.\d]+),([\.\d]+),([\.\d]+),([\.\d]+,)?([\.\d]+)?\)/i);if(d){return X(d.slice(1,5),function(e){return +e})}}else{if(c&&API.isHostMethod(c,"getCSSMatrix")){try{b=c.getCSSMatrix()}catch(h){}if(b){S(["a","b","c","d"],function(e){if(isNaN(b[e])){g=true}});if(!g){return[b.a,b.b,b.c,b.d]}}}}return G.slice(0)};M=function(c,b){if(O){N[Z(c)]=b}c.style[U]=["matrix(",b[0].toFixed(8),",",b[1].toFixed(8),",",b[2].toFixed(8),",",b[3].toFixed(8),",0,0)"].join("")};T=function(c,b){Y[Z(c)]=b;c.style[R]=b.reverse().join(" ")};W=function(c,b,d){return Y[Z(c)]||["50%","50%"]}}else{if(J&&a(J,"filters")&&a(J,"style")&&typeof J.style.filter=="string"){P=function(c){var b=c.filters["DXImageTransform.Microsoft.Matrix"];if(b){return[b.M11,b.M21,b.m12,b.m22]}return G.slice(0)};M=function(e,b,f){var c=["progid:DXImageTransform.Microsoft.Matrix(M11=",b[0].toFixed(8),",","M12=",b[2].toFixed(8),",","M21=",b[1].toFixed(8),",","M22=",b[3].toFixed(8),",sizingMethod='auto expand'",")"].join("");if(!f&&e.currentStyle&&!e.currentStyle.hasLayout){e.style.zoom="1"}var d=e.style.filter;if(!d){e.style.filter=c}else{if(A.test(d)){e.style.filter=d.replace(A,c)}else{e.style.filter+=" "+c}}}}}if(M){B=function(c,b){M(c,C(b))};API.setElementTransformMatrix=function(c,b){M(c,b)};API.getElementTransformMatrix=function(c,b){return P(c)};C=function(d){var c=G.slice(0),b;for(var e in d){if(API.isOwnProperty(d,e)&&(b=I[e])){c=F(c,b(d[e]))}}return c};API.setElementTransform=B;if(T){API.getElementTransformOrigin=function(b){return W(b)};API.setElementTransformOrigin=function(c,b){T(c,b)}}API.attachDocumentReadyListener(function(){var r,g,h,m,q;var f=function(t,u){var v={},i={},s=API.effects["transform"+t];return function(AB,x,y,AD){var AC,z,AA,w=function(){v[z]=null;if(i[z]){i[z](AB)}};if(y&&y.duration){z=Z(AB);if(v[z]){v[z].stop(true)}AA=new API.EffectTimer();y.effects=s;AC=y.effectParams||{};AC["target"+(t||"Transform")]=x;y.effectParams=AC;i[Z(AB)]=AD;v[z]=AA;AA.start(AB,y,w)}else{u(AB,x);if(AD){AD(AB)}}}};if(API.effects){m=API.effects.transform=(function(){var u,t,v,s;return function(w,y,x,i){if(i==1){if(x.transform){x.matrix=C(x.transform)}else{if(!x.targetTransform){t={};v={};for(u=x.transformOperations.length;u--;){s=x.transformOperations[u];switch(s){case"flip":case"flipH":case"flipV":t[s]=true;break;case"scale":case"scaleX":case"scaleY":t[s]=0;v[s]=1;break;case"rotate":t.rotate=90;v.rotate=0;break;case"skew":case"skewX":case"skewY":t[s]=45;v[s]=0}}x.matrix=C(t);x.targetTransform=v}else{x.matrix=P(w)}}x.targetMatrix=C(x.targetTransform)}q(w,y,x,i)}})();API.effects.transformOrigin=(function(){var t,i,u,s;return function(w,y,x,v){switch(v){case 1:t=x.origin||W(w);i=x.targetOrigin;u=H.test(t[0]);s=H.test(i[0]);if(u&&s||!u&&!s){t[0]=parseFloat(t[0]);i[0]=parseFloat(i[0]);x.originXPercent=u;u=H.test(t[1]);s=H.test(i[1]);if(u&&s||!u&&!s){t[1]=parseFloat(t[1]);i[1]=parseFloat(i[1]);x.originYPercent=u;x.sourceOrigin=t;x.targetOrigin=i}}w.style.visibility="visible";break;case 3:h(w,x.origin);return }i=x.targetOrigin;if(x.sourceOrigin){t=x.sourceOrigin;h(w,[(t[0]+(i[0]-t[0])*y)+(x.originXPercent?"%":""),(t[1]+(i[1]-t[1])*y)+(x.originXPercent?"%":"")])}else{h(w,[i[0],i[1]])}}})();q=API.effects.transformMatrix=(function(){var u,t,v,s;return function(w,y,x,i){switch(i){case 1:if(!x.matrix){x.matrix=P(w)}w.style.visibility="visible";break;case 3:g(w,x.targetMatrix,true);return }t=[];v=x.matrix;s=x.targetMatrix;for(u=4;u--;){t[u]=(v[u]+(s[u]-v[u])*y)}g(w,t,true)}})();g=M;API.setElementTransformMatrix=M=f("Matrix",M);M.async=true;r=B;API.setElementTransform=B=f("",B);B.async=true;if(T){h=T;API.setElementTransformOrigin=T=f("Origin",T);T.async=true}var o=function(s,u,t,i){if(i==1){switch(t.axes){case 1:t.transformOperations=["flipV"];break;case 2:t.transformOperations=["flipH"];break;default:t.transformOperations=["flip"]}}m(s,u,t,i)};API.effects.flip=o;API.effects.flipH=function(s,u,t,i){if(i==1){t.axes=2}o(s,u,t,i)};API.effects.flipV=function(s,u,t,i){if(i==1){t.axes=1}o(s,u,t,i)};var d=function(s,u,t,i){if(i==1){switch(t.axes){case 1:t.transformOperations=["scaleY"];break;case 2:t.transformOperations=["scaleX"];break;default:t.transformOperations=["scale"]}}m(s,u,t,i)};API.effects.scale=d;API.effects.scaleX=function(s,u,t,i){if(i==1){t.axes=2}d(s,u,t,i)};API.effects.scaleY=function(s,u,t,i){if(i==1){t.axes=1}d(s,u,t,i)};var c=function(s,u,t,i){if(i==1){switch(t.axes){case 1:t.transformOperations=["skewY"];break;case 2:t.transformOperations=["skewX"];break;default:t.transformOperations=["skew"]}}m(s,u,t,i)};API.effects.skew=c;API.effects.skewX=function(s,u,t,i){if(i==1){t.axes=2}c(s,u,t,i)};API.effects.skewY=function(s,u,t,i){if(i==1){t.axes=1}c(s,u,t,i)};API.effects.rotate=function(s,u,t,i){if(i==1){t.transformOperations=["rotate"]}m(s,u,t,i)};API.effects.spin=(function(){var t,i,s=I.rotate;return function(v,x,w,u){switch(u){case 1:w.matrix=P(v);if(w.spin){w.matrix=F(w.matrix,s(w.spin))}else{w.spin=0}if(!w.targetSpin){w.targetSpin=360}v.style.visibility="visible";break;case 3:g(v,w.matrix,true);return }t=w.spin;i=w.targetSpin;g(v,F(w.matrix,s(t+(i-t)*x)),true)}})();var l,n,k=["flip","flipH","flipV","skew","skewX","skewY","scale","scaleX","scaleY","rotate","spin","transform"];var j=API.showElement,e=API.effects;var p=function(t,i){var s=e[t];return function(u,v){u.effects=s;j(this.element(),i,u,v);return this}};var b=function(t,i){var s=e[t];return function(u,v){u.effects=s;this.forEach(function(w){j(w,i,u,v)});return this}};if(j){if(E&&E.prototype){for(l=k.length;l--;){n=k[l];E.prototype[n+"In"]=p(n,true);E.prototype[n+"Out"]=p(n,false)}}if(Q&&Q.prototype){for(l=k.length;l--;){n=k[l];Q.prototype[n+"In"]=b(n,true);Q.prototype[n+"Out"]=b(n,false)}}}}});if(E&&E.prototype){E.prototype.setTransform=function(c,b,d){B(this.element(),c,b,d);return this};E.prototype.getTransformMatrix=function(){return P(this.element())};E.prototype.setTransformMatrix=function(c,b,d){M(this.element(),c,b,d);return this};if(T){E.prototype.setTransformOrigin=function(b,c,d){T(this.element(),b,c,d);return this}}}if(Q&&Q.prototype){Q.prototype.setTransform=function(c,b,d){this.forEach(function(e){B(e,c,b,d)});return this};Q.prototype.setTransformMatrix=function(b,c,d){this.forEach(function(e){M(e,b,c,d)});return this};if(T){Q.prototype.setTransformOrigin=function(b,c,d){this.forEach(function(e){T(e,b,c,d)});return this}}}}J=null})()}

var API,global=this;if(API){(function(){var J=API,B=J.setAttribute,M=J.getAttribute,N=J.removeAttribute,K=J.addClass,Q=J.removeClass,F=J.hasClass,I=J.elementUniqueId;var L,C,E,P,A={};var D,O;var H=function(R){if(/^(true|false)$/.test(R)){return R=="true"}return R};if(B){J.getControlRole=function(R,S){return M(R,"role")};J.setControlRole=function(R,S){B(R,"role",S)};J.getWaiProperty=P=function(S,R){return M(S,"aria-"+R)};J.setWaiProperty=E=function(S,R,T){B(S,"aria-"+R,T)};L=function(S,R,T){E(S,R,T.toString())};C=function(S,R){return H(P(S,R))};J.removeWaiProperty=function(S,R){N(S,"aria-"+R)}}else{L=function(S,R,T){if(!A[R]){A[R]={}}A[R][I(S)]=T.toString()};C=function(S,R){if(!A[R]){A[R]={}}return H(A[R][I(S)])}}J.setControlState=L;J.getControlState=C;if(K||L){D=function(R){var S=new RegExp("\\s+\\("+R+"\\)");return function(U,T){if(typeof T=="undefined"){T=true}if(K){if(T){K(U,R)}else{Q(U,R)}}if(L){L(U,R,T)}if(typeof U.title=="string"&&U.title){U.title=U.title.replace(S,"");if(T){U.title+=" ("+R+")"}}}};O=function(R){return function(S){if(F){return F(S,R)}return C(S,R)}};J.disableControl=D("disabled");J.pressControl=D("pressed");J.checkControl=D("checked");J.selectControl=D("selected");J.isControlDisabled=O("disabled");J.isControlPressed=O("pressed");J.isControlChecked=O("checked");J.isControlSelected=O("selected")}var G;if(Function.prototype.call){G=function(U,V,T,S,R){return U.call(V,T,S,R)}}else{G=function(V,W,U,T,S){W._mylibWidgetCallTemp=V;var R=W._mylibWidgetCallTemp(U,T,S);delete W._mylibWidgetCallTemp;return R}}J.callInContext=G;if(J.attachDocumentReadyListener){J.attachDocumentReadyListener(function(){var X,a=API;var Z=a.setStyle,e=a.findProprietaryStyle,W=a.showElement,V,b,T,d,U;if(e){d=e("userSelect")}if(d&&Z){U=function(g,f){if(typeof f=="undefined"){f=true}Z(g,d,f?"none":"")}}else{if(B&&(typeof global.document.expando=="undefined"||global.document.expando)){U=function(g,f){if(typeof f=="undefined"){f=true}B(g,"unselectable",f?"on":"off")}}}API.makeElementUnselectable=U;if(W){if(e&&(V=e("transition"))){b=V+"Property";T=V+"Duration";X=function(j,f,i,l){if(!i){i={}}var h=i.keyClassName;var g=i.useCSSTransitions;var k=i.ondone||l;if(V){if(typeof g=="undefined"){g=!!i.effects}}if(g){j.style[T]=((i.duration||0)/1000)+"s"}else{}if(f||typeof f=="undefined"){j.style.visibility="hidden"}if(K){if(g){Q(j,"animated");if(h){Q(j,h)}K(j,"animated")}else{if(F(j,"animated")){Q(j,"animated");if(T){j.style[T]="0s"}}}}if(g&&h){K(j,h)}global.setTimeout(function(){W(j,f,{removeOnHide:true,effects:g?null:i.effects,duration:i.duration,ease:i.ease,fps:i.fps,effectParams:i.effectParams},function(){if(g&&Q){Q(j,"animated")}if(k){k(j,f)}});L(j,"hidden",typeof f!="undefined"&&!f);if(k&&!W.async){k(j,f)}},1)}}else{X=function(h,f,g,i){W(h,f,{removeOnHide:true,effects:g.effects,duration:g.duration,ease:g.ease,fps:g.fps,effectParams:g.effectParams},i);L(h,"hidden",typeof f!="undefined"&&!f)}}X.async=W.async}a.showControl=X;var R=a.attachDrag,c=a.detachDrag;if(R){var S=function(g,h,f){return function(){if(K){K(g,"dragging")}if(h){G(h,f,g)}}};var Y=function(g,h,f){return function(){if(Q){Q(g,"dragging")}if(h){G(h,f,g)}}};a.attachDragToControl=function(g,h,f){if(!f){f={}}R(g,h,{ghost:false,ondragstart:S(g,f.ondragstart,f.callbackContext||API),ondrop:Y(g,f.ondragstart,f.callbackContext||API)});if(K){K(h||g,"draggable")}};a.detachDragFromControl=function(f,g){c(f,g);if(Q){Q(g||f,"draggable")}}}if(a.setElementText){a.setControlContent=function(g,f){if(API.setElementHtml&&f.html){API.setElementHtml(g,f.html)}else{if(API.setElementNodes&&f.nodes){API.setElementNodes(g,f.nodes)}else{API.setElementText(g,f.text||"")}}}}if(a.getWorkspaceRectangle&&a.positionElement&&a.getScrollPosition){a.cornerControl=function(h,m,o,n,l){var k,i,j;if(!o){o={}}n=o.callback||n;if(!l&&API.getElementDocument){l=API.getElementDocument(h);if(!l){return false}}var f=API.getWorkspaceRectangle(l);switch(m){case"topleft":k=f[0];i=f[1];break;case"topright":k=f[0];i=f[1]+f[3]-h.offsetWidth;break;case"bottomleft":k=f[0]+f[2]-h.offsetHeight;i=f[1];break;case"bottomright":k=f[0]+f[2]-h.offsetHeight;i=f[1]+f[3]-h.offsetWidth}if(o.offset){k+=o.offset[0];i+=o.offset[1]}if(h.style.position=="fixed"){var g=API.getScrollPosition(l);k-=g[0];i-=g[1]}if(n){j=function(){G(n,o.callbackContext||API)}}API.positionElement(h,k,i,o,j);if(n&&!API.positionElement.async){j()}return[k,i]}}a=null})}J=null})()}

var API,global=this;if(API&&API.attachDocumentReadyListener){API.attachDocumentReadyListener(function(){var K=API,B=K.isOwnProperty;var S,Q={"stop":"audio/beverly_computers.wav",caution:"audio/thunder.wav",info:"audio/bird1.wav",startup:"audio/rooster.wav",shutdown:"audio/crickets.wav",toast:"audio/toast.wav"};var M=K.playAudio,I=K.preloadAudio,R=K.callInContext;if(M&&R){K.playEventSound=function(T,U,W,V){if(Q[T]){M(Q[T],10000,W,V,100)}};K.addEventSound=function(U,T){Q[U]=T};K.removeEventSound=function(U,T){delete Q[U]};K.getAudioEvents=function(){var T=[];for(var U in Q){if(B(Q,U)){T[T.length]=U}}return T};if(K.preloadAudio){K.preloadAudioScheme=function(){for(var T in Q){if(B(Q,T)){I(Q[T])}}}}var N=[],L,H,G,P,E,O,C;var D,A,J;K.loadPlaylist=function(){N=[];N.length=arguments.length;for(var T=arguments.length;T--;){N[T]=arguments[T]}H=0};K.clearPlaylist=function(){if(P){API.stopPlaylist()}N=[]};var F=function(T){global.clearTimeout(L);G=0;H=T;M(N[T].source,N[T].duration,null,null,100);if(J){R(J,S||API,T)}L=global.setTimeout(function(){if(!G){var U=T+1;if(U<N.length){F(U)}else{if(C){if(D){R(D,S||API,T)}F(0)}else{if(A){R(A,S||API)}P=false}}}},N[T].duration);O=new Date().getTime();P=true};K.playPlaylist=function(T){if(!T){T={}}if(N.length){if(T){C=T.autoRepeat;J=T.onstart;A=T.onstop;D=T.onrepeat;S=T.callbackContext;if(T.restart){H=0}}F(H);E=new Date().getTime();return true}return false};K.stopPlaylist=function(T){global.clearTimeout(L);if(T){G=1}else{API.stopAudio();P=false;G=0;if(A){R(A,S||API)}}};K.isPlaylistStoppingAfterCurrent=function(){return !!G};K.getPlaylist=function(){return N.slice(0)};K.getPlaylistIndex=function(){return H};K.getPlaylistDuration=function(){var T,U=0;for(T=N.length;T--;){U+=N[T].duration}return U};K.getPlaylistProgress=function(){};K.getPlaylistTrackDuration=function(){return N[H].duration};K.getPlaylistTrackProgress=function(){if(N.length&&P){var U=N[H].duration;var T=(new Date().getTime()-(O||0))/U;return Math.min(T,100)}return 0};K.gotoPlaylistTrackNext=function(){if(N.length&&H<N.length-1){H++;if(P){F(H)}return true}return false};K.gotoPlaylistTrackPrevious=function(){if(N.length&&H){H--;if(P){F(H)}return true}return false};K.gotoPlaylistTrackFirst=function(){if(N.length&&H){H=0;if(P){F(H)}return true}return false};K.gotoPlaylistTrackLast=function(){if(N.length&&H!=N.length-1){H=N.length-1;if(P){F(H)}return true}return false};K.gotoPlaylistTrack=function(T){if(N.length&&T>0&&T<=N.length){H=T;if(P){F(H)}return true}return false}}K=null})}

var API,global=this;if(API&&typeof API=="object"&&API.areFeatures&&API.areFeatures("attachListener","createElement","setElementText","setControlState")){API.attachDocumentReadyListener(function(){var f=API;var At=f.isHostMethod;var Az=f.canAdjustStyle;var Ar=f.cancelDefault;var AT=f.createElement;var Ad=f.showElement;var BE=f.attachListener;var H=f.attachDocumentListener;var AN=f.getEventTarget,x=f.getEventTargetRelated;var A6=f.getKeyboardKey;var d=f.attachDrag,AC=f.attachDragToControl;var w=f.detachDragFromControl;var P=f.centerElement;var AM=f.coverDocument;var Ag=f.constrainPositionToViewport;var Au=f.maximizeElement;var A1=f.restoreElement;var BB=f.setElementText;var AX=f.positionElement;var BL=f.sizeElement;var BC=f.fixElement;var m=f.getChildren;var BD=f.addClass;var BJ=f.removeClass;var BU=f.hasClass;var A8=f.getElementPositionStyle;var A9=f.getElementSizeStyle;var W=f.getElementParentElement;var l=f.getScrollPosition;var O=f.makeElementUnselectable;var Aw=f.callInContext;var BR,AK,a,L;var BM,E=AT("div");var BN=AT("div");var BG=AT("input");var t=AT("fieldset");var AG,BV,As,Aq,BA,Ao,AW,An,A5,Ap;var e=f.getBodyElement();var G,n,h,M,Ab;var AQ={};var C,BH,AF,Ae,A7,Ay,j,BS,A4,Av,o,Y,J,B,BK,BT,AV,BO,AU;var R,Am,b,AP,Ak,S,A0,AD,AJ,K,T,AZ,Al,s,Ai,Ac,k,p,BF,AE,AA,AY;var A=f.setControlRole,BQ=f.setWaiProperty,F=f.removeWaiProperty,v=f.setControlContent;var AR=f.disableControl,r=f.isControlDisabled,BP=f.checkControl,y=f.isControlChecked,AL=f.showControl;var I,c,Aj;var g,A3;var z,AB,AS;var AI=f.playEventSound,Ah=f.cornerControl;if(AI){A3=function(){var BX,BW=n.duration;if(!n.effects){BW=0}if(n.className.indexOf("stop")!=-1){BX="stop"}else{if(n.className.indexOf("caution")!=-1){BX="caution"}else{if(n.icon!==false){BX="info"}}}if(BX){global.setTimeout(function(){AI(BX)},BW)}}}var q=function(BZ,BY,BX,BW){return Aw(BZ,AU||API,BY,BX,BW)};var i=function(BX,BW){return BX+(BW?" [Ctrl+"+BW+"]":"")};var V=function(BY,BW){var BX=AT("div");if(BX){BX.title=i(BY,BW);BX.className=BY.toLowerCase()+" button captionbutton";if(A){A(BX,"button")}E.appendChild(BX)}return BX};var X=function(BX,BY){var BW=AT("input");if(BW){BW.className="commandbutton button";BW.type="button";BW.value=BX;if(BY){t.insertBefore(BW,BG)}else{t.appendChild(BW)}if(Aj){Aj(BW)}}return BW};if(AC){Al=function(BW){(BW?w:AC)(E,BR,{ondragstart:J,ondrop:B})}}var AO;var U=function(BW){if(BW){BM.style.display="block";AM(BM);if(BC&&!AO){BC(BM);AO=true}if(BD){if(M.ease){BD(BM,"ease");BD(BM,"in");BJ(BM,"out")}else{BJ(BM,"ease")}}if(BD){BD(BM,"drawn")}M.keyClassName="drawn";AL(BM,true,M)}else{if(BJ){BJ(BM,"drawn");if(n.ease){BJ(BM,"in");BD(BM,"out")}}AL(BM,false,M)}};T=function(BW){if(BR){if(BF){BR.title="Double-click to "+(BW?"restore":"maximize")}else{if(Aq){BR.title=BW?"Double-click to restore":""}}}};AZ=function(BW){if(BD){if(BW){BJ(As,"maximizebutton");BD(As,"restorebutton")}else{BJ(As,"restorebutton");BD(As,"maximizebutton")}}As.title=i(!BW?"Maximize":"Restore",".");if(r(As)){As.title+=" (disabled)"}};K=function(BW){if(Aq){AR(Aq,BW)}if(As){AR(As,!BW&&!BF)}if(As){if(BW){AZ(!G);if(p&&BR){T(!G)}}else{AZ(G);if(p&&BR){T(G)}}}};AD=function(BX,BW){BX.style.visibility=(BW)?"hidden":""};AJ=function(BW){if(AK){AD(AK,BW)}if(a){AD(a,BW)}if(L){AD(L,BW)}};s=function(BW){if(p){AJ(BW)}if(BR){if(p){T(BW)}Al(BW)}if(As){AZ(BW)}if(AG){AR(AG,BW)}};if(Au){if(BU){S=function(BW){return BU(BW,"captionbutton")}}else{S=function(BW){return BW==Aq||BW==As||BW==BA||BW==AG}}A0=function(BW){var BY,BZ,BX=m(E);BY=BX.length;while(BY--){BZ=BX[BY];if(!S(BZ)&&BZ!=BR&&BZ!=BV){BZ.style.display=(BW||(BZ==t&&!AY))?"none":""}}};var N=function(){if(AP){global.setTimeout(AP,10)}};Ai=function(BW,BX){if(BW){AQ.pos=A8(E);AQ.dim=A9(E);if(BD){BJ(E,"maximized");BD(E,"minimized")}if(BR){Al(false)}if(BW&&BT){q(BT,E)}}else{if(!G){if(AG&&y(AG)){if(E.style.position!="fixed"){Ag(AQ.pos)}}AX(E,AQ.pos[0],AQ.pos[1],h);BL(E,AQ.dim[0],AQ.dim[1],h,N);if(!BL.async){N()}}if(BJ){BJ(E,"minimized")}if(BR){Al(G)}}A0(BW);if(!BW&&G){A1(E);Ac(true)}if(BW){E.style.height=E.style.width=""}K(BW)};Ac=function(BW){var BX=function(){if(BD){(BW?BD:BJ)(E,"maximized")}if(AP){global.setTimeout(AP,10)}};(BW?Au:A1)(E,h,BX);s(BW);if(BW&&BK){q(BK,E)}G=BW;if(!Au.async){BX()}};k=function(){var BW;if(Aq&&AE&&AQ.dim&&r(Aq)){Ai(false);BW=true}else{if(G){Ac(false);BW=true}else{BW=false}}if(BW&&AV){q(AV,E)}return BW};f.maximizeAlert=function(){if(!G){Ac(true);return true}return false};f.restoreAlert=k;f.minimizeAlert=function(){if(Aq&&AE&&!r(Aq)){Ai(true);return true}return false}}function u(){return !BH||!q(BH,E)}function AH(){return !AF||!q(AF,E)}function Af(){return !Ae||!q(Ae,E)}function Ax(BW){switch(AA){case"confirm":case"yesno":case"dialog":return(BW?u:AH)();case"yesnocancel":if(typeof BW=="undefined"){return Af()}return(BW?u:AH)()}}function BI(){if(BM){U(false)}Ad(E,false,n)}function Z(BY){var BX,BW;if(Ab){if(BY){if(A7&&q(A7,E)===false){return false}R=false}if(Ay&&q(Ay,E)===false){return false}if(!j){BI();BX=true}else{BW=q(j,E,n,G);if(typeof BW=="undefined"){BI();BX=true}else{BX=BW}}if(BX){Ab=false}return !Ab}return false}if(Ad&&P&&BL&&l&&E&&BG&&t&&BN&&e&&At(global,"setTimeout")){f.dismissAlert=Z;f.getAlertElement=function(){return E};f.isAlertOpen=function(){return Ab};f.isAlertModal=function(){return Ab&&!b};f.setAlertTitle=function(BW){if(BR){BB(BR,BW)}};f.deactivateAlert=c=function(){if(BD){BD(E,"background")}if(Av){q(Av,E)}Am=true};f.activateAlert=I=function(){if(BJ){BJ(E,"background")}if(A4){q(A4,E)}Am=false};if(At(BG,"focus")){Aj=function(BW){BE(BW,"focus",function(BZ){if(Ak){global.clearTimeout(Ak)}var Ba=x(BZ);var BY=Ba;while(Ba&&Ba!=t){Ba=W(Ba)}var BX=true;if(!Ba&&o){BX=q(o,BW,BY)!==false}if(BX){I()}else{this.blur();return Ar(BZ)}});BE(BW,"blur",function(BX){if(!b){Ak=global.setTimeout(function(){var BY=true;if(Y){BY=q(Y,BW,x(BX))!==false}if(BY){if(!Aq||!AE||!r(Aq)){c()}}else{this.focus();return Ar(BX)}},100)}})}}if(Aj){Aj(BG)}f.focusAlert=AP=function(){if(Ab&&E.style.visibility=="visible"&&t.style.display!="none"){BG.focus()}I()};var Q=function(BW){if(!BW.disabled&&BW.style.display!="none"){BW.blur()}};f.blurAlert=function(){if(E.style.visibility=="visible"&&t.style.display!="none"){BG.blur();if(AW){Q(AW)}if(An){Q(An)}if(A5){Q(A5)}if(Ap){Q(Ap)}if(Ao){Q(Ao)}}if(c){c()}};var D,Aa;if(BD){f.flashAlert=function(BW){if(!BW){BW=3}if(D){global.clearInterval(D)}Aa=0;BD(E,"background");D=global.setInterval(function(){if(D){Aa++;((Aa%2)?BJ:BD)(E,"background");if(Aa==BW*2-1){global.clearInterval(D);D=0}}},400)}}BE(E,"click",function(BX){var BW;if(Ak){global.clearTimeout(Ak);Ak=null}if(Am){I();BW=true}var BY=AN(BX);if(BW&&AP&&(BY==this||BY==BN||BY==t||BY==BV||BY==BR||BY==AK||BY==a||BY==L)){AP()}});f.setAlertDirty=function(BW,BX){if(AA=="dialog"&&!AB){if(typeof BX=="boolean"){BG.value=BW?"Close":"OK";if(AW){AW.disabled=BW}}if(A5){A5.disabled=!BW}R=BW;return true}return false};f.isAlertModal=function(){return Ab&&b};if(AM){BM=AT("div");BM.className="curtain";BM.style.display="none";BM.style.visibility="hidden"}if(BQ){BN.id="mylibalertcontent"}if(Al){BR=AT("div");if(BR){BR.className="movehandle";E.appendChild(BR);if(O){O(BR)}E.style.position="absolute";Al(false);if(Ac){As=V("Maximize",".");if(As){BE(As,"click",function(BW){if(BF||!r(this)){if(!k()){Ac(true)}}})}BE(BR,"dblclick",function(BW){if(BF||!r(As)){if(!k()){Ac(true)}return Ar(BW)}})}BV=AT("div");if(BV){BV.className="icon";if(A){A(BV,"button")}BE(BV,"dblclick",function(){if(!BA||!r(BA)){Z(false)}});BE(BV,"click",function(){if(BS){q(BS,E)}});E.appendChild(BV)}BA=V("Close");if(BA){BE(BA,"click",function(){if(!r(this)){Z(false)}})}if(m&&Az&&Az("display")&&Ai){Aq=V("Minimize",",");if(Aq){BE(Aq,"click",function(){if(!r(this)){Ai(true)}})}}if(BC){AG=V("Fix");if(AG){BP(AG,false);BE(AG,"click",function(BW){if(!r(this)){if(!y(this)){BP(this);if(BD){BD(E,"fixed")}this.title="Detach";BC(E,true,h)}else{BP(this,false);if(BJ){BJ(E,"fixed")}this.title="Fix";BC(E,false,h)}if(AE&&Aq&&r(Aq)&&AQ.pos){AQ.pos=A8(E)}if(AP){global.setTimeout(AP,10)}}})}}if(BL){a=AT("div");if(a){a.className="sizehandleh";E.appendChild(a);d(E,a,{mode:"size",axes:"horizontal"})}L=AT("div");if(L){L.className="sizehandlev";E.appendChild(L);d(E,L,{mode:"size",axes:"vertical"})}AK=AT("div");if(AK){AK.className="sizehandle";E.appendChild(AK);d(E,AK,{mode:"size"})}}}}BN.className="content";E.appendChild(BN);BG.type="button";BG.value="Close";BG.className="commandbutton close";t.appendChild(BG);An=X("No");AW=X("Cancel");A5=X("Apply");Ap=X("Previous",true);Ao=X("Help");E.appendChild(t);E.style.position="absolute";Ad(E,false);AX(E,0,0);BE(BG,"click",function(){if(AB){if(z<AB){if(q(BO,z+1,z)!==false){z++;g()}}else{if(!AA||Ax(true)){Z(true)}}}else{if(!AA||Ax(true)){Z(R)}}});if(BM){e.appendChild(BM);if(AP){BE(BM,"click",function(){AP()})}}e.appendChild(E);if(H&&A6){var A2;H("keydown",function(BW){A2=(Ab&&!Am)});H("keyup",function(BY){var BZ,BX,BW;if(Ab&&!BY.shiftKey&&!BY.metaKey&&(!Am||A2)){BX=A6(BY);switch(BX){case 27:if(!BY.ctrlKey){if(!BA||!r(BA)||Ax()){Z(false);return Ar(BY)}}break;case 13:if(!BY.ctrlKey){BZ=AN(BY);BW=BZ.tagName;if(BZ.type=="text"&&/^input$/i.test(BW)){while(BZ&&BZ!=t){BZ=W(BZ)}if(BZ&&(!AA||Ax(true))){Z(R);return Ar(BY)}}}break;default:if(Ac&&p&&BY.ctrlKey){switch(BX){case 190:if(BF&&!k()){Ac(true)}break;case 188:if(AE&&Aq&&!r(Aq)){Ai(true)}}}}A2=false}})}if(Ao){BE(Ao,"click",function(){if(C){C()}})}if(AW){BE(AW,"click",function(){if(Ax()){Z(false)}})}if(An){BE(An,"click",function(){if(Ax(false)){Z(false)}})}if(A5){BE(A5,"click",function(){if(!A7||q(A7,E)!==false){R=false;this.disabled=true;if(BG.value=="Close"){BG.value="OK";if(AW){AW.disabled=false}}}})}g=function(){Ap.disabled=z==1;BG.value=z==AB?"Finish":"Next"};if(Ap){BE(Ap,"click",function(){if(AB&&z){if(q(BO,z-1,z)!==false){z--;g()}}})}f.alert=function(Bg,BY){if(AS){global.clearTimeout(AS);AS=0}var Bn,Bc,Bm,Bq,Be,BZ,BX,Bl;BY=BY||{};if(BY.effects&&typeof BY.duration=="undefined"){BY.duration=400}n=BY;h={duration:BY.duration,ease:BY.ease,fps:BY.fps};M=BY.curtain||{};AA=BY.decision;AY=BY.buttons!==false;Bc=BY.captionButtons!==false;Bm=BY.icon!==false;BO=BY.onstep;if(BO&&AA=="dialog"){AB=BY.steps;if(AB>1){z=1}else{AB=0}}else{AB=0}if(A){A(E,AA=="dialog"?"dialog":"alertdialog");if(AA=="dialog"){F(E,"described-by")}else{BQ(E,"described-by","mylibalertcontent")}}if(Ao){C=BY.onhelp;Ao.style.display=(C)?"":"none"}if(AW){AW.style.display=(AA&&AA!="yesno")?"":"none"}if(Ap){Ap.style.display=AB?"":"none";g()}if(An){An.style.display=(AA=="yesno"||AA=="yesnocancel")?"":"none"}if(BA){AR(BA,!!AA&&AA!="dialog")}if(BV){BV.title=(AA&&AA!="dialog")?"":"Double-click to close";if(A){A(BV,AA?"":"button")}BV.style.visibility=(!Bc||!Bm||!BD)?"hidden":""}var Bh=+BY.autoDismiss;if(Bh){AS=global.setTimeout(function(){if(AS&&Ab){Z(false)}},Bh)}BH=BY.onpositive;Ae=BY.onindeterminate;AF=BY.onnegative;BS=BY.oniconclick;o=BY.onfocus;Y=BY.onblur;A4=BY.onactivate;Av=BY.ondeactivate;BK=BY.onmaximize;BT=BY.onminimize;AV=BY.restore;J=BY.ondragstart;B=BY.ondrop;AU=BY.callbackContext;if(AW){AW.disabled=false}if(A5){R=false;A5.disabled=true;A7=BY.onsave;A5.style.display=(!AB&&A7&&AA=="dialog")?"":"none"}BG.value=AA?((AA.indexOf("yes")!=-1)?"Yes":(AB?"Next":"OK")):"Close";if(BR){Bq=BY.title;Be=typeof Bq=="string";if(Be){BR.style.display="";BB(BR,Bq)}else{BR.style.display="none"}}if(t){t.style.display=AY?"":"none"}Ay=BY.onclose;j=BY.onhide||arguments[3];var Bd,BW=BY.onopen;if(!Bd){Bd=BY.onshow||arguments[2]}Ad(E,false);if(!G&&BY.shrinkWrap!==false){E.style.height="";E.style.width=""}if(BM){var Ba=b;b=BY.modal;if(!Ab||b!=Ba){U(BY.modal)}}E.className=(BY.className||"alert")+" popup window";if(!Ab){BZ=E.style.left;BX=E.style.top;E.style.left=E.style.top="0"}BY.text=Bg;v(BN,BY);p=BY.sizable!==false;BF=p&&BY.maximizable!==false;if(BD){if(Ac){BJ(E,"nomaxminbuttons");(p?BD:BJ)(E,"maxminbuttons")}else{BD(E,"nomaxminbuttons")}if(Bc){(Bm?BD:BJ)(E,"iconic");BJ(E,"nocaptionbuttons")}else{BD(E,"nocaptionbuttons")}if(BC&&BY.fixable!==false){BD(E,"fixable")}}E.style.display="block";if(A0&&AE&&Aq&&r(Aq)){A0(false);if(G){A1(E);if(BF){Au(E,null,function(){if(BD){BD(E,"maximized")}})}else{G=false}s(G)}K(false)}if(As){if(p&&Ac&&BF){AR(As,false)}else{AR(As);if(G){A1(E);G=false}}s(!!G)}if(p){AE=BY.minimizable!==false}if(Aq){if(p&&Ai&&AE){AR(Aq,false)}else{AR(Aq)}}if(AJ){AJ(!p||G)}if(AG){AG.style.visibility=(BY.fixable!==false&&Be&&Bc)?"":"hidden"}if(As){As.style.visibility=(p&&Be&&Bc)?"":"hidden"}if(Aq){Aq.style.visibility=(p&&Be&&Bc)?"":"hidden"}if(BA){BA.style.visibility=(Be&&Bc)?"":"hidden"}if(BL){if(BY.shrinkWrap!==false){if(!G){E.style.height="1px";Bn=E.offsetHeight;E.style.height=""}Bn=E.clientLeft}var Bi=A9(E);if(Bi){BL(E,Bi[0],Bi[1])}}if(!Ab){E.style.left=BZ;E.style.top=BX}if(BW){q(BW,E)}Am=BY.background;if(Am){c()}var Bf,Bk=l();var Bp=y(AG);if(BC){if(typeof BY.fixed=="undefined"){Bf=Bp}else{Bf=BY.fixed}Bf=Bf&&BY.fixable!==false;if(Bf&&!Bp||(!Bf&&Bp)){if(G){A1(E)}else{if(!E.style.top){E.style.left=Bk[0]+"px";E.style.top=Bk[1]+"px"}}BC(E,Bf);if(AG){BP(AG,Bf)}if(G){Au(E)}}}var Bo=BY.position;var Bj={topleft:"nw",bottomleft:"sw",topright:"ne",bottomright:"se"};if(typeof Bo=="string"){if(API.effects&&BY.effects==API.effects.slide&&!BY.effectParams){BY.effectParams={side:"diagonal"+Bj[Bo]}}}if(Bo&&typeof Bo!="string"){if(E.style.position!="fixed"){Bo[0]+=Bk[0];Bo[1]+=Bk[1]}if(!Ab){if(G){A1(E)}E.style.top=Bo[0]+"px";E.style.left=Bo[1]+"px";if(G){Au(E)}}}if(Ab||!Bd||!q(Bd,E,BY,G)){if(Ab){if(BY.effects){Bl={duration:BY.duration,ease:BY.ease,fps:BY.fps}}global.setTimeout(function(){if(Bo){if(typeof Bo=="string"){Ah(E,Bo,Bl,AP)}else{AX(E,Bo[0],Bo[1],Bl,AP)}}else{P(E,Bl,AP)}},10);Ad(E);if(AP&&!AX.async){AP()}}else{if(!G){if(Bo){if(typeof Bo=="string"){Ah(E,Bo)}else{AX(E,Bo[0],Bo[1])}}else{P(E)}}else{A1(E);var Bb=function(){if(BD){BD(E,"maximized")}};if(Bo){if(typeof Bo=="string"){Ah(E,Bo)}else{AX(E,Bo[0],Bo[1])}}Au(E,null,Bb);if(!Au.async){Bb()}}Ab=true;Ad(E,true,BY,AP);if(AP&&!Ad.async){AP()}}}Ab=true;if(A3&&!BY.mute){A3(BY)}}}e=f=null})}

var API,global=this;if(API&&API.areFeatures&&API.areFeatures("getEBTN","getChildren","getElementText","checkControl","emptyNode","attachListener")){(function(){var R=API;var O=R.isHostMethod;var X=R.createElement,A=R.getEBTN,H=R.getChildren;var E=R.isControlChecked,M=R.isControlDisabled,e=R.isControlPressed,g=R.callInContext;var W=R.setControlRole,L=R.checkControl,I=R.disableControl,V=R.pressControl;var F=R.attachListener,P=R.detachListener,a=R.cancelDefault,J=R.cancelPropagation,d=R.getEventTarget,D=R.getEventTargetRelated;var U=R.emptyNode,f=R.getElementNodeName,T=R.getElementParentElement,Q=R.getElementDocument,C=R.getElementText;var c;var K=function(h){if(W){W(h,"button")}if(E(h)){L(h)}if(e(h)){V(h)}if(M(h)){I(h)}if(API.makeElementUnselectable){API.makeElementUnselectable(h)}};var B=function(h){return a(h)};var G=function(i,h){return function(j){if(g(i,h,this,D(j))===false){if(O(this,"blur")){this.blur()}return a(j)}}};var S=function(k,i,j){var h=X("a",j);if(h){if(i){h.appendChild(j.createTextNode(i))}else{if(API.addClass){API.addClass(k,"nocaption")}}h.tabIndex=0;h.href="#";U(k);k.appendChild(h)}return h};var Y=function(h,k,j,i){F(h,"click",B,k);if(j){F(h,"focus",G(j,i||API),k)}};var N=function(k,r,p){if(!p){p=Q(k)}if(!r){r={}}if(p&&O(p,"createTextNode")){if(W){W(k,"toolbar")}var m=H(k);for(var l=m.length;l--;){var h=m[l];var o,j=A("a",h);if(!j.length){var q=C(h);if(q){o=S(h,q,p)}}else{o=j[0]}if(o){Y(o,h,r.onfocus,r.callbackContext)}K(h)}F(k,"mousedown",function(s){var i=d(s);if(f(i)=="a"){i=T(i)}if(T(i)==this&&!M(i)){V(i)}});F(k,"mouseup",function(s){var i=d(s);if(f(i)=="a"){i=T(i)}if(T(i)==this&&!M(i)){V(i,false)}});F(k,"click",function(y){var t,w,s,v=d(y),u;if(r.radio){var x=c(this);for(t=x.length;t--;){if(E(x[t])){u=x[t]}}}if(f(v)=="a"){v=T(v)}if(v!=this&&!M(v)){if(v&&r.onclick){s=g(r.onclick,r.callbackContext||API,this,v,u)}if(s!==false){if(r.radio){w=H(this);for(t=w.length;t--;){var z=w[t];if(z!=v){L(z,false)}}if(v){L(v)}}}return a(y)}});var n=r.oncustomize;if(n){F(k,"dblclick",function(s){var i=d(s);if(i==this){g(n,r.callbackContext||API,this);return a(s)}})}k=m=null}};R.enhanceToolbar=N;var Z=function(h){return J(h)};R.attachDocumentReadyListener(function(){var h=global.API,j=h.attachDragToControl,i=h.detachDragFromControl;if(j){h.attachDragToToolbar=function(n,o,k){j(n,o);var m=H(n);for(var l=m.length;l--;){F(m[l],"mousedown",Z)}};h.detachDragFromToolbar=function(m,n){i(m,n);var l=H(m);for(var k=l.length;k--;){P(l[k],"mousedown",Z)}}}h=null});var b;if(X&&X("div")){R.addToolbarButton=b=function(k,i,l){if(!l){l=global.document}var j=X("div",l);j.className=i.className||"button";var h=S(j,i.text||"",l);Y(h,j,i.onfocus,i.callbackContext);if(i.title){j.title=i.title}if(i.id){j.id=i.id}K(j);k.appendChild(j);return j};R.removeToolbarButton=function(i,h){i.removeChild(h)};R.createToolbar=function(j,o){if(!o){o=global.document}if(!j){j={}}var m=X(j.tagName||"div",o);m.className=j.className||"toolbar panel";if(j.id){m.id=j.id}var n=j.buttons;if(n){var h=n.length;for(var k=0;k<h;k++){b(m,n[k],o)}}N(m,j,o);return m};R.getToolbarButtons=c=function(h){return H(h)}}R=null})()}

var API,global=this;if(API&&API.areFeatures&&API.areFeatures("createElement","attachDocumentReadyListener")){API.attachDocumentReadyListener(function(){var I=API,G=I.getBodyElement,C=I.showElement,B=I.createElement;var H=G();var E={left:"right",right:"left",top:"bottom",bottom:"top"};var D=I.attachListener,A=I.getElementParentElement,F=I.callInContext;var J;if(B&&D){J=function(M,L,O){var N=B("input");if(N){N.type="button";N.className="commandbutton";N.value=L;M.appendChild(N);D(N,"click",function(){return O(A(this),this)});N=M=null;return true}return false}}if(H&&API.isHostMethod(H,"appendChild")&&I.sideBar){I.enhanceSideBar=function(O,M,P){var L=G(P);if(!M){M={}}var N=M.side||"left";if(L){O.style.position="absolute";O.className=M.className||"sidebar panel";if(N=="left"||N=="right"){O.className+=" vertical"}O.className+=" "+N;L.appendChild(O);API.sideBar(O,N,M);return O}return null};if(J){I.createSideBar=function(L,Q){if(!L){L={}}var M=B("div");if(M){API.setControlContent(M,L);if(L.buttons){var N=L.onclose;if(API.showSideBar){J(M,"Close",function(){API.showSideBar(M,false,{effects:L.effects,side:L.side,duration:L.duration,ease:L.ease,fps:L.fps,removeOnHide:true});API.unSideBar(M);if(N){F(N,L.callbackContext||API,M)}})}var P=L.onautohidecollision,O=L.onautohide;if(API.autoHideSideBar){J(M,"Auto-hide",function(T,S){if(API.autoHideSideBar(T,true,{duration:L.duration,ease:L.ease,fps:L.fps})){T.className+=" autohide";S.disabled=true;if(O){F(O,L.callbackContext||API,T)}}else{var R=true;if(P){R=F(P,L.callbackContext||API,T)!==false}if(R&&API.isHostMethod(global,"alert")){global.alert("Only one sidebar per edge may be hidden.")}}})}}return API.enhanceSideBar(M,L,Q)}return null}}if(C){var K=I.showSideBar;I.showSideBar=function(N,L,M){if(M&&M.side&&M.effects&&API.effects&&M.effects==API.effects.slide&&!M.effectParams){M.effectParams={side:E[M.side]}}K(N,L,M)}}I.destroySideBar=function(L){API.unSideBar(L);var M=API.getElementParentElement(L);if(M){M.removeChild(L)}}}I=H=null})}

var API,global=this;if(API&&API.areFeatures&&API.areFeatures("createElement","attachDocumentReadyListener","getElementDocument")){API.attachDocumentReadyListener(function(){var V,R=API,U=R.getBodyElement,K=R.showControl,N=R.cornerControl,T=R.createElement,P=R.getElementDocument;var A=R.attachListener,Z=R.callInContext,G=R.getWorkspaceRectangle,X=R.getDocumentWindow,S=R.playEventSound;var L,D,Y,W,F,Q,I=["topleft","topright","bottomleft","bottomright"];var O=U();var E={};var C=function(a){for(V=I.length;V--;){a[I[V]]=[]}return a};C(E);var J=function(b){var a;if(!b||b==global){a=global.document}else{a=b.document}return a};var B,H=function(a){API.attachWindowListener("resize",function(){Y(null,a)})};var M=function(a){if(!a||a==global.document){if(!B){H(global.document);B=true}return E}else{if(!a.toaster&&(typeof a.expando=="undefined"||a.expando)){H(a);a.toaster=C({})}return a.toaster}};if(!O||typeof O.offsetWidth!="number"){return }Q=function(g,b,m){var c=0,h=0,n=M(m)[g],a=G(m),f=a[2],e=0;var j=g.indexOf("top")!=-1;var l=g.indexOf("right")!=-1;for(var d=n.length;d--;){var k=n[d];if(k.element){c+=(j?1:-1)*k.element.offsetHeight}else{if(k.arranging){c+=(j?1:-1)*k.arranging}}if(k.element&&k.element.offsetWidth>e){e=k.element.offsetWidth}if(Math.abs(c)+b.offsetHeight>f){h+=(l?-1:1)*e;c=e=0}}return[c,h]};F=function(b,g){var f,h;for(var e=I.length;e--;){f=false;var k=M(g)[I[e]];for(var d=0,c=k.length;d<c;d++){var a=k[d];if(a.element){if(a.element==b){h=k[d]}f=true}else{if(a.arranging){f=true}}}if(!f){E[I[e]]=[]}}return h};L=function(c,b,d){var a=M(d)[b];return(a[a.length]={element:c,position:b})};D=function(h,o,n){var d=0,j=0,p=M(n)[h],b=G(n),g=b[2],f=0;var k=h.indexOf("top")!=-1;var m=h.indexOf("right")!=-1;o=o||{duration:1};for(var e=0,c=p.length;e<c;e++){if(p[e].element){var a=(k?1:-1)*p[e].element.offsetHeight;if(Math.abs(d+a)>g){j+=(m?-1:1)*f;d=f=0;o.offset=[d,j]}else{o.offset=[d,j]}d+=a;p[e].destination=N(p[e].element,h,o);if(p[e].element.offsetWidth>f){f=p[e].element.offsetWidth}}else{if(p[e].arranging){d+=(k?1:-1)*p[e].arranging}}}};Y=function(a,c){for(var b=I.length;b--;){D(I[b],a,c)}};if(O&&A&&API.isHostMethod(O,"appendChild")&&N&&K){R.arrangeToast=D;R.arrangeToasts=Y;R.enhanceToast=W=function(a,k,f){var i,h=f?J(f):P(a),e=U(h);if(!f&&X){f=X(h)}if(!f){return null}if(!k){k={}}var c=k.position;if(c){c=c.toLowerCase().replace(/ /,"")}else{c="bottomleft"}if(e){var l=F(a,h);if(l){global.clearTimeout(l.timer)}a.style.position="absolute";a.style.visibility="hidden";a.className=k.className||"toast panel";if(c.indexOf("top")!=-1){a.className+=" top"}e.appendChild(a);var j={duration:k.duration,effects:k.effects,fps:k.fps,ease:k.ease,removeOnHide:true,useCSSTransitions:false};if(j.effects&&API.effects&&(j.effects==API.effects.slide||j.effects==API.effects.drop)&&!k.effectParams){j.effectParams={side:c.indexOf("top")==-1?"top":"bottom"}}else{if(j.effects&&API.effects&&j.effects==API.effects.fold&&!k.effectParams){j.effectParams={axes:1}}else{j.effectParams=k.effectParams}}var b=Q(c,a,h);var g=a.offsetWidth;N(a,c,{offset:b},null,h);if(a.offsetWidth!=g){N(a,c,{offset:[b[0],b[1]-1]},null,h)}if(k.fixed&&API.fixElement){API.fixElement(a,true,k)}var d=function(m,n){if(i&&l.element){l.element=null;if(m){n.clearTimeout(l.timer)}if(!k.onhide||Z(k.onhide,k.callbackContext||API)!==false){l.arranging=a.offsetHeight;var o=l.destination;if(o){API.positionElement(a,o[0],o[1],{duration:1})}K(a,false,j,function(){l.arranging=false;D(c,k,h);if(k.autoDestroy){API.destroyToast(a,n);a=null}})}}if(!k.autoDestroy){a=null}i=false};A(a,"click",function(){if(!k.onclick||Z(k.onclick,k.callbackContext||API)!==false){d(true,f)}});l=L(a,c,h);if(!k.onshow||Z(k.onshow)!==false){K(a,true,j,function(){l.timer=f.setTimeout(function(){d(false,f)},k.pause||5000)})}if(S&&!k.mute){global.setTimeout(function(){S("toast")},k.effects?k.duration||0:0)}i=true;return a}return null};if(R.createElement&&T("div")){R.createToast=function(b,e){var d=J(e),a=U(d);if(!e){e=global}if(!b){b={}}var c=T("div",d);if(c){if(API.setControlRole){API.setControlRole(c,"alertdialog")}c.style.visibility="hidden";c.style.position="absolute";c.style.left=c.style.top="0";API.setControlContent(c,b);if(b.onopen){Z(b.onopen,b.callbackContext||API)}a.appendChild(c);return W(c,b,e)}return null};R.destroyToast=function(c,e){var d;if(e){d=J(e)}else{d=P(c);if(d==global.document){e=global}else{if(X){e=X(d)}}}if(e){var b=F(c,d),a=U(d);if(b){a.removeChild(b.element);e.clearTimeout(b.timer);b.element=null;b.arranging=false;return true}}return false}}}R=O=null})}