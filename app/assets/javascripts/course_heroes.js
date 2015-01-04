$(function(){
  var container          = $('.hero-uploads');
  var item_container     = container.find('.hero-upload-items');
  var course_id          = container.data('course-id');
  var hero_upload_button = $('.add-hero-image');
  var create_upload_url  = hero_upload_button.attr('href');

  var append_hero_item = function(data){
    var el = JST['views/course/upload'](data)
    item_container.find('.row').append(el);
    bind_destroy_buttons();
    bind_kind_selects();
  }

  var bind_destroy_buttons = function(){
    $('.hero-destroy').on('ajax:success', function(ev, data, status, xhr) {
      var hero_item = $(this).closest('.hero-item');
      filepicker.remove({ url: data.url }, function(){
        hero_item.fadeOut();
      });
    });
  }
  bind_destroy_buttons();

  var picker_options = {
    uploadMimes: [
      'image/gif', 'image/jpeg', 'image/pjpeg', 'image/png',
      'video/avi', 'video/quicktime', 'video/mpeg', 'video/mp4',
      'video/ogg', 'video/webm', 'video/x-ms-wmv', 'video/x-flv',
      'video/x-matroska', 'video/x-msvideo', 'video/x-dv'
    ],
    pickerClicker: hero_upload_button,
    onFPResultsReady: function(Blobs) {
      var upload_data = {
        course_id: course_id,
        upload: {
          url: Blobs[0].url,
          key: Blobs[0].key,
          mimetype: Blobs[0].mimetype
        }
      }

      $.post(create_upload_url, upload_data, function(data){
        append_hero_item(data);
      });
    }
  }

  container.picker(picker_options);

  var bind_kind_selects = function() {
    $('.upload-kind-select').on('change', function(ev) {
      var form = $(this).closest('form');
      var select_value = $(this).val();
      var upload_id = $(this).closest('.hero-item').data('upload-id');

      form.submit();
    });
  }
  bind_kind_selects();
});
