module ApplicationHelper

  def truncate_text(text,options = {})
    defaults = {
      len: 62,
      term: '...'
    }
    defaults = defaults.merge(options)
    len = defaults[:len] - 1
    if text.length > defaults[:len]
      "#{text[0..len]}#{defaults[:term]}"
    else
      "#{text[0..len]}"
    end
  end

  def alert_class(alert_type)
    alert_type = {
      alert: 'error',
      notice: 'info',
      base: 'error'
    }.fetch(alert_type, alert_type.to_s)
    "alert-#{alert_type}"
  end

  def brightcove_script_source
    content_tag(:script, nil, language: "JavaScript", type: "text/javascript", src: "http://admin.brightcove.com/js/BrightcoveExperiences.js")
  end

  def marketing_video_player(video_id)
    player = VideoPlayer.for_marketing_page(video_id)

    content_tag :object, id: 'VideoPlayer', class: 'BrightcoveExperience' do
      player.params.each do |name, value|
        concat(tag :param, name: name, value: value)
      end
    end
  end

  def chapter_video_player(video_id)
    player = VideoPlayer.for_chapter_page(video_id)

    content_tag :object, id: 'VideoPlayer', class: 'BrightcoveExperience', width: 448, height: 252 do
      player.params.each do |name, value|
        concat(tag :param, name: name, value: value)
      end
    end
  end

  def office_hours_video_player(video_id, object_id = nil, options = {})
    player = VideoPlayer.for_office_hours_page(video_id, options)
    id = object_id || 'VideoPlayer'

    content_tag :object, id: id, class: 'BrightcoveExperience', width: 448, height: 252 do
      player.params.each do |name, value|
        concat(tag :param, name: name, value: value)
      end
    end
  end

end
