MC.notificationsNavbar =
  ready: ->
    $body = $("body")
    $menuTrigger = $("#menu-trigger")
    $menuTrigger.on "click", (e) ->
      e.preventDefault()
      if $body.hasClass("menu-active")
        $body.removeClass "menu-active"
      else
        $body.addClass "menu-active"
      return

