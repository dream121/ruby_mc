// page init
jQuery(function(){
  var skipper = $('#controls').data('p2h');
  var commentsSkipper = $('#discussion-container').data('p2h');
  var contentSkipper = $('#content').data('p2h');
  if ( skipper == 'skip' || commentsSkipper == 'skip' || contentSkipper == 'skip') {
    return;
  } else {
    initCarousel();
    initSameHeight();
    initCycleCarousel();
    initOpenClose();
    initInputs();
    initCustomForms();
    initValidation();
  }
});

// form validation function
function initValidation() {
  var errorClass = 'error';
  var successClass = 'success';
  var regEmail = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  var regPhone = /^[0-9]+$/;

  jQuery('form.validate-form').each(function(){
    var form = jQuery(this).attr('novalidate', 'novalidate');
    var inputs = form.find('.required, .required-number');

    form.addClass('not-valid');

    inputs.each(function(){
      jQuery(this).on('keyup', function(){
        validateForm(jQuery(this));
      });
    });

    // form validation function
    function validateForm(item) {
      checkField(item);

      if(inputs.length === inputs.closest('div').filter('.success').length) {
        form.removeClass('not-valid');
      } else {
        form.removeClass('not-valid').addClass('not-valid');
      }
    }

    // check field
    function checkField(obj) {
      var currentObject = obj;
      var currentParent = currentObject.closest('div');

      // not empty fields
      if(currentObject.hasClass('required')) {
        setState(currentParent, currentObject, !currentObject.val().length || currentObject.val() === currentObject.prop('defaultValue'));
      }
      // correct email fields
      if(currentObject.hasClass('required-email')) {
        setState(currentParent, currentObject, !regEmail.test(currentObject.val()));
      }
      // correct number fields
      if(currentObject.hasClass('required-number')) {
        setState(currentParent, currentObject, !regPhone.test(currentObject.val()));
      }
      // something selected
      if(currentObject.hasClass('required-select')) {
        setState(currentParent, currentObject, currentObject.get(0).selectedIndex === 0);
      }
    }

    // set state
    function setState(hold, field, error) {
      hold.removeClass(errorClass).removeClass(successClass);
      if(error) {
        hold.addClass(errorClass);
        field.one('focus',function(){hold.removeClass(errorClass).removeClass(successClass);});
      } else {
        hold.addClass(successClass);
      }
    }
  });
}

// initialize custom form elements
function initCustomForms() {
  jcf.setOptions('Select', {
    wrapNative: false
  });
  jcf.replaceAll();
}

// scroll gallery init
function initCarousel() {
  jQuery('div.gallery').scrollGallery({
    mask: 'div.mask',
    slider: 'div.slideset',
    slides: 'div.slide',
    btnPrev: 'a.btn-prev',
    btnNext: 'a.btn-next',
    pagerLinks: '.pagination li',
    circularRotation: false,
    autoRotation: true,
    switchTime: 3000,
    animSpeed: 500,
    step: 1
  });
  jQuery('div.class-gallery').scrollGallery({
    mask: 'div.mask',
    slider: 'div.slideset',
    slides: 'div.slide',
    btnPrev: 'a.btn-prev',
    btnNext: 'a.btn-next',
    pagerLinks: '.pagination li',
    circularRotation: false,
    autoRotation: false,
    switchTime: 3000,
    animSpeed: 500,
    step: 1
  });
}
// cycle scroll gallery init
function initCycleCarousel() {
  jQuery('div.cycle-gallery').scrollAbsoluteGallery({
    mask: 'div.mask',
    slider: 'div.slideset',
    slides: 'div.slide',
    btnPrev: 'a.btn-prev',
    btnNext: 'a.btn-next',
    pagerLinks: '.pagination li',
    stretchSlideToMask: true,
    pauseOnHover: true,
    maskAutoSize: true,
    autoRotation: true,
    switchTime: 4000,
    animSpeed: 500
  });
}
// align blocks height
function initSameHeight() {
  jQuery('.columns').sameHeight({
    elements: 'div.column',
    flexible: true,
    multiLine: true
  });
}
/*
 * jQuery Cycle Carousel plugin
 */
;(function($){
  function ScrollAbsoluteGallery(options) {
    this.options = $.extend({
      activeClass: 'active',
      mask: 'div.slides-mask',
      slider: '>ul',
      slides: '>li',
      btnPrev: '.btn-prev',
      btnNext: '.btn-next',
      pagerLinks: 'ul.pager > li',
      generatePagination: false,
      pagerList: '<ul>',
      pagerListItem: '<li><a href="#"></a></li>',
      pagerListItemText: 'a',
      galleryReadyClass: 'gallery-js-ready',
      currentNumber: 'span.current-num',
      totalNumber: 'span.total-num',
      maskAutoSize: false,
      autoRotation: false,
      pauseOnHover: false,
      stretchSlideToMask: false,
      switchTime: 3000,
      animSpeed: 500,
      handleTouch: true,
      swipeThreshold: 15,
      vertical: false
    }, options);
    this.init();
  }
  ScrollAbsoluteGallery.prototype = {
    init: function() {
      if(this.options.holder) {
        this.findElements();
        this.attachEvents();
        this.makeCallback('onInit', this);
      }
    },
    findElements: function() {
      // find structure elements
      this.holder = $(this.options.holder).addClass(this.options.galleryReadyClass);
      this.mask = this.holder.find(this.options.mask);
      this.slider = this.mask.find(this.options.slider);
      this.slides = this.slider.find(this.options.slides);
      this.btnPrev = this.holder.find(this.options.btnPrev);
      this.btnNext = this.holder.find(this.options.btnNext);

      // slide count display
      this.currentNumber = this.holder.find(this.options.currentNumber);
      this.totalNumber = this.holder.find(this.options.totalNumber);

      // create gallery pagination
      if(typeof this.options.generatePagination === 'string') {
        this.pagerLinks = this.buildPagination();
      } else {
        this.pagerLinks = this.holder.find(this.options.pagerLinks);
      }

      // define index variables
      this.sizeProperty = this.options.vertical ? 'height' : 'width';
      this.positionProperty = this.options.vertical ? 'top' : 'left';
      this.animProperty = this.options.vertical ? 'marginTop' : 'marginLeft';

      this.slideSize = this.slides[this.sizeProperty]();
      this.currentIndex = 0;
      this.prevIndex = 0;

      // reposition elements
      this.options.maskAutoSize = this.options.vertical ? false : this.options.maskAutoSize;
      if(this.options.vertical) {
        this.mask.css({
          height: this.slides.innerHeight()
        });
      }
      if(this.options.maskAutoSize){
        this.mask.css({
          height: this.slider.height()
        });
      }
      this.slider.css({
        position: 'relative',
        height: this.options.vertical ? this.slideSize * this.slides.length : '100%'
      });
      this.slides.css({
        position: 'absolute'
      }).css(this.positionProperty, -9999).eq(this.currentIndex).css(this.positionProperty, 0);
      this.refreshState();
    },
    buildPagination: function() {
      var pagerLinks = $();
      if(!this.pagerHolder) {
        this.pagerHolder = this.holder.find(this.options.generatePagination);
      }
      if(this.pagerHolder.length) {
        this.pagerHolder.empty();
        this.pagerList = $(this.options.pagerList).appendTo(this.pagerHolder);
        for(var i = 0; i < this.slides.length; i++) {
          $(this.options.pagerListItem).appendTo(this.pagerList).find(this.options.pagerListItemText).text(i+1);
        }
        pagerLinks = this.pagerList.children();
      }
      return pagerLinks;
    },
    attachEvents: function() {
      // attach handlers
      var self = this;
      if(this.btnPrev.length) {
        this.btnPrevHandler = function(e) {
          e.preventDefault();
          self.prevSlide();
        };
        this.btnPrev.click(this.btnPrevHandler);
      }
      if(this.btnNext.length) {
        this.btnNextHandler = function(e) {
          e.preventDefault();
          self.nextSlide();
        };
        this.btnNext.click(this.btnNextHandler);
      }
      if(this.pagerLinks.length) {
        this.pagerLinksHandler = function(e) {
          e.preventDefault();
          self.numSlide(self.pagerLinks.index(e.currentTarget));
        };
        this.pagerLinks.click(this.pagerLinksHandler);
      }

      // handle autorotation pause on hover
      if(this.options.pauseOnHover) {
        this.hoverHandler = function() {
          clearTimeout(self.timer);
        };
        this.leaveHandler = function() {
          self.autoRotate();
        };
        this.holder.bind({mouseenter: this.hoverHandler, mouseleave: this.leaveHandler});
      }

      // handle holder and slides dimensions
      this.resizeHandler = function() {
        if(!self.animating) {
          if(self.options.stretchSlideToMask) {
            self.resizeSlides();
          }
          self.resizeHolder();
          self.setSlidesPosition(self.currentIndex);
        }
      };
      $(window).bind('load resize orientationchange', this.resizeHandler);
      if(self.options.stretchSlideToMask) {
        self.resizeSlides();
      }

      // handle swipe on mobile devices
      if(this.options.handleTouch && window.Hammer && this.slides.length > 1 && isTouchDevice) {
        this.swipeHandler = Hammer(this.mask[0], {
          dragBlockHorizontal: !this.options.vertical,
          dragBlockVertical: this.options.vertical,
          dragMinDistance: 1,
          behavior: {
            touchAction: this.options.vertical ? 'pan-x' : 'pan-y'
          }
        }).on('touch release ' + (self.options.vertical ? 'dragup dragdown' : 'dragleft dragright'), function(e) {
          switch(e.type) {
            case 'touch':
              if(self.animating) {
                e.gesture.stopDetect();
              } else {
                clearTimeout(self.timer);
              }
              break;
            case 'dragup':
            case 'dragdown':
            case 'dragleft':
            case 'dragright':
              e.gesture.preventDefault();
              self.swipeOffset = -self.slideSize + e.gesture[self.options.vertical ? 'deltaY' : 'deltaX'];
              self.slider.css(self.animProperty, self.swipeOffset);
              clearTimeout(self.timer);
              break;
            case 'release':
              if(Math.abs(e.gesture[self.options.vertical ? 'deltaY' : 'deltaX']) > self.options.swipeThreshold) {
                if(e.gesture.direction == 'left' || e.gesture.direction == 'up') {
                  self.nextSlide();
                } else {
                  self.prevSlide();
                }
              }
              else {
                var tmpObj = {};
                tmpObj[self.animProperty] = -self.slideSize;
                self.slider.animate(tmpObj, {duration: self.options.animSpeed});
                self.autoRotate();
              }
              self.swipeOffset = 0;
          }
        });
      }

      // start autorotation
      this.autoRotate();
      this.resizeHolder();
      this.setSlidesPosition(this.currentIndex);
    },
    resizeSlides: function() {
      this.slideSize = this.mask[this.options.vertical ? 'height' : 'width']();
      this.slides.css(this.sizeProperty, this.slideSize);
    },
    resizeHolder: function() {
      if(this.options.maskAutoSize) {
        this.mask.css({
          height: this.slides.eq(this.currentIndex).outerHeight(true)
        });
      }
    },
    prevSlide: function() {
      if(!this.animating && this.slides.length > 1) {
        this.direction = -1;
        this.prevIndex = this.currentIndex;
        if(this.currentIndex > 0) this.currentIndex--;
        else this.currentIndex = this.slides.length - 1;
        this.switchSlide();
      }
    },
    nextSlide: function(fromAutoRotation) {
      if(!this.animating && this.slides.length > 1) {
        this.direction = 1;
        this.prevIndex = this.currentIndex;
        if(this.currentIndex < this.slides.length - 1) this.currentIndex++;
        else this.currentIndex = 0;
        this.switchSlide();
      }
    },
    numSlide: function(c) {
      if(!this.animating && this.currentIndex !== c && this.slides.length > 1) {
        this.direction = c > this.currentIndex ? 1 : -1;
        this.prevIndex = this.currentIndex;
        this.currentIndex = c;
        this.switchSlide();
      }
    },
    preparePosition: function() {
      // prepare slides position before animation
      this.setSlidesPosition(this.prevIndex, this.direction < 0 ? this.currentIndex : null, this.direction > 0 ? this.currentIndex : null, this.direction);
    },
    setSlidesPosition: function(index, slideLeft, slideRight, direction) {
      // reposition holder and nearest slides
      if(this.slides.length > 1) {
        var prevIndex = (typeof slideLeft === 'number' ? slideLeft : index > 0 ? index - 1 : this.slides.length - 1);
        var nextIndex = (typeof slideRight === 'number' ? slideRight : index < this.slides.length - 1 ? index + 1 : 0);

        this.slider.css(this.animProperty, this.swipeOffset ? this.swipeOffset : -this.slideSize);
        this.slides.css(this.positionProperty, -9999).eq(index).css(this.positionProperty, this.slideSize);
        if(prevIndex === nextIndex && typeof direction === 'number') {
          var calcOffset = direction > 0 ? this.slideSize*2 : 0;
          this.slides.eq(nextIndex).css(this.positionProperty, calcOffset);
        } else {
          this.slides.eq(prevIndex).css(this.positionProperty, 0);
          this.slides.eq(nextIndex).css(this.positionProperty, this.slideSize*2);
        }
      }
    },
    switchSlide: function() {
      // prepare positions and calculate offset
      var self = this;
      var oldSlide = this.slides.eq(this.prevIndex);
      var newSlide = this.slides.eq(this.currentIndex);
      this.animating = true;

      // resize mask to fit slide
      if(this.options.maskAutoSize) {
        this.mask.animate({
          height: newSlide.outerHeight(true)
        }, {
          duration: this.options.animSpeed
        });
      }

      // start animation
      var animProps = {};
      animProps[this.animProperty] = this.direction > 0 ? -this.slideSize*2 : 0;
      this.preparePosition();
      this.slider.animate(animProps,{duration:this.options.animSpeed, complete:function() {
        self.setSlidesPosition(self.currentIndex);

        // start autorotation
        self.animating = false;
        self.autoRotate();

        // onchange callback
        self.makeCallback('onChange', self);
      }});

      // refresh classes
      this.refreshState();

      // onchange callback
      this.makeCallback('onBeforeChange', this);
    },
    refreshState: function(initial) {
      // slide change function
      this.slides.removeClass(this.options.activeClass).eq(this.currentIndex).addClass(this.options.activeClass);
      this.pagerLinks.removeClass(this.options.activeClass).eq(this.currentIndex).addClass(this.options.activeClass);

      // display current slide number
      this.currentNumber.html(this.currentIndex + 1);
      this.totalNumber.html(this.slides.length);

      // add class if not enough slides
      this.holder.toggleClass('not-enough-slides', this.slides.length === 1);
    },
    autoRotate: function() {
      var self = this;
      clearTimeout(this.timer);
      if(this.options.autoRotation) {
        this.timer = setTimeout(function() {
          self.nextSlide();
        }, this.options.switchTime);
      }
    },
    makeCallback: function(name) {
      if(typeof this.options[name] === 'function') {
        var args = Array.prototype.slice.call(arguments);
        args.shift();
        this.options[name].apply(this, args);
      }
    },
    destroy: function() {
      // destroy handler
      this.btnPrev.unbind('click', this.btnPrevHandler);
      this.btnNext.unbind('click', this.btnNextHandler);
      this.pagerLinks.unbind('click', this.pagerLinksHandler);
      this.holder.unbind({mouseenter: this.hoverHandler, mouseleave: this.leaveHandler});
      $(window).unbind('load resize orientationchange', this.resizeHandler);
      clearTimeout(this.timer);

      // destroy swipe handler
      if(this.swipeHandler) {
        this.swipeHandler.dispose();
      }

      // remove inline styles, classes and pagination
      this.holder.removeClass(this.options.galleryReadyClass);
      this.slider.add(this.slides).removeAttr('style');
      if(typeof this.options.generatePagination === 'string') {
        this.pagerHolder.empty();
      }
    }
  };

  // detect device type
  var isTouchDevice = /MSIE 10.*Touch/.test(navigator.userAgent) || ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch;

  // jquery plugin
  $.fn.scrollAbsoluteGallery = function(opt){
    return this.each(function(){
      $(this).data('ScrollAbsoluteGallery', new ScrollAbsoluteGallery($.extend(opt,{holder:this})));
    });
  };
}(jQuery));
/*
 * jQuery Carousel plugin
 */
;(function($){
  function ScrollGallery(options) {
    this.options = $.extend({
      mask: 'div.mask',
      slider: '>*',
      slides: '>*',
      activeClass:'active',
      disabledClass:'disabled',
      btnPrev: 'a.btn-prev',
      btnNext: 'a.btn-next',
      generatePagination: false,
      pagerList: '<ul>',
      pagerListItem: '<li><a href="#"></a></li>',
      pagerListItemText: 'a',
      pagerLinks: '.pagination li',
      currentNumber: 'span.current-num',
      totalNumber: 'span.total-num',
      btnPlay: '.btn-play',
      btnPause: '.btn-pause',
      btnPlayPause: '.btn-play-pause',
      galleryReadyClass: 'gallery-js-ready',
      autorotationActiveClass: 'autorotation-active',
      autorotationDisabledClass: 'autorotation-disabled',
      stretchSlideToMask: false,
      circularRotation: true,
      disableWhileAnimating: false,
      autoRotation: false,
      pauseOnHover: isTouchDevice ? false : true,
      maskAutoSize: false,
      switchTime: 4000,
      animSpeed: 600,
      event:'click',
      swipeGap: false,
      swipeThreshold: 15,
      handleTouch: true,
      vertical: false,
      useTranslate3D: false,
      step: false
    }, options);
    this.init();
  }
  ScrollGallery.prototype = {
    init: function() {
      if(this.options.holder) {
        this.findElements();
        this.attachEvents();
        this.refreshPosition();
        this.refreshState(true);
        this.resumeRotation();
        this.makeCallback('onInit', this);
      }
    },
    findElements: function() {
      // define dimensions proporties
      this.fullSizeFunction = this.options.vertical ? 'outerHeight' : 'outerWidth';
      this.innerSizeFunction = this.options.vertical ? 'height' : 'width';
      this.slideSizeFunction = 'outerHeight';
      this.maskSizeProperty = 'height';
      this.animProperty = this.options.vertical ? 'marginTop' : 'marginLeft';
      this.swipeProperties = this.options.vertical ? ['up', 'down'] : ['left', 'right'];

      // control elements
      this.gallery = $(this.options.holder).addClass(this.options.galleryReadyClass);
      this.mask = this.gallery.find(this.options.mask);
      this.slider = this.mask.find(this.options.slider);
      this.slides = this.slider.find(this.options.slides);
      this.btnPrev = this.gallery.find(this.options.btnPrev);
      this.btnNext = this.gallery.find(this.options.btnNext);
      this.currentStep = 0; this.stepsCount = 0;

      // get start index
      if(this.options.step === false) {
        var activeSlide = this.slides.filter('.'+this.options.activeClass);
        if(activeSlide.length) {
          this.currentStep = this.slides.index(activeSlide);
        }
      }

      // calculate offsets
      this.calculateOffsets();

      // create gallery pagination
      if(typeof this.options.generatePagination === 'string') {
        this.pagerLinks = $();
        this.buildPagination();
      } else {
        this.pagerLinks = this.gallery.find(this.options.pagerLinks);
        this.attachPaginationEvents();
      }

      // autorotation control buttons
      this.btnPlay = this.gallery.find(this.options.btnPlay);
      this.btnPause = this.gallery.find(this.options.btnPause);
      this.btnPlayPause = this.gallery.find(this.options.btnPlayPause);

      // misc elements
      this.curNum = this.gallery.find(this.options.currentNumber);
      this.allNum = this.gallery.find(this.options.totalNumber);
    },
    attachEvents: function() {
      // bind handlers scope
      var self = this;
      this.bindHandlers(['onWindowResize']);
      $(window).bind('load resize orientationchange', this.onWindowResize);

      // previous and next button handlers
      if(this.btnPrev.length) {
        this.prevSlideHandler = function(e) {
          e.preventDefault();
          self.prevSlide();
        };
        this.btnPrev.bind(this.options.event, this.prevSlideHandler);
      }
      if(this.btnNext.length) {
        this.nextSlideHandler = function(e) {
          e.preventDefault();
          self.nextSlide();
        };
        this.btnNext.bind(this.options.event, this.nextSlideHandler);
      }

      // pause on hover handling
      if(this.options.pauseOnHover && !isTouchDevice) {
        this.hoverHandler = function() {
          if(self.options.autoRotation) {
            self.galleryHover = true;
            self.pauseRotation();
          }
        };
        this.leaveHandler = function() {
          if(self.options.autoRotation) {
            self.galleryHover = false;
            self.resumeRotation();
          }
        };
        this.gallery.bind({mouseenter: this.hoverHandler, mouseleave: this.leaveHandler});
      }

      // autorotation buttons handler
      if(this.btnPlay.length) {
        this.btnPlayHandler = function(e) {
          e.preventDefault();
          self.startRotation();
        };
        this.btnPlay.bind(this.options.event, this.btnPlayHandler);
      }
      if(this.btnPause.length) {
        this.btnPauseHandler = function(e) {
          e.preventDefault();
          self.stopRotation();
        };
        this.btnPause.bind(this.options.event, this.btnPauseHandler);
      }
      if(this.btnPlayPause.length) {
        this.btnPlayPauseHandler = function(e) {
          e.preventDefault();
          if(!self.gallery.hasClass(self.options.autorotationActiveClass)) {
            self.startRotation();
          } else {
            self.stopRotation();
          }
        };
        this.btnPlayPause.bind(this.options.event, this.btnPlayPauseHandler);
      }

      // swipe event handling
      if(isTouchDevice) {
        // enable hardware acceleration
        if(this.options.useTranslate3D) {
          this.slider.css({'-webkit-transform': 'translate3d(0px, 0px, 0px)'});
        }

        // swipe gestures
        if(this.options.handleTouch && jQuery.fn.hammer) {
          this.mask.hammer({
            drag_block_horizontal: this.options.vertical ? false : true,
            drag_block_vertical: this.options.vertical ? true : false,
            drag_min_distance: 1
          }).on(this.options.vertical ? 'touch release dragup dragdown swipeup swipedown' : 'touch release dragleft dragright swipeleft swiperight', function(ev){
            switch(ev.type) {
              case 'touch':
                if(!self.galleryAnimating){
                  self.originalOffset = parseInt(self.slider.stop(true, false).css(self.animProperty), 10);
                }
                break;
              case (self.options.vertical? 'dragup' : 'dragright'):
              case (self.options.vertical? 'dragdown' : 'dragleft'):
                if(!self.galleryAnimating){
                  if(ev.gesture.direction === self.swipeProperties[0] || ev.gesture.direction === self.swipeProperties[1]){
                    var tmpOffset = self.originalOffset + ev.gesture[self.options.vertical ? 'deltaY' : 'deltaX'];
                    tmpOffset = Math.max(Math.min(0, tmpOffset), self.maxOffset)
                    self.tmpProps = {};
                    self.tmpProps[self.animProperty] = tmpOffset;
                    self.slider.css(self.tmpProps);
                    ev.gesture.preventDefault();
                  };
                };
                break;
              case (self.options.vertical ? 'swipeup' : 'swipeleft'):
                if(!self.galleryAnimating){
                  if(ev.gesture.direction === self.swipeProperties[0]) self.nextSlide();
                }
                ev.gesture.stopDetect();
                break;
              case (self.options.vertical ? 'swipedown' : 'swiperight'):
                if(!self.galleryAnimating){
                  if(ev.gesture.direction === self.swipeProperties[1]) self.prevSlide();
                }
                ev.gesture.stopDetect();
                break;

              case 'release':
                if(!self.galleryAnimating){
                  if(Math.abs(ev.gesture[self.options.vertical ? 'deltaY' : 'deltaX']) > self.options.swipeThreshold) {
                    if(self.options.vertical){
                      if(ev.gesture.direction == 'down') self.prevSlide(); else if(ev.gesture.direction == 'up') self.nextSlide();
                    }
                    else {
                      if(ev.gesture.direction == 'right') self.prevSlide(); else if(ev.gesture.direction == 'left') self.nextSlide();
                    }
                  }
                  else {
                    self.switchSlide();
                  }
                }
                break;
            }
          });
        }
      }
    },
    onWindowResize: function() {
      if(!this.galleryAnimating) {
        this.calculateOffsets();
        this.refreshPosition();
        this.buildPagination();
        this.refreshState();
        this.resizeQueue = false;
      } else {
        this.resizeQueue = true;
      }
    },
    refreshPosition: function() {
      this.currentStep = Math.min(this.currentStep, this.stepsCount - 1);
      this.tmpProps = {};
      this.tmpProps[this.animProperty] = this.getStepOffset();
      this.slider.stop().css(this.tmpProps);
    },
    calculateOffsets: function() {
      var self = this, tmpOffset, tmpStep;
      if(this.options.stretchSlideToMask) {
        var tmpObj = {};
        tmpObj[this.innerSizeFunction] = this.mask[this.innerSizeFunction]();
        this.slides.css(tmpObj);
      }

      this.maskSize = this.mask[this.innerSizeFunction]();
      this.sumSize = this.getSumSize();
      this.maxOffset = this.maskSize - this.sumSize;

      // vertical gallery with single size step custom behavior
      if(this.options.vertical && this.options.maskAutoSize) {
        this.options.step = 1;
        this.stepsCount = this.slides.length;
        this.stepOffsets = [0];
        tmpOffset = 0;
        for(var i = 0; i < this.slides.length; i++) {
          tmpOffset -= $(this.slides[i])[this.fullSizeFunction](true);
          this.stepOffsets.push(tmpOffset);
        }
        this.maxOffset = tmpOffset;
        return;
      }

      // scroll by slide size
      if(typeof this.options.step === 'number' && this.options.step > 0) {
        this.slideDimensions = [];
        this.slides.each($.proxy(function(ind, obj){
          self.slideDimensions.push( $(obj)[self.fullSizeFunction](true) );
        },this));

        // calculate steps count
        this.stepOffsets = [0];
        this.stepsCount = 1;
        tmpOffset = tmpStep = 0;
        while(tmpOffset > this.maxOffset) {
          tmpOffset -= this.getSlideSize(tmpStep, tmpStep + this.options.step);
          tmpStep += this.options.step;
          this.stepOffsets.push(Math.max(tmpOffset, this.maxOffset));
          this.stepsCount++;
        }
      }
      // scroll by mask size
      else {
        // define step size
        this.stepSize = this.maskSize;

        // calculate steps count
        this.stepsCount = 1;
        tmpOffset = 0;
        while(tmpOffset > this.maxOffset) {
          tmpOffset -= this.stepSize;
          this.stepsCount++;
        }
      }
    },
    getSumSize: function() {
      var sum = 0;
      this.slides.each($.proxy(function(ind, obj){
        sum += $(obj)[this.fullSizeFunction](true);
      },this));
      this.slider.css(this.innerSizeFunction, sum);
      return sum;
    },
    getStepOffset: function(step) {
      step = step || this.currentStep;
      if(typeof this.options.step === 'number') {
        return this.stepOffsets[this.currentStep];
      } else {
        return Math.min(0, Math.max(-this.currentStep * this.stepSize, this.maxOffset));
      }
    },
    getSlideSize: function(i1, i2) {
      var sum = 0;
      for(var i = i1; i < Math.min(i2, this.slideDimensions.length); i++) {
        sum += this.slideDimensions[i];
      }
      return sum;
    },
    buildPagination: function() {
      if(typeof this.options.generatePagination === 'string') {
        if(!this.pagerHolder) {
          this.pagerHolder = this.gallery.find(this.options.generatePagination);
        }
        if(this.pagerHolder.length && this.oldStepsCount != this.stepsCount) {
          this.oldStepsCount = this.stepsCount;
          this.pagerHolder.empty();
          this.pagerList = $(this.options.pagerList).appendTo(this.pagerHolder);
          for(var i = 0; i < this.stepsCount; i++) {
            $(this.options.pagerListItem).appendTo(this.pagerList).find(this.options.pagerListItemText).text(i+1);
          }
          this.pagerLinks = this.pagerList.children();
          this.attachPaginationEvents();
        }
      }
    },
    attachPaginationEvents: function() {
      var self = this;
      this.pagerLinksHandler = function(e) {
        e.preventDefault();
        self.numSlide(self.pagerLinks.index(e.currentTarget));
      };
      this.pagerLinks.bind(this.options.event, this.pagerLinksHandler);
    },
    prevSlide: function() {
      if(!(this.options.disableWhileAnimating && this.galleryAnimating)) {
        if(this.currentStep > 0) {
          this.currentStep--;
          this.switchSlide();
        } else if(this.options.circularRotation) {
          this.currentStep = this.stepsCount - 1;
          this.switchSlide();
        }
      }
    },
    nextSlide: function(fromAutoRotation) {
      if(!(this.options.disableWhileAnimating && this.galleryAnimating)) {
        if(this.currentStep < this.stepsCount - 1) {
          this.currentStep++;
          this.switchSlide();
        } else if(this.options.circularRotation || fromAutoRotation === true) {
          this.currentStep = 0;
          this.switchSlide();
        }
      }
    },
    numSlide: function(c) {
      if(this.currentStep != c) {
        this.currentStep = c;
        this.switchSlide();
      }
    },
    switchSlide: function() {
      var self = this;
      this.galleryAnimating = true;
      this.tmpProps = {};
      this.tmpProps[this.animProperty] = this.getStepOffset();
      this.slider.stop().animate(this.tmpProps, {duration: this.options.animSpeed, complete: function(){
        // animation complete
        self.galleryAnimating = false;
        if(self.resizeQueue) {
          self.onWindowResize();
        }

        // onchange callback
        self.makeCallback('onChange', self);
        self.autoRotate();
      }});
      this.refreshState();

      // onchange callback
      this.makeCallback('onBeforeChange', this);
    },
    refreshState: function(initial) {
      if(this.options.step === 1 || this.stepsCount === this.slides.length) {
        this.slides.removeClass(this.options.activeClass).eq(this.currentStep).addClass(this.options.activeClass);
      }
      this.pagerLinks.removeClass(this.options.activeClass).eq(this.currentStep).addClass(this.options.activeClass);
      this.curNum.html(this.currentStep+1);
      this.allNum.html(this.stepsCount);

      // initial refresh
      if(this.options.maskAutoSize && typeof this.options.step === 'number') {
        this.tmpProps = {};
        this.tmpProps[this.maskSizeProperty] = this.slides.eq(Math.min(this.currentStep,this.slides.length-1))[this.slideSizeFunction](true);
        this.mask.stop()[initial ? 'css' : 'animate'](this.tmpProps);
      }

      // disabled state
      if(!this.options.circularRotation) {
        this.btnPrev.add(this.btnNext).removeClass(this.options.disabledClass);
        if(this.currentStep === 0) this.btnPrev.addClass(this.options.disabledClass);
        if(this.currentStep === this.stepsCount - 1) this.btnNext.addClass(this.options.disabledClass);
      }

      // add class if not enough slides
      this.gallery.toggleClass('not-enough-slides', this.sumSize <= this.maskSize);
    },
    startRotation: function() {
      this.options.autoRotation = true;
      this.galleryHover = false;
      this.autoRotationStopped = false;
      this.resumeRotation();
    },
    stopRotation: function() {
      this.galleryHover = true;
      this.autoRotationStopped = true;
      this.pauseRotation();
    },
    pauseRotation: function() {
      this.gallery.addClass(this.options.autorotationDisabledClass);
      this.gallery.removeClass(this.options.autorotationActiveClass);
      clearTimeout(this.timer);
    },
    resumeRotation: function() {
      if(!this.autoRotationStopped) {
        this.gallery.addClass(this.options.autorotationActiveClass);
        this.gallery.removeClass(this.options.autorotationDisabledClass);
        this.autoRotate();
      }
    },
    autoRotate: function() {
      var self = this;
      clearTimeout(this.timer);
      if(this.options.autoRotation && !this.galleryHover && !this.autoRotationStopped) {
        this.timer = setTimeout(function(){
          self.nextSlide(true);
        }, this.options.switchTime);
      } else {
        this.pauseRotation();
      }
    },
    bindHandlers: function(handlersList) {
      var self = this;
      $.each(handlersList, function(index, handler) {
        var origHandler = self[handler];
        self[handler] = function() {
          return origHandler.apply(self, arguments);
        };
      });
    },
    makeCallback: function(name) {
      if(typeof this.options[name] === 'function') {
        var args = Array.prototype.slice.call(arguments);
        args.shift();
        this.options[name].apply(this, args);
      }
    },
    destroy: function() {
      // destroy handler
      $(window).unbind('load resize orientationchange', this.onWindowResize);
      this.btnPrev.unbind(this.options.event, this.prevSlideHandler);
      this.btnNext.unbind(this.options.event, this.nextSlideHandler);
      this.pagerLinks.unbind(this.options.event, this.pagerLinksHandler);
      this.gallery.unbind({mouseenter: this.hoverHandler, mouseleave: this.leaveHandler});

      // autorotation buttons handlers
      this.stopRotation();
      this.btnPlay.unbind(this.options.event, this.btnPlayHandler);
      this.btnPause.unbind(this.options.event, this.btnPauseHandler);
      this.btnPlayPause.unbind(this.options.event, this.btnPlayPauseHandler);

      // destroy swipe handler
      if(this.options.handleTouch && $.fn.hammer) {
        this.mask.hammer().off('touch release dragup dragdown dragleft dragright swipeup swipedown swipeleft swiperight');
      }

      // remove inline styles, classes and pagination
      var unneededClasses = [this.options.galleryReadyClass, this.options.autorotationActiveClass, this.options.autorotationDisabledClass];
      this.gallery.removeClass(unneededClasses.join(' '));
      this.slider.add(this.slides).removeAttr('style');
      if(typeof this.options.generatePagination === 'string') {
        this.pagerHolder.empty();
      }
    }
  };

  // detect device type
  var isTouchDevice = /MSIE 10.*Touch/.test(navigator.userAgent) || ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch;

  // jquery plugin
  $.fn.scrollGallery = function(opt){
    return this.each(function(){
      $(this).data('ScrollGallery', new ScrollGallery($.extend(opt,{holder:this})));
    });
  };
}(jQuery));

/*
 * jQuery SameHeight plugin
 */
;(function($){
  $.fn.sameHeight = function(opt) {
    var options = $.extend({
      skipClass: 'same-height-ignore',
      leftEdgeClass: 'same-height-left',
      rightEdgeClass: 'same-height-right',
      elements: '>*',
      flexible: false,
      multiLine: false,
      useMinHeight: false,
      biggestHeight: false
    },opt);
    return this.each(function(){
      var holder = $(this), postResizeTimer, ignoreResize;
      var elements = holder.find(options.elements).not('.' + options.skipClass);
      if(!elements.length) return;

      // resize handler
      function doResize() {
        elements.css(options.useMinHeight && supportMinHeight ? 'minHeight' : 'height', '');
        if(options.multiLine) {
          // resize elements row by row
          resizeElementsByRows(elements, options);
        } else {
          // resize elements by holder
          resizeElements(elements, holder, options);
        }
      }
      doResize();

      // handle flexible layout / font resize
      var delayedResizeHandler = function() {
        if(!ignoreResize) {
          ignoreResize = true;
          doResize();
          clearTimeout(postResizeTimer);
          postResizeTimer = setTimeout(function() {
            doResize();
            setTimeout(function(){
              ignoreResize = false;
            }, 10);
          }, 100);
        }
      };

      // handle flexible/responsive layout
      if(options.flexible) {
        $(window).bind('resize orientationchange fontresize', delayedResizeHandler);
      }

      // handle complete page load including images and fonts
      $(window).bind('load', delayedResizeHandler);
    });
  };

  // detect css min-height support
  var supportMinHeight = typeof document.documentElement.style.maxHeight !== 'undefined';

  // get elements by rows
  function resizeElementsByRows(boxes, options) {
    var currentRow = $(), maxHeight, maxCalcHeight = 0, firstOffset = boxes.eq(0).offset().top;
    boxes.each(function(ind){
      var curItem = $(this);
      if(curItem.offset().top === firstOffset) {
        currentRow = currentRow.add(this);
      } else {
        maxHeight = getMaxHeight(currentRow);
        maxCalcHeight = Math.max(maxCalcHeight, resizeElements(currentRow, maxHeight, options));
        currentRow = curItem;
        firstOffset = curItem.offset().top;
      }
    });
    if(currentRow.length) {
      maxHeight = getMaxHeight(currentRow);
      maxCalcHeight = Math.max(maxCalcHeight, resizeElements(currentRow, maxHeight, options));
    }
    if(options.biggestHeight) {
      boxes.css(options.useMinHeight && supportMinHeight ? 'minHeight' : 'height', maxCalcHeight);
    }
  }

  // calculate max element height
  function getMaxHeight(boxes) {
    var maxHeight = 0;
    boxes.each(function(){
      maxHeight = Math.max(maxHeight, $(this).outerHeight());
    });
    return maxHeight;
  }

  // resize helper function
  function resizeElements(boxes, parent, options) {
    var calcHeight;
    var parentHeight = typeof parent === 'number' ? parent : parent.height();
    boxes.removeClass(options.leftEdgeClass).removeClass(options.rightEdgeClass).each(function(i){
      var element = $(this);
      var depthDiffHeight = 0;
      var isBorderBox = element.css('boxSizing') === 'border-box' || element.css('-moz-box-sizing') === 'border-box' || '-webkit-box-sizing' === 'border-box';

      if(typeof parent !== 'number') {
        element.parents().each(function(){
          var tmpParent = $(this);
          if(parent.is(this)) {
            return false;
          } else {
            depthDiffHeight += tmpParent.outerHeight() - tmpParent.height();
          }
        });
      }
      calcHeight = parentHeight - depthDiffHeight;
      calcHeight -= isBorderBox ? 0 : element.outerHeight() - element.height();

      if(calcHeight > 0) {
        element.css(options.useMinHeight && supportMinHeight ? 'minHeight' : 'height', calcHeight);
      }
    });
    boxes.filter(':first').addClass(options.leftEdgeClass);
    boxes.filter(':last').addClass(options.rightEdgeClass);
    return calcHeight;
  }
}(jQuery));

/*
 * jQuery FontResize Event
 */
jQuery.onFontResize = (function($) {
  $(function() {
    var randomID = 'font-resize-frame-' + Math.floor(Math.random() * 1000);
    var resizeFrame = $('<iframe>').attr('id', randomID).addClass('font-resize-helper');

    // required styles
    resizeFrame.css({
      width: '100em',
      height: '10px',
      position: 'absolute',
      borderWidth: 0,
      top: '-9999px',
      left: '-9999px'
    }).appendTo('body');

    // use native IE resize event if possible
    if (window.attachEvent && !window.addEventListener) {
      resizeFrame.bind('resize', function () {
        $.onFontResize.trigger(resizeFrame[0].offsetWidth / 100);
      });
    }
    // use script inside the iframe to detect resize for other browsers
    else {
      var doc = resizeFrame[0].contentWindow.document;
      doc.open();
      doc.write('<scri' + 'pt>window.onload = function(){var em = parent.jQuery("#' + randomID + '")[0];window.onresize = function(){if(parent.jQuery.onFontResize){parent.jQuery.onFontResize.trigger(em.offsetWidth / 100);}}};</scri' + 'pt>');
      doc.close();
    }
    jQuery.onFontResize.initialSize = resizeFrame[0].offsetWidth / 100;
  });
  return {
    // public method, so it can be called from within the iframe
    trigger: function (em) {
      $(window).trigger("fontresize", [em]);
    }
  };
}(jQuery));

// open-close init
function initOpenClose() {
  jQuery('div.open-close').openClose({
    activeClass: 'active',
    opener: '.opener',
    slider: '.slide',
    animSpeed: 400,
    effect: 'slide',
    animStart : function(){
      var self = this;
      if(self.holder.hasClass('active')){
        self.holder.closest('.col').add(self.holder.closest('.col').siblings('.col')).animate({
          height : self.holder.closest('.col').outerHeight() + self.slider.outerHeight(true)
        }, self.animSpeed, function(){
          initSameHeight();
        });
      } else {
        self.holder.closest('.col').add(self.holder.closest('.col').siblings('.col')).animate({
          height : self.holder.closest('.col').outerHeight() - self.slider.outerHeight(true)
        }, self.animSpeed, function(){
          initSameHeight();
        });
      }
    }
  });
}

// popups init
function initPopups() {
  jQuery('.popup-holder').contentPopup({
    mode: 'hover'
  });
}

/*
 * jQuery Open/Close plugin
 */
;(function($) {
  function OpenClose(options) {
    this.options = $.extend({
      addClassBeforeAnimation: true,
      hideOnClickOutside: false,
      activeClass:'active',
      opener:'.opener',
      slider:'.slide',
      animSpeed: 400,
      effect:'fade',
      event:'click'
    }, options);
    this.init();
  }
  OpenClose.prototype = {
    init: function() {
      if(this.options.holder) {
        this.findElements();
        this.attachEvents();
        this.makeCallback('onInit', this);
      }
    },
    findElements: function() {
      this.holder = $(this.options.holder);
      this.opener = this.holder.find(this.options.opener);
      this.slider = this.holder.find(this.options.slider);
    },
    attachEvents: function() {
      // add handler
      var self = this;
      this.eventHandler = function(e) {
        e.preventDefault();
        if (self.slider.hasClass(slideHiddenClass)) {
          self.showSlide();
        } else {
          self.hideSlide();
        }
      };
      self.opener.bind(self.options.event, this.eventHandler);

      // hover mode handler
      if(self.options.event === 'over') {
        self.opener.bind('mouseenter', function() {
          self.showSlide();
        });
        self.holder.bind('mouseleave', function() {
          self.hideSlide();
        });
      }

      // outside click handler
      self.outsideClickHandler = function(e) {
        if(self.options.hideOnClickOutside) {
          var target = $(e.target);
          if (!target.is(self.holder) && !target.closest(self.holder).length) {
            self.hideSlide();
          }
        }
      };

      // set initial styles
      if (this.holder.hasClass(this.options.activeClass)) {
        $(document).bind('click touchstart', self.outsideClickHandler);
      } else {
        this.slider.addClass(slideHiddenClass);
      }
    },
    showSlide: function() {
      var self = this;
      if (self.options.addClassBeforeAnimation) {
        self.holder.addClass(self.options.activeClass);
      }
      self.slider.removeClass(slideHiddenClass);
      $(document).bind('click touchstart', self.outsideClickHandler);

      self.makeCallback('animStart', true);
      toggleEffects[self.options.effect].show({
        box: self.slider,
        speed: self.options.animSpeed,
        complete: function() {
          if (!self.options.addClassBeforeAnimation) {
            self.holder.addClass(self.options.activeClass);
          }
          self.makeCallback('animEnd', true);
        }
      });
    },
    hideSlide: function() {
      var self = this;
      if (self.options.addClassBeforeAnimation) {
        self.holder.removeClass(self.options.activeClass);
      }
      $(document).unbind('click touchstart', self.outsideClickHandler);

      self.makeCallback('animStart', false);
      toggleEffects[self.options.effect].hide({
        box: self.slider,
        speed: self.options.animSpeed,
        complete: function() {
          if (!self.options.addClassBeforeAnimation) {
            self.holder.removeClass(self.options.activeClass);
          }
          self.slider.addClass(slideHiddenClass);
          self.makeCallback('animEnd', false);
        }
      });
    },
    destroy: function() {
      this.slider.removeClass(slideHiddenClass).css({display:''});
      this.opener.unbind(this.options.event, this.eventHandler);
      this.holder.removeClass(this.options.activeClass).removeData('OpenClose');
      $(document).unbind('click touchstart', this.outsideClickHandler);
    },
    makeCallback: function(name) {
      if(typeof this.options[name] === 'function') {
        var args = Array.prototype.slice.call(arguments);
        args.shift();
        this.options[name].apply(this, args);
      }
    }
  };

  // add stylesheet for slide on DOMReady
  var slideHiddenClass = 'js-slide-hidden';
  (function() {
    var tabStyleSheet = $('<style type="text/css">')[0];
    var tabStyleRule = '.' + slideHiddenClass;
    tabStyleRule += '{position:absolute !important;left:-9999px !important;top:-9999px !important;display:block !important}';
    if (tabStyleSheet.styleSheet) {
      tabStyleSheet.styleSheet.cssText = tabStyleRule;
    } else {
      tabStyleSheet.appendChild(document.createTextNode(tabStyleRule));
    }
    $('head').append(tabStyleSheet);
  }());

  // animation effects
  var toggleEffects = {
    slide: {
      show: function(o) {
        o.box.stop(true).hide().slideDown(o.speed, o.complete);
      },
      hide: function(o) {
        o.box.stop(true).slideUp(o.speed, o.complete);
      }
    },
    fade: {
      show: function(o) {
        o.box.stop(true).hide().fadeIn(o.speed, o.complete);
      },
      hide: function(o) {
        o.box.stop(true).fadeOut(o.speed, o.complete);
      }
    },
    none: {
      show: function(o) {
        o.box.hide().show(0, o.complete);
      },
      hide: function(o) {
        o.box.hide(0, o.complete);
      }
    }
  };

  // jQuery plugin interface
  $.fn.openClose = function(opt) {
    return this.each(function() {
      jQuery(this).data('OpenClose', new OpenClose($.extend(opt, {holder: this})));
    });
  };
}(jQuery));

/*
 * Popups plugin
 */
;(function($) {
  function ContentPopup(opt) {
    this.options = $.extend({
      holder: null,
      popup: '.popup',
      btnOpen: '.open',
      btnClose: '.close',
      openClass: 'popup-active',
      clickEvent: 'click',
      mode: 'click',
      hideOnClickLink: true,
      hideOnClickOutside: true,
      delay: 50
    }, opt);
    if(this.options.holder) {
      this.holder = $(this.options.holder);
      this.init();
    }
  }
  ContentPopup.prototype = {
    init: function() {
      this.findElements();
      this.attachEvents();
    },
    findElements: function() {
      this.popup = this.holder.find(this.options.popup);
      this.btnOpen = this.holder.find(this.options.btnOpen);
      this.btnClose = this.holder.find(this.options.btnClose);
    },
    attachEvents: function() {
      // handle popup openers
      var self = this;
      this.clickMode = isTouchDevice || (self.options.mode === self.options.clickEvent);

      if(this.clickMode) {
        // handle click mode
        this.btnOpen.bind(self.options.clickEvent, function(e) {
          if(self.holder.hasClass(self.options.openClass)) {
            if(self.options.hideOnClickLink) {
              self.hidePopup();
            }
          } else {
            self.showPopup();
          }
          e.preventDefault();
        });

        // prepare outside click handler
        this.outsideClickHandler = this.bind(this.outsideClickHandler, this);
      } else {
        // handle hover mode
        var timer, delayedFunc = function(func) {
          clearTimeout(timer);
          timer = setTimeout(function() {
            func.call(self);
          }, self.options.delay);
        };
        this.btnOpen.bind('mouseover', function() {
          delayedFunc(self.showPopup);
        }).bind('mouseout', function() {
          delayedFunc(self.hidePopup);
        });
        this.popup.bind('mouseover', function() {
          delayedFunc(self.showPopup);
        }).bind('mouseout', function() {
          delayedFunc(self.hidePopup);
        });
      }

      // handle close buttons
      this.btnClose.bind(self.options.clickEvent, function(e) {
        self.hidePopup();
        e.preventDefault();
      });
    },
    outsideClickHandler: function(e) {
      // hide popup if clicked outside
      var targetNode = $((e.changedTouches ? e.changedTouches[0] : e).target);
      if(!targetNode.closest(this.popup).length && !targetNode.closest(this.btnOpen).length) {
        this.hidePopup();
      }
    },
    showPopup: function() {
      // reveal popup
      this.holder.addClass(this.options.openClass);
      this.popup.css({display:'block'});

      // outside click handler
      if(this.clickMode && this.options.hideOnClickOutside && !this.outsideHandlerActive) {
        this.outsideHandlerActive = true;
        $(document).bind('click touchstart', this.outsideClickHandler);
      }
    },
    hidePopup: function() {
      // hide popup
      this.holder.removeClass(this.options.openClass);
      this.popup.css({display:'none'});

      // outside click handler
      if(this.clickMode && this.options.hideOnClickOutside && this.outsideHandlerActive) {
        this.outsideHandlerActive = false;
        $(document).unbind('click touchstart', this.outsideClickHandler);
      }
    },
    bind: function(f, scope, forceArgs){
      return function() {return f.apply(scope, forceArgs ? [forceArgs] : arguments);};
    }
  };

  // detect touch devices
  var isTouchDevice = /MSIE 10.*Touch/.test(navigator.userAgent) || ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch;

  // jQuery plugin interface
  $.fn.contentPopup = function(opt) {
    return this.each(function() {
      new ContentPopup($.extend(opt, {holder: this}));
    });
  };
}(jQuery));

// clear inputs on focus
function initInputs() {
  PlaceholderInput.replaceByOptions({
    // filter options
    clearInputs: true,
    clearTextareas: true,
    clearPasswords: true,
    skipClass: 'default',

    // input options
    wrapWithElement: false,
    showUntilTyping: false,
    getParentByClass: false,
    placeholderAttr: 'value'
  });
}

/*
 * jQuery Open/Close plugin
 */
;(function($) {
  function OpenClose(options) {
    this.options = $.extend({
      addClassBeforeAnimation: true,
      hideOnClickOutside: false,
      activeClass:'active',
      opener:'.opener',
      slider:'.slide',
      animSpeed: 400,
      effect:'fade',
      event:'click'
    }, options);
    this.init();
  }
  OpenClose.prototype = {
    init: function() {
      if(this.options.holder) {
        this.findElements();
        this.attachEvents();
        this.makeCallback('onInit', this);
      }
    },
    findElements: function() {
      this.holder = $(this.options.holder);
      this.opener = this.holder.find(this.options.opener);
      this.slider = this.holder.find(this.options.slider);
    },
    attachEvents: function() {
      // add handler
      var self = this;
      this.eventHandler = function(e) {
        e.preventDefault();
        if (self.slider.hasClass(slideHiddenClass)) {
          self.showSlide();
        } else {
          self.hideSlide();
        }
      };
      self.opener.bind(self.options.event, this.eventHandler);

      // hover mode handler
      if(self.options.event === 'over') {
        self.opener.bind('mouseenter', function() {
          self.showSlide();
        });
        self.holder.bind('mouseleave', function() {
          self.hideSlide();
        });
      }

      // outside click handler
      self.outsideClickHandler = function(e) {
        if(self.options.hideOnClickOutside) {
          var target = $(e.target);
          if (!target.is(self.holder) && !target.closest(self.holder).length) {
            self.hideSlide();
          }
        }
      };

      // set initial styles
      if (this.holder.hasClass(this.options.activeClass)) {
        $(document).bind('click touchstart', self.outsideClickHandler);
      } else {
        this.slider.addClass(slideHiddenClass);
      }
    },
    showSlide: function() {
      var self = this;
      if (self.options.addClassBeforeAnimation) {
        self.holder.addClass(self.options.activeClass);
      }
      self.slider.removeClass(slideHiddenClass);
      $(document).bind('click touchstart', self.outsideClickHandler);

      self.makeCallback('animStart', true);
      toggleEffects[self.options.effect].show({
        box: self.slider,
        speed: self.options.animSpeed,
        complete: function() {
          if (!self.options.addClassBeforeAnimation) {
            self.holder.addClass(self.options.activeClass);
          }
          self.makeCallback('animEnd', true);
        }
      });
    },
    hideSlide: function() {
      var self = this;
      if (self.options.addClassBeforeAnimation) {
        self.holder.removeClass(self.options.activeClass);
      }
      $(document).unbind('click touchstart', self.outsideClickHandler);

      self.makeCallback('animStart', false);
      toggleEffects[self.options.effect].hide({
        box: self.slider,
        speed: self.options.animSpeed,
        complete: function() {
          if (!self.options.addClassBeforeAnimation) {
            self.holder.removeClass(self.options.activeClass);
          }
          self.slider.addClass(slideHiddenClass);
          self.makeCallback('animEnd', false);
        }
      });
    },
    destroy: function() {
      this.slider.removeClass(slideHiddenClass).css({display:''});
      this.opener.unbind(this.options.event, this.eventHandler);
      this.holder.removeClass(this.options.activeClass).removeData('OpenClose');
      $(document).unbind('click touchstart', this.outsideClickHandler);
    },
    makeCallback: function(name) {
      if(typeof this.options[name] === 'function') {
        var args = Array.prototype.slice.call(arguments);
        args.shift();
        this.options[name].apply(this, args);
      }
    }
  };

  // add stylesheet for slide on DOMReady
  var slideHiddenClass = 'js-slide-hidden';
  (function() {
    var tabStyleSheet = $('<style type="text/css">')[0];
    var tabStyleRule = '.' + slideHiddenClass;
    tabStyleRule += '{position:absolute !important;left:-9999px !important;top:-9999px !important;display:block !important}';
    if (tabStyleSheet.styleSheet) {
      tabStyleSheet.styleSheet.cssText = tabStyleRule;
    } else {
      tabStyleSheet.appendChild(document.createTextNode(tabStyleRule));
    }
    $('head').append(tabStyleSheet);
  }());

  // animation effects
  var toggleEffects = {
    slide: {
      show: function(o) {
        o.box.stop(true).hide().slideDown(o.speed, o.complete);
      },
      hide: function(o) {
        o.box.stop(true).slideUp(o.speed, o.complete);
      }
    },
    fade: {
      show: function(o) {
        o.box.stop(true).hide().fadeIn(o.speed, o.complete);
      },
      hide: function(o) {
        o.box.stop(true).fadeOut(o.speed, o.complete);
      }
    },
    none: {
      show: function(o) {
        o.box.hide().show(0, o.complete);
      },
      hide: function(o) {
        o.box.hide(0, o.complete);
      }
    }
  };

  // jQuery plugin interface
  $.fn.openClose = function(opt) {
    return this.each(function() {
      jQuery(this).data('OpenClose', new OpenClose($.extend(opt, {holder: this})));
    });
  };
}(jQuery));

/*
 * Popups plugin
 */
;(function($) {
  function ContentPopup(opt) {
    this.options = $.extend({
      holder: null,
      popup: '.popup',
      btnOpen: '.open',
      btnClose: '.close',
      openClass: 'popup-active',
      clickEvent: 'click',
      mode: 'click',
      hideOnClickLink: true,
      hideOnClickOutside: true,
      delay: 50
    }, opt);
    if(this.options.holder) {
      this.holder = $(this.options.holder);
      this.init();
    }
  }
  ContentPopup.prototype = {
    init: function() {
      this.findElements();
      this.attachEvents();
    },
    findElements: function() {
      this.popup = this.holder.find(this.options.popup);
      this.btnOpen = this.holder.find(this.options.btnOpen);
      this.btnClose = this.holder.find(this.options.btnClose);
    },
    attachEvents: function() {
      // handle popup openers
      var self = this;
      this.clickMode = isTouchDevice || (self.options.mode === self.options.clickEvent);

      if(this.clickMode) {
        // handle click mode
        this.btnOpen.bind(self.options.clickEvent, function(e) {
          if(self.holder.hasClass(self.options.openClass)) {
            if(self.options.hideOnClickLink) {
              self.hidePopup();
            }
          } else {
            self.showPopup();
          }
          e.preventDefault();
        });

        // prepare outside click handler
        this.outsideClickHandler = this.bind(this.outsideClickHandler, this);
      } else {
        // handle hover mode
        var timer, delayedFunc = function(func) {
          clearTimeout(timer);
          timer = setTimeout(function() {
            func.call(self);
          }, self.options.delay);
        };
        this.btnOpen.bind('mouseover', function() {
          delayedFunc(self.showPopup);
        }).bind('mouseout', function() {
          delayedFunc(self.hidePopup);
        });
        this.popup.bind('mouseover', function() {
          delayedFunc(self.showPopup);
        }).bind('mouseout', function() {
          delayedFunc(self.hidePopup);
        });
      }

      // handle close buttons
      this.btnClose.bind(self.options.clickEvent, function(e) {
        self.hidePopup();
        e.preventDefault();
      });
    },
    outsideClickHandler: function(e) {
      // hide popup if clicked outside
      var targetNode = $((e.changedTouches ? e.changedTouches[0] : e).target);
      if(!targetNode.closest(this.popup).length && !targetNode.closest(this.btnOpen).length) {
        this.hidePopup();
      }
    },
    showPopup: function() {
      // reveal popup
      this.holder.addClass(this.options.openClass);
      this.popup.css({display:'block'});

      // outside click handler
      if(this.clickMode && this.options.hideOnClickOutside && !this.outsideHandlerActive) {
        this.outsideHandlerActive = true;
        $(document).bind('click touchstart', this.outsideClickHandler);
      }
    },
    hidePopup: function() {
      // hide popup
      this.holder.removeClass(this.options.openClass);
      this.popup.css({display:'none'});

      // outside click handler
      if(this.clickMode && this.options.hideOnClickOutside && this.outsideHandlerActive) {
        this.outsideHandlerActive = false;
        $(document).unbind('click touchstart', this.outsideClickHandler);
      }
    },
    bind: function(f, scope, forceArgs){
      return function() {return f.apply(scope, forceArgs ? [forceArgs] : arguments);};
    }
  };

  // detect touch devices
  var isTouchDevice = /MSIE 10.*Touch/.test(navigator.userAgent) || ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch;

  // jQuery plugin interface
  $.fn.contentPopup = function(opt) {
    return this.each(function() {
      new ContentPopup($.extend(opt, {holder: this}));
    });
  };
}(jQuery));

// placeholder class
;(function(){
  var placeholderCollection = [];
  PlaceholderInput = function() {
    this.options = {
      element:null,
      showUntilTyping:false,
      wrapWithElement:false,
      getParentByClass:false,
      showPasswordBullets:false,
      placeholderAttr:'value',
      inputFocusClass:'focus',
      inputActiveClass:'text-active',
      parentFocusClass:'parent-focus',
      parentActiveClass:'parent-active',
      labelFocusClass:'label-focus',
      labelActiveClass:'label-active',
      fakeElementClass:'input-placeholder-text'
    };
    placeholderCollection.push(this);
    this.init.apply(this,arguments);
  };
  PlaceholderInput.refreshAllInputs = function(except) {
    for(var i = 0; i < placeholderCollection.length; i++) {
      if(except !== placeholderCollection[i]) {
        placeholderCollection[i].refreshState();
      }
    }
  };
  PlaceholderInput.replaceByOptions = function(opt) {
    var inputs = [].concat(
      convertToArray(document.getElementsByTagName('input')),
      convertToArray(document.getElementsByTagName('textarea'))
    );
    for(var i = 0; i < inputs.length; i++) {
      if(inputs[i].className.indexOf(opt.skipClass) < 0) {
        var inputType = getInputType(inputs[i]);
        var placeholderValue = inputs[i].getAttribute('placeholder');
        if(opt.focusOnly || (opt.clearInputs && (inputType === 'text' || inputType === 'email' || placeholderValue)) ||
          (opt.clearTextareas && inputType === 'textarea') ||
          (opt.clearPasswords && inputType === 'password')
        ) {
          new PlaceholderInput({
            element:inputs[i],
            focusOnly: opt.focusOnly,
            wrapWithElement:opt.wrapWithElement,
            showUntilTyping:opt.showUntilTyping,
            getParentByClass:opt.getParentByClass,
            showPasswordBullets:opt.showPasswordBullets,
            placeholderAttr: placeholderValue ? 'placeholder' : opt.placeholderAttr
          });
        }
      }
    }
  };
  PlaceholderInput.prototype = {
    init: function(opt) {
      this.setOptions(opt);
      if(this.element && this.element.PlaceholderInst) {
        this.element.PlaceholderInst.refreshClasses();
      } else {
        this.element.PlaceholderInst = this;
        if(this.elementType !== 'radio' || this.elementType !== 'checkbox' || this.elementType !== 'file') {
          this.initElements();
          this.attachEvents();
          this.refreshClasses();
        }
      }
    },
    setOptions: function(opt) {
      for(var p in opt) {
        if(opt.hasOwnProperty(p)) {
          this.options[p] = opt[p];
        }
      }
      if(this.options.element) {
        this.element = this.options.element;
        this.elementType = getInputType(this.element);
        if(this.options.focusOnly) {
          this.wrapWithElement = false;
        } else {
          if(this.elementType === 'password' && this.options.showPasswordBullets && !this.options.showUntilTyping) {
            this.wrapWithElement = false;
          } else {
            this.wrapWithElement = this.elementType === 'password' || this.options.showUntilTyping ? true : this.options.wrapWithElement;
          }
        }
        this.setPlaceholderValue(this.options.placeholderAttr);
      }
    },
    setPlaceholderValue: function(attr) {
      this.origValue = (attr === 'value' ? this.element.defaultValue : (this.element.getAttribute(attr) || ''));
      if(this.options.placeholderAttr !== 'value') {
        this.element.removeAttribute(this.options.placeholderAttr);
      }
    },
    initElements: function() {
      // create fake element if needed
      if(this.wrapWithElement) {
        this.fakeElement = document.createElement('span');
        this.fakeElement.className = this.options.fakeElementClass;
        this.fakeElement.innerHTML += this.origValue;
        this.fakeElement.style.color = getStyle(this.element, 'color');
        this.fakeElement.style.position = 'absolute';
        this.element.parentNode.insertBefore(this.fakeElement, this.element);

        if(this.element.value === this.origValue || !this.element.value) {
          this.element.value = '';
          this.togglePlaceholderText(true);
        } else {
          this.togglePlaceholderText(false);
        }
      } else if(!this.element.value && this.origValue.length) {
        this.element.value = this.origValue;
      }
      // get input label
      if(this.element.id) {
        this.labels = document.getElementsByTagName('label');
        for(var i = 0; i < this.labels.length; i++) {
          if(this.labels[i].htmlFor === this.element.id) {
            this.labelFor = this.labels[i];
            break;
          }
        }
      }
      // get parent node (or parentNode by className)
      this.elementParent = this.element.parentNode;
      if(typeof this.options.getParentByClass === 'string') {
        var el = this.element;
        while(el.parentNode) {
          if(hasClass(el.parentNode, this.options.getParentByClass)) {
            this.elementParent = el.parentNode;
            break;
          } else {
            el = el.parentNode;
          }
        }
      }
    },
    attachEvents: function() {
      this.element.onfocus = bindScope(this.focusHandler, this);
      this.element.onblur = bindScope(this.blurHandler, this);
      if(this.options.showUntilTyping) {
        this.element.onkeydown = bindScope(this.typingHandler, this);
        this.element.onpaste = bindScope(this.typingHandler, this);
      }
      if(this.wrapWithElement) this.fakeElement.onclick = bindScope(this.focusSetter, this);
    },
    togglePlaceholderText: function(state) {
      if(!this.element.readOnly && !this.options.focusOnly) {
        if(this.wrapWithElement) {
          this.fakeElement.style.display = state ? '' : 'none';
        } else {
          this.element.value = state ? this.origValue : '';
        }
      }
    },
    focusSetter: function() {
      this.element.focus();
    },
    focusHandler: function() {
      clearInterval(this.checkerInterval);
      this.checkerInterval = setInterval(bindScope(this.intervalHandler,this), 1);
      this.focused = true;
      if(!this.element.value.length || this.element.value === this.origValue) {
        if(!this.options.showUntilTyping) {
          this.togglePlaceholderText(false);
        }
      }
      this.refreshClasses();
    },
    blurHandler: function() {
      clearInterval(this.checkerInterval);
      this.focused = false;
      if(!this.element.value.length || this.element.value === this.origValue) {
        this.togglePlaceholderText(true);
      }
      this.refreshClasses();
      PlaceholderInput.refreshAllInputs(this);
    },
    typingHandler: function() {
      setTimeout(bindScope(function(){
        if(this.element.value.length) {
          this.togglePlaceholderText(false);
          this.refreshClasses();
        }
      },this), 10);
    },
    intervalHandler: function() {
      if(typeof this.tmpValue === 'undefined') {
        this.tmpValue = this.element.value;
      }
      if(this.tmpValue != this.element.value) {
        PlaceholderInput.refreshAllInputs(this);
      }
    },
    refreshState: function() {
      if(this.wrapWithElement) {
        if(this.element.value.length && this.element.value !== this.origValue) {
          this.togglePlaceholderText(false);
        } else if(!this.element.value.length) {
          this.togglePlaceholderText(true);
        }
      }
      this.refreshClasses();
    },
    refreshClasses: function() {
      this.textActive = this.focused || (this.element.value.length && this.element.value !== this.origValue);
      this.setStateClass(this.element, this.options.inputFocusClass,this.focused);
      this.setStateClass(this.elementParent, this.options.parentFocusClass,this.focused);
      this.setStateClass(this.labelFor, this.options.labelFocusClass,this.focused);
      this.setStateClass(this.element, this.options.inputActiveClass, this.textActive);
      this.setStateClass(this.elementParent, this.options.parentActiveClass, this.textActive);
      this.setStateClass(this.labelFor, this.options.labelActiveClass, this.textActive);
    },
    setStateClass: function(el,cls,state) {
      if(!el) return; else if(state) addClass(el,cls); else removeClass(el,cls);
    }
  };

  // utility functions
  function convertToArray(collection) {
    var arr = [];
    for (var i = 0, ref = arr.length = collection.length; i < ref; i++) {
      arr[i] = collection[i];
    }
    return arr;
  }
  function getInputType(input) {
    return (input.type ? input.type : input.tagName).toLowerCase();
  }
  function hasClass(el,cls) {
    return el.className ? el.className.match(new RegExp('(\\s|^)'+cls+'(\\s|$)')) : false;
  }
  function addClass(el,cls) {
    if (!hasClass(el,cls)) el.className += " "+cls;
  }
  function removeClass(el,cls) {
    if (hasClass(el,cls)) {el.className=el.className.replace(new RegExp('(\\s|^)'+cls+'(\\s|$)'),' ');}
  }
  function bindScope(f, scope) {
    return function() {return f.apply(scope, arguments);};
  }
  function getStyle(el, prop) {
    if (document.defaultView && document.defaultView.getComputedStyle) {
      return document.defaultView.getComputedStyle(el, null)[prop];
    } else if (el.currentStyle) {
      return el.currentStyle[prop];
    } else {
      return el.style[prop];
    }
  }
}());


/*!
 * JCF - JavaScript Custom Forms - Core
 */
;(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
    define(['jquery'], factory);
  } else if (typeof exports === 'object') {
    module.exports = factory(require('jquery'));
  } else {
    root.jcf = factory(jQuery);
  }
}(this, function ($) {
  'use strict';

  // private variables
  var customInstances = [];

  // default global options
  var commonOptions = {
    optionsKey: 'jcf',
    dataKey: 'jcf-instance',
    rtlClass: 'jcf-rtl',
    focusClass: 'jcf-focus',
    pressedClass: 'jcf-pressed',
    disabledClass: 'jcf-disabled',
    hiddenClass: 'jcf-hidden',
    resetAppearanceClass: 'jcf-reset-appearance',
    unselectableClass: 'jcf-unselectable'
  };

  // detect device type
  var isTouchDevice = ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch,
    isWinPhoneDevice = navigator.msPointerEnabled && /MSIE 10.*Touch/.test(navigator.userAgent);
  commonOptions.isMobileDevice = !!(isTouchDevice || isWinPhoneDevice);

  // create global stylesheet if custom forms are used
  var createStyleSheet = function() {
    var styleTag = $('<style>').appendTo('head'),
      styleSheet = styleTag.prop('sheet') || styleTag.prop('styleSheet');

    // crossbrowser style handling
    var addCSSRule = function(selector, rules, index) {
      if(styleSheet.insertRule) {
        styleSheet.insertRule(selector + '{' + rules + '}', index);
      } else {
        styleSheet.addRule(selector, rules, index);
      }
    };

    // add special rules
    addCSSRule('.' + commonOptions.hiddenClass, 'position:absolute !important;left:-9999px !important;display:block !important');
    addCSSRule('.' + commonOptions.rtlClass + '.' + commonOptions.hiddenClass, 'right:-9999px !important; left: auto !important');
    addCSSRule('.' + commonOptions.unselectableClass, '-webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none;');
    addCSSRule('.' + commonOptions.resetAppearanceClass, 'background: none; border: none; -webkit-appearance: none; appearance: none; opacity: 0; filter: alpha(opacity=0);');

    // detect rtl pages
    var html = $('html'), body = $('body');
    if(html.css('direction') === 'rtl' || body.css('direction') === 'rtl') {
      html.addClass(commonOptions.rtlClass);
    }

    // mark stylesheet as created
    commonOptions.styleSheetCreated = true;
  };

  // simplified pointer events handler
  (function() {
    var pointerEventsSupported = navigator.pointerEnabled || navigator.msPointerEnabled,
      touchEventsSupported = ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch,
      eventList, eventMap = {}, eventPrefix = 'jcf-';

    // detect events to attach
    if(pointerEventsSupported) {
      eventList = {
        pointerover: navigator.pointerEnabled ? 'pointerover' : 'MSPointerOver',
        pointerdown: navigator.pointerEnabled ? 'pointerdown' : 'MSPointerDown',
        pointermove: navigator.pointerEnabled ? 'pointermove' : 'MSPointerMove',
        pointerup: navigator.pointerEnabled ? 'pointerup' : 'MSPointerUp'
      };
    } else {
      eventList = {
        pointerover: 'mouseover',
        pointerdown: 'mousedown' + (touchEventsSupported ? ' touchstart' : ''),
        pointermove: 'mousemove' + (touchEventsSupported ? ' touchmove' : ''),
        pointerup: 'mouseup' + (touchEventsSupported ? ' touchend' : '')
      };
    }

    // create event map
    $.each(eventList, function(targetEventName, fakeEventList) {
      $.each(fakeEventList.split(' '), function(index, fakeEventName) {
        eventMap[fakeEventName] = targetEventName;
      });
    });

    // jQuery event hooks
    $.each(eventList, function(eventName, eventHandlers) {
      eventHandlers = eventHandlers.split(' ');
      $.event.special[eventPrefix + eventName] = {
        setup: function() {
          var self = this;
          $.each(eventHandlers, function(index, fallbackEvent) {
            if(self.addEventListener) self.addEventListener(fallbackEvent, fixEvent, false);
            else self['on' + fallbackEvent] = fixEvent;
          });
        },
        teardown: function() {
          var self = this;
          $.each(eventHandlers, function(index, fallbackEvent) {
            if(self.addEventListener) self.removeEventListener(fallbackEvent, fixEvent, false);
            else self['on' + fallbackEvent] = null;
          });
        }
      };
    });

    // check that mouse event are not simulated by mobile browsers
    var lastTouch = null;
    var mouseEventSimulated = function(e) {
      var dx = Math.abs(e.clientX - lastTouch.x),
        dy = Math.abs(e.clientY - lastTouch.y),
        rangeDistance = 25;

      if (dx <= rangeDistance && dy <= rangeDistance) {
        return true;
      }
    };

    // normalize event
    var fixEvent = function(e) {
      var origEvent = e || window.event,
        targetEventName = eventMap[origEvent.type];

      e = $.event.fix(origEvent);
      e.type = eventPrefix + targetEventName;

      if(origEvent.pointerType) {
        switch(origEvent.pointerType) {
          case 2: e.pointerType = 'touch'; break;
          case 3: e.pointerType = 'pen'; break;
          case 4: e.pointerType = 'mouse'; break;
          default: e.pointerType = origEvent.pointerType;
        }
      } else {
        e.pointerType = origEvent.type.substr(0,5); // "mouse" or "touch" word length
      }
      if(!e.pageX || !e.pageY) {
        e.pageX = (origEvent.changedTouches ? origEvent.changedTouches[0] : origEvent).pageX;
        e.pageY = (origEvent.changedTouches ? origEvent.changedTouches[0] : origEvent).pageY;
      }

      if(origEvent.type === 'touchend' && origEvent.changedTouches[0]) {
        lastTouch = {x: origEvent.changedTouches[0].clientX, y: origEvent.changedTouches[0].clientY};
      }
      if(e.pointerType === 'mouse' && lastTouch && mouseEventSimulated(e)) {
        return;
      } else {
        return ($.event.dispatch || $.event.handle).call(this, e);
      }
    };
  }());

  // custom mousewheel/trackpad handler
  (function() {
    var wheelEvents = ('onwheel' in document || document.documentMode >= 9 ? 'wheel' : 'mousewheel DOMMouseScroll').split(' '),
      shimEventName = 'jcf-mousewheel';

    $.event.special[shimEventName] = {
      setup: function() {
        var self = this;
        $.each(wheelEvents, function(index, fallbackEvent) {
          if(self.addEventListener) self.addEventListener(fallbackEvent, fixEvent, false);
          else self['on' + fallbackEvent] = fixEvent;
        });
      },
      teardown: function() {
        var self = this;
        $.each(wheelEvents, function(index, fallbackEvent) {
          if(self.addEventListener) self.removeEventListener(fallbackEvent, fixEvent, false);
          else self['on' + fallbackEvent] = null;
        });
      }
    };

    var fixEvent = function(e) {
      var origEvent = e || window.event;
      e = $.event.fix(origEvent);
      e.type = shimEventName;

      // old wheel events handler
      if('detail'      in origEvent) { e.deltaY = -origEvent.detail;      }
      if('wheelDelta'  in origEvent) { e.deltaY = -origEvent.wheelDelta;  }
      if('wheelDeltaY' in origEvent) { e.deltaY = -origEvent.wheelDeltaY; }
      if('wheelDeltaX' in origEvent) { e.deltaX = -origEvent.wheelDeltaX; }

      // modern wheel event handler
      if('deltaY' in origEvent) {
        e.deltaY = origEvent.deltaY;
      }
      if('deltaX' in origEvent) {
        e.deltaX = origEvent.deltaX;
      }
      e.delta = e.deltaY || e.deltaX;
      return ($.event.dispatch || $.event.handle).call(this, e);
    };
  }());

  // public API
  return {
    modules: {},
    getOptions: function() {
      return $.extend({}, commonOptions);
    },
    setOptions: function(moduleName, moduleOptions) {
      if(arguments.length > 1) {
        // set module options
        if(this.modules[moduleName]) {
          $.extend(this.modules[moduleName].prototype.options, moduleOptions);
        }
      } else {
        // set common options
        $.extend(commonOptions, moduleName);
      }
    },
    addModule: function(proto) {
      // add module to list
      var Module = function(options) {
        // save instance to collection
        options.element.data(commonOptions.dataKey, this);
        customInstances.push(this);

        // save options
        this.options = $.extend({}, commonOptions, this.options, options.element.data(commonOptions.optionsKey), options);

        // bind event handlers to instance
        this.bindHandlers();

        // call constructor
        this.init.apply(this, arguments);
      };

      // set proto as prototype for new module
      Module.prototype = proto;

      // bind event handlers for module and its plugins (functions beggining with on)
      Module.prototype.bindHandlers = function() {
        var self = this;
        $.each(self, function(propName, propValue) {
          if(propName.indexOf('on') === 0 && $.isFunction(propValue)) {
            // dont use $.proxy here because it doesn't create unique handler
            self[propName] = function() {
              return propValue.apply(self, arguments);
            };
          }
        });
      };
      if(proto.plugins) {
        $.each(proto.plugins, function(pluginName, plugin) {
          plugin.prototype.bindHandlers = Module.prototype.bindHandlers;
        });
      }

      // override destroy method
      var originalDestroy = Module.prototype.destroy;
      Module.prototype.destroy = function() {
        this.options.element.removeData(this.options.dataKey);

        for(var i = customInstances.length - 1; i >= 0; i--) {
          if(customInstances[i] === this) {
            customInstances.splice(i, 1);
            break;
          }
        }

        if(originalDestroy) {
          originalDestroy.apply(this, arguments);
        }
      };

      // save module to list
      this.modules[proto.name] = Module;
    },
    getInstance: function(element) {
      return $(element).data(commonOptions.dataKey);
    },
    replace: function(elements, moduleName, customOptions) {
      var self = this,
        instance;

      if(!commonOptions.styleSheetCreated) {
        createStyleSheet();
      }

      $(elements).each(function() {
        var moduleOptions,
          element = $(this);

        instance = element.data(commonOptions.dataKey);
        if(instance) {
          instance.refresh();
        } else {
          if(!moduleName) {
            $.each(self.modules, function(currentModuleName, module) {
              if(module.prototype.matchElement.call(module.prototype, element)) {
                moduleName = currentModuleName;
                return false;
              }
            });
          }
          if(moduleName) {
            moduleOptions = $.extend({element:element}, customOptions);
            instance = new self.modules[moduleName](moduleOptions);
          }
        }
      });
      return instance;
    },
    refresh: function(elements) {
      $(elements).each(function() {
        var instance = $(this).data(commonOptions.dataKey);
        if(instance) {
          instance.refresh();
        }
      });
    },
    destroy: function(elements) {
      $(elements).each(function() {
        var instance = $(this).data(commonOptions.dataKey);
        if(instance) {
          instance.destroy();
        }
      });
    },
    replaceAll: function(context) {
      var self = this;
      $.each(this.modules, function(moduleName, module) {
        $(module.prototype.selector, context).each(function() {
          self.replace(this, moduleName);
        });
      });
    },
    refreshAll: function(context) {
      if(context) {
        $.each(this.modules, function(moduleName, module) {
          $(module.prototype.selector, context).each(function() {
            var instance = $(this).data(commonOptions.dataKey);
            if(instance) {
              instance.refresh();
            }
          });
        });
      } else {
        for(var i = customInstances.length - 1; i >= 0; i--) {
          customInstances[i].refresh();
        }
      }
    },
    destroyAll: function(context) {
      var self = this;
      if(context) {
        $.each(this.modules, function(moduleName, module) {
          $(module.prototype.selector, context).each(function(index, element) {
            var instance = $(element).data(commonOptions.dataKey);
            if(instance) {
              instance.destroy();
            }
          });
        });
      } else {
        while(customInstances.length) {
          customInstances[0].destroy();
        }
      }
    }
  };
}));

/*!
 * JCF - JavaScript Custom Forms - Select Module
 */
;(function($, window) {
  'use strict';

  jcf.addModule({
    name: 'Select',
    selector: 'select',
    options: {
      element: null
    },
    plugins: {
      ListBox: ListBox,
      ComboBox: ComboBox,
      SelectList: SelectList
    },
    matchElement: function(element) {
      return element.is('select');
    },
    init: function() {
      this.element = $(this.options.element);
      this.createInstance();
    },
    isListBox: function() {
      return this.element.is('[size]:not([jcf-size]), [multiple]');
    },
    createInstance: function() {
      if(this.instance) {
        this.instance.destroy();
      }
      if(this.isListBox()) {
        this.instance = new ListBox(this.options);
      } else {
        this.instance = new ComboBox(this.options);
      }
    },
    refresh: function() {
      var typeMismatch = (this.isListBox() && this.instance instanceof ComboBox) ||
                (!this.isListBox() && this.instance instanceof ListBox);

      if(typeMismatch) {
        this.createInstance();
      } else {
        this.instance.refresh();
      }
    },
    destroy: function() {
      this.instance.destroy();
    }
  });

  // combobox module
  function ComboBox(options) {
    this.options = $.extend({
      wrapNative: true,
      wrapNativeOnMobile: true,
      fakeDropInBody: true,
      useCustomScroll: true,
      flipDropToFit: true,
      maxVisibleItems: 10,
      fakeAreaStructure: '<span class="jcf-select"><span class="jcf-select-text"></span><span class="jcf-select-opener"></span></span>',
      fakeDropStructure: '<div class="jcf-select-drop"><div class="jcf-select-drop-content"></div></div>',
      optionClassPrefix: 'jcf-option-',
      selectClassPrefix: 'jcf-select-',
      dropContentSelector: '.jcf-select-drop-content',
      selectTextSelector: '.jcf-select-text',
      dropActiveClass: 'jcf-drop-active',
      flipDropClass: 'jcf-drop-flipped'
    }, options);
    this.init();
  }
  $.extend(ComboBox.prototype, {
    init: function(options) {
      this.initStructure();
      this.bindHandlers();
      this.attachEvents();
      this.refresh();
    },
    initStructure: function() {
      // prepare structure
      this.win = $(window);
      this.doc = $(document);
      this.realElement = $(this.options.element);
      this.fakeElement = $(this.options.fakeAreaStructure).insertAfter(this.realElement);
      this.selectTextContainer = this.fakeElement.find(this.options.selectTextSelector);
      this.selectText = $('<span></span>').appendTo(this.selectTextContainer);
      makeUnselectable(this.fakeElement);

      // copy classes from original select
      this.fakeElement.addClass(getPrefixedClasses(this.realElement.prop('className'), this.options.selectClassPrefix));

      // detect device type and dropdown behavior
      if(this.options.isMobileDevice && this.options.wrapNativeOnMobile && !this.options.wrapNative) {
        this.options.wrapNative = true;
      }

      if(this.options.wrapNative) {
        // wrap native select inside fake block
        this.realElement.prependTo(this.fakeElement).css({
          position: 'absolute',
          height: '100%',
          width: '100%'
        }).addClass(this.options.resetAppearanceClass);
      } else {
        // just hide native select
        this.realElement.addClass(this.options.hiddenClass);
        this.fakeDropTarget = this.options.fakeDropInBody ? $('body') : this.fakeElement;
      }
    },
    attachEvents: function() {
      // delayed refresh handler
      var self = this;
      this.delayedRefresh = function() {
        setTimeout(function() {
          self.refresh();
          if(self.list) {
            self.list.refresh();
          }
        }, 1);
      };

      // native dropdown event handlers
      if(this.options.wrapNative) {
        this.realElement.on({
          focus: this.onFocus,
          change: this.onChange,
          click: this.onChange,
          keydown: this.onChange
        });
      } else {
        // custom dropdown event handlers
        this.realElement.on({
          focus: this.onFocus,
          change: this.onChange,
          keydown: this.onKeyDown
        });
        this.fakeElement.on({
          'jcf-pointerdown': this.onSelectAreaPress
        });
      }
    },
    onKeyDown: function(e) {
      if(e.which === 13) {
        this.toggleDropdown();
      } else {
        this.delayedRefresh();
      }
    },
    onChange: function() {
      this.refresh();
    },
    onFocus: function() {
      if(!this.pressedFlag || !this.focusedFlag) {
        this.fakeElement.addClass(this.options.focusClass);
        this.realElement.on('blur', this.onBlur);
        this.toggleListMode(true);
        this.focusedFlag = true;
      }
    },
    onBlur: function() {
      if(!this.pressedFlag) {
        this.fakeElement.removeClass(this.options.focusClass);
        this.realElement.off('blur', this.onBlur);
        this.toggleListMode(false);
        this.focusedFlag = false;
      }
    },
    onResize: function() {
      if(this.dropActive) {
        this.hideDropdown();
      }
    },
    onSelectDropPress: function() {
      this.pressedFlag = true;
    },
    onSelectDropRelease: function(e, pointerEvent) {
      this.pressedFlag = false;
      if(pointerEvent.pointerType === 'mouse') {
        this.realElement.focus();
      }
    },
    onSelectAreaPress: function(e) {
      // skip click if drop inside fake element or real select is disabled
      var dropClickedInsideFakeElement = !this.options.fakeDropInBody && $(e.target).closest(this.dropdown).length;
      if(dropClickedInsideFakeElement || e.button > 1 || this.realElement.is(':disabled')) {
        return;
      }

      // toggle dropdown visibility
      this.toggleDropdown();

      // misc handlers
      if(!this.focusedFlag) {
        if(e.pointerType === 'mouse') {
          this.realElement.focus();
        } else {
          this.onFocus(e);
        }
      }
      this.pressedFlag = true;
      this.fakeElement.addClass(this.options.pressedClass);
      this.doc.on('jcf-pointerup', this.onSelectAreaRelease);
    },
    onSelectAreaRelease: function(e) {
      if(this.focusedFlag && e.pointerType === 'mouse') {
        this.realElement.focus();
      }
      this.pressedFlag = false;
      this.fakeElement.removeClass(this.options.pressedClass);
      this.doc.off('jcf-pointerup', this.onSelectAreaRelease);
    },
    onOutsideClick: function(e) {
      var target = $(e.target),
        clickedInsideSelect = target.closest(this.fakeElement).length || target.closest(this.dropdown).length;

      if(!clickedInsideSelect) {
        this.hideDropdown();
      }
    },
    onSelect: function() {
      this.hideDropdown();
      this.refresh();
      this.realElement.trigger('change');
    },
    toggleListMode: function(state) {
      if(!this.options.wrapNative) {
        if(state) {
          // temporary change select to list to avoid appearing of native dropdown
          this.realElement.attr({
            size: 4,
            'jcf-size': ''
          });
        } else {
          // restore select from list mode to dropdown select
          if(!this.options.wrapNative) {
            this.realElement.removeAttr('size jcf-size');
          }
        }
      }
    },
    createDropdown: function() {
      // destroy previous dropdown if needed
      if(this.dropdown) {
        this.list.destroy();
        this.dropdown.remove();
      }

      // create new drop container
      this.dropdown = $(this.options.fakeDropStructure).appendTo(this.fakeDropTarget);
      this.dropdown.addClass(getPrefixedClasses(this.realElement.prop('className'), this.options.selectClassPrefix));
      makeUnselectable(this.dropdown);

      // create new select list instance
      this.list = new SelectList({
        useHoverClass: true,
        handleResize: false,
        alwaysPreventMouseWheel: true,
        maxVisibleItems: this.options.maxVisibleItems,
        useCustomScroll: this.options.useCustomScroll,
        holder: this.dropdown.find(this.options.dropContentSelector),
        element: this.realElement
      });
      $(this.list).on({
        select: this.onSelect,
        press: this.onSelectDropPress,
        release: this.onSelectDropRelease
      });
    },
    repositionDropdown: function() {
      var selectOffset = this.fakeElement.offset(),
        selectWidth = this.fakeElement.outerWidth(),
        selectHeight = this.fakeElement.outerHeight(),
        dropHeight = this.dropdown.outerHeight(),
        winScrollTop = this.win.scrollTop(),
        winHeight = this.win.height(),
        calcTop, calcLeft, bodyOffset, needFlipDrop = false;

      // check flip drop position
      if(selectOffset.top + selectHeight + dropHeight > winScrollTop + winHeight && selectOffset.top - dropHeight > winScrollTop) {
        needFlipDrop = true;
      }

      if(this.options.fakeDropInBody) {
        bodyOffset = this.fakeDropTarget.css('position') !== 'static' ? this.fakeDropTarget.offset().top : 0;
        if(this.options.flipDropToFit && needFlipDrop) {
          // calculate flipped dropdown position
          calcLeft = selectOffset.left;
          calcTop = selectOffset.top - dropHeight - bodyOffset;
        } else {
          // calculate default drop position
          calcLeft = selectOffset.left;
          calcTop = selectOffset.top + selectHeight - bodyOffset;
        }

        // update drop styles
        this.dropdown.css({
          position: 'absolute',
          width: selectWidth,
          left: calcLeft,
          top: calcTop
        });
      }

      // refresh flipped class
      this.dropdown.add(this.fakeElement).toggleClass(this.options.flipDropClass, this.options.flipDropToFit && needFlipDrop);
    },
    showDropdown: function() {
      // create options list if not created
      if(!this.dropdown) {
        this.createDropdown();
      }

      // show dropdown
      this.dropActive = true;
      this.dropdown.appendTo(this.fakeDropTarget);
      this.fakeElement.addClass(this.options.dropActiveClass);
      this.refreshSelectedText();
      this.repositionDropdown();
      this.list.setScrollTop(this.savedScrollTop);
      this.list.refresh();

      // add temporary event handlers
      this.win.on('resize', this.onResize);
      this.doc.on('jcf-pointerdown', this.onOutsideClick);
    },
    hideDropdown: function() {
      if(this.dropdown) {
        this.savedScrollTop = this.list.getScrollTop();
        this.fakeElement.removeClass(this.options.dropActiveClass + ' ' + this.options.flipDropClass);
        this.dropdown.removeClass(this.options.flipDropClass).detach();
        this.doc.off('jcf-pointerdown', this.onOutsideClick);
        this.win.off('resize', this.onResize);
        this.dropActive = false;
      }
    },
    toggleDropdown: function() {
      if(this.dropActive) {
        this.hideDropdown();
      } else {
        this.showDropdown();
      }
    },
    refreshSelectedText: function() {
      // redraw selected area
      var selectedIndex = this.realElement.prop('selectedIndex'),
        selectedOption = this.realElement.prop('options')[selectedIndex],
        selectedOptionImage = selectedOption.getAttribute('data-image'),
        selectedOptionClasses,
        selectedFakeElement;

      if(this.currentSelectedText !== selectedOption.innerHTML || this.currentSelectedImage !== selectedOptionImage) {
        selectedOptionClasses = getPrefixedClasses(selectedOption.className, this.options.optionClassPrefix);
        this.selectText.attr('class', selectedOptionClasses).html(selectedOption.innerHTML);

        if(selectedOptionImage) {
          if(!this.selectImage) {
            this.selectImage = $('<img>').prependTo(this.selectTextContainer).hide();
          }
          this.selectImage.attr('src', selectedOptionImage).show();
        } else if(this.selectImage) {
          this.selectImage.hide();
        }

        this.currentSelectedText = selectedOption.innerHTML;
        this.currentSelectedImage = selectedOptionImage;
      }
    },
    refresh: function() {
      // refresh selected text
      this.refreshSelectedText();

      // handle disabled state
      this.fakeElement.toggleClass(this.options.disabledClass, this.realElement.is(':disabled'));
    },
    destroy: function() {
      // restore structure
      if(this.options.wrapNative) {
        this.realElement.insertBefore(this.fakeElement).css({
          position: '',
          height: '',
          width: ''
        }).removeClass(this.options.resetAppearanceClass);
      } else {
        this.realElement.removeClass(this.options.hiddenClass);
        if(this.realElement.is('[jcf-size]')) {
          this.realElement.removeAttr('size jcf-size');
        }
      }

      // removing element will also remove its event handlers
      this.fakeElement.remove();

      // remove other event handlers
      this.doc.off('jcf-pointerup', this.onSelectAreaRelease);
      this.realElement.off({
        focus: this.onFocus
      });
    }
  });

  // listbox module
  function ListBox(options) {
    this.options = $.extend({
      wrapNative: true,
      useCustomScroll: true,
      fakeStructure: '<span class="jcf-list-box"><span class="jcf-list-wrapper"></span></span>',
      selectClassPrefix: 'jcf-select-',
      listHolder: '.jcf-list-wrapper'
    }, options);
    this.init();
  }
  $.extend(ListBox.prototype, {
    init: function(options) {
      this.bindHandlers();
      this.initStructure();
      this.attachEvents();
    },
    initStructure: function() {
      var self = this;
      this.realElement = $(this.options.element);
      this.fakeElement = $(this.options.fakeStructure).insertAfter(this.realElement);
      this.listHolder = this.fakeElement.find(this.options.listHolder);
      makeUnselectable(this.fakeElement);

      // copy classes from original select
      this.fakeElement.addClass(getPrefixedClasses(this.realElement.prop('className'), this.options.selectClassPrefix));
      this.realElement.addClass(this.options.hiddenClass);

      this.list = new SelectList({
        useCustomScroll: this.options.useCustomScroll,
        holder: this.listHolder,
        selectOnClick: false,
        element: this.realElement
      });
    },
    attachEvents: function() {
      // delayed refresh handler
      var self = this;
      this.delayedRefresh = function() {
        clearTimeout(self.refreshTimer);
        self.refreshTimer = setTimeout(function() {
          self.refresh();
        }, 1);
      };

      // other event handlers
      this.realElement.on({
        focus: this.onFocus,
        click: this.delayedRefresh,
        keydown: this.delayedRefresh
      });

      // select list event handlers
      $(this.list).on({
        select: this.onSelect,
        press: this.onFakeOptionsPress,
        release: this.onFakeOptionsRelease
      });
    },
    onFakeOptionsPress: function(e, pointerEvent) {
      this.pressedFlag = true;
      if(pointerEvent.pointerType === 'mouse') {
        this.realElement.focus();
      }
    },
    onFakeOptionsRelease: function(e, pointerEvent) {
      this.pressedFlag = false;
      if(pointerEvent.pointerType === 'mouse') {
        this.realElement.focus();
      }
    },
    onSelect: function() {
      this.realElement.trigger('change');
    },
    onFocus: function() {
      if(!this.pressedFlag || !this.focusedFlag) {
        this.fakeElement.addClass(this.options.focusClass);
        this.realElement.on('blur', this.onBlur);
        this.focusedFlag = true;
      }
    },
    onBlur: function() {
      if(!this.pressedFlag) {
        this.fakeElement.removeClass(this.options.focusClass);
        this.realElement.off('blur', this.onBlur);
        this.focusedFlag = false;
      }
    },
    refresh: function() {
      this.fakeElement.toggleClass(this.options.disabledClass, this.realElement.is(':disabled'));
      this.list.refresh();
    },
    destroy: function() {
      this.list.destroy();
      this.realElement.insertBefore(this.fakeElement).removeClass(this.options.hiddenClass);
      this.fakeElement.remove();
    }
  });

  // options list module
  function SelectList(options) {
    this.options = $.extend({
      holder: null,
      maxVisibleItems: 10,
      selectOnClick: true,
      useHoverClass: false,
      useCustomScroll: false,
      handleResize: true,
      alwaysPreventMouseWheel: false,
      indexAttribute: 'data-index',
      cloneClassPrefix: 'jcf-option-',
      containerStructure: '<span class="jcf-list"><span class="jcf-list-content"></span></span>',
      containerSelector: '.jcf-list-content',
      captionClass: 'jcf-optgroup-caption',
      disabledClass: 'jcf-disabled',
      optionClass: 'jcf-option',
      groupClass: 'jcf-optgroup',
      hoverClass: 'jcf-hover',
      selectedClass: 'jcf-selected',
      scrollClass: 'jcf-scroll-active'
    }, options);
    this.init();
  }
  $.extend(SelectList.prototype, {
    init: function() {
      this.initStructure();
      this.refreshSelectedClass();
      this.attachEvents();
    },
    initStructure: function() {
      this.element = $(this.options.element);
      this.indexSelector = '[' + this.options.indexAttribute + ']';
      this.container = $(this.options.containerStructure).appendTo(this.options.holder);
      this.listHolder = this.container.find(this.options.containerSelector);
      this.lastClickedIndex = this.element.prop('selectedIndex');
      this.rebuildList();
    },
    attachEvents: function() {
      this.bindHandlers();
      this.listHolder.on('jcf-pointerdown', this.indexSelector, this.onItemPress);
      this.listHolder.on('jcf-pointerdown', this.onPress);

      if(this.options.useHoverClass) {
        this.listHolder.on('jcf-pointerover', this.indexSelector, this.onHoverItem);
      }
    },
    onPress: function(e) {
      $(this).trigger('press', e);
      this.listHolder.on('jcf-pointerup', this.onRelease);
    },
    onRelease: function(e) {
      $(this).trigger('release', e);
      this.listHolder.off('jcf-pointerup', this.onRelease);
    },
    onHoverItem: function(e) {
      var hoverIndex = parseFloat(e.currentTarget.getAttribute(this.options.indexAttribute));
      this.fakeOptions.removeClass(this.options.hoverClass).eq(hoverIndex).addClass(this.options.hoverClass);
    },
    onItemPress: function(e) {
      if(e.pointerType === 'touch' || this.options.selectOnClick) {
        // select option after "click"
        this.tmpListOffsetTop = this.list.offset().top;
        this.listHolder.on('jcf-pointerup', this.indexSelector, this.onItemRelease);
      } else {
        // select option immediately
        this.onSelectItem(e);
      }
    },
    onItemRelease: function(e) {
      // remove event handlers and temporary data
      this.listHolder.on('jcf-pointerup', this.indexSelector, this.onItemRelease);

      // simulate item selection
      if(this.tmpListOffsetTop === this.list.offset().top) {
        this.onSelectItem(e);
      }
      delete this.tmpListOffsetTop;
    },
    onSelectItem: function(e) {
      var clickedIndex = parseFloat(e.currentTarget.getAttribute(this.options.indexAttribute)),
        range;

      // ignore clicks on disabled options
      if(e.button > 1 || this.realOptions[clickedIndex].disabled) {
        return;
      }

      if(this.element.prop('multiple')) {
        if(e.metaKey || e.ctrlKey || e.pointerType === 'touch') {
          // if CTRL/CMD pressed or touch devices - toggle selected option
          this.realOptions[clickedIndex].selected = !this.realOptions[clickedIndex].selected;
        } else if(e.shiftKey) {
          // if SHIFT pressed - update selection
          range = [this.lastClickedIndex, clickedIndex].sort(function(a, b){
            return a - b;
          });
          this.realOptions.each(function(index, option) {
            option.selected = (index >= range[0] && index <= range[1]);
          });
        } else {
          // set single selected index
          this.element.prop('selectedIndex', clickedIndex);
        }
      } else {
        this.element.prop('selectedIndex', clickedIndex);
      }

      // save last clicked option
      if(!e.shiftKey) {
        this.lastClickedIndex = clickedIndex;
      }

      // refresh classes
      this.refreshSelectedClass();

      // scroll to active item in desktop browsers
      if(e.pointerType === 'mouse') {
        this.scrollToActiveOption();
      }

      // make callback when item selected
      $(this).trigger('select');
    },
    rebuildList: function() {
      // rebuild options
      var self = this,
        rootElement = this.element[0];

      // recursively create fake options
      this.storedSelectHTML = rootElement.innerHTML;
      this.optionIndex = 0;
      this.list = $(this.createOptionsList(rootElement));
      this.listHolder.empty().append(this.list);
      this.realOptions = this.element.find('option');
      this.fakeOptions = this.list.find(this.indexSelector);
      this.fakeListItems = this.list.find('.' + this.options.captionClass + ',' + this.indexSelector);
      delete this.optionIndex;

      // detect max visible items
      var maxCount = this.options.maxVisibleItems,
        sizeValue = this.element.prop('size');
      if(sizeValue > 1) {
        maxCount = sizeValue;
      }

      // handle scrollbar
      var needScrollBar = this.fakeOptions.length > maxCount;
      this.container.toggleClass(this.options.scrollClass, needScrollBar);
      if(needScrollBar) {
        // change max-height
        this.listHolder.css({
          maxHeight: this.getOverflowHeight(maxCount),
          overflow: 'auto'
        });

        if(this.options.useCustomScroll && jcf.modules.Scrollable) {
          // add custom scrollbar if specified in options
          jcf.replace(this.listHolder, 'Scrollable', {
            handleResize: this.options.handleResize,
            alwaysPreventMouseWheel: this.options.alwaysPreventMouseWheel
          });
          return;
        }
      }

      // disable edge wheel scrolling
      if(this.options.alwaysPreventMouseWheel) {
        this.preventWheelHandler = function(e) {
          var currentScrollTop = self.listHolder.scrollTop(),
            maxScrollTop = self.listHolder.prop('scrollHeight') - self.listHolder.innerHeight(),
            maxScrollLeft = self.listHolder.prop('scrollWidth') - self.listHolder.innerWidth();

          // check edge cases
          if((currentScrollTop <= 0 && e.deltaY < 0) || (currentScrollTop >= maxScrollTop && e.deltaY > 0)) {
            e.preventDefault();
          }
        };
        this.listHolder.on('jcf-mousewheel', this.preventWheelHandler);
      }
    },
    refreshSelectedClass: function() {
      var self = this,
        selectedItem,
        isMultiple = this.element.prop('multiple'),
        selectedIndex = this.element.prop('selectedIndex');

      if(isMultiple) {
        this.realOptions.each(function(index, option) {
          self.fakeOptions.eq(index).toggleClass(self.options.selectedClass, !!option.selected);
        });
      } else {
        this.fakeOptions.removeClass(this.options.selectedClass + ' ' + this.options.hoverClass);
        selectedItem = this.fakeOptions.eq(selectedIndex).addClass(this.options.selectedClass);
        if(this.options.useHoverClass) {
          selectedItem.addClass(this.options.hoverClass);
        }
      }
    },
    scrollToActiveOption: function() {
      // scroll to target option
      var targetOffset = this.getActiveOptionOffset();
      this.listHolder.prop('scrollTop', targetOffset);
    },
    getSelectedIndexRange: function() {
      var firstSelected = -1, lastSelected = -1;
      this.realOptions.each(function(index, option) {
        if(option.selected) {
          if(firstSelected < 0) {
            firstSelected = index;
          }
          lastSelected = index;
        }
      });
      return [firstSelected, lastSelected];
    },
    getChangedSelectedIndex: function() {
      var selectedIndex = this.element.prop('selectedIndex'),
        targetIndex;

      if(this.element.prop('multiple')) {
        // multiple selects handling
        if(!this.previousRange) {
          this.previousRange = [selectedIndex, selectedIndex];
        }
        this.currentRange = this.getSelectedIndexRange();
        targetIndex = this.currentRange[this.currentRange[0] !== this.previousRange[0] ? 0 : 1];
        this.previousRange = this.currentRange;
        return targetIndex;
      } else {
        // single choice selects handling
        return selectedIndex;
      }
    },
    getActiveOptionOffset: function() {
      // calc values
      var dropHeight = this.listHolder.height(),
        dropScrollTop = this.listHolder.prop('scrollTop'),
        currentIndex = this.getChangedSelectedIndex(),
        fakeOption = this.fakeOptions.eq(currentIndex),
        fakeOptionOffset = fakeOption.offset().top - this.list.offset().top,
        fakeOptionHeight = fakeOption.innerHeight();

      // scroll list
      if(fakeOptionOffset + fakeOptionHeight >= dropScrollTop + dropHeight) {
        // scroll down (always scroll to option)
        return fakeOptionOffset - dropHeight + fakeOptionHeight;
      } else if(fakeOptionOffset < dropScrollTop) {
        // scroll up to option
        return fakeOptionOffset;
      }
    },
    getOverflowHeight: function(sizeValue) {
      var item = this.fakeListItems.eq(sizeValue - 1),
        listOffset = this.list.offset().top,
        itemOffset = item.offset().top,
        itemHeight = item.innerHeight();

      return itemOffset + itemHeight - listOffset;
    },
    getScrollTop: function() {
      return this.listHolder.scrollTop();
    },
    setScrollTop: function(value) {
      this.listHolder.scrollTop(value);
    },
    createOption: function(option) {
      var newOption = document.createElement('span');
      newOption.className = this.options.optionClass;
      newOption.innerHTML = option.innerHTML;
      newOption.setAttribute(this.options.indexAttribute, this.optionIndex++);

      var optionImage, optionImageSrc = option.getAttribute('data-image');
      if(optionImageSrc) {
        optionImage = document.createElement('img');
        optionImage.src = optionImageSrc;
        newOption.insertBefore(optionImage, newOption.childNodes[0]);
      }
      if(option.disabled) {
        newOption.className += ' ' + this.options.disabledClass;
      }
      if(option.className) {
        newOption.className += ' ' + getPrefixedClasses(option.className, this.options.cloneClassPrefix);
      }
      return newOption;
    },
    createOptGroup: function(optgroup) {
      var optGroupContainer = document.createElement('span'),
        optGroupName = optgroup.getAttribute('label'),
        optGroupCaption, optGroupList;

      // create caption
      optGroupCaption = document.createElement('span');
      optGroupCaption.className = this.options.captionClass;
      optGroupCaption.innerHTML = optGroupName;
      optGroupContainer.appendChild(optGroupCaption);

      // create list of options
      if(optgroup.children.length) {
        optGroupList = this.createOptionsList(optgroup);
        optGroupContainer.appendChild(optGroupList);
      }

      optGroupContainer.className = this.options.groupClass;
      return optGroupContainer;
    },
    createOptionContainer: function() {
      var optionContainer = document.createElement('li');
      return optionContainer;
    },
    createOptionsList: function(container) {
      var self = this,
        list = document.createElement('ul');

      $.each(container.children, function(index, currentNode) {
        var item = self.createOptionContainer(currentNode),
          newNode;

        switch(currentNode.tagName.toLowerCase()) {
          case 'option': newNode = self.createOption(currentNode); break;
          case 'optgroup': newNode = self.createOptGroup(currentNode); break;
        }
        list.appendChild(item).appendChild(newNode);
      });
      return list;
    },
    refresh: function() {
      // check for select innerHTML changes
      if(this.storedSelectHTML !== this.element.prop('innerHTML')) {
        this.rebuildList();
      }

      // refresh custom scrollbar
      var scrollInstance = jcf.getInstance(this.listHolder);
      if(scrollInstance) {
        scrollInstance.refresh();
      }

      // scroll active option into view
      this.scrollToActiveOption();

      // refresh selectes classes
      this.refreshSelectedClass();
    },
    destroy: function() {
      this.listHolder.off('jcf-mousewheel', this.preventWheelHandler);
      this.listHolder.off('jcf-pointerdown', this.indexSelector, this.onSelectItem);
      this.listHolder.off('jcf-pointerover', this.indexSelector, this.onHoverItem);
      this.listHolder.off('jcf-pointerdown', this.onPress);
    }
  });

  // helper functions
  var getPrefixedClasses = function(className, prefixToAdd) {
    return className ? className.replace(/[\s]*([\S]+)+[\s]*/gi, prefixToAdd + '$1 ') : '';
  };
  var makeUnselectable = (function() {
    var unselectableClass = jcf.getOptions().unselectableClass;
    function preventHandler(e) {
      e.preventDefault();
    }
    return function(node) {
      node.addClass(unselectableClass).on('selectstart', preventHandler);
    };
  }());

}(jQuery, this));

// initialize custom form elements
function initCustomForms() {
  jcf.setOptions('Select', {
    wrapNative: false,
    wrapNativeOnMobile: false
  });
  jcf.replaceAll();
}

/*!
 * JCF - JavaScript Custom Forms - Core
 */
;(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
    define(['jquery'], factory);
  } else if (typeof exports === 'object') {
    module.exports = factory(require('jquery'));
  } else {
    root.jcf = factory(jQuery);
  }
}(this, function ($) {
  'use strict';

  // private variables
  var customInstances = [];

  // default global options
  var commonOptions = {
    optionsKey: 'jcf',
    dataKey: 'jcf-instance',
    rtlClass: 'jcf-rtl',
    focusClass: 'jcf-focus',
    pressedClass: 'jcf-pressed',
    disabledClass: 'jcf-disabled',
    hiddenClass: 'jcf-hidden',
    resetAppearanceClass: 'jcf-reset-appearance',
    unselectableClass: 'jcf-unselectable'
  };

  // detect device type
  var isTouchDevice = ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch,
    isWinPhoneDevice = navigator.msPointerEnabled && /MSIE 10.*Touch/.test(navigator.userAgent);
  commonOptions.isMobileDevice = !!(isTouchDevice || isWinPhoneDevice);

  // create global stylesheet if custom forms are used
  var createStyleSheet = function() {
    var styleTag = $('<style>').appendTo('head'),
      styleSheet = styleTag.prop('sheet') || styleTag.prop('styleSheet');

    // crossbrowser style handling
    var addCSSRule = function(selector, rules, index) {
      if(styleSheet.insertRule) {
        styleSheet.insertRule(selector + '{' + rules + '}', index);
      } else {
        styleSheet.addRule(selector, rules, index);
      }
    };

    // add special rules
    addCSSRule('.' + commonOptions.hiddenClass, 'position:absolute !important;left:-9999px !important;display:block !important');
    addCSSRule('.' + commonOptions.rtlClass + '.' + commonOptions.hiddenClass, 'right:-9999px !important; left: auto !important');
    addCSSRule('.' + commonOptions.unselectableClass, '-webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none;');
    addCSSRule('.' + commonOptions.resetAppearanceClass, 'background: none; border: none; -webkit-appearance: none; appearance: none; opacity: 0; filter: alpha(opacity=0);');

    // detect rtl pages
    var html = $('html'), body = $('body');
    if(html.css('direction') === 'rtl' || body.css('direction') === 'rtl') {
      html.addClass(commonOptions.rtlClass);
    }

    // mark stylesheet as created
    commonOptions.styleSheetCreated = true;
  };

  // simplified pointer events handler
  (function() {
    var pointerEventsSupported = navigator.pointerEnabled || navigator.msPointerEnabled,
      touchEventsSupported = ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch,
      eventList, eventMap = {}, eventPrefix = 'jcf-';

    // detect events to attach
    if(pointerEventsSupported) {
      eventList = {
        pointerover: navigator.pointerEnabled ? 'pointerover' : 'MSPointerOver',
        pointerdown: navigator.pointerEnabled ? 'pointerdown' : 'MSPointerDown',
        pointermove: navigator.pointerEnabled ? 'pointermove' : 'MSPointerMove',
        pointerup: navigator.pointerEnabled ? 'pointerup' : 'MSPointerUp'
      };
    } else {
      eventList = {
        pointerover: 'mouseover',
        pointerdown: 'mousedown' + (touchEventsSupported ? ' touchstart' : ''),
        pointermove: 'mousemove' + (touchEventsSupported ? ' touchmove' : ''),
        pointerup: 'mouseup' + (touchEventsSupported ? ' touchend' : '')
      };
    }

    // create event map
    $.each(eventList, function(targetEventName, fakeEventList) {
      $.each(fakeEventList.split(' '), function(index, fakeEventName) {
        eventMap[fakeEventName] = targetEventName;
      });
    });

    // jQuery event hooks
    $.each(eventList, function(eventName, eventHandlers) {
      eventHandlers = eventHandlers.split(' ');
      $.event.special[eventPrefix + eventName] = {
        setup: function() {
          var self = this;
          $.each(eventHandlers, function(index, fallbackEvent) {
            if(self.addEventListener) self.addEventListener(fallbackEvent, fixEvent, false);
            else self['on' + fallbackEvent] = fixEvent;
          });
        },
        teardown: function() {
          var self = this;
          $.each(eventHandlers, function(index, fallbackEvent) {
            if(self.addEventListener) self.removeEventListener(fallbackEvent, fixEvent, false);
            else self['on' + fallbackEvent] = null;
          });
        }
      };
    });

    // check that mouse event are not simulated by mobile browsers
    var lastTouch = null;
    var mouseEventSimulated = function(e) {
      var dx = Math.abs(e.clientX - lastTouch.x),
        dy = Math.abs(e.clientY - lastTouch.y),
        rangeDistance = 25;

      if (dx <= rangeDistance && dy <= rangeDistance) {
        return true;
      }
    };

    // normalize event
    var fixEvent = function(e) {
      var origEvent = e || window.event,
        targetEventName = eventMap[origEvent.type];

      e = $.event.fix(origEvent);
      e.type = eventPrefix + targetEventName;

      if(origEvent.pointerType) {
        switch(origEvent.pointerType) {
          case 2: e.pointerType = 'touch'; break;
          case 3: e.pointerType = 'pen'; break;
          case 4: e.pointerType = 'mouse'; break;
          default: e.pointerType = origEvent.pointerType;
        }
      } else {
        e.pointerType = origEvent.type.substr(0,5); // "mouse" or "touch" word length
      }
      if(!e.pageX || !e.pageY) {
        e.pageX = (origEvent.changedTouches ? origEvent.changedTouches[0] : origEvent).pageX;
        e.pageY = (origEvent.changedTouches ? origEvent.changedTouches[0] : origEvent).pageY;
      }

      if(origEvent.type === 'touchend' && origEvent.changedTouches[0]) {
        lastTouch = {x: origEvent.changedTouches[0].clientX, y: origEvent.changedTouches[0].clientY};
      }
      if(e.pointerType === 'mouse' && lastTouch && mouseEventSimulated(e)) {
        return;
      } else {
        return ($.event.dispatch || $.event.handle).call(this, e);
      }
    };
  }());

  // custom mousewheel/trackpad handler
  (function() {
    var wheelEvents = ('onwheel' in document || document.documentMode >= 9 ? 'wheel' : 'mousewheel DOMMouseScroll').split(' '),
      shimEventName = 'jcf-mousewheel';

    $.event.special[shimEventName] = {
      setup: function() {
        var self = this;
        $.each(wheelEvents, function(index, fallbackEvent) {
          if(self.addEventListener) self.addEventListener(fallbackEvent, fixEvent, false);
          else self['on' + fallbackEvent] = fixEvent;
        });
      },
      teardown: function() {
        var self = this;
        $.each(wheelEvents, function(index, fallbackEvent) {
          if(self.addEventListener) self.removeEventListener(fallbackEvent, fixEvent, false);
          else self['on' + fallbackEvent] = null;
        });
      }
    };

    var fixEvent = function(e) {
      var origEvent = e || window.event;
      e = $.event.fix(origEvent);
      e.type = shimEventName;

      // old wheel events handler
      if('detail'      in origEvent) { e.deltaY = -origEvent.detail;      }
      if('wheelDelta'  in origEvent) { e.deltaY = -origEvent.wheelDelta;  }
      if('wheelDeltaY' in origEvent) { e.deltaY = -origEvent.wheelDeltaY; }
      if('wheelDeltaX' in origEvent) { e.deltaX = -origEvent.wheelDeltaX; }

      // modern wheel event handler
      if('deltaY' in origEvent) {
        e.deltaY = origEvent.deltaY;
      }
      if('deltaX' in origEvent) {
        e.deltaX = origEvent.deltaX;
      }
      e.delta = e.deltaY || e.deltaX;
      return ($.event.dispatch || $.event.handle).call(this, e);
    };
  }());

  // public API
  return {
    modules: {},
    getOptions: function() {
      return $.extend({}, commonOptions);
    },
    setOptions: function(moduleName, moduleOptions) {
      if(arguments.length > 1) {
        // set module options
        if(this.modules[moduleName]) {
          $.extend(this.modules[moduleName].prototype.options, moduleOptions);
        }
      } else {
        // set common options
        $.extend(commonOptions, moduleName);
      }
    },
    addModule: function(proto) {
      // add module to list
      var Module = function(options) {
        // save instance to collection
        options.element.data(commonOptions.dataKey, this);
        customInstances.push(this);

        // save options
        this.options = $.extend({}, commonOptions, this.options, options.element.data(commonOptions.optionsKey), options);

        // bind event handlers to instance
        this.bindHandlers();

        // call constructor
        this.init.apply(this, arguments);
      };

      // set proto as prototype for new module
      Module.prototype = proto;

      // bind event handlers for module and its plugins (functions beggining with on)
      Module.prototype.bindHandlers = function() {
        var self = this;
        $.each(self, function(propName, propValue) {
          if(propName.indexOf('on') === 0 && $.isFunction(propValue)) {
            // dont use $.proxy here because it doesn't create unique handler
            self[propName] = function() {
              return propValue.apply(self, arguments);
            };
          }
        });
      };
      if(proto.plugins) {
        $.each(proto.plugins, function(pluginName, plugin) {
          plugin.prototype.bindHandlers = Module.prototype.bindHandlers;
        });
      }

      // override destroy method
      var originalDestroy = Module.prototype.destroy;
      Module.prototype.destroy = function() {
        this.options.element.removeData(this.options.dataKey);

        for(var i = customInstances.length - 1; i >= 0; i--) {
          if(customInstances[i] === this) {
            customInstances.splice(i, 1);
            break;
          }
        }

        if(originalDestroy) {
          originalDestroy.apply(this, arguments);
        }
      };

      // save module to list
      this.modules[proto.name] = Module;
    },
    getInstance: function(element) {
      return $(element).data(commonOptions.dataKey);
    },
    replace: function(elements, moduleName, customOptions) {
      var self = this,
        instance;

      if(!commonOptions.styleSheetCreated) {
        createStyleSheet();
      }

      $(elements).each(function() {
        var moduleOptions,
          element = $(this);

        instance = element.data(commonOptions.dataKey);
        if(instance) {
          instance.refresh();
        } else {
          if(!moduleName) {
            $.each(self.modules, function(currentModuleName, module) {
              if(module.prototype.matchElement.call(module.prototype, element)) {
                moduleName = currentModuleName;
                return false;
              }
            });
          }
          if(moduleName) {
            moduleOptions = $.extend({element:element}, customOptions);
            instance = new self.modules[moduleName](moduleOptions);
          }
        }
      });
      return instance;
    },
    refresh: function(elements) {
      $(elements).each(function() {
        var instance = $(this).data(commonOptions.dataKey);
        if(instance) {
          instance.refresh();
        }
      });
    },
    destroy: function(elements) {
      $(elements).each(function() {
        var instance = $(this).data(commonOptions.dataKey);
        if(instance) {
          instance.destroy();
        }
      });
    },
    replaceAll: function(context) {
      var self = this;
      $.each(this.modules, function(moduleName, module) {
        $(module.prototype.selector, context).each(function() {
          self.replace(this, moduleName);
        });
      });
    },
    refreshAll: function(context) {
      if(context) {
        $.each(this.modules, function(moduleName, module) {
          $(module.prototype.selector, context).each(function() {
            var instance = $(this).data(commonOptions.dataKey);
            if(instance) {
              instance.refresh();
            }
          });
        });
      } else {
        for(var i = customInstances.length - 1; i >= 0; i--) {
          customInstances[i].refresh();
        }
      }
    },
    destroyAll: function(context) {
      var self = this;
      if(context) {
        $.each(this.modules, function(moduleName, module) {
          $(module.prototype.selector, context).each(function(index, element) {
            var instance = $(element).data(commonOptions.dataKey);
            if(instance) {
              instance.destroy();
            }
          });
        });
      } else {
        while(customInstances.length) {
          customInstances[0].destroy();
        }
      }
    }
  };
}));

/*!
 * JCF - JavaScript Custom Forms - Select Module
 */
;(function($, window) {
  'use strict';

  jcf.addModule({
    name: 'Select',
    selector: 'select',
    options: {
      element: null
    },
    plugins: {
      ListBox: ListBox,
      ComboBox: ComboBox,
      SelectList: SelectList
    },
    matchElement: function(element) {
      return element.is('select');
    },
    init: function() {
      this.element = $(this.options.element);
      this.createInstance();
    },
    isListBox: function() {
      return this.element.is('[size]:not([jcf-size]), [multiple]');
    },
    createInstance: function() {
      if(this.instance) {
        this.instance.destroy();
      }
      if(this.isListBox()) {
        this.instance = new ListBox(this.options);
      } else {
        this.instance = new ComboBox(this.options);
      }
    },
    refresh: function() {
      var typeMismatch = (this.isListBox() && this.instance instanceof ComboBox) ||
                (!this.isListBox() && this.instance instanceof ListBox);

      if(typeMismatch) {
        this.createInstance();
      } else {
        this.instance.refresh();
      }
    },
    destroy: function() {
      this.instance.destroy();
    }
  });

  // combobox module
  function ComboBox(options) {
    this.options = $.extend({
      wrapNative: true,
      wrapNativeOnMobile: true,
      fakeDropInBody: true,
      useCustomScroll: true,
      flipDropToFit: true,
      maxVisibleItems: 10,
      fakeAreaStructure: '<span class="jcf-select"><span class="jcf-select-text"></span><span class="jcf-select-opener"></span></span>',
      fakeDropStructure: '<div class="jcf-select-drop"><div class="jcf-select-drop-content"></div></div>',
      optionClassPrefix: 'jcf-option-',
      selectClassPrefix: 'jcf-select-',
      dropContentSelector: '.jcf-select-drop-content',
      selectTextSelector: '.jcf-select-text',
      dropActiveClass: 'jcf-drop-active',
      flipDropClass: 'jcf-drop-flipped'
    }, options);
    this.init();
  }
  $.extend(ComboBox.prototype, {
    init: function(options) {
      this.initStructure();
      this.bindHandlers();
      this.attachEvents();
      this.refresh();
    },
    initStructure: function() {
      // prepare structure
      this.win = $(window);
      this.doc = $(document);
      this.realElement = $(this.options.element);
      this.fakeElement = $(this.options.fakeAreaStructure).insertAfter(this.realElement);
      this.selectTextContainer = this.fakeElement.find(this.options.selectTextSelector);
      this.selectText = $('<span></span>').appendTo(this.selectTextContainer);
      makeUnselectable(this.fakeElement);

      // copy classes from original select
      this.fakeElement.addClass(getPrefixedClasses(this.realElement.prop('className'), this.options.selectClassPrefix));

      // detect device type and dropdown behavior
      if(this.options.isMobileDevice && this.options.wrapNativeOnMobile && !this.options.wrapNative) {
        this.options.wrapNative = true;
      }

      if(this.options.wrapNative) {
        // wrap native select inside fake block
        this.realElement.prependTo(this.fakeElement).css({
          position: 'absolute',
          height: '100%',
          width: '100%'
        }).addClass(this.options.resetAppearanceClass);
      } else {
        // just hide native select
        this.realElement.addClass(this.options.hiddenClass);
        this.fakeDropTarget = this.options.fakeDropInBody ? $('body') : this.fakeElement;
      }
    },
    attachEvents: function() {
      // delayed refresh handler
      var self = this;
      this.delayedRefresh = function() {
        setTimeout(function() {
          self.refresh();
          if(self.list) {
            self.list.refresh();
          }
        }, 1);
      };

      // native dropdown event handlers
      if(this.options.wrapNative) {
        this.realElement.on({
          focus: this.onFocus,
          change: this.onChange,
          click: this.onChange,
          keydown: this.onChange
        });
      } else {
        // custom dropdown event handlers
        this.realElement.on({
          focus: this.onFocus,
          change: this.onChange,
          keydown: this.onKeyDown
        });
        this.fakeElement.on({
          'jcf-pointerdown': this.onSelectAreaPress
        });
      }
    },
    onKeyDown: function(e) {
      if(e.which === 13) {
        this.toggleDropdown();
      } else {
        this.delayedRefresh();
      }
    },
    onChange: function() {
      this.refresh();
    },
    onFocus: function() {
      if(!this.pressedFlag || !this.focusedFlag) {
        this.fakeElement.addClass(this.options.focusClass);
        this.realElement.on('blur', this.onBlur);
        this.toggleListMode(true);
        this.focusedFlag = true;
      }
    },
    onBlur: function() {
      if(!this.pressedFlag) {
        this.fakeElement.removeClass(this.options.focusClass);
        this.realElement.off('blur', this.onBlur);
        this.toggleListMode(false);
        this.focusedFlag = false;
      }
    },
    onResize: function() {
      if(this.dropActive) {
        this.hideDropdown();
      }
    },
    onSelectDropPress: function() {
      this.pressedFlag = true;
    },
    onSelectDropRelease: function(e, pointerEvent) {
      this.pressedFlag = false;
      if(pointerEvent.pointerType === 'mouse') {
        this.realElement.focus();
      }
    },
    onSelectAreaPress: function(e) {
      // skip click if drop inside fake element or real select is disabled
      var dropClickedInsideFakeElement = !this.options.fakeDropInBody && $(e.target).closest(this.dropdown).length;
      if(dropClickedInsideFakeElement || e.button > 1 || this.realElement.is(':disabled')) {
        return;
      }

      // toggle dropdown visibility
      this.toggleDropdown();

      // misc handlers
      if(!this.focusedFlag) {
        if(e.pointerType === 'mouse') {
          this.realElement.focus();
        } else {
          this.onFocus(e);
        }
      }
      this.pressedFlag = true;
      this.fakeElement.addClass(this.options.pressedClass);
      this.doc.on('jcf-pointerup', this.onSelectAreaRelease);
    },
    onSelectAreaRelease: function(e) {
      if(this.focusedFlag && e.pointerType === 'mouse') {
        this.realElement.focus();
      }
      this.pressedFlag = false;
      this.fakeElement.removeClass(this.options.pressedClass);
      this.doc.off('jcf-pointerup', this.onSelectAreaRelease);
    },
    onOutsideClick: function(e) {
      var target = $(e.target),
        clickedInsideSelect = target.closest(this.fakeElement).length || target.closest(this.dropdown).length;

      if(!clickedInsideSelect) {
        this.hideDropdown();
      }
    },
    onSelect: function() {
      this.hideDropdown();
      this.refresh();
      this.realElement.trigger('change');
    },
    toggleListMode: function(state) {
      if(!this.options.wrapNative) {
        if(state) {
          // temporary change select to list to avoid appearing of native dropdown
          this.realElement.attr({
            size: 4,
            'jcf-size': ''
          });
        } else {
          // restore select from list mode to dropdown select
          if(!this.options.wrapNative) {
            this.realElement.removeAttr('size jcf-size');
          }
        }
      }
    },
    createDropdown: function() {
      // destroy previous dropdown if needed
      if(this.dropdown) {
        this.list.destroy();
        this.dropdown.remove();
      }

      // create new drop container
      this.dropdown = $(this.options.fakeDropStructure).appendTo(this.fakeDropTarget);
      this.dropdown.addClass(getPrefixedClasses(this.realElement.prop('className'), this.options.selectClassPrefix));
      makeUnselectable(this.dropdown);

      // set initial styles for dropdown in body
      if(this.options.fakeDropInBody) {
        this.dropdown.css({
          position: 'absolute',
          top: -9999
        });
      }

      // create new select list instance
      this.list = new SelectList({
        useHoverClass: true,
        handleResize: false,
        alwaysPreventMouseWheel: true,
        maxVisibleItems: this.options.maxVisibleItems,
        useCustomScroll: this.options.useCustomScroll,
        holder: this.dropdown.find(this.options.dropContentSelector),
        element: this.realElement
      });
      $(this.list).on({
        select: this.onSelect,
        press: this.onSelectDropPress,
        release: this.onSelectDropRelease
      });
    },
    repositionDropdown: function() {
      var selectOffset = this.fakeElement.offset(),
        selectWidth = this.fakeElement.outerWidth(),
        selectHeight = this.fakeElement.outerHeight(),
        dropHeight = this.dropdown.outerHeight(),
        winScrollTop = this.win.scrollTop(),
        winHeight = this.win.height(),
        calcTop, calcLeft, bodyOffset, needFlipDrop = false;

      // check flip drop position
      if(selectOffset.top + selectHeight + dropHeight > winScrollTop + winHeight && selectOffset.top - dropHeight > winScrollTop) {
        needFlipDrop = true;
      }

      if(this.options.fakeDropInBody) {
        bodyOffset = this.fakeDropTarget.css('position') !== 'static' ? this.fakeDropTarget.offset().top : 0;
        if(this.options.flipDropToFit && needFlipDrop) {
          // calculate flipped dropdown position
          calcLeft = selectOffset.left;
          calcTop = selectOffset.top - dropHeight - bodyOffset;
        } else {
          // calculate default drop position
          calcLeft = selectOffset.left;
          calcTop = selectOffset.top + selectHeight - bodyOffset;
        }

        // update drop styles
        this.dropdown.css({
          width: selectWidth,
          left: calcLeft,
          top: calcTop
        });
      }

      // refresh flipped class
      this.dropdown.add(this.fakeElement).toggleClass(this.options.flipDropClass, this.options.flipDropToFit && needFlipDrop);
    },
    showDropdown: function() {
      // create options list if not created
      if(!this.dropdown) {
        this.createDropdown();
      }

      // show dropdown
      this.dropActive = true;
      this.dropdown.appendTo(this.fakeDropTarget);
      this.fakeElement.addClass(this.options.dropActiveClass);
      this.refreshSelectedText();
      this.repositionDropdown();
      this.list.setScrollTop(this.savedScrollTop);
      this.list.refresh();

      // add temporary event handlers
      this.win.on('resize', this.onResize);
      this.doc.on('jcf-pointerdown', this.onOutsideClick);
    },
    hideDropdown: function() {
      if(this.dropdown) {
        this.savedScrollTop = this.list.getScrollTop();
        this.fakeElement.removeClass(this.options.dropActiveClass + ' ' + this.options.flipDropClass);
        this.dropdown.removeClass(this.options.flipDropClass).detach();
        this.doc.off('jcf-pointerdown', this.onOutsideClick);
        this.win.off('resize', this.onResize);
        this.dropActive = false;
      }
    },
    toggleDropdown: function() {
      if(this.dropActive) {
        this.hideDropdown();
      } else {
        this.showDropdown();
      }
    },
    refreshSelectedText: function() {
      // redraw selected area
      var selectedIndex = this.realElement.prop('selectedIndex'),
        selectedOption = this.realElement.prop('options')[selectedIndex],
        selectedOptionImage = selectedOption.getAttribute('data-image'),
        selectedOptionClasses,
        selectedFakeElement;

      if(this.currentSelectedText !== selectedOption.innerHTML || this.currentSelectedImage !== selectedOptionImage) {
        selectedOptionClasses = getPrefixedClasses(selectedOption.className, this.options.optionClassPrefix);
        this.selectText.attr('class', selectedOptionClasses).html(selectedOption.innerHTML);

        if(selectedOptionImage) {
          if(!this.selectImage) {
            this.selectImage = $('<img>').prependTo(this.selectTextContainer).hide();
          }
          this.selectImage.attr('src', selectedOptionImage).show();
        } else if(this.selectImage) {
          this.selectImage.hide();
        }

        this.currentSelectedText = selectedOption.innerHTML;
        this.currentSelectedImage = selectedOptionImage;
      }
    },
    refresh: function() {
      // refresh selected text
      this.refreshSelectedText();

      // handle disabled state
      this.fakeElement.toggleClass(this.options.disabledClass, this.realElement.is(':disabled'));
    },
    destroy: function() {
      // restore structure
      if(this.options.wrapNative) {
        this.realElement.insertBefore(this.fakeElement).css({
          position: '',
          height: '',
          width: ''
        }).removeClass(this.options.resetAppearanceClass);
      } else {
        this.realElement.removeClass(this.options.hiddenClass);
        if(this.realElement.is('[jcf-size]')) {
          this.realElement.removeAttr('size jcf-size');
        }
      }

      // removing element will also remove its event handlers
      this.fakeElement.remove();

      // remove other event handlers
      this.doc.off('jcf-pointerup', this.onSelectAreaRelease);
      this.realElement.off({
        focus: this.onFocus
      });
    }
  });

  // listbox module
  function ListBox(options) {
    this.options = $.extend({
      wrapNative: true,
      useCustomScroll: true,
      fakeStructure: '<span class="jcf-list-box"><span class="jcf-list-wrapper"></span></span>',
      selectClassPrefix: 'jcf-select-',
      listHolder: '.jcf-list-wrapper'
    }, options);
    this.init();
  }
  $.extend(ListBox.prototype, {
    init: function(options) {
      this.bindHandlers();
      this.initStructure();
      this.attachEvents();
    },
    initStructure: function() {
      var self = this;
      this.realElement = $(this.options.element);
      this.fakeElement = $(this.options.fakeStructure).insertAfter(this.realElement);
      this.listHolder = this.fakeElement.find(this.options.listHolder);
      makeUnselectable(this.fakeElement);

      // copy classes from original select
      this.fakeElement.addClass(getPrefixedClasses(this.realElement.prop('className'), this.options.selectClassPrefix));
      this.realElement.addClass(this.options.hiddenClass);

      this.list = new SelectList({
        useCustomScroll: this.options.useCustomScroll,
        holder: this.listHolder,
        selectOnClick: false,
        element: this.realElement
      });
    },
    attachEvents: function() {
      // delayed refresh handler
      var self = this;
      this.delayedRefresh = function() {
        clearTimeout(self.refreshTimer);
        self.refreshTimer = setTimeout(function() {
          self.refresh();
        }, 1);
      };

      // other event handlers
      this.realElement.on({
        focus: this.onFocus,
        click: this.delayedRefresh,
        keydown: this.delayedRefresh
      });

      // select list event handlers
      $(this.list).on({
        select: this.onSelect,
        press: this.onFakeOptionsPress,
        release: this.onFakeOptionsRelease
      });
    },
    onFakeOptionsPress: function(e, pointerEvent) {
      this.pressedFlag = true;
      if(pointerEvent.pointerType === 'mouse') {
        this.realElement.focus();
      }
    },
    onFakeOptionsRelease: function(e, pointerEvent) {
      this.pressedFlag = false;
      if(pointerEvent.pointerType === 'mouse') {
        this.realElement.focus();
      }
    },
    onSelect: function() {
      this.realElement.trigger('change');
    },
    onFocus: function() {
      if(!this.pressedFlag || !this.focusedFlag) {
        this.fakeElement.addClass(this.options.focusClass);
        this.realElement.on('blur', this.onBlur);
        this.focusedFlag = true;
      }
    },
    onBlur: function() {
      if(!this.pressedFlag) {
        this.fakeElement.removeClass(this.options.focusClass);
        this.realElement.off('blur', this.onBlur);
        this.focusedFlag = false;
      }
    },
    refresh: function() {
      this.fakeElement.toggleClass(this.options.disabledClass, this.realElement.is(':disabled'));
      this.list.refresh();
    },
    destroy: function() {
      this.list.destroy();
      this.realElement.insertBefore(this.fakeElement).removeClass(this.options.hiddenClass);
      this.fakeElement.remove();
    }
  });

  // options list module
  function SelectList(options) {
    this.options = $.extend({
      holder: null,
      maxVisibleItems: 10,
      selectOnClick: true,
      useHoverClass: false,
      useCustomScroll: false,
      handleResize: true,
      alwaysPreventMouseWheel: false,
      indexAttribute: 'data-index',
      cloneClassPrefix: 'jcf-option-',
      containerStructure: '<span class="jcf-list"><span class="jcf-list-content"></span></span>',
      containerSelector: '.jcf-list-content',
      captionClass: 'jcf-optgroup-caption',
      disabledClass: 'jcf-disabled',
      optionClass: 'jcf-option',
      groupClass: 'jcf-optgroup',
      hoverClass: 'jcf-hover',
      selectedClass: 'jcf-selected',
      scrollClass: 'jcf-scroll-active'
    }, options);
    this.init();
  }
  $.extend(SelectList.prototype, {
    init: function() {
      this.initStructure();
      this.refreshSelectedClass();
      this.attachEvents();
    },
    initStructure: function() {
      this.element = $(this.options.element);
      this.indexSelector = '[' + this.options.indexAttribute + ']';
      this.container = $(this.options.containerStructure).appendTo(this.options.holder);
      this.listHolder = this.container.find(this.options.containerSelector);
      this.lastClickedIndex = this.element.prop('selectedIndex');
      this.rebuildList();
    },
    attachEvents: function() {
      this.bindHandlers();
      this.listHolder.on('jcf-pointerdown', this.indexSelector, this.onItemPress);
      this.listHolder.on('jcf-pointerdown', this.onPress);

      if(this.options.useHoverClass) {
        this.listHolder.on('jcf-pointerover', this.indexSelector, this.onHoverItem);
      }
    },
    onPress: function(e) {
      $(this).trigger('press', e);
      this.listHolder.on('jcf-pointerup', this.onRelease);
    },
    onRelease: function(e) {
      $(this).trigger('release', e);
      this.listHolder.off('jcf-pointerup', this.onRelease);
    },
    onHoverItem: function(e) {
      var hoverIndex = parseFloat(e.currentTarget.getAttribute(this.options.indexAttribute));
      this.fakeOptions.removeClass(this.options.hoverClass).eq(hoverIndex).addClass(this.options.hoverClass);
    },
    onItemPress: function(e) {
      if(e.pointerType === 'touch' || this.options.selectOnClick) {
        // select option after "click"
        this.tmpListOffsetTop = this.list.offset().top;
        this.listHolder.on('jcf-pointerup', this.indexSelector, this.onItemRelease);
      } else {
        // select option immediately
        this.onSelectItem(e);
      }
    },
    onItemRelease: function(e) {
      // remove event handlers and temporary data
      this.listHolder.on('jcf-pointerup', this.indexSelector, this.onItemRelease);

      // simulate item selection
      if(this.tmpListOffsetTop === this.list.offset().top) {
        this.onSelectItem(e);
      }
      delete this.tmpListOffsetTop;
    },
    onSelectItem: function(e) {
      var clickedIndex = parseFloat(e.currentTarget.getAttribute(this.options.indexAttribute)),
        range;

      // ignore clicks on disabled options
      if(e.button > 1 || this.realOptions[clickedIndex].disabled) {
        return;
      }

      if(this.element.prop('multiple')) {
        if(e.metaKey || e.ctrlKey || e.pointerType === 'touch') {
          // if CTRL/CMD pressed or touch devices - toggle selected option
          this.realOptions[clickedIndex].selected = !this.realOptions[clickedIndex].selected;
        } else if(e.shiftKey) {
          // if SHIFT pressed - update selection
          range = [this.lastClickedIndex, clickedIndex].sort(function(a, b){
            return a - b;
          });
          this.realOptions.each(function(index, option) {
            option.selected = (index >= range[0] && index <= range[1]);
          });
        } else {
          // set single selected index
          this.element.prop('selectedIndex', clickedIndex);
        }
      } else {
        this.element.prop('selectedIndex', clickedIndex);
      }

      // save last clicked option
      if(!e.shiftKey) {
        this.lastClickedIndex = clickedIndex;
      }

      // refresh classes
      this.refreshSelectedClass();

      // scroll to active item in desktop browsers
      if(e.pointerType === 'mouse') {
        this.scrollToActiveOption();
      }

      // make callback when item selected
      $(this).trigger('select');
    },
    rebuildList: function() {
      // rebuild options
      var self = this,
        rootElement = this.element[0];

      // recursively create fake options
      this.storedSelectHTML = rootElement.innerHTML;
      this.optionIndex = 0;
      this.list = $(this.createOptionsList(rootElement));
      this.listHolder.empty().append(this.list);
      this.realOptions = this.element.find('option');
      this.fakeOptions = this.list.find(this.indexSelector);
      this.fakeListItems = this.list.find('.' + this.options.captionClass + ',' + this.indexSelector);
      delete this.optionIndex;

      // detect max visible items
      var maxCount = this.options.maxVisibleItems,
        sizeValue = this.element.prop('size');
      if(sizeValue > 1) {
        maxCount = sizeValue;
      }

      // handle scrollbar
      var needScrollBar = this.fakeOptions.length > maxCount;
      this.container.toggleClass(this.options.scrollClass, needScrollBar);
      if(needScrollBar) {
        // change max-height
        this.listHolder.css({
          maxHeight: this.getOverflowHeight(maxCount),
          overflow: 'auto'
        });

        if(this.options.useCustomScroll && jcf.modules.Scrollable) {
          // add custom scrollbar if specified in options
          jcf.replace(this.listHolder, 'Scrollable', {
            handleResize: this.options.handleResize,
            alwaysPreventMouseWheel: this.options.alwaysPreventMouseWheel
          });
          return;
        }
      }

      // disable edge wheel scrolling
      if(this.options.alwaysPreventMouseWheel) {
        this.preventWheelHandler = function(e) {
          var currentScrollTop = self.listHolder.scrollTop(),
            maxScrollTop = self.listHolder.prop('scrollHeight') - self.listHolder.innerHeight(),
            maxScrollLeft = self.listHolder.prop('scrollWidth') - self.listHolder.innerWidth();

          // check edge cases
          if((currentScrollTop <= 0 && e.deltaY < 0) || (currentScrollTop >= maxScrollTop && e.deltaY > 0)) {
            e.preventDefault();
          }
        };
        this.listHolder.on('jcf-mousewheel', this.preventWheelHandler);
      }
    },
    refreshSelectedClass: function() {
      var self = this,
        selectedItem,
        isMultiple = this.element.prop('multiple'),
        selectedIndex = this.element.prop('selectedIndex');

      if(isMultiple) {
        this.realOptions.each(function(index, option) {
          self.fakeOptions.eq(index).toggleClass(self.options.selectedClass, !!option.selected);
        });
      } else {
        this.fakeOptions.removeClass(this.options.selectedClass + ' ' + this.options.hoverClass);
        selectedItem = this.fakeOptions.eq(selectedIndex).addClass(this.options.selectedClass);
        if(this.options.useHoverClass) {
          selectedItem.addClass(this.options.hoverClass);
        }
      }
    },
    scrollToActiveOption: function() {
      // scroll to target option
      var targetOffset = this.getActiveOptionOffset();
      this.listHolder.prop('scrollTop', targetOffset);
    },
    getSelectedIndexRange: function() {
      var firstSelected = -1, lastSelected = -1;
      this.realOptions.each(function(index, option) {
        if(option.selected) {
          if(firstSelected < 0) {
            firstSelected = index;
          }
          lastSelected = index;
        }
      });
      return [firstSelected, lastSelected];
    },
    getChangedSelectedIndex: function() {
      var selectedIndex = this.element.prop('selectedIndex'),
        targetIndex;

      if(this.element.prop('multiple')) {
        // multiple selects handling
        if(!this.previousRange) {
          this.previousRange = [selectedIndex, selectedIndex];
        }
        this.currentRange = this.getSelectedIndexRange();
        targetIndex = this.currentRange[this.currentRange[0] !== this.previousRange[0] ? 0 : 1];
        this.previousRange = this.currentRange;
        return targetIndex;
      } else {
        // single choice selects handling
        return selectedIndex;
      }
    },
    getActiveOptionOffset: function() {
      // calc values
      var dropHeight = this.listHolder.height(),
        dropScrollTop = this.listHolder.prop('scrollTop'),
        currentIndex = this.getChangedSelectedIndex(),
        fakeOption = this.fakeOptions.eq(currentIndex),
        fakeOptionOffset = fakeOption.offset().top - this.list.offset().top,
        fakeOptionHeight = fakeOption.innerHeight();

      // scroll list
      if(fakeOptionOffset + fakeOptionHeight >= dropScrollTop + dropHeight) {
        // scroll down (always scroll to option)
        return fakeOptionOffset - dropHeight + fakeOptionHeight;
      } else if(fakeOptionOffset < dropScrollTop) {
        // scroll up to option
        return fakeOptionOffset;
      }
    },
    getOverflowHeight: function(sizeValue) {
      var item = this.fakeListItems.eq(sizeValue - 1),
        listOffset = this.list.offset().top,
        itemOffset = item.offset().top,
        itemHeight = item.innerHeight();

      return itemOffset + itemHeight - listOffset;
    },
    getScrollTop: function() {
      return this.listHolder.scrollTop();
    },
    setScrollTop: function(value) {
      this.listHolder.scrollTop(value);
    },
    createOption: function(option) {
      var newOption = document.createElement('span');
      newOption.className = this.options.optionClass;
      newOption.innerHTML = option.innerHTML;
      newOption.setAttribute(this.options.indexAttribute, this.optionIndex++);

      var optionImage, optionImageSrc = option.getAttribute('data-image');
      if(optionImageSrc) {
        optionImage = document.createElement('img');
        optionImage.src = optionImageSrc;
        newOption.insertBefore(optionImage, newOption.childNodes[0]);
      }
      if(option.disabled) {
        newOption.className += ' ' + this.options.disabledClass;
      }
      if(option.className) {
        newOption.className += ' ' + getPrefixedClasses(option.className, this.options.cloneClassPrefix);
      }
      return newOption;
    },
    createOptGroup: function(optgroup) {
      var optGroupContainer = document.createElement('span'),
        optGroupName = optgroup.getAttribute('label'),
        optGroupCaption, optGroupList;

      // create caption
      optGroupCaption = document.createElement('span');
      optGroupCaption.className = this.options.captionClass;
      optGroupCaption.innerHTML = optGroupName;
      optGroupContainer.appendChild(optGroupCaption);

      // create list of options
      if(optgroup.children.length) {
        optGroupList = this.createOptionsList(optgroup);
        optGroupContainer.appendChild(optGroupList);
      }

      optGroupContainer.className = this.options.groupClass;
      return optGroupContainer;
    },
    createOptionContainer: function() {
      var optionContainer = document.createElement('li');
      return optionContainer;
    },
    createOptionsList: function(container) {
      var self = this,
        list = document.createElement('ul');

      $.each(container.children, function(index, currentNode) {
        var item = self.createOptionContainer(currentNode),
          newNode;

        switch(currentNode.tagName.toLowerCase()) {
          case 'option': newNode = self.createOption(currentNode); break;
          case 'optgroup': newNode = self.createOptGroup(currentNode); break;
        }
        list.appendChild(item).appendChild(newNode);
      });
      return list;
    },
    refresh: function() {
      // check for select innerHTML changes
      if(this.storedSelectHTML !== this.element.prop('innerHTML')) {
        this.rebuildList();
      }

      // refresh custom scrollbar
      var scrollInstance = jcf.getInstance(this.listHolder);
      if(scrollInstance) {
        scrollInstance.refresh();
      }

      // scroll active option into view
      this.scrollToActiveOption();

      // refresh selectes classes
      this.refreshSelectedClass();
    },
    destroy: function() {
      this.listHolder.off('jcf-mousewheel', this.preventWheelHandler);
      this.listHolder.off('jcf-pointerdown', this.indexSelector, this.onSelectItem);
      this.listHolder.off('jcf-pointerover', this.indexSelector, this.onHoverItem);
      this.listHolder.off('jcf-pointerdown', this.onPress);
    }
  });

  // helper functions
  var getPrefixedClasses = function(className, prefixToAdd) {
    return className ? className.replace(/[\s]*([\S]+)+[\s]*/gi, prefixToAdd + '$1 ') : '';
  };
  var makeUnselectable = (function() {
    var unselectableClass = jcf.getOptions().unselectableClass;
    function preventHandler(e) {
      e.preventDefault();
    }
    return function(node) {
      node.addClass(unselectableClass).on('selectstart', preventHandler);
    };
  }());

}(jQuery, this));

/*!
 * JCF - JavaScript Custom Forms - Radio module
 */
;(function($, window) {
  'use strict';

  jcf.addModule({
    name: 'Radio',
    selector: 'input[type="radio"]',
    options: {
      wrapNative: true,
      checkedClass: 'jcf-checked',
      uncheckedClass: 'jcf-unchecked',
      labelActiveClass: 'jcf-label-active',
      fakeStructure: '<span class="jcf-radio"><span></span></span>'
    },
    matchElement: function(element) {
      return element.is(':radio');
    },
    init: function(options) {
      this.initStructure();
      this.attachEvents();
      this.refresh();
    },
    initStructure: function() {
      // prepare structure
      this.doc = $(document);
      this.realElement = $(this.options.element);
      this.fakeElement = $(this.options.fakeStructure).insertAfter(this.realElement);
      this.labelElement = this.getLabelFor();

      if(this.options.wrapNative) {
        // wrap native radio inside fake block
        this.realElement.prependTo(this.fakeElement).css({
          position: 'absolute',
          opacity: 0
        });
      } else {
        // just hide native radio
        this.realElement.addClass(this.options.hiddenClass);
      }
    },
    attachEvents: function() {
      // add event handlers
      this.realElement.on({
        focus: this.onFocus,
        click: this.onRealClick
      });
      this.fakeElement.on('click', this.onFakeClick);
      this.fakeElement.on('jcf-pointerdown', this.onPress);
    },
    onRealClick: function() {
      // redraw current radio and its group
      this.refreshRadioGroup();
    },
    onFakeClick: function(e) {
      // skip event if clicked on real element inside wrapper
      if(this.options.wrapNative && this.realElement.is(e.target)) {
        return;
      }

      // toggle checked class
      if(!this.realElement.is(':disabled')) {
        this.realElement.prop('checked', true);
        this.refreshRadioGroup();
        this.realElement.trigger('change');
      }
    },
    onFocus: function() {
      if(!this.pressedFlag || !this.focusedFlag) {
        this.focusedFlag = true;
        this.fakeElement.addClass(this.options.focusClass);
        this.realElement.on('blur', this.onBlur);
      }
    },
    onBlur: function() {
      if(!this.pressedFlag) {
        this.focusedFlag = false;
        this.fakeElement.removeClass(this.options.focusClass);
        this.realElement.off('blur', this.onBlur);
      }
    },
    onPress: function() {
      if(!this.focusedFlag) {
        this.realElement.focus();
      }
      this.pressedFlag = true;
      this.fakeElement.addClass(this.options.pressedClass);
      this.doc.on('jcf-pointerup', this.onRelease);
    },
    onRelease: function() {
      if(this.focusedFlag) {
        this.realElement.focus();
      }
      this.pressedFlag = false;
      this.fakeElement.removeClass(this.options.pressedClass);
      this.doc.off('jcf-pointerup', this.onRelease);
    },
    getRadioGroup: function(radio) {
      // find radio group for specified radio button
      var name = radio.attr('name'),
        parentForm = radio.parents('form');

      if(name) {
        if(parentForm.length) {
          return parentForm.find('input[name="' + name + '"]');
        } else {
          return $('input[name="' + name + '"]:not(form input)');
        }
      } else {
        return radio;
      }
    },
    getLabelFor: function() {
      var parentLabel = this.realElement.closest('label'),
        elementId = this.realElement.prop('id');

      if(!parentLabel.length && elementId) {
        parentLabel = $('label[for="' + elementId + '"]');
      }
      return parentLabel.length ? parentLabel : null;
    },
    refreshRadioGroup: function() {
      // redraw current radio and its group
      this.getRadioGroup(this.realElement).each(function() {
        jcf.refresh(this);
      });
    },
    refresh: function() {
      // redraw current radio button
      var isChecked = this.realElement.is(':checked'),
        isDisabled = this.realElement.is(':disabled');

      this.fakeElement.toggleClass(this.options.checkedClass, isChecked)
              .toggleClass(this.options.uncheckedClass, !isChecked)
              .toggleClass(this.options.disabledClass, isDisabled);

      if(this.labelElement) {
        this.labelElement.toggleClass(this.options.labelActiveClass, isChecked);
      }
    },
    destroy: function() {
      // restore structure
      if(this.options.wrapNative) {
        this.realElement.insertBefore(this.fakeElement).css({
          position: '',
          width: '',
          height: '',
          opacity: '',
          margin: ''
        });
      } else {
        this.realElement.removeClass(this.options.hiddenClass);
      }

      // removing element will also remove its event handlers
      this.fakeElement.off('jcf-pointerdown', this.onPress);
      this.fakeElement.remove();

      // remove other event handlers
      this.doc.off('jcf-pointerup', this.onRelease);
      this.realElement.off({
        blur: this.onBlur,
        focus: this.onFocus,
        click: this.onRealClick
      });
    }
  });

}(jQuery, this));

/*!
 * JCF - JavaScript Custom Forms - Checkbox Module
 */
;(function($, window) {
  'use strict';

  jcf.addModule({
    name: 'Checkbox',
    selector: 'input[type="checkbox"]',
    options: {
      wrapNative: true,
      checkedClass: 'jcf-checked',
      uncheckedClass: 'jcf-unchecked',
      labelActiveClass: 'jcf-label-active',
      fakeStructure: '<span class="jcf-checkbox"><span></span></span>'
    },
    matchElement: function(element) {
      return element.is(':checkbox');
    },
    init: function(options) {
      this.initStructure();
      this.attachEvents();
      this.refresh();
    },
    initStructure: function() {
      // prepare structure
      this.doc = $(document);
      this.realElement = $(this.options.element);
      this.fakeElement = $(this.options.fakeStructure).insertAfter(this.realElement);
      this.labelElement = this.getLabelFor();

      if(this.options.wrapNative) {
        // wrap native checkbox inside fake block
        this.realElement.appendTo(this.fakeElement).css({
          position: 'absolute',
          height: '100%',
          width: '100%',
          opacity: 0,
          margin: 0
        });
      } else {
        // just hide native checkbox
        this.realElement.addClass(this.options.hiddenClass);
      }
    },
    attachEvents: function() {
      // add event handlers
      this.realElement.on({
        focus: this.onFocus,
        click: this.onRealClick
      });
      this.fakeElement.on('click', this.onFakeClick);
      this.fakeElement.on('jcf-pointerdown', this.onPress);
    },
    onRealClick: function() {
      // just redraw fake element
      this.refresh();
    },
    onFakeClick: function(e) {
      // skip event if clicked on real element inside wrapper
      if(this.options.wrapNative && this.realElement.is(e.target)) {
        return;
      }

      // toggle checked class
      if(!this.realElement.is(':disabled')) {
        this.realElement.prop('checked', !this.realElement.prop('checked'));
        this.refresh();
        this.realElement.trigger('change');
      }
    },
    onFocus: function() {
      if(!this.pressedFlag || !this.focusedFlag) {
        this.fakeElement.addClass(this.options.focusClass);

        this.focusedFlag = true;
        this.realElement.on('blur', this.onBlur);
      }
    },
    onBlur: function() {
      if(!this.pressedFlag) {
        this.fakeElement.removeClass(this.options.focusClass);

        this.focusedFlag = false;
        this.realElement.off('blur', this.onBlur);
      }
    },
    onPress: function() {
      if(!this.focusedFlag) {
        this.realElement.focus();
      }
      this.pressedFlag = true;
      this.fakeElement.addClass(this.options.pressedClass);
      this.doc.on('jcf-pointerup', this.onRelease);
    },
    onRelease: function() {
      if(this.focusedFlag) {
        this.realElement.focus();
      }
      this.pressedFlag = false;
      this.fakeElement.removeClass(this.options.pressedClass);
      this.doc.off('jcf-pointerup', this.onRelease);
    },
    getLabelFor: function() {
      var parentLabel = this.realElement.closest('label'),
        elementId = this.realElement.prop('id');

      if(!parentLabel.length && elementId) {
        parentLabel = $('label[for="' + elementId + '"]');
      }
      return parentLabel.length ? parentLabel : null;
    },
    refresh: function() {
      // redraw custom checkbox
      var isChecked = this.realElement.is(':checked'),
        isDisabled = this.realElement.is(':disabled');

      this.fakeElement.toggleClass(this.options.checkedClass, isChecked)
              .toggleClass(this.options.uncheckedClass, !isChecked)
              .toggleClass(this.options.disabledClass, isDisabled);

      if(this.labelElement) {
        this.labelElement.toggleClass(this.options.labelActiveClass, isChecked);
      }
    },
    destroy: function() {
      // restore structure
      if(this.options.wrapNative) {
        this.realElement.insertBefore(this.fakeElement).css({
          position: '',
          width: '',
          height: '',
          opacity: '',
          margin: ''
        });
      } else {
        this.realElement.removeClass(this.options.hiddenClass);
      }

      // removing element will also remove its event handlers
      this.fakeElement.off('jcf-pointerdown', this.onPress);
      this.fakeElement.remove();

      // remove other event handlers
      this.doc.off('jcf-pointerup', this.onRelease);
      this.realElement.off({
        focus: this.onFocus,
        click: this.onRealClick
      });
    }
  });

}(jQuery, this));



/*! Hammer.JS - v1.0.5 - 2013-04-07
 * http://eightmedia.github.com/hammer.js
 *
 * Copyright (c) 2013 Jorik Tangelder <j.tangelder@gmail.com>;
 * Licensed under the MIT license */
;(function(t,e){"use strict";function n(){if(!i.READY){i.event.determineEventTypes();for(var t in i.gestures)i.gestures.hasOwnProperty(t)&&i.detection.register(i.gestures[t]);i.event.onTouch(i.DOCUMENT,i.EVENT_MOVE,i.detection.detect),i.event.onTouch(i.DOCUMENT,i.EVENT_END,i.detection.detect),i.READY=!0}}var i=function(t,e){return new i.Instance(t,e||{})};i.defaults={stop_browser_behavior:{userSelect:"none",touchAction:"none",touchCallout:"none",contentZooming:"none",userDrag:"none",tapHighlightColor:"rgba(0,0,0,0)"}},i.HAS_POINTEREVENTS=navigator.pointerEnabled||navigator.msPointerEnabled,i.HAS_TOUCHEVENTS="ontouchstart"in t,i.MOBILE_REGEX=/mobile|tablet|ip(ad|hone|od)|android/i,i.NO_MOUSEEVENTS=i.HAS_TOUCHEVENTS&&navigator.userAgent.match(i.MOBILE_REGEX),i.EVENT_TYPES={},i.DIRECTION_DOWN="down",i.DIRECTION_LEFT="left",i.DIRECTION_UP="up",i.DIRECTION_RIGHT="right",i.POINTER_MOUSE="mouse",i.POINTER_TOUCH="touch",i.POINTER_PEN="pen",i.EVENT_START="start",i.EVENT_MOVE="move",i.EVENT_END="end",i.DOCUMENT=document,i.plugins={},i.READY=!1,i.Instance=function(t,e){var r=this;return n(),this.element=t,this.enabled=!0,this.options=i.utils.extend(i.utils.extend({},i.defaults),e||{}),this.options.stop_browser_behavior&&i.utils.stopDefaultBrowserBehavior(this.element,this.options.stop_browser_behavior),i.event.onTouch(t,i.EVENT_START,function(t){r.enabled&&i.detection.startDetect(r,t)}),this},i.Instance.prototype={on:function(t,e){for(var n=t.split(" "),i=0;n.length>i;i++)this.element.addEventListener(n[i],e,!1);return this},off:function(t,e){for(var n=t.split(" "),i=0;n.length>i;i++)this.element.removeEventListener(n[i],e,!1);return this},trigger:function(t,e){var n=i.DOCUMENT.createEvent("Event");n.initEvent(t,!0,!0),n.gesture=e;var r=this.element;return i.utils.hasParent(e.target,r)&&(r=e.target),r.dispatchEvent(n),this},enable:function(t){return this.enabled=t,this}};var r=null,o=!1,s=!1;i.event={bindDom:function(t,e,n){for(var i=e.split(" "),r=0;i.length>r;r++)t.addEventListener(i[r],n,!1)},onTouch:function(t,e,n){var a=this;this.bindDom(t,i.EVENT_TYPES[e],function(c){var u=c.type.toLowerCase();if(!u.match(/mouse/)||!s){(u.match(/touch/)||u.match(/pointerdown/)||u.match(/mouse/)&&1===c.which)&&(o=!0),u.match(/touch|pointer/)&&(s=!0);var h=0;o&&(i.HAS_POINTEREVENTS&&e!=i.EVENT_END?h=i.PointerEvent.updatePointer(e,c):u.match(/touch/)?h=c.touches.length:s||(h=u.match(/up/)?0:1),h>0&&e==i.EVENT_END?e=i.EVENT_MOVE:h||(e=i.EVENT_END),h||null===r?r=c:c=r,n.call(i.detection,a.collectEventData(t,e,c)),i.HAS_POINTEREVENTS&&e==i.EVENT_END&&(h=i.PointerEvent.updatePointer(e,c))),h||(r=null,o=!1,s=!1,i.PointerEvent.reset())}})},determineEventTypes:function(){var t;t=i.HAS_POINTEREVENTS?i.PointerEvent.getEvents():i.NO_MOUSEEVENTS?["touchstart","touchmove","touchend touchcancel"]:["touchstart mousedown","touchmove mousemove","touchend touchcancel mouseup"],i.EVENT_TYPES[i.EVENT_START]=t[0],i.EVENT_TYPES[i.EVENT_MOVE]=t[1],i.EVENT_TYPES[i.EVENT_END]=t[2]},getTouchList:function(t){return i.HAS_POINTEREVENTS?i.PointerEvent.getTouchList():t.touches?t.touches:[{identifier:1,pageX:t.pageX,pageY:t.pageY,target:t.target}]},collectEventData:function(t,e,n){var r=this.getTouchList(n,e),o=i.POINTER_TOUCH;return(n.type.match(/mouse/)||i.PointerEvent.matchType(i.POINTER_MOUSE,n))&&(o=i.POINTER_MOUSE),{center:i.utils.getCenter(r),timeStamp:(new Date).getTime(),target:n.target,touches:r,eventType:e,pointerType:o,srcEvent:n,preventDefault:function(){this.srcEvent.preventManipulation&&this.srcEvent.preventManipulation(),this.srcEvent.preventDefault&&this.srcEvent.preventDefault()},stopPropagation:function(){this.srcEvent.stopPropagation()},stopDetect:function(){return i.detection.stopDetect()}}}},i.PointerEvent={pointers:{},getTouchList:function(){var t=this,e=[];return Object.keys(t.pointers).sort().forEach(function(n){e.push(t.pointers[n])}),e},updatePointer:function(t,e){return t==i.EVENT_END?this.pointers={}:(e.identifier=e.pointerId,this.pointers[e.pointerId]=e),Object.keys(this.pointers).length},matchType:function(t,e){if(!e.pointerType)return!1;var n={};return n[i.POINTER_MOUSE]=e.pointerType==e.MSPOINTER_TYPE_MOUSE||e.pointerType==i.POINTER_MOUSE,n[i.POINTER_TOUCH]=e.pointerType==e.MSPOINTER_TYPE_TOUCH||e.pointerType==i.POINTER_TOUCH,n[i.POINTER_PEN]=e.pointerType==e.MSPOINTER_TYPE_PEN||e.pointerType==i.POINTER_PEN,n[t]},getEvents:function(){return["pointerdown MSPointerDown","pointermove MSPointerMove","pointerup pointercancel MSPointerUp MSPointerCancel"]},reset:function(){this.pointers={}}},i.utils={extend:function(t,n,i){for(var r in n)t[r]!==e&&i||(t[r]=n[r]);return t},hasParent:function(t,e){for(;t;){if(t==e)return!0;t=t.parentNode}return!1},getCenter:function(t){for(var e=[],n=[],i=0,r=t.length;r>i;i++)e.push(t[i].pageX),n.push(t[i].pageY);return{pageX:(Math.min.apply(Math,e)+Math.max.apply(Math,e))/2,pageY:(Math.min.apply(Math,n)+Math.max.apply(Math,n))/2}},getVelocity:function(t,e,n){return{x:Math.abs(e/t)||0,y:Math.abs(n/t)||0}},getAngle:function(t,e){var n=e.pageY-t.pageY,i=e.pageX-t.pageX;return 180*Math.atan2(n,i)/Math.PI},getDirection:function(t,e){var n=Math.abs(t.pageX-e.pageX),r=Math.abs(t.pageY-e.pageY);return n>=r?t.pageX-e.pageX>0?i.DIRECTION_LEFT:i.DIRECTION_RIGHT:t.pageY-e.pageY>0?i.DIRECTION_UP:i.DIRECTION_DOWN},getDistance:function(t,e){var n=e.pageX-t.pageX,i=e.pageY-t.pageY;return Math.sqrt(n*n+i*i)},getScale:function(t,e){return t.length>=2&&e.length>=2?this.getDistance(e[0],e[1])/this.getDistance(t[0],t[1]):1},getRotation:function(t,e){return t.length>=2&&e.length>=2?this.getAngle(e[1],e[0])-this.getAngle(t[1],t[0]):0},isVertical:function(t){return t==i.DIRECTION_UP||t==i.DIRECTION_DOWN},stopDefaultBrowserBehavior:function(t,e){var n,i=["webkit","khtml","moz","ms","o",""];if(e&&t.style){for(var r=0;i.length>r;r++)for(var o in e)e.hasOwnProperty(o)&&(n=o,i[r]&&(n=i[r]+n.substring(0,1).toUpperCase()+n.substring(1)),t.style[n]=e[o]);"none"==e.userSelect&&(t.onselectstart=function(){return!1})}}},i.detection={gestures:[],current:null,previous:null,stopped:!1,startDetect:function(t,e){this.current||(this.stopped=!1,this.current={inst:t,startEvent:i.utils.extend({},e),lastEvent:!1,name:""},this.detect(e))},detect:function(t){if(this.current&&!this.stopped){t=this.extendEventData(t);for(var e=this.current.inst.options,n=0,r=this.gestures.length;r>n;n++){var o=this.gestures[n];if(!this.stopped&&e[o.name]!==!1&&o.handler.call(o,t,this.current.inst)===!1){this.stopDetect();break}}return this.current&&(this.current.lastEvent=t),t.eventType==i.EVENT_END&&!t.touches.length-1&&this.stopDetect(),t}},stopDetect:function(){this.previous=i.utils.extend({},this.current),this.current=null,this.stopped=!0},extendEventData:function(t){var e=this.current.startEvent;if(e&&(t.touches.length!=e.touches.length||t.touches===e.touches)){e.touches=[];for(var n=0,r=t.touches.length;r>n;n++)e.touches.push(i.utils.extend({},t.touches[n]))}var o=t.timeStamp-e.timeStamp,s=t.center.pageX-e.center.pageX,a=t.center.pageY-e.center.pageY,c=i.utils.getVelocity(o,s,a);return i.utils.extend(t,{deltaTime:o,deltaX:s,deltaY:a,velocityX:c.x,velocityY:c.y,distance:i.utils.getDistance(e.center,t.center),angle:i.utils.getAngle(e.center,t.center),direction:i.utils.getDirection(e.center,t.center),scale:i.utils.getScale(e.touches,t.touches),rotation:i.utils.getRotation(e.touches,t.touches),startEvent:e}),t},register:function(t){var n=t.defaults||{};return n[t.name]===e&&(n[t.name]=!0),i.utils.extend(i.defaults,n,!0),t.index=t.index||1e3,this.gestures.push(t),this.gestures.sort(function(t,e){return t.index<e.index?-1:t.index>e.index?1:0}),this.gestures}},i.gestures=i.gestures||{},i.gestures.Hold={name:"hold",index:10,defaults:{hold_timeout:500,hold_threshold:1},timer:null,handler:function(t,e){switch(t.eventType){case i.EVENT_START:clearTimeout(this.timer),i.detection.current.name=this.name,this.timer=setTimeout(function(){"hold"==i.detection.current.name&&e.trigger("hold",t)},e.options.hold_timeout);break;case i.EVENT_MOVE:t.distance>e.options.hold_threshold&&clearTimeout(this.timer);break;case i.EVENT_END:clearTimeout(this.timer)}}},i.gestures.Tap={name:"tap",index:100,defaults:{tap_max_touchtime:250,tap_max_distance:10,tap_always:!0,doubletap_distance:20,doubletap_interval:300},handler:function(t,e){if(t.eventType==i.EVENT_END){var n=i.detection.previous,r=!1;if(t.deltaTime>e.options.tap_max_touchtime||t.distance>e.options.tap_max_distance)return;n&&"tap"==n.name&&t.timeStamp-n.lastEvent.timeStamp<e.options.doubletap_interval&&t.distance<e.options.doubletap_distance&&(e.trigger("doubletap",t),r=!0),(!r||e.options.tap_always)&&(i.detection.current.name="tap",e.trigger(i.detection.current.name,t))}}},i.gestures.Swipe={name:"swipe",index:40,defaults:{swipe_max_touches:1,swipe_velocity:.7},handler:function(t,e){if(t.eventType==i.EVENT_END){if(e.options.swipe_max_touches>0&&t.touches.length>e.options.swipe_max_touches)return;(t.velocityX>e.options.swipe_velocity||t.velocityY>e.options.swipe_velocity)&&(e.trigger(this.name,t),e.trigger(this.name+t.direction,t))}}},i.gestures.Drag={name:"drag",index:50,defaults:{drag_min_distance:10,drag_max_touches:1,drag_block_horizontal:!1,drag_block_vertical:!1,drag_lock_to_axis:!1,drag_lock_min_distance:25},triggered:!1,handler:function(t,n){if(i.detection.current.name!=this.name&&this.triggered)return n.trigger(this.name+"end",t),this.triggered=!1,e;if(!(n.options.drag_max_touches>0&&t.touches.length>n.options.drag_max_touches))switch(t.eventType){case i.EVENT_START:this.triggered=!1;break;case i.EVENT_MOVE:if(t.distance<n.options.drag_min_distance&&i.detection.current.name!=this.name)return;i.detection.current.name=this.name,(i.detection.current.lastEvent.drag_locked_to_axis||n.options.drag_lock_to_axis&&n.options.drag_lock_min_distance<=t.distance)&&(t.drag_locked_to_axis=!0);var r=i.detection.current.lastEvent.direction;t.drag_locked_to_axis&&r!==t.direction&&(t.direction=i.utils.isVertical(r)?0>t.deltaY?i.DIRECTION_UP:i.DIRECTION_DOWN:0>t.deltaX?i.DIRECTION_LEFT:i.DIRECTION_RIGHT),this.triggered||(n.trigger(this.name+"start",t),this.triggered=!0),n.trigger(this.name,t),n.trigger(this.name+t.direction,t),(n.options.drag_block_vertical&&i.utils.isVertical(t.direction)||n.options.drag_block_horizontal&&!i.utils.isVertical(t.direction))&&t.preventDefault();break;case i.EVENT_END:this.triggered&&n.trigger(this.name+"end",t),this.triggered=!1}}},i.gestures.Transform={name:"transform",index:45,defaults:{transform_min_scale:.01,transform_min_rotation:1,transform_always_block:!1},triggered:!1,handler:function(t,n){if(i.detection.current.name!=this.name&&this.triggered)return n.trigger(this.name+"end",t),this.triggered=!1,e;if(!(2>t.touches.length))switch(n.options.transform_always_block&&t.preventDefault(),t.eventType){case i.EVENT_START:this.triggered=!1;break;case i.EVENT_MOVE:var r=Math.abs(1-t.scale),o=Math.abs(t.rotation);if(n.options.transform_min_scale>r&&n.options.transform_min_rotation>o)return;i.detection.current.name=this.name,this.triggered||(n.trigger(this.name+"start",t),this.triggered=!0),n.trigger(this.name,t),o>n.options.transform_min_rotation&&n.trigger("rotate",t),r>n.options.transform_min_scale&&(n.trigger("pinch",t),n.trigger("pinch"+(1>t.scale?"in":"out"),t));break;case i.EVENT_END:this.triggered&&n.trigger(this.name+"end",t),this.triggered=!1}}},i.gestures.Touch={name:"touch",index:-1/0,defaults:{prevent_default:!1,prevent_mouseevents:!1},handler:function(t,n){return n.options.prevent_mouseevents&&t.pointerType==i.POINTER_MOUSE?(t.stopDetect(),e):(n.options.prevent_default&&t.preventDefault(),t.eventType==i.EVENT_START&&n.trigger(this.name,t),e)}},i.gestures.Release={name:"release",index:1/0,handler:function(t,e){t.eventType==i.EVENT_END&&e.trigger(this.name,t)}},"object"==typeof module&&"object"==typeof module.exports?module.exports=i:(t.Hammer=i,"function"==typeof t.define&&t.define.amd&&t.define("hammer",[],function(){return i}))})(this),function(t,e){"use strict";t!==e&&(Hammer.event.bindDom=function(n,i,r){t(n).on(i,function(t){var n=t.originalEvent||t;n.pageX===e&&(n.pageX=t.pageX,n.pageY=t.pageY),n.target||(n.target=t.target),n.which===e&&(n.which=n.button),n.preventDefault||(n.preventDefault=t.preventDefault),n.stopPropagation||(n.stopPropagation=t.stopPropagation),r.call(this,n)})},Hammer.Instance.prototype.on=function(e,n){return t(this.element).on(e,n)},Hammer.Instance.prototype.off=function(e,n){return t(this.element).off(e,n)},Hammer.Instance.prototype.trigger=function(e,n){var i=t(this.element);return i.has(n.target).length&&(i=t(n.target)),i.trigger({type:e,gesture:n})},t.fn.hammer=function(e){return this.each(function(){var n=t(this),i=n.data("hammer");i?i&&e&&Hammer.utils.extend(i.options,e):n.data("hammer",new Hammer(this,e||{}))})})}(window.jQuery||window.Zepto);

/*! matchMedia() polyfill - Test a CSS media type/query in JS. Authors & copyright (c) 2012: Scott Jehl, Paul Irish, Nicholas Zakas. Dual MIT/BSD license */
;window.matchMedia=window.matchMedia||(function(e,f){var c,a=e.documentElement,b=a.firstElementChild||a.firstChild,d=e.createElement("body"),g=e.createElement("div");g.id="mq-test-1";g.style.cssText="position:absolute;top:-100em";d.appendChild(g);return function(h){g.innerHTML='&shy;<style media="'+h+'"> #mq-test-1 { width: 42px; }</style>';a.insertBefore(d,b);c=g.offsetWidth==42;a.removeChild(d);return{matches:c,media:h}}})(document);

/*! Picturefill - Responsive Images that work today. (and mimic the proposed Picture element with span elements). Author: Scott Jehl, Filament Group, 2012 | License: MIT/GPLv2 */
;(function(a){a.picturefill=function(){var b=a.document.getElementsByTagName("span");for(var f=0,l=b.length;f<l;f++){if(b[f].getAttribute("data-picture")!==null){var c=b[f].getElementsByTagName("span"),h=[];for(var e=0,g=c.length;e<g;e++){var d=c[e].getAttribute("data-media");if(!d||(a.matchMedia&&a.matchMedia(d).matches)){h.push(c[e])}}var m=b[f].getElementsByTagName("img")[0];if(h.length){var k=h.pop();if(!m||m.parentNode.nodeName==="NOSCRIPT"){m=a.document.createElement("img");m.alt=b[f].getAttribute("data-alt")}if(k.getAttribute("data-width")){m.setAttribute("width",k.getAttribute("data-width"))}else{m.removeAttribute("width")}if(k.getAttribute("data-height")){m.setAttribute("height",k.getAttribute("data-height"))}else{m.removeAttribute("height")}m.src=k.getAttribute("data-src");k.appendChild(m)}else{if(m){m.parentNode.removeChild(m)}}}}};if(a.addEventListener){a.addEventListener("resize",a.picturefill,false);a.addEventListener("DOMContentLoaded",function(){a.picturefill();a.removeEventListener("load",a.picturefill,false)},false);a.addEventListener("load",a.picturefill,false)}else{if(a.attachEvent){a.attachEvent("onload",a.picturefill)}}}(this));
