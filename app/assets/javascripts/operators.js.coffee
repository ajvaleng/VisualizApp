# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
buses = null;
stops = null;
$ ->
  linea_id = 0
  refreshIntervalId = 0
  en_tramite = false;
	# enable chosen js
  $('.chzn-select').chosen
    allow_single_deselect: true
    no_results_text: 'No hay resultados'

   $('.chzn-select').change ->
    if this.value
      linea_id = this.value
      url = '/recorridos/'+linea_id+'.js'
      console.log url
      Gmaps.map.clearMarkers()
      Gmaps.map.destroy_polylines()
      $.get url
      clearInterval(refreshIntervalId)
      get_buses()
      refreshIntervalId = setInterval( get_buses, 10000)
      console.log 'id: '+refreshIntervalId


  get_buses = () ->
    if !en_tramite
      en_tramite = true;
      console.log 'Bajando Buses...'
      url = '/buses.js?linea_id='+linea_id
      console.log url
      $.get url, (data) ->
          en_tramite = false
