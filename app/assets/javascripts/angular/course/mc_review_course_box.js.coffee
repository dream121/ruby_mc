angular.module('masterclassApp')
  .directive 'mcReviewCourseBox', ['$resource', 'csrfToken', 'CourseReview', ($resource, csrfToken, CourseReview) ->
    templateUrl: 'angular/course/review_course_box_template.html'
    scope:
      course: '=mcReviewCourseBox'
    link: ($scope) ->
      createOrUpdate = (course_review, callback=->) ->
        params =
          authenticity_token: csrfToken,
          course_review: angular.copy(course_review)
        params.course_review.course_id = $scope.course.id

        updateStateAndLatestReviewThenCallback = (review) ->
          # TODO: Hacky. Ideally the logic to reflect this state change would come from the server
          $scope.course.state = 'reviewed' if review.rating && review.review
          $scope.course.latest_review ||= review
          callback(review)

        if $scope.course.latest_review
          id = { course_review_id: $scope.course.latest_review.id }
          CourseReview.update id, params, updateStateAndLatestReviewThenCallback, (httpResponse) -> console.log('error', JSON.stringify(arguments, httpResponse.code))
        else
          CourseReview.save params, updateStateAndLatestReviewThenCallback, (httpResponse) -> console.log('error', JSON.stringify(arguments, httpResponse.code))


      $scope.options = [1,2,3,4,5]
      $scope.courseReview = angular.copy($scope.course.latest_review) || {}

      $scope.rate = (index) ->
        rating = index+1
        createOrUpdate {rating: rating}, (review) ->
          $scope.courseReview.rating = review.rating

      $scope.submit = ->
        createOrUpdate { review: $scope.courseReview.review }

      $scope.setIsEditing = (value) ->
        $scope.isEditing = value
  ]
