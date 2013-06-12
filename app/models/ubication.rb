class Ubication
  include Mongoid::Document
  attr_accessible :city, :country, :_id
  field :city, type: String
  field :country, type: String
end
