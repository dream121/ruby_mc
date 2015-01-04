if (typeof Object.create !== 'function') {

  Object.create = function(o) {
    function F() {};
    F.prototype = o;
    return new F();
  };
}


(function($) {
  var CommentForm = {
    init: function(options, elem) {
      // Mix in the passed in options with the default options
      this.elem                   = elem;
      this.$elem                  = $(elem);

      this.options = {
        updateBaseUrl: '/api/v1/users/:user_id/cart/add_coupon',
        createBaseUrl: '/api/v1/course_comments',
        findBaseUrl: '/api/v1/users/:user_id/cart',
        fetchBaseUrl: '/api/v1/course_comments',
        updateBaseUrl: '/api/v1/course_comments/:comment_id',
        commentIdToken: ':comment_id',
        viewContainer: '#comments-view-container',
        commentFormContainer: '#comment-form-container',
        rootNode: 'course_comments',
      }

      this.options = $.extend({}, this.options, options);

      // Save the element reference, both as a jQuery
      // reference and a normal reference
      //this.elem                   = elem;
      //this.$elem                  = $(elem);

      this.baseUrl                = this.options.baseUrl;
      this.fetchBaseUrl           = this.options.fetchBaseUrl;
      this.createBaseUrl          = this.options.createBaseUrl;
      this.chapterId              = this.$elem.data('chapter-id');
      this.courseId               = this.$elem.data('course-id');
      this.userId                 = this.$elem.data('user-id');
      this.userImageUrl           = this.$elem.data('user-profile-image-url');
      this.userName               = this.$elem.data('user-name');
      this.$viewContainer         = $(this.options.viewContainer, this.$elem);
      this.$commentFormContainer  = $(this.options.commentFormContainer, this.$elem);
      this.rootNode               = this.options.rootNode;
      this.ajaxCount              = 0;
      this.updateBaseUrl          = this.options.updateBaseUrl;
      this.queryString            = this.getQueryString();
      this.focused                = null;
      this.counter                = 0;
      // CommentFormInputs
      var _self                   = this;
      this.fetch(this.getQueryObject(this.queryString));
      //this.fetch({roots_only: true});
      this.bindEvents();

      return this;
    },

    getQueryString: function() {
      var qs, arr = window.location.href.split('?');
      if (arr.length > 1) {
        qs = arr[arr.length - 1]
      } else {
        return null; 
      }
      return qs;
    },

    getQueryObject: function(qs) {
      var arr, _i, obj = {}, direction, sortCol;

      if (qs) {

        arr = qs.split('&');
        for ( _i = 0; _i < arr.length; ++_i) {
          var tmp = arr[_i].split('=');
          obj[tmp[0]] = tmp[1]
        }

        if ( obj.hasOwnProperty('sortby') ) {
          if ( obj.sortby == 'likes' ) {
            direction = 'desc';
            sortCol = 'votes'
            return { by: sortCol, direction: direction, limit: 5, votes: 0, roots_only: true }
          } else {
            return { roots_only: true };
          }
        } else if ( obj.hasOwnProperty('comment_id')) {
          return { comment_id: obj.comment_id, focus_id: obj.comment_id }
        } else {
          return { roots_only: true };
        }

      }
      return { roots_only: true };
    },

    getFetchParams: function() {
      var arr;
      if (this.queryString) {

      } else {

        return { root_only: true };

      }
    },

    findUrl: function() {
      return this.findBaseUrl.replace(this.userIdToken, this.currentUserId);
    },

    createUrl: function() {
      return this.createBaseUrl;
    },

    updateUrl: function(id) {
      return this.updateBaseUrl.replace(this.commentIdToken, id);
    },

    fetchUrl: function() {
      return this.fetchBaseUrl;
    },

    getSearchOptions: function(options) {
      return $.extend({},{
        chapter_id: this.chapterId,
        course_id: this.courseId
      }, options);
    },

    getUserOptions: function(options) {
      return $.extend({},{
        user_profile_image_url: this.userImageUrl,
        user_id: this.userId,
        user_user_name: this.userName
      }, options);
    },

    disableSubmitButton: function() {
      this.$submitButton.attr('disabled', true);
    },

    enableSubmitButton: function() {
      this.$submitButton.removeAttr('disabled');
    },


    bindEvents: function() {
      var context = this;
      $('body').on("click", ".course-comment-input", function(e){
        e.preventDefault();
        if ( $(this).closest('form').hasClass('reply-form') ) {
          var $viewContainer = $(this).closest('.post-block');
        }
        context.handleFormSubmission($(this).closest('form'), $viewContainer);
      });

      // exposes the form
      $('body').on("click", ".post-button.reply", function(e){
        e.preventDefault();
        context.handleReplyButtonClick($(this), e);
      });

      $('body').on('click', '.comment-collapse.focused', function(e){
        e.preventDefault(e);
        // This is ridiculous - why is there so much logic in the on event
        // if anything there should be a controller with logic to decide 
        // which callback to use.
        //
        var _self         = $(this), placement, removeIds,
            commentIds,
            depth         = _self.data('depth'),
            expanded      = _self.data('expanded'),
            loaded        = _self.data('loaded'),
            collapseTypeText, collapseStateText;
        if (_self.data('comment-ids').length > 0 ) {
          commentIds = _self.data('comment-ids').join(', ');
        }

        if ( depth == 2 ) {
          collapseTypeText = 'comments';
        } else {
          collapseTypeText = 'replies';
        }

        if ( expanded == true ) {
          collapseStateText = 'expand'
        } else {
          collapseStateText = 'collapse';
        }

        if (_self.hasClass('top')) {
          placement = 'top'
        } else if ( _self.hasClass('bottom')) {
          placement = 'bottom'
        }

        if ( loaded == true ) { // if the ajaxComments have been loaded don't load more

          if ( expanded == true ) {
            commentIds
            $(commentIds).slideUp('fast');
            _self.data('expanded', false)
          } else {
            $(commentIds).slideDown('fast');
            _self.data('expanded', true);
          }

          $('.reply-text', _self).text(collapseStateText + ' ' + collapseTypeText);

        } else { // If the ajax comment haven't
          context.handleProgressiveLoad(placement, _self)
        }

      });

      $('body').on("click", ".like-text, .unlike-text", function(e){
        e.preventDefault();
        // Always cache the jQuery reference to the $el
        var _self = $(this);
        context.handleLikeButtonClick(_self, e);
      });
    },

    handleProgressiveLoad: function(placement, _self) {
      var obj = this.buildProgressiveObject(placement, _self);
      this.progressiveFetch(obj);
    },

    progressiveFetch: function(obj) {
      var context = this;
      $.ajax({
        url: obj.fetchUrl,
        dataType: 'json',
        context: context,
      })
      .done(
        function(data, textResponse, jqXHR) {
          this.handleProgressiveFetch(data, textResponse, jqXHR, obj);
        }
      )
      .fail(
      );

    },

    updateFocusedCollapseBar: function(options, showObject, commentIds) {

      var $collapseBar = $('#' + options.data.triggerObject.uuid),
          cIds         = $collapseBar.data('comment-ids'),
          depth        = $collapseBar.data('depth'),
          collapseText;
      if ( cIds.length > 0 ) {// if there is already data in the attribute
        cIds = cIds.concat(commentIds);
      } else { // if there is no data in the attribute
        cIds = commentIds;
      }

      $collapseBar.data('comment-ids', commentIds);
      $collapseBar.data('expanded', true);
      $collapseBar.data('loaded', true);

      // update the text
      if ( depth == 2 ) {

        collapseText = 'collapse comments'
      } else {
        collapseText = 'collapse replies'
      }
      $('.reply-text', $collapseBar).text(collapseText);
    },

    handleProgressiveFetch: function(data, textResponse, jqXHR, obj, context) {
      var data = $.extend(
        {},
        data,
        { placement: obj.placement, triggerObject: obj, callback: this.updateFocusedCollapseBar }
      );
      var _objects = data.course_comments.reverse();
      this.addFocusedElements(data);
    },

    buildProgressiveObject: function(placement, _self) {
      var obj     = {}, removeIds = _self.data('remove-on-expanded');
      obj.uuid    = _self.attr('id');
      obj.id      = _self.data('comment-id');
      obj.nextUrl = _self.data('next-url');
      obj.prevUrl = _self.data('prev-url');
      obj.depth   = _self.data('depth');
      obj.placement = placement;
      if ( obj.depth == 2 ) {
        obj.viewContainer = this.$viewContainer;
      } else {
        obj.viewContainer = $('#post-block-' + obj.id);
      }
      if ( placement == 'top' ) {
        obj.fetchUrl = obj.nextUrl;
      } else {
        obj.fetchUrl = obj.prevUrl;
      }

      if ( typeof removeIds != 'undefined' && removeIds.length > 0 ) {
        obj.removeIds = removeIds.join(', ');
      }

      return obj;
    },

    handleLikeButtonClick: function($el, evnt) {
      var voteType, $commentContainer = $el.closest('.post.comment.commentable'), data, commentId;
      commentId = $commentContainer.data('comment-id');
      if ( $el.hasClass('like-text') ) {
        voteType = 'up';
      } else if ( $el.hasClass('unlike-text') ) {
        voteType = 'down'
      } else {
        return false;
      }

      data = {
        course_comment: {
          id: commentId,
          vote: voteType,
        }
      };

      this.update(data.course_comment.id, data, $commentContainer)
    },

    handleReplyButtonClick: function($el, evnt) {
      var $context = $el.closest('.post-block');
      var $formEl = $('.post-reply.latent', $context);
      $el.slideUp('fast')//hide();
      $formEl.slideDown('fast');
    },

    handleFormSubmission: function($el, $viewContainer) {
      var context = this,
          $textArea = $('textarea', $el),
          focused = $textArea.hasClass('focused');

      var data = {
        course_comment: {
          comment: $textArea.val(),
          chapter_id: this.chapterId,
          course_id: this.courseId,
          parent_id: $textArea.data('parent-id'),
          user_id: this.userId,
          visible: true,
          image_url: $('#image_url', $el).val(),
        },
        depth: $textArea.data('depth'),
      };
      if ( focused == true ) {
        data.callback = this.handleFocusedCreate;
      }
      this.create(data, $viewContainer);
    },

    handleFocusedCreate: function(data, textResponse, jqXHR, obj ) {
      if ( typeof data != 'undefined' ) {
        var $lastEl, $bottomCollapseBar, $formContainer, $thisEl, removeIds;
        if ( data.depth == 2) {
          $lastEl = $('.commentable.outer').last();
          $thisEl = this.createShowEl({ course_comment: data }).addClass('hidden');
          $formContainer = $('.post.comment.focused');
          $thisEl.insertBefore($formContainer);
          $thisEl.removeClass('hidden').hide().slideDown('fast');

          if ( $('.show-block.focused.bottom.outer').length > 0 ) {
            $bottomCollapseBar = $('.show-block.focused.bottom.outer');

            // the items have not been loaded yet
            if ( $bottomCollapseBar.data('loaded') != true && $bottomCollapseBar.data('expanded') == false ) {
              if ( $bottomCollapseBar.data('remove-on-expanded').length > 0 ) {
                removeIds = $bottomCollapseBar.data('remove-on-expanded').push('#' + data.id);
                $bottomCollapseBar.data('remove-on-expanded', removeIds);
              } else {
                $bottomCollapseBar.data('remove-on-expanded', ['#' + data.id ]);
              }

            }
          }
        } else {
          $thisEl = this.createShowEl({ course_comment: data }).addClass('hidden');
          $parentContainer = $('#' + data.parent_id);
          $formContainer = $('.post.reply.focused', $parentContainer);
          $thisEl.insertBefore($formContainer);
          $thisEl.removeClass('hidden').hide().slideDown('fast');

          $bottomCollapseBar = $('.show-block.focused.bottom', $parentContainer);

          if ( $bottomCollapseBar.length > 0 ) {
            if ($bottomCollapseBar.data('remove-on-expanded').length > 0 ) {
              removeIds = $bottomCollapseBar.data('remove-on-expanded').push('#' + data.id);
              $bottomCollapseBar.data('remove-on-expanded', removeIds);
            } else {
              $bottomCollapseBar.data('remove-on-expanded', ['#' + data.id]);
            }
          }
        }
      }
    },

    fetch: function(searchOptions, viewContainer) {
      var context = this;
      $.ajax({
        url: context.fetchUrl(),
        dataType: 'json',
        context: context,
        data: context.getSearchOptions(searchOptions),
        beforeSend: function() {
          ++context.ajaxCount;
        },
        complete: function() {
          --context.ajaxCount;
          if (context.ajaxCount == 0) {
            setTimeout(function(){
              $('.discussion-block').fadeIn('fast', function() {
                if (context.focusId) {
                  $('html body').animate({
                    scrollTop: ($('#'+context.focusId).offset().top - 100 )
                  }, 2000, function(){
                    $('.holder', $('#' + context.focusId)).first().animate({ backgroundColor: '#fff' }, 1000)
                    .animate({backgroundColor: '#F7F3EE'}, 1000);
                    context.focusId = null;
                  });
                }
              });
            }, 500);
          } 
        },
      })
      .done(function(data, textResponse, jqXHR) {
        this.handleFetch(data, textResponse, jqXHR, viewContainer) }
      )
      .fail(this.handleError);
    },

    handleFetch: function( data, textResponse, jqXHR, viewContainer ) {
      // Sets a flag to denote a focused search.
      if ( data.focused && this.focused == null ) {
        this.focused = true;
      }

      if ( this.focused == true ) {
        //this.addCollapseBarElements(data, viewContainer);
        this.addFocusedElements(data, viewContainer);
      } else {
        this.addCollapseBarElement(data, viewContainer);
        this.addElements(data, viewContainer);
      }

    },

    createFocusedShowEl: function(options) {
      var options = options || {}, object = $.extend({}, options.currentObject, this.getUserOptions()), el;

      // these are the fields needed for the collapse bar logic
      // @uuid
      // @nextUrl
      // @prevUrl
      // @viewContainerId
      // @collapseText
      // @first_id
      // @last_id
      // @items_left
      // @items_before
      object.uuid          = this.guid();
      object.nextUrl       = options.data.next_page_url;
      object.prevUrl       = options.data.prev_page_url;
      object.viewContainer = this.getCollapseViewContainer(object.course_comment.depth, options.viewContainer);
      object.collapseText  = this.getCollapseText(object.course_comment.depth);
      object.last_id       = options.data.last_id;
      object.first_id      = options.data.first_id;
      object.items_before  = options.data.items_before;
      object.items_left    = options.data.items_left;
      object.placement     = options.data.placement;
      object.data          = options.data;

      el = JST['views/course_comments/focused_comment'](object);
      return { el: $(el), object: object };
    },

    renderFocusedShowEl: function(options) {
      var options =  options || {}, depth = options.object.course_comment.depth, $target;
      //options.el.insertBefore(this.$commentFormContainer);

      if ( typeof this.focusId == 'undefined' ) {
        this.focusId = options.object.data.focus_id
      }
      // This is a progressive load
      if ( options.object.placement && options.object.placement == 'top' || options.object.placement == 'bottom') {
        $target = $('#' + options.object.data.triggerObject.uuid);
        options.el.insertAfter($target);

      } else { // This is not a progressive load

        if ( depth == 2 ) { // This is a top level comment
          this.counter++;
          this.$viewContainer.append(options.el);

        } else { // This is a 3rd level or deeper comment
          $('#post-block-'+ options.object.course_comment.parent_id).append(options.el);
        }

      }

    },

    addFocusedElements: function(data, viewContainer) {
      var _i, showObject, _data, _objects = data[this.rootNode].reverse(), _data = data, options = {}, commentIds = [],
          trigObj, removeIds, focus_parent_id, focus_id, depth, queryObj;

      options.data = _data;

      if ( viewContainer ) {
        options.viewContainer = viewContainer;
      }
      if ( _objects.length < 1 && viewContainer) {
      }

      if ( options.data.placement == 'top' ) {
        _objects = _objects.reverse();
      } else if ( options.data.placement == 'bottom' ) {
        _objects = _objects.reverse();
      }

      if ( _objects.length < 1 ) {
        var html = JST['views/course_comments/focused_reply_form']({ requester_id: options.data.requester_id });
        var $replyFormEl = $(html);
        $('#post-block-' + options.data.requester_id).append($replyFormEl);
      }

      for ( _i = 0; _i < _objects.length; ++_i ) {
        options.currentObject = _objects[_i];
        showObject            = this.createFocusedShowEl(options);
        focus_parent_id       = showObject.object.data.focus_parent_id;
        focus_id              = showObject.object.data.focus_id;
        depth                 = showObject.object.course_comment.depth;

        commentIds.push('#' + showObject.object.course_comment.id);
        this.renderFocusedShowEl(showObject);

        // render first object
        if ( ( _i + 1 ) == 1 && this.options.onRenderFirstFocusedEl ) {
          this.options.onRenderFirstFocusedEl.apply(this, [options, showObject]);
        }

        // everyobject
        if ( this.options.onRenderFocusedEl ) {
          this.options.onRenderFocusedEl.apply(this, [options, showObject]);
        }

        // Start of logic to determine whether or not a parent element
        if ( depth == 2 ) {
          queryObj = {
            parent_id: options.currentObject.course_comment.parent_id,
            focus_parent_id: focus_parent_id,
          };
          if ( typeof focus_parent_id != 'undefined' && focus_id == options.currentObject.course_comment.id ) {
            queryObj.focus_id = 50000000000;
            queryObj.comment_id = options.currentObject.course_comment.id
            this.fetch(queryObj);
          } else if ( typeof focus_parent_id != 'undefined' && focus_parent_id == options.currentObject.course_comment.id ) {
            queryObj.comment_id = focus_id;
            queryObj.focus_id = focus_id;
            this.fetch(queryObj);

          } else if ( typeof focus_parent_id != 'undefined' && focus_parent_id != options.currentObject.course_comment.id ) {
            queryObj.focus_id = focus_id;
            queryObj.comment_id = options.currentObject.course_comment.id
            this.fetch(queryObj);
          }
        }

        // render last object
        if ( (_i + 1 ) == _objects.length && this.options.onRenderLastFocusedEl ) {
          trigObj = showObject.object.data.triggerObject;

          if ( typeof trigObj != 'undefined' ) {
            // This removes the
            //$('#' + trigObj.uuid).slideUp('fast');
            $('#' + trigObj.uuid).hide();
            if ( typeof trigObj.removeIds != 'undefined' && trigObj.removeIds.length > 0 ) {
              $(trigObj.removeIds).slideDown('slow', function() {
                $(trigObj.removeIds).remove();
              });
            }
          }

          this.options.onRenderLastFocusedEl.apply(this, [options, showObject, commentIds]);
          if ( showObject.object.data.callback ) {
            showObject.object.data.callback.apply(this, [options, showObject, commentIds]);
          }
        }
      }
    },

    getRestOfUrl: function(url, depth) {
      var finUrl, roots = '&roots_only=true';

      //finUrl = url.replace(/per_page=\d*/, 'per_page=1000');
      finUrl = url.replace(/limit=\d*/, 'limit=1000');

      if ( depth == 2 && finUrl.indexOf(roots) == -1 ) {
        finUrl = finUrl.concat(roots);
      }
      return finUrl;
    },

    createCollapseBarElement: function(data, $viewContainer) {
      var collapseText,
          obj,
          el,
          viewContainer,
          depth = data.course_comments[0].course_comment.depth;

      if ( depth == 2 ) {
        viewContainer = this.$viewContainer;
        collapseText = 'comments';


      } else {

        viewContainer = $viewContainer;
        collapseText = 'replies';

      }

      obj = {
        course_comments: {
          uuid: this.guid(),
          collapseText: collapseText,
          nextUrl: this.getRestOfUrl(data.next_page_url, depth),
          viewContainerId: viewContainer.attr('id'),
        }
      };
      el = JST['views/course_comments/collapse_bar'](obj);
      return $(el);
    },

    getCollapseText: function(depth) {
      if (depth == 2 ) {
        return 'comments';
      }  else { 
        return 'replies';
      }
    },

    getCollapseViewContainer: function(depth, viewContainer) {
      if ( depth == 2 ) {
        return this.$viewContainer;
      } else {
        return viewContainer
      }
    },

    createFocusedCollapseEl: function(options) {
      var options = options || {},
          obj,
          el,
          depth         = options.data.course_comments[0].course_comment.depth;
          collapseText  = this.getCollapseText(depth);
          viewContainer = this.getCollapseViewContainer(depth, options.$viewContainer);

      obj = {
        course_comments: {
          uuid: this.guid(),
          collapseText: collapseText,
          viewContainer: viewContainer.attr('id')
        }
      };

      if ( options.barType == 'before' ) {
        obj.nextUrl = options.data.next_page_url;
      } else {
        obj.nextUrl = options.data.prev_page_url;
      }
      el = JST['views/course_comments/collapse_bar'](obj);
      return $(el);

    },

    addCollapseBarElements: function(data, $viewContainer) {
      var $el, $vc, options;
      collapseViewOptions = {
        data: data,
        $viewContainer: $viewContainer,
      };

      if ( $viewContainer ) { // these are replies
        if ( $('.show-block.comment-collapse').length == 0 ) {
          // collapse bar for comments previous comments
          if ( data.items_left > 0 ) {
            collapseViewOptions.barType = 'before';
            $firstEl =  this.createFocusedCollapseEl(collapseViewOptions);
            $firstEl.addClass('inner');
            $viewContainer.prepend($firstEl);
          }

          // add collapse bar for comments made after
          if ( data.items_before > 0 ) {
            collapseViewOptions.barType = 'after';
            $secondEl = this.createFocusedCollapseEl(collapseViewOptions);
            $secondEl.addClass('inner');
            $viewContainer.append($secondEl);
          }
        }
      } else { // these are comments
        if ( $('.show-block.comment-collapse').length == 0 ) {
          if ( data.items_left > 0) {
            collapseViewOptions.barType = 'before';
            $firstEl = this.createFocusedCollapseEl(collapseViewOptions);
            $firstEl.addClass('outer');
            $firstEl.insertBefore(this.$commentFormContainer);
          }

          if ( data.items_before > 0 ) {
            collapseViewOptions.barType = 'after';
            $secondEl = this.createFocusedCollapseEl(collapseViewOptions);
            $secondEl.addClass('outer');
            $secondEl.insertBefore(this.$commentFormContainer)
          }
        }
      }
    },

    addCollapseBarElement: function(data, $viewContainer) {
      var $el, $vc;
      // If there is a view container then it is a child element
      if ( $viewContainer ) {

        // check to see if there is already a collapse bar
        // Will need to change once we have to potentially render two collapse bars
        // maybe the collapse bars
        if ( $('.show-block.comment-collapse', $viewContainer).length == 0 && data.items_left > 0 ) {
          $el = this.createCollapseBarElement(data, $viewContainer);
          $el.addClass('inner');
          $viewContainer.prepend($el);
        }

      } else {
        if ( $('.show-block.comment-collapse', $viewContainer).length == 0 && data.items_left > 0 ) {
          $el = this.createCollapseBarElement(data);
          $el.addClass('outer');
          $el.insertBefore(this.$commentFormContainer);
        }
      }

      if ( this.options.onAfterCollapseBarInserted && $el ) {
        this.options.onAfterCollapseBarInserted.apply(this, [$el]);
      }
    },

    guid: function() {
      function s4() {
        return Math.floor((1 + Math.random()) * 0x10000)
          .toString(16)
          .substring(1);
      }
      return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
    },


    addElements: function(objs, viewContainer) {
      var _i, $el, _objects = objs[this.rootNode];

      // The ajax call for the children(signified by the presence of viewContainer)
      // did not return any objects so add the be the first to comment 
      // element
      if (_objects.length < 1 && viewContainer) {
        this.addReplyFormElement(viewContainer);
      }


      // Typical loop through to render any of the comments
      // or replies
      for ( _i = 0; _i < _objects.length; ++_i ) {
        $el = this.createShowEl(_objects[_i]);
        // potential area to let the end user add the view
        this.bindShowEl($el);
        this.renderShowEl($el, viewContainer, objs, _objects[_i]);

        if ( (_i + 1 ) == _objects.length ) {
          if ( this.options.onRenderLastEl) {
            this.options.onRenderLastEl.apply(this, [$el])
          }
        }
      }
    },

    // Generally for render the return value of the 
    // create function
    addElement: function(obj, viewContainer) {
      $el = this.createShowEl(obj);
      this.bindShowEl($el);
      this.renderSingleEl($el, viewContainer);
    },

    createShowEl: function(data, view) {
      var data = $.extend({}, data, this.getUserOptions());
      var el = JST['views/course_comments/comment'](data);
      return $(el);
    },

    renderSingleEl: function($el, viewContainer) {
      var $target, context = this;
      if ( viewContainer ) {

        $target = $('.post-reply.reply', viewContainer);
        $el.insertBefore($target).hide().slideDown('fast');

      } else {

        $el.insertBefore(this.$commentFormContainer).hide().slideDown('fast');

      }
    },

    renderShowEl: function($el,viewContainer, data, object) {
      var context = this;
      // if the user supplied a function for this callback
      if ( this.options.onRenderShowEl ) {
        this.options.onRenderShowEl.apply(this, [$el, this.$viewContainer]);
      } else {

        if ( viewContainer ) {
          this.addReplyFormElement(viewContainer);
          var $target = $('.post-reply.reply', viewContainer);

          if ( $target.prev().hasClass('commentable') ) {
            $el.insertBefore($('.commentable.reply', viewContainer).first());
          } else {
            $el.insertBefore($target);
          }

        } else {

          if ( this.$commentFormContainer.prev().hasClass('commentable')) {
            $el.insertBefore($('.commentable.outer').first());
          } else {
            $el.insertBefore(this.$commentFormContainer);
          } 
        }
      }


      // After render callback area
      if ( this.options.onAfterRenderShowEl ) {
        this.options.onAfterRenderShowEl.apply(this, [$el])
      } else {

        if ( $el.data('depth') == 2 ) {
          if ( typeof data.focus_id != 'undefined' && typeof this.focusId == 'undefined') {
            this.focusId = data.focus_id;
          }

          var $vc = $('.post-block', $el);
          var queryObj = { parent_id: $el.data('comment-id') }
          if ( object.course_comment.id == data.focus_parent_id)  {
            var tempObj = {
              id: data.focus_id,
              focus_parent_id: data.focus_parent_id,
            };
            queryObj = $.extend({}, queryObj, tempObj);
          }
          this.fetch(queryObj, $vc);
        } else {

        }
      }
    },

    bindShowEl: function() {

    },

    addReplyFormElement: function(viewContainer) {
      if (this.hasReplyForm(viewContainer) == false ) {
        var parentId = viewContainer.closest('.commentable.outer').data('comment-id');

        var $replyEl = this.createReplyForm({parentId: parentId, userImageUrl: this.userImageUrl});
        this.renderReplyForm($replyEl, viewContainer);
      }

    },

    hasReplyForm: function(viewContainer) {
      return $('.post-reply.reply', viewContainer).length > 0
    },

    renderReplyForm: function($replyEl, $viewContainer) {
      $viewContainer.append($replyEl);
    },

    createReplyForm: function(data) {
      var el = JST['views/course_comments/form'](data);
      return $(el);
    },

    bindReplyForm: function() {

    },

    find: function() {
      var context = this;
      $.ajax({
        url: context.findUrl(),
        dataType: 'json',
        type: 'GET',
        data: {
          coupon: {
            code: context.returnDiscountCode()
          }
        }
      })
      .done(context.handleFind )
      .fail( this.handleError );
    },

    create: function(obj, $viewContainer) {
      var context = this;
      $.ajax({
        url: context.createUrl(),
        context: context,
        dataType: 'json',
        type: 'POST',
        data: obj,
        beforeSend: function() {
          ++context.ajaxCount;
        },
        complete: function() {
          --context.ajaxCount;
        }
      })
      .done(
        function(data, textResponse, jqXHR) {
          if ( obj.callback ) {
            obj.callback.apply(this, [data, textResponse, jqXHR, obj]);
          } else {
            this.handleCreate(data, textResponse, jqXHR, $viewContainer);
          }

          if ( this.options.onAfterFormSubmission ) {
            this.options.onAfterFormSubmission.apply(this, [data, textResponse, jqXHR, $viewContainer]);
          }

        }
      )
      .fail( this.handleError )
    },

    update: function(id, data, viewContainer) {
      var context = this;
      $.ajax({
        url: context.updateUrl(id),
        context: context,
        dataType: 'json',
        type: 'PUT',
        data: data
      })
      .done( 
        function( data, textResponse, jqXHR ) {
          context.handleUpdate( data, textResponse, jqXHR, viewContainer )
        }
      )
      .fail( this.handleError );
    },

    handleFind: function(data, textResponse, jqXHR) {
    },

    handleCreate: function(data, textResponse, jqXHR, $viewContainer) {
      var d = { course_comment: data }
      this.addElement(d, $viewContainer);
    },

    handleUpdate: function(data, textResponse, jqXHR, viewContainer) {
      var likesContainer = $('#likes-container-' + data.id);
      if ( data.vote_type == 'up' ) {
        $('a.like-text', likesContainer).text('Unlike').addClass('unlike-text').removeClass('like-text');
      } else if ( data.vote_type == 'down' ) {
        $('a.unlike-text', likesContainer).text('Like').addClass('like-text').removeClass('unlike-text');
      }
      $('.text-muted', likesContainer).empty().text('(' + data.tally_to_s.toString() + ')')
    },

    handleError: function() {

    },

  };

  //Start plugin
  $.fn.extend({
    'commentForm': function(options) {
      return this.each(function(){
        // Create a new changeUrlForm
        var myCommentForm = Object.create(CommentForm);

        // Set intialize with plugin options
        myCommentForm.init(options, this);

        // Save the reference to the instance in the elem's data object
        $(this).data('commentForm', myCommentForm);
      });
    },
  });

  $(document).ready(function(){
  });

}(jQuery));
