angular.module('masterclassApp')
  .factory 'CourseReview', ['$resource', ($resource) ->
      CourseReview = $resource '/api/v1/course_reviews/:course_review_id', null, {
        update:
          method: 'PUT'
      }
  ]
