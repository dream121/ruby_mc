module UploadsHelper
  def upload_s3_url(key)
    "//masterclass-airasmussen.s3.amazonaws.com/#{key}"
  end
end
