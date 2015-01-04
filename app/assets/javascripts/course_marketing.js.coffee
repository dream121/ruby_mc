MC.courseMarketing =
  fbWallPost: () ->
    $element = $('#facebook-container')

    fb_options =
      method: 'feed'
      app_id: $element.data('app_id')
      name: $element.data('name')
      link: $element.data('link')
      picture: $element.data('picture')
      caption: $element.data('caption')
      description: $element.data('description')

    FB.ui(fb_options, (response) ->)
  ready: ->
    $('.main-content .pricing-narrow').sticky({topSpacing: 0})
    $('.visual .visual-block').sticky({topSpacing: 0})
    `$('.course-collapse').click(function(){
	    $('.course-collapse').slideUp("slow");	
  		$('.holder').slideDown("slow");
 	});`

    $('#slide-skills-boxes-trigger').on 'click', (e) ->
      e.preventDefault()
      $('#slide-box-1').addClass('boxes-slide-far-left')
      $('#slide-box-2').addClass('boxes-slide-far-left')
      $('#slide-box-3').addClass('boxes-slide-left-middle')
      $('#slide-box-4').addClass('boxes-scale-down-right')
