var global=this,API,D,C;if(API&&API.attachDocumentReadyListener){API.attachDocumentReadyListener(function(){var P=API.isHostMethod,O=API.isHostObjectProperty,E=API.getDocumentWindow;var F,K,A,H,N,M,J;var G,B,L=global.document;if(P(global,"getSelection")&&E){F=function(Q){return E(Q).getSelection()}}else{if(O(global.document,"selection")){F=function(Q){return(Q||global.document).selection}}}var I=function(Q){if(typeof Q.text=="string"){return Q.text}if(P(Q,"toString")){return Q.toString()}};if(F){J=function(R){if(P(R,"toString")){return R.toString()}var Q=A(R);if(Q){return I(Q)}return""};A=function(Q){if(P(Q,"getRangeAt")){return Q.rangeCount?null:Q.getRangeAt(0)}if(P(Q,"createRange")){return Q.createRange()}return null}}if(A){K=function(S){var Q,R=F(S);if(P(R,"empty")){R.empty()}else{Q=A(R);if(Q&&P(Q,"collapse")){Q.collapse()}}}}if(K){API.clearDocumentSelection=function(Q){K(Q)}}API.getDocumentSelectionText=function(Q){return J(F(Q))};if(P(L,"createElement")){B=L.createElement("input");G=API.getBodyElement();G.appendChild(B);if(typeof B.selectionStart=="number"){H=function(R){var S=R.selectionStart,Q=R.selectionEnd;return[S,Q,R.value.substring(S,Q)]};N=function(R,S,Q){R.selectionStart=S;R.selectionEnd=Q}}else{if(A){H=function(S){var T,R,Q,V;if(P(S,"focus")){S.focus()}T=A(F());if(T){if(P(T,"duplicate")){R=T.duplicate();if(S.tagName=="INPUT"){R.expand("textedit")}else{R.moveToElementText(S)}Q=R.text.length;R.setEndPoint("starttostart",T);V=Q-R.text.length;var U=T.text.replace(/\r\n/g,"\n");return([V,V+U.length,U])}}return null};if(P(B,"createTextRange")){N=function(T,U,Q){var S,R=T.createTextRange();R.collapse();R.moveStart("character",U);R.moveEnd("character",Q-U);R.select();S=H(T);if(S[0]!=U){R.move("character",U-S[0]);R.select()}}}}}}G.removeChild(B);API.getControlSelection=H;API.setControlSelection=N;if(N){M=API.clearControlSelection=function(Q){N(Q,0,0)}}if(C&&C.prototype&&H){if(N){C.prototype.getSelection=function(){return H(this.element())};C.prototype.setSelection=function(R,Q){N(this.element(),R,Q);return this};C.prototype.clearSelection=function(){M(this.element());return this}}}if(D&&D.prototype&&J){D.prototype.getSelectionText=function(){return J(F(this.node()))};if(K){D.prototype.clearSelection=function(){K(this.node());return this}}}L=B=null})}