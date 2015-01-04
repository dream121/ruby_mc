class Document < ActiveRecord::Base
  belongs_to :documentable, polymorphic: true
  validates :title, presence: true
  validates :kind, presence: true

  # https://github.com/thoughtbot/paperclip/wiki/Restricting-Access-to-Objects-Stored-on-Amazon-S3
  has_attached_file :document,
    s3_permissions: :private,
    s3_headers: { "Content-Disposition" => "attachment" }
end
