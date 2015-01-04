MC.instructor =
  ready: =>
    if $('body#instructors').length > 0

      filepicker.setKey('AMWWtbU5VRVOMxeytNPx3z')

      uploadFile = (image_list, input)->
        filepicker.pickAndStore
          mimetype: 'image/*'
          folders: true
          multiple: false
          maxSize: 5.24e+7
        ,
          location: 's3'
          access: 'public'
        , (Blob) ->

          blob = Blob[0]

          addToList(image_list, blob)
          $(input).val(blob['url'])

      deleteFile = (blob, input)->
        filepicker.remove blob, ->
          $(input).val('')

      addToList = (list, data) ->
        url = data['url']
        $(list).find('em').remove()
        $("<li><a href='#{url}'>#{url}</a></li>").appendTo(list)

      $('.delete-image').click((e)->
        e.stopPropagation()
        e.preventDefault()

        context = $(this).parents('.filepicker-upload')

        blob  = context.find('input').val()
        input = context.find('input')

        deleteFile(blob, input)
        $(this).parent().html("<em>file removed</em>")
      )

      $('.upload-image').click((e)->
        e.stopPropagation()
        e.preventDefault()

        context = $(this).parent()

        image_list = context.find('.upload-list')
        input      = context.find('input')

        uploadFile(image_list, input)
      )


      height = $('.holder').height()
      $('.video-title').css('height', height)
      $('.holder object').css('height', height)

      $(window).on 'resize', ->
        if $('.dialog')
          height = $('.dialog').height()
          $('.symbol').css('height', height)
          $('.q-and-a-video').css('height', height)
