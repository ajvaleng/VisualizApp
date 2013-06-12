# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	# enable chosen js
  $('.chzn-select').chosen
    allow_single_deselect: true
    no_results_text: 'No hay resultados'

   $('.chzn-select').change ->
    if this.value
      url = '/recorridos/'+this.value+'.js'
      console.log url
      Gmaps.map.clearMarkers()
      Gmaps.map.destroy_polylines()
      $.get url
      get_buses(this.value)


  get_buses = (linea_id) ->
    url = '/buses.js?linea_id='+linea_id
    console.log url
    $.get url
