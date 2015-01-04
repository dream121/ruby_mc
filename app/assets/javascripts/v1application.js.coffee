#= require vendorv1
#= require facebook
#= require masterclass
#= require responsive-tabs
#= require scriptcam
#= require_tree ./views
#= require answer.jquery.js
#= require analytics
#= require answer.js.coffee
#= require cart_products
#= require comments
#= require coupon.jquery.js
#= require coupons
#= require course_facts
#= require course_marketing
#= require course_reviews
#= require experiments
#= require facebook
#= require masterclass
#= require mc_uploader.jquery.js
#= require office_hours
#= require order_products
#= require orders
#= require products
#= require related_products
#= require responsive-tabs
#= require scriptcam
#= require sign
#= require user_sessions
#= require user_settings
#= require video
#= require video_marketing

ready = ->
  MC.sessions.ready()
  MC.experiments.ready()
  MC.orders.ready()
  MC.videoMarketing.ready()
  MC.courseMarketing.ready()
  MC.courseTabs.ready()
  MC.forums.ready()
  MC.analytics.ready()
  MC.courseReviews.ready()
  MC.answer.ready()
  MC.coupon.ready()
  MC.userSettings.ready()
  $('body').tooltip
    selector: 'a[rel="tooltip"], [data-toggle="tooltip"]'

$(document).ready(ready)
$(document).on('page:load', ready)
