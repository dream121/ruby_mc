MC.home_page =
  fbWallPost: () ->
    $element = $('body')

    fb_options =
      method: 'feed'
      app_id: $element.data('app_id')
      link: $element.data('link')
      picture: $element.data('picture')
      caption: $element.data('caption')
      description: $element.data('description')

    FB.ui(fb_options, (response) ->)
    
  ready: ->

