// page init
bindReady(function(){
	initSameHeight();
});

// align blocks height
function initSameHeight() {
	setSameHeight({
		holder: '.columns',
		elements: 'div.column',
		flexible: true,
		multiLine: true
	});
}

// set same height for blocks
function setSameHeight(opt) {
	// default options
	var options = {
		holder: null,
		skipClass: 'same-height-ignore',
		leftEdgeClass: 'same-height-left',
		rightEdgeClass: 'same-height-right',
		elements: '>*',
		flexible: false,
		multiLine: false,
		useMinHeight: false,
		biggestHeight: false
	};
	for(var p in opt) {
		if(opt.hasOwnProperty(p)) {
			options[p] = opt[p];
		}
	}

	// init script
	if(options.holder) {
		var holders = lib.queryElementsBySelector(options.holder);
		lib.each(holders, function(ind, curHolder){
			var curElements = [], resizeTimer, postResizeTimer;
			var tmpElements = lib.queryElementsBySelector(options.elements, curHolder);

			// get resize elements
			for(var i = 0; i < tmpElements.length; i++) {
				if(!lib.hasClass(tmpElements[i], options.skipClass)) {
					curElements.push(tmpElements[i]);
				}
			}
			if(!curElements.length) return;

			// resize handler
			function doResize() {
				for(var i = 0; i < curElements.length; i++) {
					curElements[i].style[options.useMinHeight && SameHeight.supportMinHeight ? 'minHeight' : 'height'] = '';
				}

				if(options.multiLine) {
					// resize elements row by row
					SameHeight.resizeElementsByRows(curElements, options);
				} else {
					// resize elements by holder
					SameHeight.setSize(curElements, curHolder, options);
				}
			}
			doResize();

			// handle flexible layout / font resize
			function flexibleResizeHandler() {
				clearTimeout(resizeTimer);
				resizeTimer = setTimeout(function(){
					doResize();
					clearTimeout(postResizeTimer);
					postResizeTimer = setTimeout(doResize, 100);
				},1);
			}
			if(options.flexible) {
				addEvent(window, 'resize', flexibleResizeHandler);
				addEvent(window, 'orientationchange', flexibleResizeHandler);
				FontResizeEvent.onChange(flexibleResizeHandler);
			}
			// handle complete page load including images and fonts
			addEvent(window, 'load', flexibleResizeHandler);
		});
	}

	// event handler helper functions
	function addEvent(object, event, handler) {
		if(object.addEventListener) object.addEventListener(event, handler, false);
		else if(object.attachEvent) object.attachEvent('on'+event, handler);
	}
}

/*
 * SameHeight helper module
 */
SameHeight = {
	supportMinHeight: typeof document.documentElement.style.maxHeight !== 'undefined', // detect css min-height support
	setSize: function(boxes, parent, options) {
		var calcHeight, holderHeight = typeof parent === 'number' ? parent : this.getHeight(parent);

		for(var i = 0; i < boxes.length; i++) {
			var box = boxes[i];
			var depthDiffHeight = 0;
			var isBorderBox = this.isBorderBox(box);
			lib.removeClass(box, options.leftEdgeClass);
			lib.removeClass(box, options.rightEdgeClass);

			if(typeof parent != 'number') {
				var tmpParent = box.parentNode;
				while(tmpParent != parent) {
					depthDiffHeight += this.getOuterHeight(tmpParent) - this.getHeight(tmpParent);
					tmpParent = tmpParent.parentNode;
				}
			}
			calcHeight = holderHeight - depthDiffHeight;
			calcHeight -= isBorderBox ? 0 : this.getOuterHeight(box) - this.getHeight(box);
			if(calcHeight > 0) {
				box.style[options.useMinHeight && this.supportMinHeight ? 'minHeight' : 'height'] = calcHeight + 'px';
			}
		}

		lib.addClass(boxes[0], options.leftEdgeClass);
		lib.addClass(boxes[boxes.length - 1], options.rightEdgeClass);
		return calcHeight;
	},
	getOffset: function(obj) {
		if (obj.getBoundingClientRect) {
			var scrollLeft = window.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft;
			var scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
			var clientLeft = document.documentElement.clientLeft || document.body.clientLeft || 0;
			var clientTop = document.documentElement.clientTop || document.body.clientTop || 0;
			return {
				top:Math.round(obj.getBoundingClientRect().top + scrollTop - clientTop),
				left:Math.round(obj.getBoundingClientRect().left + scrollLeft - clientLeft)
			};
		} else {
			var posLeft = 0, posTop = 0;
			while (obj.offsetParent) {posLeft += obj.offsetLeft; posTop += obj.offsetTop; obj = obj.offsetParent;}
			return {top:posTop,left:posLeft};
		}
	},
	getStyle: function(el, prop) {
		if (document.defaultView && document.defaultView.getComputedStyle) {
			return document.defaultView.getComputedStyle(el, null)[prop];
		} else if (el.currentStyle) {
			return el.currentStyle[prop];
		} else {
			return el.style[prop];
		}
	},
	getStylesTotal: function(obj) {
		var sum = 0;
		for(var i = 1; i < arguments.length; i++) {
			var val = parseFloat(this.getStyle(obj, arguments[i]));
			if(!isNaN(val)) {
				sum += val;
			}
		}
		return sum;
	},
	getHeight: function(obj) {
		return obj.offsetHeight - this.getStylesTotal(obj, 'borderTopWidth', 'borderBottomWidth', 'paddingTop', 'paddingBottom');
	},
	getOuterHeight: function(obj) {
		return obj.offsetHeight;
	},
	isBorderBox: function(obj) {
		var f = this.getStyle, styleValue = f(obj, 'boxSizing') || f(obj, 'WebkitBoxSizing') || f(obj, 'MozBoxSizing');
		return styleValue === 'border-box';
	},
	resizeElementsByRows: function(boxes, options) {
		var currentRow = [], maxHeight, maxCalcHeight = 0, firstOffset = this.getOffset(boxes[0]).top;
		for(var i = 0; i < boxes.length; i++) {
			if(this.getOffset(boxes[i]).top === firstOffset) {
				currentRow.push(boxes[i]);
			} else {
				maxHeight = this.getMaxHeight(currentRow);
				maxCalcHeight = Math.max(maxCalcHeight, this.setSize(currentRow, maxHeight, options));
				firstOffset = this.getOffset(boxes[i]).top;
				currentRow = [boxes[i]];
			}
		}
		if(currentRow.length) {
			maxHeight = this.getMaxHeight(currentRow);
			maxCalcHeight = Math.max(maxCalcHeight, this.setSize(currentRow, maxHeight, options));
		}
		if(options.biggestHeight) {
			for(i = 0; i < boxes.length; i++) {
				boxes[i].style[options.useMinHeight && this.supportMinHeight ? 'minHeight' : 'height'] = maxCalcHeight + 'px';
			}
		}
	},
	getMaxHeight: function(boxes) {
		var maxHeight = 0;
		for(var i = 0; i < boxes.length; i++) {
			maxHeight = Math.max(maxHeight, this.getOuterHeight(boxes[i]));
		}
		return maxHeight;
	}
};

/*
 * FontResize Event
 */
FontResizeEvent = (function(window,document){
	var randomID = 'font-resize-frame-' + Math.floor(Math.random() * 1000);
	var resizeFrame = document.createElement('iframe');
	resizeFrame.id = randomID; resizeFrame.className = 'font-resize-helper';
	resizeFrame.style.cssText = 'position:absolute;width:100em;height:10px;top:-9999px;left:-9999px;border-width:0';

	// wait for page load
	function onPageReady() {
		document.body.appendChild(resizeFrame);

		// use native IE resize event if possible
		if (/MSIE (6|7|8)/.test(navigator.userAgent)) {
			resizeFrame.onresize = function() {
				window.FontResizeEvent.trigger(resizeFrame.offsetWidth / 100);
			};
		}
		// use script inside the iframe to detect resize for other browsers
		else {
			var doc = resizeFrame.contentWindow.document;
			doc.open();
			doc.write('<scri' + 'pt>window.onload = function(){var em = parent.document.getElementById("' + randomID + '");window.onresize = function(){if(parent.FontResizeEvent){parent.FontResizeEvent.trigger(em.offsetWidth / 100);}}};</scri' + 'pt>');
			doc.close();
		}
	}
	if(window.addEventListener) window.addEventListener('load', onPageReady, false);
	else if(window.attachEvent) window.attachEvent('onload', onPageReady);

	// public interface
	var callbacks = [];
	return {
		onChange: function(f) {
			if(typeof f === 'function') {
				callbacks.push(f);
			}
		},
		trigger: function(em) {
			for(var i = 0; i < callbacks.length; i++) {
				callbacks[i](em);
			}
		}
	};
}(this, document));

/*
 * Utility module
 */
lib = {
	hasClass: function(el,cls) {
		return el && el.className ? el.className.match(new RegExp('(\\s|^)'+cls+'(\\s|$)')) : false;
	},
	addClass: function(el,cls) {
		if (el && !this.hasClass(el,cls)) el.className += " "+cls;
	},
	removeClass: function(el,cls) {
		if (el && this.hasClass(el,cls)) {el.className=el.className.replace(new RegExp('(\\s|^)'+cls+'(\\s|$)'),' ');}
	},
	extend: function(obj) {
		for(var i = 1; i < arguments.length; i++) {
			for(var p in arguments[i]) {
				if(arguments[i].hasOwnProperty(p)) {
					obj[p] = arguments[i][p];
				}
			}
		}
		return obj;
	},
	each: function(obj, callback) {
		var property, len;
		if(typeof obj.length === 'number') {
			for(property = 0, len = obj.length; property < len; property++) {
				if(callback.call(obj[property], property, obj[property]) === false) {
					break;
				}
			}
		} else {
			for(property in obj) {
				if(obj.hasOwnProperty(property)) {
					if(callback.call(obj[property], property, obj[property]) === false) {
						break;
					}
				}
			}
		}
	},
	event: (function() {
		var fixEvent = function(e) {
			e = e || window.event;
			if(e.isFixed) return e; else e.isFixed = true;
			if(!e.target) e.target = e.srcElement;
			e.preventDefault = e.preventDefault || function() {this.returnValue = false;};
			e.stopPropagation = e.stopPropagation || function() {this.cancelBubble = true;};
			return e;
		};
		return {
			add: function(elem, event, handler) {
				if(!elem.events) {
					elem.events = {};
					elem.handle = function(e) {
						var ret, handlers = elem.events[e.type];
						e = fixEvent(e);
						for(var i = 0, len = handlers.length; i < len; i++) {
							if(handlers[i]) {
								ret = handlers[i].call(elem, e);
								if(ret === false) {
									e.preventDefault();
									e.stopPropagation();
								}
							}
						}
					};
				}
				if(!elem.events[event]) {
					elem.events[event] = [];
					if(elem.addEventListener) elem.addEventListener(event, elem.handle, false);
					else if(elem.attachEvent) elem.attachEvent('on'+event, elem.handle);
				}
				elem.events[event].push(handler);
			},
			remove: function(elem, event, handler) {
				var handlers = elem.events[event];
				for(var i = handlers.length - 1; i >= 0; i--) {
					if(handlers[i] === handler) {
						handlers.splice(i,1);
					}
				}
				if(!handlers.length) {
					delete elem.events[event];
					if(elem.removeEventListener) elem.removeEventListener(event, elem.handle, false);
					else if(elem.detachEvent) elem.detachEvent('on'+event, elem.handle);
				}
			}
		};
	}()),
	queryElementsBySelector: function(selector, scope) {
		scope = scope || document;
		if(!selector) return [];
		if(selector === '>*') return scope.children;
		if(typeof document.querySelectorAll === 'function') {
			return scope.querySelectorAll(selector);
		}
		var selectors = selector.split(',');
		var resultList = [];
		for(var s = 0; s < selectors.length; s++) {
			var currentContext = [scope || document];
			var tokens = selectors[s].replace(/^\s+/,'').replace(/\s+$/,'').split(' ');
			for (var i = 0; i < tokens.length; i++) {
				token = tokens[i].replace(/^\s+/,'').replace(/\s+$/,'');
				if (token.indexOf('#') > -1) {
					var bits = token.split('#'), tagName = bits[0], id = bits[1];
					var element = document.getElementById(id);
					if (element && tagName && element.nodeName.toLowerCase() != tagName) {
						return [];
					}
					currentContext = element ? [element] : [];
					continue;
				}
				if (token.indexOf('.') > -1) {
					var bits = token.split('.'), tagName = bits[0] || '*', className = bits[1], found = [], foundCount = 0;
					for (var h = 0; h < currentContext.length; h++) {
						var elements;
						if (tagName == '*') {
							elements = currentContext[h].getElementsByTagName('*');
						} else {
							elements = currentContext[h].getElementsByTagName(tagName);
						}
						for (var j = 0; j < elements.length; j++) {
							found[foundCount++] = elements[j];
						}
					}
					currentContext = [];
					var currentContextIndex = 0;
					for (var k = 0; k < found.length; k++) {
						if (found[k].className && found[k].className.match(new RegExp('(\\s|^)'+className+'(\\s|$)'))) {
							currentContext[currentContextIndex++] = found[k];
						}
					}
					continue;
				}
				if (token.match(/^(\w*)\[(\w+)([=~\|\^\$\*]?)=?"?([^\]"]*)"?\]$/)) {
					var tagName = RegExp.$1 || '*', attrName = RegExp.$2, attrOperator = RegExp.$3, attrValue = RegExp.$4;
					if(attrName.toLowerCase() == 'for' && this.browser.msie && this.browser.version < 8) {
						attrName = 'htmlFor';
					}
					var found = [], foundCount = 0;
					for (var h = 0; h < currentContext.length; h++) {
						var elements;
						if (tagName == '*') {
							elements = currentContext[h].getElementsByTagName('*');
						} else {
							elements = currentContext[h].getElementsByTagName(tagName);
						}
						for (var j = 0; elements[j]; j++) {
							found[foundCount++] = elements[j];
						}
					}
					currentContext = [];
					var currentContextIndex = 0, checkFunction;
					switch (attrOperator) {
						case '=': checkFunction = function(e) { return (e.getAttribute(attrName) == attrValue) }; break;
						case '~': checkFunction = function(e) { return (e.getAttribute(attrName).match(new RegExp('(\\s|^)'+attrValue+'(\\s|$)'))) }; break;
						case '|': checkFunction = function(e) { return (e.getAttribute(attrName).match(new RegExp('^'+attrValue+'-?'))) }; break;
						case '^': checkFunction = function(e) { return (e.getAttribute(attrName).indexOf(attrValue) == 0) }; break;
						case '$': checkFunction = function(e) { return (e.getAttribute(attrName).lastIndexOf(attrValue) == e.getAttribute(attrName).length - attrValue.length) }; break;
						case '*': checkFunction = function(e) { return (e.getAttribute(attrName).indexOf(attrValue) > -1) }; break;
						default : checkFunction = function(e) { return e.getAttribute(attrName) };
					}
					currentContext = [];
					var currentContextIndex = 0;
					for (var k = 0; k < found.length; k++) {
						if (checkFunction(found[k])) {
							currentContext[currentContextIndex++] = found[k];
						}
					}
					continue;
				}
				tagName = token;
				var found = [], foundCount = 0;
				for (var h = 0; h < currentContext.length; h++) {
					var elements = currentContext[h].getElementsByTagName(tagName);
					for (var j = 0; j < elements.length; j++) {
						found[foundCount++] = elements[j];
					}
				}
				currentContext = found;
			}
			resultList = [].concat(resultList,currentContext);
		}
		return resultList;
	},
	trim: function (str) {
		return str.replace(/^\s+/, '').replace(/\s+$/, '');
	},
	bind: function(f, scope, forceArgs){
		return function() {return f.apply(scope, typeof forceArgs !== 'undefined' ? [forceArgs] : arguments);};
	}
};

// DOM ready handler
function bindReady(handler){
	var called = false;
	var ready = function() {
		if (called) return;
		called = true;
		handler();
	};
	if (document.addEventListener) {
		document.addEventListener('DOMContentLoaded', ready, false);
	} else if (document.attachEvent) {
		if (document.documentElement.doScroll && window == window.top) {
			var tryScroll = function(){
				if (called) return;
				if (!document.body) return;
				try {
					document.documentElement.doScroll('left');
					ready();
				} catch(e) {
					setTimeout(tryScroll, 0);
				}
			};
			tryScroll();
		}
		document.attachEvent('onreadystatechange', function(){
			if (document.readyState === 'complete') {
				ready();
			}
		});
	}
	if (window.addEventListener) window.addEventListener('load', ready, false);
	else if (window.attachEvent) window.attachEvent('onload', ready);
}

/*! matchMedia() polyfill - Test a CSS media type/query in JS. Authors & copyright (c) 2012: Scott Jehl, Paul Irish, Nicholas Zakas. Dual MIT/BSD license */
;window.matchMedia=window.matchMedia||(function(e,f){var c,a=e.documentElement,b=a.firstElementChild||a.firstChild,d=e.createElement("body"),g=e.createElement("div");g.id="mq-test-1";g.style.cssText="position:absolute;top:-100em";d.appendChild(g);return function(h){g.innerHTML='&shy;<style media="'+h+'"> #mq-test-1 { width: 42px; }</style>';a.insertBefore(d,b);c=g.offsetWidth==42;a.removeChild(d);return{matches:c,media:h}}})(document);

/*! Picturefill - Responsive Images that work today. (and mimic the proposed Picture element with span elements). Author: Scott Jehl, Filament Group, 2012 | License: MIT/GPLv2 */
;(function(a){a.picturefill=function(){var b=a.document.getElementsByTagName("span");for(var f=0,l=b.length;f<l;f++){if(b[f].getAttribute("data-picture")!==null){var c=b[f].getElementsByTagName("span"),h=[];for(var e=0,g=c.length;e<g;e++){var d=c[e].getAttribute("data-media");if(!d||(a.matchMedia&&a.matchMedia(d).matches)){h.push(c[e])}}var m=b[f].getElementsByTagName("img")[0];if(h.length){var k=h.pop();if(!m||m.parentNode.nodeName==="NOSCRIPT"){m=a.document.createElement("img");m.alt=b[f].getAttribute("data-alt")}if(k.getAttribute("data-width")){m.setAttribute("width",k.getAttribute("data-width"))}else{m.removeAttribute("width")}if(k.getAttribute("data-height")){m.setAttribute("height",k.getAttribute("data-height"))}else{m.removeAttribute("height")}m.src=k.getAttribute("data-src");k.appendChild(m)}else{if(m){m.parentNode.removeChild(m)}}}}};if(a.addEventListener){a.addEventListener("resize",a.picturefill,false);a.addEventListener("DOMContentLoaded",function(){a.picturefill();a.removeEventListener("load",a.picturefill,false)},false);a.addEventListener("load",a.picturefill,false)}else{if(a.attachEvent){a.attachEvent("onload",a.picturefill)}}}(this));
