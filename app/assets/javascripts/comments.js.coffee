MC.forums =
  # Logic to handle expanding and retracting the correct number of
  # comments
  handleExpanderRetractorClick: (e, container, $elem) ->
    if $elem.hasClass('opened')
      $elem.removeClass('opened').addClass('closed')
      if $elem.hasClass('outer')
        $('.dynamic-outer', container).slideUp('fast')
      else
        $('.commentable:lt(-5)', container).slideUp('fast')
    else if $elem.hasClass('closed')
      $elem.removeClass('closed').addClass('opened')
      if $elem.hasClass('outer')
        $('.dynamic-outer', container).fadeIn('fast')
      else
        $('.commentable', container).fadeIn('fast')

  # Handlers for progressive loader
  onBeforeRenderElements: (objects, textStatus, jqXHR) ->

  onRenderShowEl: ($el, $viewContainer, $elem) ->
    depth = $el.data('depth')
    $el.insertAfter($elem).hide().fadeIn('fast')
    commentPlugin = $('#discussion-container').data('commentForm')
    if depth == 2
      $el.addClass('dynamic-outer')
      $vc = $('.post-block', $el)
      parentId = $el.data('comment-id')
      userImageUrl = $('#discussion-container').data('user-profile-image-url')
      userId = $('#discussion-container').data('user-id')

      options =
        parentId: parentId
        userImageUrl: userImageUrl
        userId: userId
      $replyEl = JST['views/course_comments/form'](options)
      $vc.append($replyEl).hide().fadeIn('fast')
      commentPlugin.fetch({parent_id: parentId}, $vc)

  onRenderLastEl: ($el, $trigger, mcLoader, $elem) ->
    # $trigger.slideUp('fast')
    $trigger.hide()

  onAfterRenderElements: ($viewContainer, $trigger, mcLoader, $elem) ->
    $elem.off('click')
    # $('#collapse-reply-text', $elem).text('Collapse replies')
    $elem.addClass('opened')
    $elem.on 'click', (e) ->
      container = $(this).parent()
      MC.forums.handleExpanderRetractorClick(e, container, $elem)



  getOptions: ($el) ->
    options =
      viewTemplatePath: $el.data('view-template-path')
      triggerId: "##{$el.data('trigger-id')}"
      viewContainer: "##{$el.data('view-container')}"
      rootNode: "#{$el.data('root-node')}"
      objectNode: $el.data('object-node')
      onBeforeRenderElements: MC.forums.onBeforeRenderElements
      onRenderShowEl: MC.forums.onRenderShowEl
      onRenderLastEl: MC.forums.onRenderLastEl
      onAfterRenderElements: MC.forums.onAfterRenderElements
  # end Handlers for progressive loader

  ready: ->

    # jQuery option Object literal for filepicker-jquery.js
    pickerOptions =
      pickerField: '#image_url'
      thumbField: '#fp-thumb'
      fullsizeField: 'fake'
      fpkey: 'AMWWtbU5VRVOMxeytNPx3z'
      fpRemoveElSelector: '#fp-remover'
      pickerClicker: '#fp-clicker'
      multipleFiles: false
      location: 's3'
      access: 'public'
      onFPResultsReady: (Blobs, $thumbnailField, $pickerField, $fullsizeField, context) ->
        el = JST['views/course_comments/comment_image'](Blobs[0])
        $thumbnailField.empty().html(el)
        $pickerField.val(Blobs[0].url)

    # jQuery option Object literal for comment-jquery.js
    commentFormOptions =
      onRenderFirstFocusedEl: (options, showObject) ->

      onRenderLastFocusedEl: (options, showObject, ids) ->
        # expand the comment as they come in
        idList = ids.join(', ')
        $(ids.join(', ')).removeClass('hidden')
        $(idList).hide()
        $(idList).fadeIn('slow')
      onRenderFocusedEl: (options, showObject) ->

      onAfterFormSubmission: (data, textResponse, jqXHR, $viewContainer) ->
        if $viewContainer
          $('textarea', $viewContainer).val('')
        else
          $('#fp-thumb').empty()
          $('textarea', '#comment-form-container').val('')
          $('#image_url', $viewContainer).val('')
      onAfterCollapseBarInserted: ($elParam) ->
        element = $('#' + $elParam.attr('id'))
        $('#' + $elParam.attr('id')).progressiveLoader(MC.forums.getOptions(element))

    # Random jQuery to hide the discussion-block
    # this really should be replaced with CSS
    # $('.discussion-block').hide()

    # jQuery Plugin initiations
    $('#discussion-container').commentForm(commentFormOptions)
    $('#comment-form-container').picker(pickerOptions)
