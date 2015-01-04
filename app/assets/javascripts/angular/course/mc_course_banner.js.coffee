angular.module('masterclassApp')
  .directive 'mcCourseBanner', ->
    templateUrl: 'angular/course/course_banner_template.html'
    scope:
      course: '=mcCourseBanner'
