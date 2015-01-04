if (typeof Object.create !== 'function') {

  Object.create = function(o) {
    function F() {};
    F.prototype = o;
    return new F();
  };
}

(function($) {
  var AnswerForm = {
    init: function(options, elem) {
      // Mix in the passed in options with the default options
      this.options = {
        baseUrl: '/api/v1/answers/'
      }

      this.options = $.extend({}, this.options, options);

      // Save the element reference, both as a jQuery
      // reference and a normal reference
      this.elem             = elem;
      this.$elem            = $(elem);
      this.questionId       = this.$elem.data('questionid');
      this.baseUrl          = this.options.baseUrl;
      var _self              = this;
      this.bindEvents();

      return this;
    },

    on: function(eventName, callback) {
      $(window).on("answerForm:" + eventName, callback);
    },

    off: function(eventName, callback) {
      $(window).off("answerForm:" + eventName, callback);
    },

    one: function(eventName, callback) {
      $(window).on("answerForm:" + eventName, callback);
    },

    trigger: function(eventName, options) {
      $(window).trigger("answerForm:" + eventName, options);
    },

    findUrl: function() {
      return this.baseUrl + this.questionId
    },

    createUrl: function() {
      return this.baseUrl
    },

    updateUrl: function() {
      return this.baseUrl + this.questionId
    },


    bindEvents: function() {
      var context = this;
      this.$elem.on('click', function(e) {
        e.preventDefault();
        context.find();
      });

      //this.off('recordFound')
      this.on('recordFound', function(e, options) {
        context.insertRowHtml();
      });

      this.on('recordCreated', function(e, options) {

      });

      this.on('recordUpdated', function(e, options) {

      });

    },

    insertRowHtml: function() {
      console.log('the insertRow is executed');
      var html = this.createRowHtml();
      html.insertAfter(this.$elem.closest('tr'));
    },

    createRowHtml: function() {
      var html = JST['views/answers/_show']();
      return $(html);
    },

    find: function() {
      console.log('this is happenning')
      var context = this;
      $.ajax({
        url: context.findUrl(),
        dataType: 'json',
        type: 'GET',
        data: {
          answer: {
            question_id: context.questionId
          }
        }
      })
      .done(context.handleFind(context))
      .fail( this.handleError );
    },

    create: function() {
      var context = this;
      $.ajax({
        url: context.createUrl(),
        dataType: 'json',
        type: 'POST',
        data: {
          answer: {

          }
        }
      })
      .done( this.handleCreate )
      .fail( this.handleError )
    },

    update: function() {
      var context = this;
      $.ajax({
        url: context.updateUrl(),
        dataType: 'json',
        type: 'PUT',
        data: {
          answer: {

          }
        }
      })
      .done( this.handleUpdate )
      .fail( this.handleError )
    },

    handleFind: function(data, textResponse, jqXHR) {
      console.log('the callback is happening');
      //console.log(this);
      //console.log(data);
      this.insertRowHtml();
    },

    handleCreate: function(data, textResponse, jqXHR) {
      console.log(this);
      this.trigger('recordCreated', {
        data: data
      });
    },

    handleUpdate: function(data, textResponse, jqXHR) {
      this.trigger('recordUpdated', {
        data: data
      });
    },

    handleError: function() {

    },

  };

  //Start plugin
  $.fn.extend({
    'answerForm': function(options) {
      return this.each(function(){
        // Create a new changeUrlForm
        var myAnswerForm = Object.create(AnswerForm);

        // Set intialize with plugin options
        myAnswerForm.init(options, this);

        // Save the reference to the instance in the elem's data object
        $(this).data('answerForm', myAnswerForm);
      });
    },
  });

  $(document).ready(function(){
  });

}(jQuery));
