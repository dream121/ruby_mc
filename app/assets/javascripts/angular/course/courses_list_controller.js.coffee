angular.module('masterclassApp')
  .controller 'CoursesListController', ['$scope', 'Course', ($scope, Course) ->
    $scope.comingSoonCourses  = Course.upcoming()
    $scope.recommendedCourses = Course.recommended()
    $scope.yourCourses        = Course.forCurrentUser()
  ]
