class Recoleccion
  include Mongoid::Document
  field :presonas_suben, :type => Integer, :default => 0
  field :personas_bajan, :type => Integer, :default => 0
  field :longitude, :type => Float, :default => 0
  field :latitude, :type => Float, :default => 0
  field :paradero
  field :recorrido
  field :patente
  field :nombre
  field :puerta, :type => Integer, :default => 0
  field :llegada_paradero, :type => DateTime
  field :salida_paradero, :type => DateTime
  
  def self.cmp_wday (dias, fecha)
    semana = ["Domingo","Lunes","Martes","Miercoles","Jueves","Viernes","Sabado",]
    dias.include? (semana[fecha.wday])
  end
  
  
  rails_admin do
    list do
      field :presonas_suben
      field :personas_bajan
      field :paradero
      field :recorrido
      field :patente
      field :nombre
      field :puerta
      field :llegada_paradero
      field :salida_paradero
    end
  end
  
end