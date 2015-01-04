if (typeof Object.create !== 'function') {

  Object.create = function(o) {
    function F() {};
    F.prototype = o;
    return new F();
  };
}

(function($) {
  var Picker = {
    init: function(options, elem) {
      // Mix in the passed in options with the default options
      this.options = {
        uploadMimes: [
          'image/gif',
          'image/jpeg',
          'image/pjpeg',
          'image/png'
        ],
        uploadServices: [
          'COMPUTER',
          'FACEBOOK'
        ],
        pickerField: '#fp-field',
        thumbField: '#fp-thumbField',
        fullsizeField: '#fp-fullsize',
        fpKey: 'AMWWtbU5VRVOMxeytNPx3z',
        pickerClicker: '#fp-click-target',
        multipleFiles: false,
        maxSize: 5.24e+7,
        location: 's3',
        access: 'public',
        fpRemoveElSelector: '#fake',
      }

      this.options = $.extend({}, this.options, options);

      // Save the element reference, both as a jQuery
      // reference and a normal reference
      this.elem                     = elem;
      this.$elem                    = $(elem);
      this.baseUrl                  = this.options.baseUrl;
      this.uploadServices           = this.options.uploadServices;
      this.uploadMimes              = this.options.uploadMimes;
      this.$pickerField             = $(this.options.pickerField);
      this.$pickerClicker           = $(this.options.pickerClicker);
      this.$thumbField              = $(this.options.thumbField);
      this.$fullSizeField           = $(this.options.fullsizeField);
      this.fpRemoveElSelector       = this.options.fpRemoveElSelector;
      this.fpkey                    = this.options.fpKey;
      this.multipleFiles            = this.options.multipleFiles;
      var _self                     = this;
      this.setFPKey();
      this.bindEvents();

      return this;
    },

    bindEvents: function() {
      context = this;
      context.$pickerClicker.on('click', function(e){
        e.preventDefault();
        context.activatePicker();
      });

      $(this.$elem).on('click', this.fpRemoveElSelector, function(e){
        e.preventDefault();
        context.removePickerFile();
      });

    },

    setFPKey: function() {
      filepicker.setKey(this.fpkey);
    },

    removePickerFile: function() {
      var context = this;

      if ( this.onBeforeRemovePickerFile ) {

        this.options.onBeforeRemovePickerFile.apply(this, []);

      } else {

        filepicker.remove({url: this.$pickerField.val() }, function() {

          if ( context.options.onAfterRemovePickerFile ) {

            context.options.onAfterRemovePickerFile.apply(this, []);

          } else {

            if ( context.$pickerField && typeof context.$pickerField != 'undefined' ) {
              context.$pickerField.val('');
            }

            if ( context.$thumbField && typeof context.$thumbField.empty != 'undefined' ) {
              context.$thumbField.empty();
            }
            if ( context.$fullsizeField && typeof context.$fullsizeField.empty != 'undefined' ) {
              context.$fullsizeField.empty();
            }

          }
        });
      }
    },

    activatePicker: function() {
      var context = this;

      filepicker.pickAndStore({
        multiple: this.multipleFiles,
        maxSize: 5.24e+7,
        mimetype: this.uploadMimes,
        services: this.uploadServices,
      },
      {
        location: 's3',
        access: 'public'
      },
      function(Blobs) {
        context.handlePickerResults(Blobs, context)
      },
      function(FPError) { }
      );
    },

    handlePickerResults: function(Blobs, context) {
      if ( this.options.onFPResultsReady ) {
        this.options.onFPResultsReady.apply(this, [Blobs, this.$thumbField, this.$pickerField, this.$fullsizeField ]);
      } else {
        this.updatePickerFields(Blobs, context)
      }
    },

    updatePickerFields: function(Blobs, context) {

    },

  };

  //Start plugin
  $.fn.extend({
    'picker': function(options) {
      return this.each(function(){
        // Create a new changeUrlForm
        var myPicker = Object.create(Picker);

        // Set intialize with plugin options
        myPicker.init(options, this);

        // Save the reference to the instance in the elem's data object
        $(this).data('picker', myPicker);
      });
    },
  });

  $(document).ready(function(){
  });

}(jQuery));
