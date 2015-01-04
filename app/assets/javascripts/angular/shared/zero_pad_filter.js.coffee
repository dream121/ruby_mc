# http://jsperf.com/ways-to-0-pad-a-number/27
angular.module('masterclassApp')
  .filter 'zeroPad', ->
    (integer, digits) ->
      N = Math.pow(10, digits)
      if integer < N
        ("" + (N + integer)).slice(1)
      else
        "" + integer
