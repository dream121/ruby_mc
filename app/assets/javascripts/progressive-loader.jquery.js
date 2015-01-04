if (typeof Object.create !== 'function') {
  Object.create = function(o) {
    function F() {};
    F.prototype = o;
    return new F();
  };
}

(function($) {
  var ProgressiveLoader = {
    init: function(options, elem) {
      // Save the element reference, both as a jQuery
      // reference and a normal reference
      this.elem                 = elem;
      this.$elem                = $(elem);

      // Mix in the passed in options with the default options
      this.options = {
        viewTemplatePath: 'sochi',
        triggerId: '#show-more-divider',
        viewContainer: '#questions-and-answers',
        startingPageNo: 1,
        rootNode: 'questions',
        objectNode: 'question',
      };

      //this.options = $.extend({}, this.options, this.dataOptions, options);

      this.options = $.extend({}, this.options, options);

      this.triggerId            = this.options.triggerId;
      this.$trigger             = $(this.triggerId);
      this.$viewContainer       = $(this.options.viewContainer);
      this.courseId             = this.$trigger.data('course-id');
      this.nextUrl              = this.$trigger.data('next-url');
      this.prevUrl              = this.$trigger.data('prev-url');
      this.fetchUrl             = '/api/v1/questions';
      this.pageNo               = this.options.startingPageNo;
      this.viewTemplatePath     = this.options.viewTemplatePath;
      this.rootNode             = this.options.rootNode;
      this.objectNode           = this.options.objectNode;
      this.bindEvents();

      return this;
    },

    getNextUrl: function() {
      return this.nextUrl;
    },

    setNextUrl: function(nextUrl) {
      this.$trigger.data('next-url', nextUrl);
    },

    getPrevUrl: function() {
      return this.prevUrl;
    },

    setPrevUrl: function(prevUrl) {
      this.$trigger.data('prev-url', prevUrl);
    },

    createShowEl: function(data) {
      var el = JST[this.viewTemplatePath](data);
      return $(el);
    },

    bindShowEl: function($el) {
      // potential area to bind for the user
    },

    renderShowEl: function($el, objs, obj) {
      // If the user supplied a function for this event
      if (this.options.onRenderShowEl) {
        this.options.onRenderShowEl.apply(this, [$el, this.$viewContainer, this.$elem]);
      } else { // just render it per the docs
        this.$viewContainer.append($el, objs, obj);
      }
      if (this.options.onRenderLastEl && typeof obj[this.objectNode] != undefined && (objs.last_id == obj[this.objectNode].id)) {
        MCLoader = {
          prev_page_url: objs.prev_page_url,
          next_page_url: objs.next_page_url,
          last_id: objs.last_id,
          first_id: objs.first_id,
          total_items: objs.total_items,
          items_left: objs.items_left
        };
        this.options.onRenderLastEl.apply(this, [$el, this.$trigger, MCLoader, this.$elem])
      }
    },

    addElements: function(objs) {
      var _i, $el, _objects = objs[this.rootNode];
      if ( _objects ) {
        for ( _i = 0; _i < _objects.length; ++_i ) {
          $el = this.createShowEl(_objects[_i]);
          // potential area to let the end user add the view
          this.bindShowEl($el);
          this.renderShowEl($el, objs, _objects[_i]);
        }
      } else {
        return {};
      }

      if ( this.options.onAfterRenderElements ) {
        MCLoader = {
          prev_page_url: objs.prev_page_url,
          next_page_url: objs.next_page_url,
          last_id: objs.last_id,
          first_id: objs.first_id,
          total_items: objs.total_items,
          items_left: objs.items_left
        };
        this.options.onAfterRenderElements.apply(this, [this.$viewContainer, this.$trigger, MCLoader, this.$elem]);
      }
      this.updateNextUrl(objs.next_page_url);
    },

    updateNextUrl: function(url) {
      this.nextUrl = url;
    },

    bindEvents: function() {
      var context = this;

      context.$trigger.on('click', function(e){
        e.preventDefault();
        context.fetch();
      });

    },

    fetch: function() {
      var context = this;
      $.ajax({
        url: context.nextUrl,
        context: context,
        dataType: 'json',
        type: 'GET',
      })
      .done( context.handleFetch )
      .fail( this.handleError );
    },

    handleFetch: function(data, textStatus, jqXHR ) {
      var objects = data;
      if (this.options.onBeforeRenderElements) {

        this.options.onBeforeRenderElements.apply(this, [objects, textStatus, jqXHR] );
      }
      this.addElements(data);
    },


  };

  //Start plugin
  $.fn.extend({
    'progressiveLoader': function(options) {
      return this.each(function(){
        // Create a new changeUrlForm
        var myProgressiveLoader = Object.create(ProgressiveLoader);

        // Set intialize with plugin options
        myProgressiveLoader.init(options, this);

        // Save the reference to the instance in the elem's data object
        $(this).data('progressiveLoader', myProgressiveLoader);
      });
    },
  });

  $(document).ready(function(){
  });

}(jQuery));
