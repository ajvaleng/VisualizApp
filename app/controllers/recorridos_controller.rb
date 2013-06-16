class RecorridosController < ApplicationController
  # GET /recorridos
  # GET /recorridos.json
  def index
    @recorridos = Recorrido.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recorridos }
    end
  end

  # GET /recorridos/1
  # GET /recorridos/1.json
  def show
    recorrido = Recorrido.find(params[:id].to_i)
    @polylines = []
    @stops = []
    # @shapes = Shape.all
    secuencias = recorrido.get_secuencias_of_the_hour

    secuencias.each_with_index do |s, i|
      @polylines[i] = []
      Shape.where(:code => s.code).first.points.each_with_index do |p, e|
        e == 0 ? @polylines[i] << {:strokeColor => '#000000', :icons => [], :lat => p.lat, :lng => p.lng } : @polylines[i] << {:lat => p.lat, :lng => p.lng }
      end
      s.stops.each do |stop|
        @stops << {:title => stop.code, :lat => stop.lat, :lng => stop.lng,:width => 24, :height => 28, :picture => "../images/parada_24.png" }
      end
    end


    respond_to do |format|
      format.js
      format.html
      format.json { render json: @recorrido }
    end
  end

  def get_buses
    if params[:linea_id]
      id = params[:linea_id]
    else
      id = Recorrido.where(:code => params[:linea_codigo]).first.id
    end

    response = HTTParty.get('http://citppuc.cloudapp.net/api/buses/?id_linea='+id.to_s)
    @buses = JSON.parse(response.body)

    respond_to do |format|
      format.js{
        @buses2 = []
        @buses3 = []
        @buses.each do |bus|
          @buses2 << {
            :lat => bus['gps_latitud'],
            :lng => bus['gps_longitud'],
            :width => 41,
            :height => 16,
            :direction => bus['sentido'],
            :patente => bus['patente'],
            :zIndex => 3,
            :picture => "../images/bus_"+bus['sentido']+"_16.png",
            :description => render_to_string(:partial => "/buses/infowindow", :locals => { :bus => bus})
          }
          @buses3 << {
            :lat => bus['gps_latitud'],
            :lng => bus['gps_longitud'],
            :width => 41,
            :height => 16,
            :direction => bus['sentido'],
            :patente => bus['patente'],
            :zIndex => 3,
            :picture => "../images/bus_16.png",
            :description => render_to_string(:partial => "/buses/infowindow", :locals => { :bus => bus})
          }
        end
      }
      format.json {
        if params[:direction]
          @buses2 = []
          @buses.each do |bus|
            if bus["sentido"] == params[:direction]
              now = Time.new
              time = bus['fecha_hora_gps'].split('T')[1].split(':')
              t = Time.new(now.year, now.month, now.day, time[0].to_i, time[1].to_i, time[2].to_i,'+00:00')
              @buses2 << {
                :lat => bus['gps_latitud'],
                :lng => bus['gps_longitud'],
                :time_dif => (now - t).to_i,
                :patente => bus['patente']
              }
            end
          end
          render json: @buses2
        else
          render json: @buses
        end
      }
    end
  end

end