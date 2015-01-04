class HomePageDecorator < Draper::Decorator
  delegate_all

  def image_url(kind=:banner, format=:original)
    image = images.find_by kind: kind
    image.image.url(format) if image
  end

  def image_kinds
    %w(banner)
  end


end
