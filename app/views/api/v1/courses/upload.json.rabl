object @upload => :upload
attributes :id, :url, :kind, :key, :mimetype, :uploadable_id

node(:enrolled_upload_types) { |upload| upload.uploadable.decorate.enrolled_hero_kinds }
node :links do |upload|
  {
    :edit => api_v1_course_upload_path(upload.uploadable_id, upload),
    :destroy => api_v1_course_upload_path(upload.uploadable_id, upload)
  }
end
