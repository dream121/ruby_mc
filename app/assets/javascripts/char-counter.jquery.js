if (typeof Object.create !== 'function') {
  Object.create = function(o) {
    function F() {};
    F.prototype = o;
    return new F();
  };
}

(function($) {
  var CharCounter = {
    init: function(options, elem) {
      // Mix in the passed in options with the default options
      this.options = {
        countedField: '#counter-field',
        counterText: '#counter-text',
        direction: 'down', // string 'down, up, d, u
        maxCharacters: 140,
        warningThreshold: 10,
        warningColor: '#E44B4B'
      }

      this.options = $.extend({}, this.options, options);

      // Save the element reference, both as a jQuery
      // reference and a normal reference
      this.elem                 = elem;
      this.$elem                = $(elem);
      this.$countedField        = $(this.options.countedField);
      this.$counterText         = $(this.options.counterText);
      this.direction            = this.options.direction;
      this.maxCharacters        = this.options.maxCharacters;
      this.warningThreshold     = this.options.warningThreshold;
      this.warningColor         = this.options.warningColor;
      this.disabledFlag         = false;
      this.startCounterText();
      this.bindEvents();

      return this;
    },

    bindEvents: function() {
      var context = this;

      context.$countedField.on('keypress keyup change', function(event){
        if ( context.isFieldInputable() == true ) {
          if ( context.disabledFlag == false ) {
            context.updateCounterText();
          } else {
            context.allowKeypress($(event.currentTarget));
            context.disabledFlag = false;
            context.updateCounterText();
          }
        } else {
          if ( context.disabledFlag == false ) {
            context.disabledFlag = true;
            context.disallowKeypress($(event.currentTarget));
            context.updateCounterText();
          }
        }
        context.changeCounterColor();
      });

      context.$countedField.on('paste', function(e){
        e.preventDefault();
        if ( context.isFieldInputable() == true ) {
          context.$countedField.val(context.truncatedPasteValue(e));
        }
      });
    },

    isFieldInputable: function() {
      if ( this.currentCountValue() >= this.maxCharacters ) {
        return false;
      } else if ( this.currentCountValue() <= this.maxCharacters ) {
        return true;
      }
    },

    changeCounterColor: function() {
      if ( this.currentCountValue() >= ( this.maxCharacters - this.warningThreshold )) {
        if ( this.$counterText.css('color') != this.warningColor ) {
          this.$counterText.css('color', this.warningColor);
        }
      } else {
        if ( this.$counterText.css('color') != '' ) {
          this.$counterText.css('color', '');
        }
      }
      return this.$counterText.css('color');
    },

    currentPastedValue: function(e) {
      var pastedText = null;
      if ( window.clipboardData && window.clipboardData.getData ) { // ie
        pastedText = window.clipboardData.getData('Text');
      } else {
        pastedText = e.originalEvent.clipboardData.getData('text/plain');
      }
      return pastedText;
    },

    truncatedPasteValue: function(e) {
      return (this.$countedField.val() + this.currentPastedValue(e)).substring(0, this.maxCharacters);
    },

    isValidMaxChar: function() {
      if ( this.maxCharacters && this.maxCharacters === parseInt(this.maxCharacters) ) {
        return true;
      } else {
        return false
      }
    },

    currentCountValue: function() {
      return this.$countedField.val().length;
    },

    startCounterText: function() {
      this.$counterText.text(this.maxCharacters)
    },

    updateCounterText: function() {
      var val = null;
      if ( this.direction == 'down' && this.isValidMaxChar() == true ) {
        val = (this.maxCharacters - this.currentCountValue());
        this.$counterText.text(val);
      } else {
        val = this.currentCountValue();
        this.$counterText.text(val);
      }
      return val;
    },

    disallowKeypress: function(el) {
      el.bind('keypress.one', function(event) {
        event.preventDefault();
      });
    },

    allowKeypress: function(el) {
      el.unbind('keypress.one');
    },

  };

  //Start plugin
  $.fn.extend({
    'charCounter': function(options) {
      return this.each(function(){
        // Create a new changeUrlForm
        var myCharCounter = Object.create(CharCounter);

        // Set intialize with plugin options
        myCharCounter.init(options, this);

        // Save the reference to the instance in the elem's data object
        $(this).data('charCounter', myCharCounter);
      });
    },
  });

  $(document).ready(function(){
  });

}(jQuery));
