# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
buses = null
stops = null
show_ida = true
show_vuelta = true
$ ->
  linea_id = 0
  refreshIntervalId = 0
  en_tramite = false
	# enable chosen js
  $('.chzn-select').chosen
    allow_single_deselect: true
    no_results_text: 'No hay resultados'

   $('.chzn-select').change ->
    if this.value
      $('#opciones').css('visibility','visible')
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

  $('#check_ida').change ->
    if $(this).is(':checked')
      show_ida = true
      show_stops_and_buses(0)
      if show_vuelta
        Gmaps.map.replacePolylines(polylines, false)
      else
        Gmaps.map.replacePolylines([polylines[0]], false)
    else
      show_ida = false
      hide_stops_and_buses(0)
      if show_vuelta
        Gmaps.map.replacePolylines([polylines[1]], false)
      else
        Gmaps.map.destroy_polylines()

  $('#check_vuelta').change ->
    if $(this).is(':checked')
      show_vuelta = true
      show_stops_and_buses(1)
      if show_ida
        Gmaps.map.replacePolylines(polylines, false)
      else
        Gmaps.map.replacePolylines([polylines[1]], false)
    else
      show_vuelta = false
      hide_stops_and_buses(1)
      if show_ida
        Gmaps.map.replacePolylines([polylines[0]], false)
      else
        Gmaps.map.destroy_polylines()


  get_buses = () ->
    if !en_tramite
      en_tramite = true;
      console.log 'Bajando Buses...'
      url = '/buses.js?linea_id='+linea_id
      console.log url
      $.get url, (data) ->
        en_tramite = false
        show_or_hide_buses()

  show_stops_and_buses = (ida) ->
    if ida == 0
      direction = 'I'
    else
      direction = 'R'
    $.each Gmaps.map.markers, (index, marker) ->
      if (marker.type == 'stop' && marker.ida == ida) || ((marker.type == 'bus' || marker.type == 'sign') && marker.direction == direction)
        # markers.push(marker)
        Gmaps.map.showMarker(marker)
    # console.log markers
    # Gmaps.map.addMarkers(markers)

  hide_stops_and_buses = (ida) ->
    if ida == 0
      direction = 'I'
    else
      direction = 'R'
    $.each Gmaps.map.markers, (index, marker) ->
      if (marker.type == 'stop' && marker.ida == ida) || ((marker.type == 'bus' || marker.type == 'sign') && marker.direction == direction)
        Gmaps.map.hideMarker(marker);

  show_or_hide_buses = () ->
    if not $('#check_ida').is(':checked')
      hide_stops_and_buses(0)
    if not $('#check_vuelta').is(':checked')
      hide_stops_and_buses(1)