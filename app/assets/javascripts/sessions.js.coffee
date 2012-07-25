# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  lastUpdate = null
  return  if $("#chart").length is 0

  chart = new Highcharts.Chart(
    chart:
      renderTo: "chart"
      type: "areaspline"
      backgroundColor: "#222"
      shadow: true

    title:
      text: "Power consumption"
      style:
        color: "#999"
        fontSize: "14px"

    xAxis:
      type: "datetime"
      lineColor: "#101010"

    yAxis:
      title:
        text: "Power / W"

      gridLineColor: "#101010"

    colors: [ "#00B4F8" ]
    credits:
      enabled: false

    labels:
      style:
        color: "#AAA"

    tooltip:
      formatter: ->
        Highcharts.dateFormat("%Y-%m-%d %H:%M:%S", @x) + "<br/>" + Highcharts.numberFormat(@y, 0) + "W"

      borderWidth: 0
      backgroundColor: "#101010"
      style:
        color: "#aaa"

    plotOptions:
      areaspline:
        fillOpacity: 0.5
        fillColor:
          linearGradient: [ 0, 0, 0, 300 ]
          stops: [ [ 0, "rgba(0,180,248,0.6)" ], [ 1, "rgba(0,180,248,0.2)" ] ]

        lineWidth: 4
        states:
          hover:
            lineWidth: 5

        marker:
          enabled: false
          states:
            hover:
              enabled: true
              symbol: "circle"
              radius: 5
              lineWidth: 1

        pointInterval: 3600000
        pointStart: Date.UTC(2009, 9, 6, 0, 0, 0)

    legend:
      enabled: false

    series: [
      name: "Consumption"
      data: []
    ]
  )
  addPoints = (r) ->
    return  unless r instanceof Array
    data = []
    isEmpty = chart.series[0].data.length is 0
    i = 0
    len = r.length

    for item in r
      point = [ (new Date(item.created_at)).getTime(), +item.consumption ]
      (if isEmpty then data.push(point) else chart.series[0].addPoint(point, false))

    (if isEmpty then chart.series[0].setData(data) else chart.redraw())

  handleUpdate = (r) ->
    addPoints r
    lastUpdate = (new Date()).getTime() / 1000  if (r instanceof Array) and r.length > 0
    setTimeout fetch, 5000

  fetch = ->
    params = {}
    params.from = lastUpdate  if lastUpdate isnt null
    $.ajax
      type: "GET"
      url: "/api/observations"
      data: params
      dataType: 'json'
      success: handleUpdate

  fetch()