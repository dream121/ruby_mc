MC.sessions =
  ready: ->
    $('p.show-email-form').click ->
      $('#email-form').removeClass('hide')

    if $('.alert-error').length != 0
      $('p.show-email-form').click()

    $('#email-form form').on 'submit', ->
      $auth_key = $(this).find('#auth_key, #email')
      lower = $auth_key.val().toLowerCase()
      $auth_key.val(lower)
