MC.experiments =
  variations: ->
    # https://www.optimizely.com/docs/tutorials#reporting-data
    # https://www.optimizely.com/docs/api#data-object

    activeExperiments = window.optimizely.data.state.activeExperiments
    variations = window.optimizely.data.state.variationIdsMap

    # filter the variations by activeExperiments
    activeExperimentData = {}
    for experimentID in activeExperiments
      experimentName = @_experimentName(experimentID)
      variationID = variations[experimentID][0]
      variationName = @_variationName(variationID)
      activeExperimentData[experimentName] = variationName
    activeExperimentData

  _variationName: (id) ->
    window.optimizely.data.variations[id].name

  _experimentName: (id) ->
    window.optimizely.data.experiments[id].name

  ready: =>
    window.optimizely ||= []
    if $('#order-complete').length > 0
      cents = $('#order-complete').data('revenue')
      MC.experiments.trackRevenue(cents)

  # https://help.optimizely.com/hc/en-us/articles/200039865-How-can-I-track-revenue-with-Optimizely-
  trackRevenue: (valueInCents) ->
    window.optimizely.push(['trackEvent', 'order_complete', {'revenue': valueInCents}])

  cueAlternateVideo: ->
    video_id = MC.experiments.variations()['Sample Chapter vs. Overview Video']
    if video_id && video_id != 'Original'
      # MC.log video_id
      MC.videoMarketing.videoPlayer.cueVideoByID(video_id)
