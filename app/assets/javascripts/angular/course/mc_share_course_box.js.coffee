angular.module('masterclassApp')
  .directive 'mcShareCourseBox', ->
    templateUrl: 'angular/course/share_course_box_template.html'
    scope:
      course: '=mcShareCourseBox'
    link: ($scope) ->
      $scope.courseFbWallPost = ->
        fb_params =
          method: 'feed',
          app_id: gon.facebook_key,
          name: $scope.course.instructor_first_name,
          link: 'http://www.masterclass.com',
          picture: $scope.course.banner_image_url,
          caption: "teaches you #{$scope.course.skill}",
          description: $scope.course.overview

        originalScrollTop = $(window).scrollTop()
        FB.ui fb_params, (response) ->
          $(window).scrollTop(originalScrollTop)

        return false
