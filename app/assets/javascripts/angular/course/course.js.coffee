angular.module('masterclassApp')
  .factory 'Course', ['$resource', ($resource) ->
    $resource '/api/v1/courses/:subaction', {}, {
      upcoming:
        method: 'GET'
        isArray: true
        params:
          subaction: 'upcoming'
      recommended:
        method: 'GET'
        url: '/api/v1/user/courses/recommended'
        isArray: true
      forCurrentUser:
        method: 'GET'
        url: '/api/v1/user/courses'
        isArray: true
    }
  ]
