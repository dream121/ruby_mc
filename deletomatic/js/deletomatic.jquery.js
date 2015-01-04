if (typeof Object.create !== 'function') {

  Object.create = function(o) {
    function F() {};
    F.prototype = o;
    return new F();
  };
}
(function($) {
  var Deletomatic = {
    init: function(options, elem) {
      // Mix in the passed in options with the default options
      this.options = {
        userInputEl: '#usertext-1',
        userConvertedTextEl: '#display-text',
        baseTextEl: '#james-text-1',
        baseConvertedTextEl: '#james-converted-text',
        compareButton: '#compare-button'
      };

      this.options = $.extend({}, this.options, options);

      // Save the element reference, both as a jQuery
      // reference and a normal reference
      this.elem                     = elem;
      this.$elem                    = $(elem);
      this.userInputEl              = $(this.options.userInputEl, this.$elem);
      this.userConvertedTextEl      = $(this.options.userConvertedTextEl, this.$elem);
      this.baseTextEl               = $(this.options.baseTextEl);
      this.baseConvertedTextEl      = $(this.options.baseConvertedTextEl);
      this.compareButton            = $(this.options.compareButton);
      this.isDragging               = false;
      this.bindEvents();

      return this;
    },

    bindEvents: function() {
      context = this;
      this.userInputEl.on('mousedown', function(e){
        document.designMode = 'on';
        $(window).on('mousemove', function(){
          context.isDragging = true;
          $(window).off("mousemove");
        });
      })
      .on('mouseup', function(){
        var wasDragging = context.isDragging;
        context.isDragging = false;
        $(window).off('mousemove');

        if ( !wasDragging ) { // was clicking
          document.designMode = 'off';
        } else { // was dragging
          document.execCommand('strikethrough', true);
          document.designMode = 'off';
          context.setUserInputConvertedHtml();
        }
      });

      this.baseTextEl.on('mousedown', function(e){
        document.designMode = 'on';
        $(window).on('mousemove', function() {
          context.isDragging = true;
          $(window).off('mousemove');

        });
      })
      .on('mouseup', function(){
        var wasDragging = context.isDragging;
        context.isDragging = false;
        $(window).off('mousemove');

        if (!wasDragging) { // was clicking
          document.designMode = 'off';
        } else {
          document.execCommand('strikethrough', true);
          document.designMode = 'off';
          context.setBaseInputConvertedHtml();
        }
      });

      this.compareButton.on('click', function(e){
        e.preventDefault();
        alert('you clicked me!');
      })
    },

    getUserInputHtml: function() {
      return this.userInputEl.html();
    },

    getUserInputConvertedText: function() {
      return this.userConvertedTextEl.text();
    },

    userInputConvertTextToArray: function() {
      return this.getUserInputConvertedText().split('');
    },

    setUserInputConvertedHtml: function() {
      var strikes, strike, i, j;
      this.userConvertedTextEl.html(this.getUserInputHtml());
      strikes = $('strike', this.userConvertedTextEl);


      for ( i = 0; i < strikes.length; ++i ) {
        strike = $(strikes[i]);
        strike.text(strike.text().replace(/\s/g, '').replace(/[^|]/g, '~'));
      }
      this.userConvertedTextEl.text(this.userConvertedTextEl.text().replace(/[^~]/g, '`'));

    },

    setBaseInputConvertedHtml: function() {
      var strikes, stringArray, strike, i, j;
      this.baseConvertedTextEl.html(this.getBaseInputHtml());

      strikes = $('strike', this.baseConvertedTextEl);

      for ( i = 0; i < strikes.length; ++i ) {
        stringArray = []; 
        strike = $(strikes[i]);
        strike.text(strike.text().replace(/\s/g, '').replace(/[^|]/g, '~'));
      }
      this.baseConvertedTextEl.text(this.baseConvertedTextEl.text().replace(/[^~]/g, '`'));
    },

    getBaseInputHtml: function() {
      return this.baseTextEl.html();
    },
    getBaseInputText: function() {
      return this.baseTextEl.text();
    },

    getBaseConvertedHtml: function() {
      return this.baseConvertedTextEl.html();
    },

    getBaseConvertedText: function() {
      return this.baseConvertedTextEl.text();
    },

    baseConvertedTextToArray: function() {
      return this.getBaseConvertedTextEl().split('');
    },

    compareImportantText: function() {

    },

    compareUnwantedText: function() {

    },

    compareRedlinedText: function() {

      var unwantedArr, wantedArr, i, baseArray;
      baseArray = this.baseConvertedTextToArray();
      userArray = this.userInputConvertTextToArray();
      for ( i = 0; i < baseArray.length; ++i) {
        if ( baseArray[i] == '`' ) {
          wantedArr.push(baseArray[i]);
          if ( baseArray[i] == userArray[i] ) {

          } else {

          }

        } else if ( baseArray[i] == '~' ) {
          unwantedArray.push(baseArray[i]);
          if ( baseArray[i] == userArray[i] ) {

          } else {

          }
        }
      }
      return { unwantedArray: unwantedArr }
    },

  };

  //Start plugin
  $.fn.extend({
    'deletomatic': function(options) {
      return this.each(function(){
        // Create a new changeUrlForm
        var myDeletomatic = Object.create(Deletomatic);

        // Set intialize with plugin options
        myDeletomatic.init(options, this);

        // Save the reference to the instance in the elem's data object
        $(this).data('deletomatic', myDeletomatic);
      });
    },
  });

  $(document).ready(function(){
  });

}(jQuery));



