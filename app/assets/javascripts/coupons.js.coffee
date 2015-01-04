MC.coupon =
  ready: =>
    $('#coupon-form').couponForm()

    # Click handler for the cvc popup
    $('.question').on 'click',(e) ->
      e.preventDefault()
      console.log('the question is being clicked')
      $('.cvc-popup-holder').toggleClass('hidden')

    # removes the cvc popup if another field is entered
    # or a select menu is chosen
    $('input, select').on 'focus input paste blur change', ->
      cvcPopup = $('.cvc-popup-holder')
      unless cvcPopup.hasClass('hidden')
        cvcPopup.addClass('hidden')
