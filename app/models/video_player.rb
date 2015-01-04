class VideoPlayer

  attr_reader :params

  DEFAULT_PARAMS = {
    bgcolor: "#FFFFFF",
    # width: 480,
    # height: 270,
    playerID: ENV["BRIGHTCOVE_PLAYER_ID"],
    playerKey: ENV["BRIGHTCOVE_PLAYER_KEY"],
    isVid: true,
    isUI: true,
    autoStart: false,
    dynamicStreaming: true,
    htmlFallback: true
  }

  def initialize(video_id, params={})
    @params = DEFAULT_PARAMS.merge(params)
    @params['@videoPlayer'] = video_id
  end

  def self.for_marketing_page(video_id)
    params = {
      includeAPI: true,
      templateLoadHandler: 'MC.videoMarketing.onTemplateLoad',
      templateReadyHandler: 'MC.videoMarketing.onTemplateReady'
    }
    self.new(video_id, params)
  end

  def self.for_chapter_page(video_id)
    params = {
      includeAPI: true,
      templateLoadHandler: 'MC.video.onTemplateLoad',
      autoStart: false,
      templateReadyHandler: 'MC.video.onTemplateReady'
    }
    self.new(video_id, params)
  end

  def self.for_office_hours_page(video_id, options = {})
    params = {
      includeAPI: true,
      templateLoadHandler: 'MC.office_hour.onTemplateLoad',
      autoStart: false,
      templateReadyHandler: 'MC.office_hour.onTemplateReady',
      playerID: '3843043672001',
      playerKey: 'AQ~~,AAACfm5YCLE~,QvFK8KCmpdsFIY4MHAczuHrGz7MXp3pQ'
    }
    params.merge!(options)
    self.new(video_id, params)
  end
end
