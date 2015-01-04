window.MC =
  Brightcove: {}
  Experiments: {}

  log: (message) ->
    if window["console"] && console["log"]
      console.log(message)
