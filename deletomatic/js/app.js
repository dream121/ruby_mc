$(document).ready(function(){

  $('#main-container').deletomatic();
  //var isDragging = false;
  //$('#usertext-1').on('mousedown', function(e){
  //  document.designMode = 'on'
  //  $(window).on('mousemove', function(){
  //    isDragging = true;
  //    $(window).off("mousemove");
  //  });
  //})
  //.on('mouseup', function(){
  //  var wasDragging = isDragging;
  //  isDragging = false;
  //  $(window).off('mousemove');
  //  if ( !wasDragging ) { // was clicking

  //    document.designMode = 'off';

  //  } else { // was dragging

  //    document.execCommand('strikethrough');
  //    document.designMode = 'off';
  //    var pText = $('#usertext-1').html();

  //    $('#display-text').html(pText);
  //    var $strikes = $('strike', $('#display-text'));
  //    for ( var i=0; i < $strikes.length; ++i ) {
  //      var stringArray = [];
  //      var strike = $($strikes[i]);

  //      for ( var j = 0; j < strike.text().length; ++j ) {
  //        stringArray.push(0);
  //      }

  //      strike.text(stringArray.join(''));
  //    }
  //    //console.log($('#display-text').text().replace(/[^0]/g, '1'));
  //    $('#display-text').text($('#display-text').text().replace(/[^0]/g, '1'));
  //  }
  //});

});
