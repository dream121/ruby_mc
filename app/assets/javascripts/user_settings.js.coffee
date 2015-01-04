MC.userSettings =
  replyAtMeCheckbox: null
  replyAtMeCheckboxUi: null
  removeImageButton: null

  bindRemoveEvent: (url) ->
    klass = $('.visual a.remove')

    if !url
      url = $('.visual').find('img').attr('src')

    klass.on 'ajax:success', (e, data, status, xhr) =>
      html = data.html

      filepicker.remove { url: url }, () ->
        $('.visual').replaceWith(html)

  bindEvents: () ->
    @replyAtMeCheckboxUi.on 'click', (event) =>

      if @replyAtMeCheckboxUi.hasClass('jcf-unchecked')
        $('.jcf-radio').addClass('jcf-unchecked').removeClass('jcf-checked')
        $('input:radio', '#radio-list').removeAttr('checked')
        @replyAtMeCheckbox.removeAttr('checked')
      else
        rad1 = $('input:radio', '#radio-list').first().attr('checked', 'checked')
        rad1.closest('.jcf-radio').addClass('jcf-checked').removeClass('jcf-unchecked')
        @replyAtMeCheckbox.attr('checked', 'checked')

    $('.jcf-radio', '#radio-list').on 'click', (event) =>
      if @replyAtMeCheckboxUi.hasClass('jcf-unchecked')
        @replyAtMeCheckboxUi.addClass('jcf-checked').removeClass('jcf-unchecked')
        @replyAtMeCheckbox.attr('checked', 'checked')

    @changeImageButton.on 'click', (event) =>
      event.preventDefault()

  ready: ->
    MC.userSettings.replyAtMeCheckbox   = $('#reply_at_me')
    MC.userSettings.replyAtMeCheckboxUi = MC.userSettings.replyAtMeCheckbox.closest('.jcf-checkbox')
    MC.userSettings.changeImageButton   = $('#change-image')
    MC.userSettings.changeImageButton   = $('#change-image')
    MC.userSettings.profilePicture      = $('#profile-picture')
    MC.userSettings.removeImageButton   = MC.userSettings.profilePicture.find('a.remove')
    $('#uploader').up()

    @bindEvents()
    @bindRemoveEvent()

    pickerOptions =
      pickerClicker: @changeImageButton
      onFPResultsReady: (Blobs) ->

        $.post '/account/add_image', Blobs[0], (data) ->
          $('.visual').replaceWith(data.html)
          MC.userSettings.bindRemoveEvent($('.visual img').attr('src'))

    @profilePicture.picker(pickerOptions)


