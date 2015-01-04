MC.office_hour =

  onTemplateLoad: (experienceID) =>
    if typeof MC.office_hour.experiences == 'undefined'
      MC.office_hour.experiences = {}
    MC.office_hour.experiences[experienceID] = brightcove.api.getExperience(experienceID)
    @APIModules = brightcove.api.modules.APIModules
    @mediaEvent = brightcove.api.events.MediaEvent

  # player is ready to interact with API
  onTemplateReady: (experienceID, somethingElse) =>
    if typeof MC.office_hour.videoPlayers == 'undefined'
      MC.office_hour.videoPlayers = {}

    MC.office_hour.videoPlayers[experienceID.target.experience.id] = MC.office_hour.experiences[experienceID.target.experience.id].getModule(@APIModules.VIDEO_PLAYER)
    console.log MC.office_hour.videoPlayers[experienceID.target.experience.id]
    MC.office_hour.videoPlayers[experienceID.target.experience.id].addEventListener(brightcove.api.events.MediaEvent.BEGIN, MC.office_hour.onVideoBegin)

    # @videoPlayer = @experience.getModule(@APIModules.VIDEO_PLAYER)
    # @videoPlayer.addEventListener(@mediaEvent.BEGIN, @onVideoBegin)
    # @videoPlayer.addEventListener(@mediaEvent.PROGRESS, @onVideoProgress)
    # @videoPlayer.addEventListener(@mediaEvent.COMPLETE, @onVideoComplete)
    # @videoPlayer.play() # pordcupine note this should probably be handled in the video default params, so now it is

  onVideoBegin: (param) ->
    console.log('the video has begun: ', param)

  ready: =>

    # handles form field expansion, retraction,
    # validation, video uploads, and webcam
    $('#question-form-grid').uploadForm()

    # character counter for text-question
    textQuestionOptions =
      countedField: '#text-question'
      counterText: '#text-question-counter-text'
    $('#text-question').charCounter(textQuestionOptions)

    # character counter for subject_question
    subjectOptions =
      countedField: '#question_subject',
      counterText: '#subject-counter-text',
      maxCharacters: 66
    $('#question_subject').charCounter(subjectOptions)

    # progressive loader for questions and answers
    questionsProgressiveLoaderConfig =
      viewTemplatePath: 'views/office_hours/question_and_answer'
      rootNode: 'questions'
      objectNode: 'question'
      triggerId: '#show-more-divider'
      viewContainer: '#questions-and-answers'

      onBeforeRenderElements: (objects, textStatus, jqXHR) ->
        $('.divider').last().removeClass('hidden')

      onRenderShowEl: ($el, $viewContainer) ->
        $viewContainer.append($el)
        height = $('.dialog', $el).height()
        $('.symbol', $el).css('height', height)
        $('.q-and-a-video').css('height', height)

      onRenderLastEl: ($el, $trigger, mcLoader) ->
        # $('span', $trigger).text("Show Remaining #{mcLoader.items_left}")

      onAfterRenderElements: ($viewContainer, $trigger, mcLoader) ->
        if (mcLoader.items_left <= 0)
          $trigger.remove()
        else
          $('.divider').last().addClass('hidden')

    $('#questions-and-answers').progressiveLoader(questionsProgressiveLoaderConfig)



$ ->
  height = $('.dialog').height()
  $('.symbol').css('height', height)
  $('.q-and-a-video').css('height', height)

  $(window).on 'resize', ->
    if $('.dialog')
      height = $('.dialog').height()
      $('.symbol').css('height', height)
      $('.q-and-a-video').css('height', height)
