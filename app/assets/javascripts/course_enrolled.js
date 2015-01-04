$(function(){
  info = $('.enrolled-course').find('.columns-holder');
  video_container = $('#enrolled_hero_video');
  video = video_container.find('video');

  $(window).resize(function(){
    if($(this).width() <= 750) {
      info.css('margin-top', 0);
    } else {
      info.css('margin-top', video.height() / 1.5);
    }
  });

  if($(window).width() <= 750) {
    info.css('margin-top', 0);
  } else {
    info.css('margin-top', video.height() / 1.5);
  }
});
