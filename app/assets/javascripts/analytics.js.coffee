MC.analytics =

  track: (event, data) =>
    _kmq.push ['record', event, data]
    # MC.log [event, data]

  ready: =>
    MC.analytics._trackTabs()
    MC.analytics._trackLinks()
    MC.analytics._trackUI()

    metadata = $('meta[name=user-metadata]')
    if metadata.length > 0
      _kmq.push(['identify', metadata.data('km-identity')])


  # PRIVATE:

  _trackTabs: ->
    $('a.track-tab').click (e) =>
      href = e.target.attributes['href'].value
      MC.analytics.track 'tabs.click', { 'href': href }

  _trackUI: ->
    $('.track-ui').click (e) =>
      title = e.target.attributes['title'].value
      tag = e.target.tagName
      MC.analytics.track 'ui.click', { 'title': title, tag: tag }

  _trackLinks: ->
    $('a.track-outgoing').click (e) ->
      MC.analytics._trackLinkClickEvent(e)

  _trackLinkClickEvent: (e) ->
    e.preventDefault()
    href = e.target.attributes.href.value
    MC.analytics.track 'links.click', { 'href': href }
    setTimeout ->
      location.href = href
    , 100

_.bindAll MC.analytics, 'ready', '_trackLinkClickEvent'
