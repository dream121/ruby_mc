class DocumentDecorator < Draper::Decorator
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetUrlHelper

  delegate_all

  def icon
    file = icon_file_for(extension)
    "icons/#{file}"
  end

  def title
    if object.url.blank?
      object.title
    else
      link_to object.title, object.url
    end
  end

  def filename
    if object.document.file?
      object.document.original_filename
    else
      nil
    end
  end

  private

  def extension
    # document.content_type.split(/\//).last
    if object.document.file?
      object.document.original_filename.split(/\./).last.downcase
    end
  end

  def icon_file_for(extension)
    MimeTypeIcons::FILES.detect {|f| f == "#{extension}-icon-128x128.png" } || MimeTypeIcons::DEFAULT
  end
end
