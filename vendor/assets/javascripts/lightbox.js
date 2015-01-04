/****************************************
	Barebones Lightbox2 Template
	by Kyle Schaeffer
	http://www.kyleschaeffer.com
	* requires jQuery
****************************************/
var currentOpacity = 0;
var opacityTarget = 0;
var delta = .05;
var delayCounter = 0;
var delay = 3; // in frames to wait before brightening lightbox

var enableLightboxFade = true;

var lastRefreshWidth = 0;

$(function() {
	if ($(window).width() < 768) {
	    // do something for small screens
	    enableLightboxFade = false;
	}
	else if ($(window).width() > 768 &&  $(window).width() <= 992) {
	    // do something for medium screens
	}
	else if ($(window).width() > 992 &&  $(window).width() <= 1200) {
	    // do something for big screens
	}
	else  {
	    // do something for huge screens
	}

});

$(function() {
	setInterval(function(){
		var currentOpacity = $('#lightbox2-shadow').css("opacity");
		currentOpacity = parseFloat(currentOpacity);

		if ( currentOpacity < .01 ){
			$('#lightbox2-shadow').hide();
		}
		else{
			$('#lightbox2-shadow').show();
		}
		if ( Math.abs(opacityTarget - currentOpacity) < delta + .01 ){
			currentOpacity = opacityTarget;
			$('#lightbox2-shadow').css({ opacity: 0 });
		}
		else if ( opacityTarget > currentOpacity ){
			currentOpacity += delta;
			delayCounter = 0;
		}
		else if ( opacityTarget < currentOpacity ) {
			if ( ++delayCounter > delay){
				currentOpacity -= delta;
			}
		}

		$('#lightbox2-shadow').css({ opacity: currentOpacity });
	},30);
});

delta2 = .05;

setInterval(function(){
	$(".hoverImage2").each(
		function() {
			var currentOpacity2 = $( this ).css("opacity");
			var opacityTarget2 = parseFloat($.data( this, "desiredOpacity"));
			currentOpacity2 = parseFloat(currentOpacity2);

			if ( Math.abs(opacityTarget2 - currentOpacity2) < delta2 + .01 ){
				currentOpacity2 = opacityTarget2;
			}
			else if ( opacityTarget2 > currentOpacity2 ){
				currentOpacity2 += delta2;
			}
			else if ( opacityTarget2 < currentOpacity2 ) {
				currentOpacity2 -= delta2;
			}

			$( this ).css({ opacity: currentOpacity2 });
		});
},30);

setInterval(function(){
	if (Math.abs( lastRefreshWidth - $(window).width())){
  	$('.hoverImage2').remove();
		constructHoverFeature();
	}

	}
,500);

//$(function() {
$( window ).load(function(){
	constructHoverFeature();
});

$(function() {
	    lightbox2("");
	});

function constructHoverFeature(){
	lastRefreshWidth = $(window).width();
	$(".thumbnail-wrapper").each(
		function() {
		$( this ).css("z-index", 100);
	    var caller = $( this ).clone();
	    var priorWidth = $( this ).width();
	    var priorHeight = $( this ).height();
	    var priorMarginLeft = $( this ).css("margin-left");
	    var priorMarginRight = $( this ) .css("margin-right");
	    var position = $( this ).position();
	    var priorZ = $ ( this ).css("z-index");

	    $( this ).find(".thumbnail-caption").hide();
	    $( caller ).addClass("hoverImage2");
	    $( caller ).css({top: position.top, left: position.left, position: "absolute"});
	    $( caller ).css("z-index", "9999999");
	    $( caller ).width(priorWidth);
	    $( caller ).height(priorHeight);
	    $( caller ).css("margin-left", priorMarginLeft);
	    $( caller ).css("margin-right", priorMarginRight);
	    $( caller ).find(".thumbnail-caption").width(priorWidth);
	    $( caller ).find(".thumbnail-caption").css("top", priorHeight);
	    $( caller ).find(".thumbnail-caption").css("display", "block");
	    $( this ).closest(".thumbnail").append(caller);

	    if ( enableLightboxFade ){
	    	$( caller ).css("opacity", 0);
		    $.data( this, "desiredOpacity", 0);
		    $( caller ).hover(
		    	function() {
		    		$.data( this, "desiredOpacity", 1);
		    		opacityTarget = .75;
		    	}, function() {
		 		   	$.data( this, "desiredOpacity", .01);
		    		opacityTarget = 0;
		    		closeLightbox2();
		    	});
		}
		else{
		    $.data( this, "desiredOpacity", 1);

		}
	})

}


// display the lightbox2
function lightbox2(insertContent, ajaxContentUrl){

	// jQuery wrapper (optional, for compatibility only)
	(function($) {

		// add lightbox2/shadow <div/>'s if not previously added
		if($('#lightbox2-shadow').size() == 0){
			var theShadow = $('<div id="lightbox2-shadow"/>');
			$(theShadow).click(function(e){
				closeLightbox2();
			});
			$('body').append(theShadow);
		}

		// display the lightbox2
		$('#lightbox2-shadow').show();
		$('#lightbox2-shadow').css({ opacity: 0 });
		$('#lightbox2-shadow').css("z-index", "99");
	    opacityTarget = 0;
	})(jQuery); // end jQuery wrapper

}




// close the lightbox2
function closeLightbox2(){

	// jQuery wrapper (optional, for compatibility only)
	(function($) {
		function complete() {
		  	$('.hoverImage').remove();
 			 }
		opacityTarget = 0;
	})(jQuery); // end jQuery wrapper

}
