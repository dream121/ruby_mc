$(function(){
  // profile photo upload
  var photoUploadButton = $('.photo').find('a.edit');
  var pickerOptions = {
    pickerClicker: photoUploadButton,
    onFPResultsReady: function(Blobs) {
      var removeBlobUrl = $('.photo').find('img').attr('src');
      var modifiedBlob = $.extend(Blobs[0], { context: "profile" })
      $.post('/account/add_image', modifiedBlob, function(data){
        filepicker.remove({ url: removeBlobUrl }, function(){
          $('.photo').replaceWith(data.html);
        });
      });
    }
  }
  $('.photo').picker(pickerOptions);

  // get comments button
  $('.get_all_comments').each(function(){
    var button            = $(this);
    var button_container  = button.closest('.show-block');
    var comment_container = button_container.closest('.discussion-block');

    var request_params = {
      result_only: true,
      user_id: button.attr('data-user-id'),
      course_id: button.attr('data-course-id'),
      offset: button.attr('data-offset')
    }

    button.click(function(e){
      e.preventDefault();

      button_container.hide(0, function(){
        comment_container.append('<div class="loader-container"><img class="loader" src="/assets/ajax-loader.gif" /></div>');
      });

      $.get(button.attr('href'), request_params, function(data){
        el = JST['views/course_comments/profile_comment_block']({ comments: data });
        $('.loader-container').hide();
        comment_container.append(el);
      });
    });
  });

  // rating form
  $('.review_rating').each(function() {
    var form = $(this);
    var rating = form.find('ul.stars');
    var review_container = form.find('.review-container');
    var edit_review = review_container.find('a.edit');
    var review = form.find('textarea');
    var submit = form.find('.course-review-submit');

    if(!review.val().trim()) {
      edit_review.hide();
    }

    edit_review.click(function(e){
      e.preventDefault();
      review_container.hide(0, function(){
        review.show();
      });
    });

    review.on({
      click: function(){
        rating.slideUp('fast', function(){
          submit.slideDown('fast');
        });
      }
    });

    // clicking outside of textarea for
    // rating hides post button and shows
    // stars
    $(document).mouseup(function(e){
      if(!form.is(e.target) && form.has(e.target).length === 0) {
        submit.slideUp('fast', function(){
          rating.slideDown('fast');
        });
      }
    });

    // new/update form
    form.on('ajax:success', function(ev, data, status, xhr){
      var form = $(this);

      var review_id_options = {
        form: form,
        review_id: data.id,
        css_id: "course_" + data.course_id + "_course_review_review_id",
        name: "course_review[review_id]"
      }

      add_review_id_field(review_id_options);
      add_method_field(form, 'patch');

      form.attr('action', data.edit_action_url);

      review_container.find('.review-text').html(review.val());

      if(review.val().trim()) {
        submit.slideUp('fast', function(){
          rating.slideDown('fast', function(){
            review_container.show(0, function(){
              edit_review.show(0);
              review.hide(0);
            });
          });
        });
      } else {
        submit.slideUp('fast', function(){
          rating.slideDown('fast');
        });
      }
    });
  });

  // star rating
  var set_stars = function(form_id, stars) {
    for(i = 1; i <= 5; i++) {
      if(i <= stars) {
        $("#" + form_id + "_" + i).addClass("on");
      } else {
        $("#" + form_id + "_" + i).removeClass("on");
      }
    }
  }

  var add_review_id_field = function(options) {
    var review_id_field = '<input type="hidden" id="'+ options.css_id +'" name="'+ options.name +'" value="'+ options.review_id +'" />';
    if(options.form.find('#'+options.css_id).length == 0) {
      options.form.append(review_id_field);
    }
  }

  var add_method_field = function(form, method) {
    var method_field = '<input type="hidden" name="_method" value="'+ method +'" />';
    if(form.find('input[value="'+ method +'"]').length == 0) {
      form.append(method_field);
    }
  }

  $('.review_rating .rating-star').click(function(){
    var star    = $(this);
    var stars   = star.data('star-position');
    var form_id = star.data('form-id');
    var form    = $("#" + form_id);

    $("#" + form_id + "_rating").val(stars);

    $.ajax({
      type: "post",
      url: form.attr('action'),
      data: form.serialize(),
      success: function(data){
        set_stars(form_id, $("#" + form_id + "_rating").val());
        var review_id_options = {
          form: form,
          review_id: data.id,
          css_id: "course_" + data.course_id + "_course_review_review_id",
          name: "course_review[review_id]"
        }

        add_review_id_field(review_id_options);
        add_method_field(form, 'patch');

        form.attr('action', data.edit_action_url);
      }
    });
  });

  // set stars init
  $('.review_rating').each(function() {
    var form_id = $(this).attr('id');
    set_stars(form_id, $("#" + form_id + "_rating").val());
  });

  var updateFormValues = function(form, data){
    var re = /\[(.*?)\]/

    form.find('input[type="text"]').each(function(){
      var name  = $(this).attr('name');
      var key   = re.exec(name)[1];
      var value = $(this).val();

      $(this).attr('value', value);
    });
  }

  // headline
  $('.about .edit, .edit-profile').click(function(e) {
    e.preventDefault();

    var container   = $(this).parent().parent();

    container.find('.headline-info').hide(0, function(){
      container.find('.headline-form').show();
    });
  });

  // hide form on cancel
  $('.headline-form').find('input.reset').click(function(e) {
    var form = $('.headline-form');

    form.hide(0, function(){
      $(this).prev().show();
    });
  });

  $('.headline-form').on('ajax:success', function(ev, data, status, xhr){
    var headline_info = $(this).prev();
    var tagline       = data.tagline;
    var city          = data.city;
    var country       = data.country;

    updateFormValues($(this), data);

    headline_info.find("[data-field-name]").each(function(){
      var new_value     = data[$(this).data('field-name')];
      var field_name    = $(this).data('field-name');
      var profile_value = $(this).attr('data-profile-value');
      var default_value = $(this).attr('data-default-value');

      $(this).attr('data-profile-value', new_value);

      if(field_name == 'country') {
        if(country != "" && city !="") {
          $(this).html(", " + new_value);
        } else {
          $(this).html(new_value);
        }
      } else if(field_name == 'tagline') {
        if(tagline != "" && (city != "" || country != "")) {
          $(this).html(new_value + " | ");
        } else {
          $(this).html(new_value);
        }
      } else if(field_name == '') {

      } else {
        $(this).html(new_value);
      }
    });

    $(this).hide(0, function(){
      headline_info.show();
    });
  });

});
