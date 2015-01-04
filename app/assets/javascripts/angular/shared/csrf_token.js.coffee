angular.module('masterclassApp')
  .factory 'csrfToken', ->
    $('meta[name="csrf-token"]').attr('content')
