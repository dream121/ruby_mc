MC.videoMarketing =

  # all data received, but player not set up yet
  onTemplateLoad: (experienceID) ->
    @experience = brightcove.api.getExperience(experienceID);
    @APIModules = brightcove.api.modules.APIModules;
    @mediaEvent = brightcove.api.events.MediaEvent;

  # player is ready to interact with API
  onTemplateReady: ->
    @videoPlayer = @experience.getModule(@APIModules.VIDEO_PLAYER)
    @videoPlayer.addEventListener(@mediaEvent.BEGIN, @onVideoBegin)
    @videoPlayer.addEventListener(@mediaEvent.PROGRESS, @onVideoProgress)
    MC.experiments.cueAlternateVideo()

  onVideoBegin: ->
    MC.analytics.track 'videos.marketing.begin', { 'id': @videoID, 'course': @courseTitle }

  onVideoProgress: (progress) ->
    # fire "complete" event at 90%
    if (progress.position / progress.duration) >= 0.9 && !@completeEventSent
      MC.analytics.track 'videos.marketing.complete', { 'id': @videoID, 'course': @courseTitle }
      @completeEventSent = true

  ready: ->
    if brightcove?
      @videoID = $('#video-metadata').data('video-id')
      @corseTitle = $('#video-metadata').data('course-title')
      brightcove.createExperiences()

      $('.course-preview-button i').click ->
        $('.button-and-title-wrapper').addClass('fadeout')
        $('.course-video-preview').addClass('fadein')
        $(".course-video-preview").fadeIn "slow", ->
          $(".course-video-preview").css "z-index", 9


_.bindAll MC.videoMarketing, 'ready', 'onTemplateLoad', 'onTemplateReady', 'onVideoBegin', 'onVideoProgress'
