class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  has_attached_file :video, :styles => {
    :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }
  }, :processors => [:ffmpeg]

  validates_attachment_content_type :video, :content_type => /\Avideo\/.*\Z/

end
