class Shape
  include Mongoid::Document
  field :code, type: String
  embeds_many :points
end

class Point
  include Mongoid::Document
  attr_accessible :lat, :lng
  field :lat, type: Float
  field :lng, type: Float
  embedded_in :shape
end
