class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  validates :image, attachment_presence: true

  has_attached_file :image, styles: {
    thumb: "100x100#", # centrally cropped
    medium: "400x400>" # only scale down
  }
end
