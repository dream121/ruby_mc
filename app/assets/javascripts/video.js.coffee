MC.video =
  position: null
  progress: null
  chapterID: null
  userID: null
  userCourseID: null

  # all data received, but player not set up yet
  onTemplateLoad: (experienceID) ->
    console.log(experienceID)
    @experience = brightcove.api.getExperience(experienceID);
    @APIModules = brightcove.api.modules.APIModules;
    @mediaEvent = brightcove.api.events.MediaEvent;

  # player is ready to interact with API
  onTemplateReady: ->
    @videoPlayer = @experience.getModule(@APIModules.VIDEO_PLAYER)
    @videoPlayer.addEventListener(@mediaEvent.BEGIN, @onVideoBegin)
    @videoPlayer.addEventListener(@mediaEvent.PROGRESS, @onVideoProgress)
    @videoPlayer.addEventListener(@mediaEvent.COMPLETE, @onVideoComplete)
    # @videoPlayer.play() # pordcupine note this should probably be handled in the video default params, so now it is

  # MEDIA EVENTS
  # http://docs.brightcove.com/en/video-cloud/smart-player-api/reference/symbols/brightcove.api.events.MediaEvent.html

  onVideoProgress: (progress, media) ->
    console.log('firing the event')
    interval = 5 # seconds
    console.log('this is the media: ', media)
    @progress = progress
    boxed = parseInt(progress.position / interval) * interval
    if @position != boxed
      @position = boxed
      @saveVideoProgress()

    # fire "complete" event at 90%
    if (progress.position / progress.duration) >= 0.9 && !@completeEventSent
      MC.analytics.track 'videos.enrolled.complete', { 'id': @videoID, 'chapter': @chapterTitle, 'course': @courseTitle }
      @completeEventSent = true

  onVideoComplete: ->
    @saveVideoProgress()

  saveVideoProgress: ->
    return unless @userCourseID # admins
    MC.log "saveVideoProgress: #{@progress.position}"

    data =
      user_course:
        progress:
          chapter_id: @chapterID,
          position: @progress.position,
          duration: @progress.duration

    $.ajax
      type: 'PUT',
      url: "/api/v1/users/#{@userID}/user_courses/#{@userCourseID}",
      data: data,
      success: @saveVideoProgressSuccess

  saveVideoProgressSuccess: (data, status, xhr) ->
    # MC.log [data, status, xhr]

  onVideoBegin: ->
    MC.log 'video begin'
    MC.analytics.track 'videos.enrolled.begin', { 'id': @videoID, 'chapter': @chapterTitle, 'course': @courseTitle }
    @videoPlayer.seek(@position)

  ready: ->
    if brightcove?
      @userID = $('#chapter-metadata').data('user-id')
      @userCourseID = $('#chapter-metadata').data('user-course-id')
      @chapterID = $('#chapter-metadata').data('chapter-id')
      @chapterTitle = $('#chapter-metadata').data('chapter-title')
      @courseTitle = $('#chapter-metadata').data('course-title')
      @position = $('#chapter-metadata').data('chapter-position')
      @videoID = $('#video-metadata').data('video-id')
      brightcove.createExperiences()

_.bindAll MC.video, 'ready', 'onTemplateLoad', 'onTemplateReady', 'onVideoBegin', 'onVideoProgress', 'onVideoComplete', 'saveVideoProgress', 'saveVideoProgressSuccess'

$(document).ready(MC.video.ready)
$(document).on('page:load', MC.video.ready)
