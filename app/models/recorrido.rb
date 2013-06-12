class Recorrido
	include Mongoid::Document
	attr_accessible :code, :_id, :operator_id
	field :code, type: String
	field :operator_id, type: Integer
	embeds_many :secuencias

	def get_secuencias_of_the_hour
		now = Time.new.in_time_zone('Santiago')
		dia_a_buscar = ''
		dia_a_buscar = 'Lunes' if now.monday?
		dia_a_buscar = 'Martes' if now.tuesday?
		dia_a_buscar = 'Miercoles' if now.wednesday?
		dia_a_buscar = 'Jueves' if now.thursday?
		dia_a_buscar = 'Viernes' if now.friday?
		dia_a_buscar = 'Sabado' if now.saturday?
		dia_a_buscar = 'Domingo' if now.sunday?

		secuencias = []

		self.secuencias.each do |sec|
			sec.horarios.each do |h|
				if h.days.include?(dia_a_buscar)
					time_split = h.start_time.split(':')
					start_time = Time.new(now.year, now.month, now.day, time_split[0].to_i, time_split[1].to_i, time_split[2].to_i, "-04:00")
					time_split = h.end_time.split(':')
					end_time = Time.new(now.year, now.month, now.day, time_split[0].to_i, time_split[1].to_i, time_split[2].to_i, "-04:00")

					secuencias << sec if (now <=> start_time) == 1 and (now <=> end_time) == -1

				end
			end
		end
		return secuencias
	end
end

class Secuencia
	include Mongoid::Document
	attr_accessible :id, :code, :direction
	field :id, type: Integer
	field :code, type: String
	field :direction, type: String
	embeds_many :horarios
	embeds_many :stops
	embedded_in :recorrido
end

class Horario
	include Mongoid::Document
	attr_accessible :days, :start_time, :end_time
	field :days, type: Array
	field :start_time, type: String
	field :end_time, type: String
	embedded_in :secuencia
end

class Stop
	include Mongoid::Document
	attr_accessible :id, :code, :number, :name, :lat,:lng,:origin_distance,:velocity
	field :id, type: Integer
	field :code, type: String
	field :number, type: Integer
	field :name, type: String
	field :lat, type: Float
	field :lng, type: Float
	field :origin_distance, type: Float
	field :velocity, type: Float

	embedded_in :secuencia
end
