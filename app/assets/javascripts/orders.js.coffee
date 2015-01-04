MC.orders =

  stripeResponseHandler: (status, response) ->
    $form = $('#new_order')

    if response.error
      MC.orders.handleErrorResponseCode(response.error)
      $form.find('button').prop('disabled', false)
    else
      token = response.id
      $form.append($('<input type="hidden" name="stripeToken" />').val(token))

      try
        experiments = JSON.stringify MC.experiments.variations()
        $form.append($('<input type="hidden" name="experiments" />').val(experiments))
      catch error
        MC.log error

      $form.get(0).submit()

  returnRightValue: (errorField) ->
    id = errorField.attr('id')
    if id == 'cart-number'
      right = '120px'
    else if id == 'cart-cvc'
      right = '47px'
    else
      right = '40px'

  returnErrorElement: (errorField) ->
    id = errorField.attr('id')
    if id == 'cart-number'
      $('#' + id)
    else if id == 'cart-cvc'
      $('#' + id) 
    else if id == 'cart-exp-month'
      $('#' + id).siblings('.jcf-select')


  handleErrorResponseCode: (response) ->
    $errorField = $("#cart-#{response.param.split('_').join('-')}")
    right = @returnRightValue($errorField)
    $dangerEl = @returnErrorElement($errorField).removeClass('focus').css('border', '1px solid #BE3F3F')

    $dangerWarning = $errorField.siblings('.cart-danger').removeClass('hidden').css('right', right)

    @addClearBinding($errorField, $dangerEl)
    $('.popup-holder').addClass('hidden')
    $('.popup').removeClass('cvc-error month-error number-error')


    if response.param == 'cvc'
      errorBox = $('#pop-cvc-date')
      messageBox = $('#data-cvc-message-box')
      MC.orders.addErrorMessage(errorBox, messageBox, response.message)
      messageBox.closest('.popup').addClass('cvc-error')
    else if response.param == 'exp_month'
      errorBox = $('#pop-cvc-date')
      messageBox = $('#data-cvc-message-box')
      MC.orders.addErrorMessage(errorBox, messageBox, response.message)
      messageBox.closest('.popup').addClass('month-error')
    else if response.param == 'exp_year'
      errorBox = $('#pop-cvc-date')
      messageBox = $('#data-cvc-message-box')
      MC.orders.addErrorMessage(errorBox, messageBox, response.message)
    else
      errorBox = $('#pop-card')
      messageBox = $('#card-message-box')
      MC.orders.addErrorMessage(errorBox, messageBox, response.message)
      messageBox.closest('.popup').addClass('number-error')


  addErrorMessage: (errContainer, errMessageContainer, errMessage) ->
    errContainer.removeClass('hidden')
    errMessageContainer.text(errMessage)

  addClearBinding: (errorField, dangerEl) ->
    errorField.one ('input paste change blur'), ->
      errorField.siblings('.cart-danger').css('right', '')
      errorField.siblings('.cart-danger').addClass('hidden')
      $('.popup-holder').addClass('hidden')
      errorField.off('input paste change blur')
      dangerEl.css('border', '')



  submitCardInfo: (event) ->
    $form = $(@)
    if parseInt($form.data('total-price')) > 0
      event.preventDefault()
      MC.orders.clearErrors()
      $form.find('button').prop('disabled', true)

      Stripe.card.createToken($form, MC.orders.stripeResponseHandler)

      # Prevent the form from submitting with the default action
      return false

  addError: (param) ->
    $("input[data-stripe=#{param}]").closest('.form-group').toggleClass('has-error', true)


  clearErrors: ->
    $('.payment-errors').show()
    $('.form-group').removeClass('has-error')

  ready: ->
    $('#new_order').submit(MC.orders.submitCardInfo)
