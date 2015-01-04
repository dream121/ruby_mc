if (typeof Object.create !== 'function') {

  Object.create = function(o) {
    function F() {};
    F.prototype = o;
    return new F();
  };
}

(function($) {
  var CouponForm = {
    init: function(options, elem) {
      // Mix in the passed in options with the default options
      this.options = {
        updateBaseUrl: '/api/v1/users/:user_id/cart/add_coupon',
        findBaseUrl: '/api/v1/users/:user_id/cart',
        userIdToken: ':user_id',
        priceTarget: '#total-price',
      }

      this.options = $.extend({}, this.options, options);

      // Save the element reference, both as a jQuery
      // reference and a normal reference
      this.elem                 = elem;
      this.$elem                = $(elem);
      this.baseUrl              = this.options.baseUrl;
      this.$submitButton        = $('#coupon-submit', this.$elem);
      this.$couponField         = $('#discount-code', this.$elem);
      this.$formRow             = $('#coupon-submit').closest('.form-row')
      this.$priceText           = $('#total-price');
      this.$orderForm           = $('#new_order');
      this.$discountCodeOpener  = $('#discount-code-opener')
      this.currentUserId        = this.$elem.data('userid');
      this.findBaseUrl          = this.options.findBaseUrl;
      this.updateBaseUrl        = this.options.updateBaseUrl;
      this.userIdToken          = this.options.userIdToken
      var _self                 = this;
      this.bindEvents();

      return this;
    },

    findUrl: function() {
      return this.findBaseUrl.replace(this.userIdToken, this.currentUserId)
    },

    createUrl: function() {
      return this.baseUrl
    },

    updateUrl: function(id) {
      return this.updateBaseUrl.replace(this.userIdToken, this.currentUserId)
    },

    returnDiscountCode: function() {
      return this.$couponField.val();
    },

    setOrderTotal: function(price) {
      this.$orderForm.data('total-price', price);
      return this.$orderForm.data('total-price');
    },

    returnOrderTotal: function() {
      return parseInt(this.$orderForm.data('total-price'));
    },

    calculateOrderTotal: function(discountAmt) {
      var amt = this.returnOrderTotal() - discountAmt;
      return amt 
    },

    updateTotal: function(discountAmt) {
      var discountedTotal = this.calculateOrderTotal(discountAmt);
      return this.setOrderTotal(discountedTotal);
    },

    updateDisplayAmount: function(discountAmt) {
      var displayTotal = Math.floor(this.returnOrderTotal() / 100)
      this.$priceText.text("total $" + displayTotal);
      return displayTotal;
    },

    parseCouponPrice: function(data) {
      if (typeof data.coupon != 'undefined' ) {
        return data.coupon.price;
      }
      return null
    },

    disableSubmitButton: function() {
      this.$submitButton.attr('disabled', true);
    },

    enableSubmitButton: function() {
      this.$submitButton.removeAttr('disabled');
    },

    disableCouponInput: function() {
      this.$couponField.attr('disabled', true);
    },

    enableCouponInput: function() {
      this.$couponField.removeAttr('disabled');
    },

    bindEvents: function() {
      var context = this;
      context.$submitButton.off('click');
      context.$submitButton.on('click', function(e){
        e.preventDefault();
        context.update();
      });
    },


    insertDiscountHtml: function(discountAmt) {
      this.createDiscountHtml(Math.floor(discountAmt / 100)).insertAfter(this.$formRow);
    },

    createDiscountHtml: function(discountAmt) {
      var obj = { amount: discountAmt }
      var html = JST['views/carts/discount_applied']({obj: obj});
      return $(html);
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

    create: function() {
      var context = this;
      $.ajax({
        url: context.createUrl(),
        dataType: 'json',
        type: 'POST',
        data: {
          coupon: {

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
        context: context,
        dataType: 'json',
        type: 'PUT',
        data: {
          coupon: {
            code: context.returnDiscountCode() 
          }
        }
      })
      .done( context.handleUpdate)
      .fail( this.handleError )
    },

    handleFind: function(data, textResponse, jqXHR) {
    },

    handleCreate: function(data, textResponse, jqXHR) {
    },

    handleUpdate: function(data, textResponse, jqXHR, context) {
      var couponAmount = this.parseCouponPrice(data);
      this.updateTotal(couponAmount);
      this.updateDisplayAmount(couponAmount);
      this.insertDiscountHtml(Math.floor(couponAmount));
      this.$formRow.remove();
      this.$discountCodeOpener.html('Discount Code Applied');
    },

    handleError: function() {
    },

  };

  //Start plugin
  $.fn.extend({
    'couponForm': function(options) {
      return this.each(function(){
        // Create a new changeUrlForm
        var myCouponForm = Object.create(CouponForm);

        // Set intialize with plugin options
        myCouponForm.init(options, this);

        // Save the reference to the instance in the elem's data object
        $(this).data('couponForm', myCouponForm);
      });
    },
  });

  $(document).ready(function(){
  });

}(jQuery));
