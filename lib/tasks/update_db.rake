namespace :db do

	desc "update from clients api"
	task :update_db  => :environment do
		update_ubications
		update_operators
		update_recorridos
	end
	desc "update from clients api"
	task :update_ubications  => :environment do
		update_ubications
	end
	desc "update from clients api"
	task :update_operators  => :environment do
		update_operators
	end
	desc "update from clients api"
	task :update_recorridos  => :environment do
		update_recorridos
	end

	desc "load shapes from csv"
	task :load_shapes  => :environment do
		load_shapes
	end

	def update_ubications
		Ubication.delete_all
		include HTTParty
		require 'json'
		response = HTTParty.get('http://citppuc.cloudapp.net/api/ubicaciones')
		body = JSON.parse(response.body)
		body.each do |ubication|
			puts "Agregando la ubicacion: "+ubication["ciudad"]
			Ubication.create(
			:_id => ubication["ubicacion_id"],
			:city => ubication["ciudad"],
			:country => ubication["pais"]
			)
		end
	end

	def update_operators
		Operator.delete_all
		include HTTParty
		require 'json'
		response = HTTParty.get('http://citppuc.cloudapp.net/api/operadores')
		body = JSON.parse(response.body)
		body.each do |item|
			puts "Agregando operador: "+item["nombre_operador"]
			Operator.create(
			:_id => item["operador_id"],
			:name => item["nombre_operador"],
			:code => item["codigo_operador"]
			)
		end
	end

	def update_recorridos
		Recorrido.delete_all
		include HTTParty
		require 'json'
		body = ''
		response = HTTParty.get('http://citppuc.cloudapp.net/api/lineas')
		body = JSON.parse(response.body)
		body.each do |item|
			puts "Agregando recorrido: "+item["codigo_linea"]
			recorrido = Recorrido.create(
			:_id => item["linea_id"],
			:code => item["codigo_linea"],
			:operator_id => item["operador_id"],
			:secuencias => [],
			:stops => [],
			)
			json = nil
			while json.nil?
				response2 = HTTParty.get('http://citppuc.cloudapp.net/api/lineas/'+item["linea_id"].to_s)
				next if response2.body == ''
				json = JSON.parse(response2.body)

			end
			if json["secuencias"]
				json["secuencias"].each do |sec|
					puts "Agregando secuencia "+sec["codigo_secuencia"]
					secuencia = Secuencia.new(
					:id => sec["secuencia_id"],
					:code => sec["codigo_secuencia"],
					:direction => sec["sentido"],
					:horarios => []
					)

					if sec["horarios"]
						sec["horarios"].each do |h|
							horario = Horario.new(
							:days => h["dias"],
							:start_time => h["hora_inicio"],
							:end_time => h["hora_termino"]
							)
							secuencia.horarios << horario
						end
					else
						puts "No tiene horarios!"
					end

					if sec["secuencia_paraderos"]
						sec["secuencia_paraderos"].each do |h|
							stop = Stop.new(
							:id => h["paradero_id"],
							:code => h["codigo_paradero"],
							:number => h["numero_secuencia"],
							:name => h["nombre_paradero"],
							:lat => h["gps_latitud"],
							:lng => h["gps_longitud"],
							:origin_distance => h["distancia_origen"],
							:velocity => h["velocidad_tramo"],
							)
							secuencia.stops << stop
						end
					else
						puts "No tiene paraderos!"
					end

					recorrido.secuencias << secuencia
				end
			else
				puts "No tiene secuencias"
			end

		end
	end

	def load_shapes
		require 'csv'
		puts 'Loading Shapes....'
		Shape.delete_all
		shape = nil
		CSV.foreach("csv/shapes-v1.csv") do |row|
			if shape.nil? or shape.code != row[0]
				puts 'loading shape '+row[0]
				shape = Shape.create(
				:code => row[0],
				:points => []
				)
			end
			puts 'loading point '+row[1]+' '+row[2]
			point = Point.new(
			:lat => row[1],
			:lng => row[2]
			)
			shape.points << point

		end
		puts 'Shapes loaded'
	end

end


