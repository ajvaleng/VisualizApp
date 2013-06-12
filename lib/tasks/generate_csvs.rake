desc "generar los csvs para la aplicaciones mobiles"
task :generate_csvs  => :environment do
	# generate_stops
	# generate_routes
	# generate_route_shapes
	generate_shapes_stops
	# generate_shapes
end

def generate_stops
	require 'csv'
	include HTTParty
	require 'json'
	response = HTTParty.get('http://citppuc.cloudapp.net/api/paraderos')
	body = JSON.parse(response.body)
	CSV.open('csv/aplicacion/stops.csv', 'w') do |csv|
		body.each do |item|
			puts "Agragando paradero: "+item["codigo_paradero"]
			csv << [item["codigo_paradero"], item["codigo_paradero"], item["nombre_paradero"], item["gps_latitud"], item["gps_longitud"]]
		end
	end
end

# Quizas sea mejorar hacer el csv con los gtfs
def generate_routes
	require 'csv'
	include HTTParty
	require 'json'
	response = HTTParty.get('http://citppuc.cloudapp.net/api/lineas')
	body = JSON.parse(response.body)
	CSV.open('csv/aplicacion/routes.csv', 'w') do |csv|
		body.each do |item|
			puts "Agragando ruta: "+item["codigo_linea"]
			csv << [item["codigo_linea"], 0, 'FFFFFF']
		end
	end
end

# se necesita tener cargada la base de datos
def generate_route_shapes
	require 'csv'
	include HTTParty
	require 'json'
	response = HTTParty.get('http://citppuc.cloudapp.net/api/lineas')
	body = JSON.parse(response.body)
	CSV.open('csv/aplicacion/routeShapes.csv', 'w') do |csv|
		body.each do |item|
			json = nil
			while json.nil?
				response2 = HTTParty.get('http://citppuc.cloudapp.net/api/lineas/'+item["linea_id"].to_s)
				next if response2.body == ''
				json = JSON.parse(response2.body)
			end
			if json["secuencias"]
				json["secuencias"].each do |sec|
					puts "Agregando secuencia "+sec["codigo_secuencia"]
					if sec["horarios"]
						sec["horarios"].each do |h|
							dias = ''
							h["dias"].each do |dia|
								dias << dia+','
							end
							csv << [ item["codigo_linea"], sec["codigo_secuencia"], h["hora_inicio"], h["hora_termino"], dias]
						end
					else
						puts "No tiene horarios!"
					end


				end
			else
				puts "No tiene secuencias"
			end

		end
	end
end

def generate_shapes_stops
	require 'csv'
	include HTTParty
	require 'json'
	response = HTTParty.get('http://citppuc.cloudapp.net/api/lineas')
	body = JSON.parse(response.body)
	CSV.open('csv/aplicacion/shapeStops.csv', 'w') do |csv|
		body.each do |item|
			json = nil
			while json.nil?
				response2 = HTTParty.get('http://citppuc.cloudapp.net/api/lineas/'+item["linea_id"].to_s)
				next if response2.body == ''
				json = JSON.parse(response2.body)
			end
			if json["secuencias"]
				json["secuencias"].each do |sec|
					if sec["secuencia_paraderos"]
						sec["secuencia_paraderos"].each_with_index do |h, i|
							puts "Agregando paradero "+h["codigo_paradero"]+" para el shape "+sec["codigo_secuencia"]
							csv << [ sec["codigo_secuencia"], h["codigo_paradero"],i]
						end
					else
						puts "No tiene horarios!"
					end


				end
			else
				puts "No tiene secuencias"
			end

		end
	end
end

def generate_shapes
	require 'csv'
	puts 'Loading Shapes....'
	shape = nil
	index = 0
	CSV.open('csv/aplicacion/shapes.csv', 'w') do |csv|
		CSV.foreach("csv/shapes-v1.csv") do |row|
			puts 'loading shape '+row[0]+' '+row[3]
			csv << [ row[0], row[1], row[2], row[3]] if index.even?
			index += 1
		end
	end
	puts 'Shapes loaded'
end
