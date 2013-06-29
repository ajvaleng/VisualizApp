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
        @stops << {:title => stop.code,
         :lat => stop.lat,
         :lng => stop.lng,
         :width => 24,
         :height => 28,
         :picture => "../images/parada_24.png", :type => 'stop',
         :type => 'stop',
         :ida => i,
         :description => render_to_string(:partial => "/recorridos/stop_infowindow", :locals => { :stop => stop})}
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

    begin
      response = HTTParty.get('http://citppuc.cloudapp.net/api/buses/?id_linea='+id.to_s)
      @buses = JSON.parse(response.body)
    rescue
      @buses = []
    end

    respond_to do |format|
      format.js{
        @buses2 = []
        @signs = []
        @buses.each do |bus|
          # calculo del tiempo
          now = Time.new
          time = bus['fecha_hora_gps'].split('T')[1].split(':')
          t = Time.new(now.year, now.month, now.day, time[0].to_i, time[1].to_i, time[2].to_i,'+00:00')
          dif = (now - t).to_i
          dif_horas = (dif/3600).to_i
          dif -= dif_horas * 3600
          dif_minutos = (dif/60).to_i
          dif -= dif_minutos * 60
          dif_secs = dif
          texto_diferencia = "Hace "
          texto_diferencia <<  dif_horas.to_s+" horas, " if dif_horas > 0
          texto_diferencia <<  dif_minutos.to_s+" minutos, " if dif_minutos > 0
          texto_diferencia <<  dif_secs.to_s+" segundos." if dif_secs > 0

          # calcular la retencion
          # raise 'hh'
          recorrido = Recorrido.where(:id => id.to_i).first
          tiempo_retencion = 0
          retencion_correcta = nil

          bus['retenciones'].each do |retencion|
            bus['sentido'] == 'I' ? secuencia = recorrido.get_secuencias_of_the_hour[0] : secuencia = recorrido.get_secuencias_of_the_hour[1]
            stop = secuencia.stops.where(:id => retencion['paradero_id']).first
            if not stop.nil? and stop.origin_distance > bus['distancia_origen']
              tiempo_retencion = -1 if retencion['segundos_retencion'] >= 1
              tiempo_retencion = 1 if retencion['segundos_retencion'] <= -1
              retencion_correcta = retencion if retencion['segundos_retencion'] != 0
              break;
            end
          end

          @buses2 << {
            :lat => bus['gps_latitud'],
            :lng => bus['gps_longitud'],
            :width => 41,
            :height => 16,
            :direction => bus['sentido'],
            :patente => bus['patente'],
            :zindex => 1000,
            :type => 'bus',
            :stop => tiempo_retencion,
            :picture => "../images/bus_"+bus['sentido']+"_16.png",
            :description => render_to_string(:partial => "/buses/infowindow", :locals => { :bus => bus, :time_dif => texto_diferencia, :retencion => retencion_correcta})
          }
          @signs << {
            :lat => bus['gps_latitud'],
            :lng => bus['gps_longitud'],
            :width => 18,
            :height => 18,
            :zIndex => 1001,
            :picture => "../images/stop_18.png"
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