class RecoleccionsController < ApplicationController  
  require 'open-uri'
  require 'json'
  
  # GET /recoleccions
  # GET /recoleccions.json
  def index
    @recoleccions = Recoleccion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recoleccions }
      format.csv { send_data @recoleccions.to_csv }
    end
  end

  # GET /recoleccions/1
  # GET /recoleccions/1.json
  def show
    @recoleccion = Recoleccion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recoleccion }
    end
  end

  # GET /recoleccions/new
  # GET /recoleccions/new.json
  def new
    @recoleccion = Recoleccion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recoleccion }
    end
  end

  # GET /recoleccions/1/edit
  def edit
    @recoleccion = Recoleccion.find(params[:id])
  end

  # POST /recoleccions
  # POST /recoleccions.json
  def create
    linea_id = nil
    recoleccions = Array.new
    all_recoleccion_valid = true
    numero_secuencia = nil
    linea_inicial = params[:linea]
    codigo_paradero_inicial=params[:paradero_inicial]
    secuencia_paraderos = nil
    
    begin    
      # Buscar todas las lineas para encontrar el id
      lineas = JSON.parse(open("http://citppuc.cloudapp.net/api/lineas").read)
      #Accion para encontra el id
      lineas.each do |linea|
        linea_id = linea["linea_id"] if linea["codigo_linea"] == linea_inicial
      end
      #fetch secuencia y encontrar la sequencia donde parte
      if linea_id
        secuencias = JSON.parse(open("http://citppuc.cloudapp.net/api/lineas/"+linea_id.to_s).read)
      end
      #Aqui cambiar la logica para los distintos horarios
      
      tr = DateTime.parse(params[:recoleccion][0]["llegada_paradero"])
      
      secuencias["secuencias"].each do |secuencia|
        secuencia["horarios"].each do |horario|
          if Recoleccion.cmp_wday horario["dias"], tr
            if( tr.strftime(horario["hora_inicio"]) < tr.strftime('%H:%M:%S') and tr.strftime('%H:%M:%S') < tr.strftime(horario["hora_termino"]) )
              secuencia["secuencia_paraderos"][0..-2].each do |paradero|
                if paradero["codigo_paradero"].casecmp(codigo_paradero_inicial) == 0
                  secuencia_paraderos = secuencia["secuencia_paraderos"]
                end
              end
            end
          end
        end
      end
      # secuencia_paraderos[0] -> primer paradero de la sequencia
      #Encuentra el numero de la sequencia a la que pertenece el paradero inicial
      secuencia_paraderos.each do |paradero|
        if  paradero["codigo_paradero"].casecmp(codigo_paradero_inicial) == 0
          numero_secuencia = paradero["numero_secuencia"].to_i 
          break
        end
      end
      #incializa las recolecciones
      params[:recoleccion].each do |recoleccion|
        #revisar cual es mas cercano
        sqr_error = 1000
        for i in 0..10
          i -= secuencia_paraderos.count+1  if numero_secuencia-5+i > secuencia_paraderos.count
          if secuencia_paraderos[numero_secuencia-5+i]
            sqr_error_act = (recoleccion["latitude"].to_f - secuencia_paraderos[numero_secuencia-5+i]["gps_latitud"].to_f)**2 +
                          (recoleccion["longitude"].to_f - secuencia_paraderos[numero_secuencia-5+i]["gps_longitud"].to_f)**2
            #puts sqr_error_act
            if (sqr_error >= sqr_error_act)
              sqr_error = sqr_error_act
              paradero = secuencia_paraderos[numero_secuencia-5+i]["codigo_paradero"]
            end
          end
        end
        #Setear datos genericos
        recoleccion["paradero"] = paradero 
        recoleccion["recorrido"] = linea_inicial
        recoleccion["patente"] = params[:patente]
        recoleccion["puerta"] = params[:puerta]
        recoleccion["nombre"] = params[:nombre]
        
        new_recoleccion = Recoleccion.new(recoleccion)
        recoleccions << new_recoleccion
        unless new_recoleccion.valid?
          all_recoleccion_valid = false
          invalid_recoleccion = recoleccion
        end
      end
      puts "Paradero ecnontrado"
    rescue
      puts "Error al encontrar el paradero"
      params[:recoleccion].each do |recoleccion|
        recoleccion["patente"] = params[:patente]
        recoleccion["puerta"] = params[:puerta]
        recoleccion["nombre"] = params[:nombre]
        recoleccion["recorrido"] = params[:linea]
        recoleccion["paradero"] = "error"+params[:paradero_inicial]
        new_recoleccion = Recoleccion.new(recoleccion)
        recoleccions << new_recoleccion
        unless new_recoleccion.valid?
          all_recoleccion_valid = false
          invalid_recoleccion = recoleccion
        end
      end
    end
    
    respond_to do |format|
      if all_recoleccion_valid
        @recoleccions = []
        recoleccions.each do |recoleccion|
          recoleccion.save
          @recoleccions << recoleccion
        end
        format.html { redirect_to @recoleccions.first, notice: 'Recoleccion was successfully created.' }
        format.json { render json: @recoleccions, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: invalid_recoleccion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recoleccions/1
  # PUT /recoleccions/1.json
  def update
    @recoleccion = Recoleccion.find(params[:id])

    respond_to do |format|
      if @recoleccion.update_attributes(params[:recoleccion])
        format.html { redirect_to @recoleccion, notice: 'Recoleccion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recoleccion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recoleccions/1
  # DELETE /recoleccions/1.json
  def destroy
    @recoleccion = Recoleccion.find(params[:id])
    @recoleccion.destroy

    respond_to do |format|
      format.html { redirect_to recoleccions_url }
      format.json { head :no_content }
    end
  end
end
