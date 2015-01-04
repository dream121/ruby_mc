function wireUpReplyButton(){
  $('textarea').each( function(index, element){
      if(!$(this).hasClass("I see you")){

        console.log("unwired buttons found");
        $(this).addClass("I see you");
          $(this).keydown(function(){
          console.log("text value", $(this).text() );
          if ($(this).text() == "Add your comment here" ){
          $(this).text("");
          }
         });

      }

  });
      $('.comment-file-field').each( function(index, element){
     if (!$(this).hasClass('wired')){
       $(this).addClass('wired');
       $(this).change(function(e){
          console.log("file added! !!1 1 !!! !1 11 !!! 000!01010101!!");
           $(this).parent().parent().find('.file-upload-text').text("Image Added");
           console.log("the class of the parent", $(this).parent().parent());
         });
    }
    });

  $('.post-button').click(function(){
        console.log("post-button clicked");
        $(this).parent().parent().find('.for-input').slideDown('medium', function(){
          });
        $(this).parent().parent().find('textarea').focus(); 
        $(this).parent().fadeOut('medium');
  });
}
