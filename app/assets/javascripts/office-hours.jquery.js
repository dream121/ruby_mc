if (typeof Object.create !== 'function') {

  Object.create = function(o) {
    function F() {};
    F.prototype = o;
    return new F();
  };
}

(function($) {
  var UploadForm = {
    init: function(options, elem) {
      // Mix in the passed in options with the default options
      this.options = {
        nodeRoot: 'question',
        validateFields: ['#question_subject', '#text-question', '#video-url'],
        updateBaseUrl: '/api/v1/users/:user_id/cart/add_coupon',
        findBaseUrl: '/api/v1/users/:user_id/cart',
        userIdToken: ':user_id',
        priceTarget: '#total-price',
        uploadMimes: [
          'video/quicktime',
          'video/x-msvideo',
          'video/x-ms-wmv',
          'application/octet-stream',
          'video/mp4',
          'video/mp4v-es',
          'video/mpeg',
          'application/x-3gp',
          'video/3gpp2',
          'video/x-m4v',
          'video/3gpp',
          'video/avi',
          'video/x-flv',
          'binary/octet-stream'
        ],
        uploadServices: [
          'COMPUTER',
        ],
        webcamMimes: [
          'video/quicktime',
          'video/x-msvideo',
          'video/x-ms-wmv',
          'application/octet-stream',
          'video/mp4',
          'video/mp4v-es',
          'video/mpeg',
          'application/x-3gp',
          'video/3gpp2', 
          'video/x-m4v', 
          'video/3gpp', 
          'video/avi', 
          'video/x-flv',
          'binary/octet-stream'
        ],
        webcamServices: [
          'VIDEO'
        ]
      }

      this.options = $.extend({}, this.options, options);

      // Save the element reference, both as a jQuery
      // reference and a normal reference
      this.elem                     = elem;
      this.$elem                    = $(elem);
      this.baseUrl                  = this.options.baseUrl;
      this.uploadServices           = this.options.uploadServices;
      this.webcamServices           = this.options.webcamServices;
      this.$hiddenVideoField        = $('#video-url');
      this.$hiddenQuestionTypeField = $('#question-type');
      this.$submitButton            = $('#new-question-answer-form-submit', this.$elem);
      this.$webcamField             = $('#video-field');
      this.webcamWidth              = this.$webcamField.closest('.col-sm-4').outerWidth();
      this.$uploadField             = $('#upload-field');
      this.closeUpload              = this.$uploadField.closest('.col-sm-4');
      this.uploadWidth              = this.$uploadField.closest('.col-sm-4').width();
      this.$textQuestionField       = $('#text-question');
      this.closeText                = this.$textQuestionField.closest('.col-sm-4');
      this.textQuestionWidth        = this.$textQuestionField.closest('.col-container');
      this.$subjectField            = $('#question_subject');
      this.$inputsContainer         = $('#inputs-container');
      this.inputsContainerWidth     = this.$inputsContainer.width();
      this.inputsContainerHeight    = this.$inputsContainer.height();
      this.currentUserId            = this.$elem.data('userid');
      this.courseId                 = this.$elem.data('courseid');
      this.findBaseUrl              = this.options.findBaseUrl;
      this.updateBaseUrl            = this.options.updateBaseUrl;
      this.userIdToken              = this.options.userIdToken;
      this.validateFields           = this.options.validateFields;
      this.originalWidth            = 0;
      this.uf                       = this.$uploadField.closest('.col-sm-4');
      this.tf                       = this.$textQuestionField.closest('.col-sm-4');
      this.wf                       = this.$webcamField.closest('.col-sm-4');
      this.sb                       = this.$submitButton.closest('.wider-column');
      this.tfPosition               = this.tf.position();
      this.wfPosition               = this.wf.position();
      this.sbPosition               = this.sb.position();
      this.ufPosition               = this.uf.position(); 
      this.$formRow                 = this.uf.closest('.row');
      this.formRowHeight            = this.uf.closest('.row').height();
      this.validState               = false;
      this.questionType             = null;
      this.nodeRoot                 = this.options.nodeRoot;
      var _self                     = this;
      $('#column-wrapper').css('height', $('#column-wrapper').height());
      this.disableSubmitButton();
      this.bindEvents();

      return this;
    },

    findUrl: function() {
      return this.findBaseUrl.replace(this.userIdToken, this.currentUserId)
    },

    createUrl: function() {
      return '/api/v1/questions';
    },

    updateUrl: function(id) {
      return this.updateBaseUrl.replace(this.userIdToken, this.currentUserId)
    },

    disableSubmitButton: function() {
      this.$submitButton.attr('disabled', true);
      this.$submitButton.removeClass('mc-active-button');
      this.$submitButton.addClass('mc-inactive-button');
    },

    enableSubmitButton: function() {
      this.$submitButton.removeAttr('disabled');
      this.$submitButton.removeClass('mc-inactive-button');
      this.$submitButton.addClass('mc-active-button');
    },

    validateForm: function() {
      if ((this.$hiddenVideoField.val().length + this.$textQuestionField.val().length) > 0 && (this.$subjectField.val().length > 0 )) {
        if ( this.validState == false ) {
          this.enableSubmitButton();
          this.validState = true;
        }
      } else {
        if (this.validState == true ) {
          this.disableSubmitButton();
          this.validState = false;
        }
      }
    },

    concatValidateFields: function() {
      var fields = this.validateFields.join(", ");
      return fields;
    },

    bindEvents: function() {
      var context = this;
      filepicker.setKey('AMWWtbU5VRVOMxeytNPx3z');

      context.$submitButton.on('click', function(e){
        e.preventDefault()
        if ( context.validState == true ) {
          context.create();
        }

      });

      $('.instructional-text, img.instruct, #upload-rerecord', $('#upload-inputs')).on('click', function(e){
        e.stopPropagation();
        e.preventDefault();
        context.activatePicker(context.uploadServices, context.handleUploadSuccess, context.handleUploadError);
      });

      $('.instructional-text, img.instruct, #webcam-rerecord', $('#webcam-inputs')).on('click', function(e){
        e.stopPropagation();
        e.preventDefault();
        context.activatePicker(context.webcamServices, context.handleWebcamSucess, context.handleWebcamError);
      });

      $('.instructional-text, img.instruct', $('#text-inputs')).on('click', function(e) {
        e.stopPropagation();
        e.preventDefault();
        context.expandTextFieldBox()
      });

      $('#text-remove-text').on('click', function(e){
        e.stopPropagation();
        e.preventDefault();
        context.retractTextBox();
        context.$textQuestionField.val('').change();
      });

      $('#upload-remove-text').on('click', function(e) {
        e.stopPropagation();
        e.preventDefault();
        context.clearHiddenVideoUrl();
        context.retractUploadFieldBox();
      });

      $('#webcam-remove-text').on('click', function(e) {
        e.stopPropagation();
        e.preventDefault();
        context.clearHiddenVideoUrl();
        context.retractWebcamFieldBox();
        $('#webcam-video-flash').empty();
      });

      $(context.concatValidateFields()).on('change blur paste input keypress', function(e){
        context.validateForm()
      });
    },

    activatePicker: function(fpServices, cb, error) {
      var context = this;
      filepicker.pickAndStore({
        multiple: false,
        maxSize: 5.24e+7,
        mimetype: [
          'video/quicktime',
          'video/x-msvideo',
          'video/x-ms-wmv',
          'application/octet-stream',
          'video/mp4',
          'video/mp4v-es',
          'video/mpeg',
          'application/x-3gp',
          'video/3gpp2', 
          'video/x-m4v', 
          'video/3gpp', 
          'video/avi', 
          'video/x-flv',
          'binary/octet-stream'
        ],
        services: fpServices
      },
      {
        location: 's3',
        access: 'public'
      },
      function(Blobs) { cb.apply(context,[Blobs]); },
      function(FPError) {}
      );
    },

    setHiddenVideoUrl: function(fieldVal) {
      this.$hiddenVideoField.val(fieldVal).change();
    },

    clearHiddenVideoUrl: function() {
      this.$hiddenVideoField.val('').change();
    },


    handleWebcamSucess: function(Blobs) {
      var context = this;
      this.setHiddenVideoUrl(Blobs[0].url);
      this.questionType = 'webcam'

      setTimeout(function(){
        context.expandWebcamFieldBox(Blobs);

      }, 500);
    },
    handleUploadSuccess: function(Blobs) {
      var context = this;
      this.setHiddenVideoUrl(Blobs[0].url);
      this.type = 'upload'
      setTimeout(function(){
        context.expandUploadFieldBox(Blobs);
      }, 500);
    },
    setFormElementPositions: function(activeEl) {
      this.uf.css(this.ufPosition);
      this.sb.css(this.sbPosition);
      this.tf.css(this.tfPosition);
      this.wf.css(this.wfPosition);
      this.sb.css('position', 'absolute');
      this.tf.css('position', 'absolute');
      this.wf.css('position', 'absolute');
      this.uf.css('position', 'absolute');
      activeEl.css('z-index', '50');
    },

    unsetFormElementPositions: function(activeEl) {
      this.uf.css(this.ufPosition);
      this.sb.css(this.sbPosition);
      this.tf.css(this.tfPosition)
      this.wf.css(this.wfPosition);
      this.sb.css('position', 'static');
      this.tf.css('position', 'static');
      this.wf.css('position', 'static');
      this.uf.css('position', 'static');
      activeEl.css('z-index', '0');

    },

    expandUploadFieldBox: function(Blobs) {
      var context           = this;
      var webcamToggled     = false;
      var textFieldToggled  = false;

      this.uf.closest('.row').css('height', this.formRowHeight);
      this.setFormElementPositions(this.uf);

      this.uf.stop(true, true).animate(
        {
          left: this.wfPosition.left, width: this.inputsContainerWidth
        },
        {
          duration: 500,
          step: function(now, fx) {
          },
          progress: function(animation, progress, remaining) {
            if (progress > 0.12 && webcamToggled != true) {
              context.hideIntructionalContent();
              webcamToggled = true;
              context.wf.stop(true, true).hide('slide', { direction: 'left' }, 410);
              context.tf.stop(true, true).hide('slide', { direction: 'right' }, 410);
            }
          },
          complete: function() {
            $('#upload-rerecord').removeClass('hidden');
            $('#upload-remove-text').removeClass('hidden');
          }
        }
      );
    },
    retractUploadFieldBox: function() {
      var context           = this;
      var webcamToggled     = false;
      var textFieldToggled  = false;

      this.wf.stop(true, true).show('slide', { direction: 'left' }, 480);
      this.tf.stop(true, true).show('slide', { direction: 'right' }, 480);
      this.uf.stop(true, true).animate(
        {
          left: this.ufPosition.left,
          width: 314
        },
        {
          duration: 500,
          progress: function(animation, progress, remaining) {

          },
          complete: function() {
            context.unsetFormElementPositions(context.uf);
            context.showInstructionalContent();
            $('#upload-rerecord').addClass('hidden');
            $('#upload-remove-text').addClass('hidden');
            context.$formRow.css('height', '');
          }
        }
      );

    },

    expandTextFieldBox: function() {
      var context = this;
      var webcamToggled = false;
      var uploadToggled = false;


      this.uf.closest('.row').css('height', this.formRowHeight);
      this.setFormElementPositions(this.tf);

      this.tf.stop(true, true).animate(
        {
          left: this.wfPosition.left, width: this.inputsContainerWidth
        }, 
        {
          duration: 500,
          progress: function(animation, progress, remaining) {
            if (progress > 0.30 && webcamToggled != true) {
              context.hideIntructionalContent();
              webcamToggled = true; 
              context.wf.stop(true, true).hide('slide', { direction: 'left'}, 480);
            } 

            if (progress > 0.20 && uploadToggled != true) {
              context.uf.stop(true, true).hide('slide', { direction: 'left'}, 480); 
            }
          },
          complete: function() {
            $('#text-remove-text').removeClass('hidden');
            $('#text-question-counter-text').removeClass('hidden');
            context.$textQuestionField.attr('placeholder', 'Add your text question here.');
            context.questionType = 'text'
          }
        }
      );

    },

    retractTextBox: function() {
      var context = this;
      var webcamToggled = false;
      var uploadToggled = false;

      this.$textQuestionField.removeAttr('placeholder');

      this.wf.stop(true, true).show('slide', { direction: 'right' }, 480); 
      this.uf.stop(true, true).show('slide', { direction: 'right' }, 480); 
      this.tf.stop(true, true).animate(
        {
          left: this.tfPosition.left,
          width: 314
        }, 
        {
          duration: 500,
          progress: function(animation, progress, remaining) {

          },
          complete: function() {
            context.unsetFormElementPositions(context.tf);
            context.showInstructionalContent();
            $('#text-remove-text').addClass('hidden');
            $('#text-question-counter-text').addClass('hidden');
            context.$formRow.css('height', '');
          }
        }
      );
    },

    retractWebcamFieldBox: function() {
      var context           = this;
      var uploadToggled     = false;
      var textFieldToggled  = false;

      this.wf.stop(true, true).animate(
        {
          width: 314
        },
        {
          progress: function(animnation, progress, remaining) {

          },
          complete: function() {
            context.unsetFormElementPositions(context.wf);
            context.showInstructionalContent();
            $('#webcam-rerecord').addClass('hidden');
            $('#webcam-remove-text').addClass('hidden');
            context.$formRow.css('height', '');
          }
        }
      );
      this.uf.stop(true, true).show('slide', { direction: 'right' }, 480);
      this.tf.stop(true, true).show('slide', { direction: 'right' }, 480);
    },

    expandWebcamFieldBox: function(Blobs) {
      var context           = this;
      var uploadToggled     = false;
      var textFieldToggled  = false;

      this.uf.closest('.row').css('height', this.formRowHeight);
      this.setFormElementPositions(this.wf);

      this.wf.stop(true, true).animate(
        {
          width: this.inputsContainerWidth
        },
        {
          duration: 500,
          progress: function(animation, progress, remaining) {
            if (progress > 0.12 && uploadToggled != true) {
              context.hideIntructionalContent();
              uploadToggled = true; 
              context.uf.stop(true, true).hide('slide', { direction: 'left' }, 480);
            } 
            if (progress > 0.30 && textFieldToggled != true) {
              textFieldToggled = true; 
              context.tf.stop(true, true).hide('slide', { direction: 'left' }, 480);
            }
          },
          complete: function() {
            $('#webcam-rerecord').removeClass('hidden');
            $('#webcam-remove-text').removeClass('hidden');
            context.renderVideoEl(Blobs, function(Blobs){
              var id = Blobs[0].url.split('.')[0];
              console.log(id);
              dataOptions = {}
              videojs(id, {controls: true, autoplay: true, preload: 'auto' }, function(){
              });
            });
          }
        }
      ); 
    },

    createVideoEl: function(Blobs) {
      var el = JST['views/office_hours/video_preview']({obj: Blobs});
      return $(el);
    },

    renderVideoEl: function(Blobs, callback) {
      var $el = this.createVideoEl(Blobs) 
      $('#webcam-video-flash').html($el);
      callback(Blobs)
      return $el;
    },

    bindVideoEl: function() {

    },

    hideIntructionalContent: function() {
      $('.instructional-text, img.instruct').fadeOut('fast');
    },
    showInstructionalContent: function() {
      $('.instructional-text, img.instruct').show(); 
    },

    addFlashVideo: function(Blobs) {
      var html = JST['views/office_hours/video_preview']({obj: Blobs});
    },

    handleWebcamError: function(FPError) {

    },

    handleUploadError: function(FPError) {

    },

    find: function() {
      var context = this;
      $.ajax({
        url: context.findUrl(),
        dataType: 'json',
        type: 'GET',
        data: {}
      })
      .done(context.handleFind )
      .fail( this.handleError );
    },

    create: function() {
      var context = this;
      var url = this.createUrl();
      var data = {
        question: {
          user_id:          this.currentUserId,
          course_id:        this.courseId,
          thumb_url:        '//placehold.it/448x252',
          subject:          this.$subjectField.val(),
          text_question:    this.$textQuestionField.val(),
          source_url:       this.$hiddenVideoField.val()
        }
      };
      $.ajax({
        url: url,
        context: context,
        dataType: 'json',
        type: 'POST',
        data: data
      })
      .done( this.handleCreate )
      .fail( this.handleError )
    },

    update: function() {
      var context = this;
      $.ajax({
        url: context.updateUrl(),
        context: context,
        dataType: 'json',
        type: 'PUT',
        data: {}
      })
      .done( context.handleUpdate )
      .fail( this.handleError )
    },

    handleFind: function(data, textResponse, jqXHR) {
    },

    handleCreate: function(data, textResponse, jqXHR) {
      var $el = this.createShowEl(data);
      this.bindShowEl($el)
      this.renderShowEl($el);

      if ( this.questionType == 'upload' ) {

      } else if ( this.questionType == 'webcam' ) {
        var arr = data.source_url.split('/');
        var id = arr[arr.length - 1];
        videojs(id, {controls: true, autoplay: false, preload: 'auto' }, function(){
        });
      } else if ( this.questionType == 'text' ) {

      }
    },

    handleUpdate: function(data, textResponse, jqXHR) {
    },

    createShowEl: function(data) {
      var obj = {}
      obj[this.nodeRoot] = data;
      var el = JST['views/office_hours/show'](obj);
      return $(el);
    },

    bindShowEl: function($el) {
      var context = this;
      $('.thank-you-may-i-have-another', $el).on('click', function(e){
        e.preventDefault();
        context.clearForm();
        context.showForm();
      });
    },

    renderShowEl: function($el) {
      $('#thank-you-message-container').html($el);
      $('#new-question').hide();
    },

    handleError: function() {
    },

    clearForm: function() {
      this.$subjectField.val('');
      this.$textQuestionField.val('');
      this.$hiddenVideoField.val('');
      this.questionType = null;
    },

    showForm: function() {
      var context = this;
      this.retractTextBox();
      this.retractUploadFieldBox();
      this.retractWebcamFieldBox();
      setTimeout(function(){
        $('#thank-you-message-container').empty();
        context.disableSubmitButton();
        $('#new-question').show();
      }, 500)
    },

    hideThankYouContainer: function() {
      $('#thank-you-message-container').empty();
    }
  };

  //Start plugin
  $.fn.extend({
    'uploadForm': function(options) {
      return this.each(function(){
        // Create a new changeUrlForm
        var myUploadForm = Object.create(UploadForm);

        // Set intialize with plugin options
        myUploadForm.init(options, this);

        // Save the reference to the instance in the elem's data object
        $(this).data('uploadForm', myUploadForm);
      });
    },
  });

  $(document).ready(function(){
  });

}(jQuery));
