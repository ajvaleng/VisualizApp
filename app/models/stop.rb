class Stop
  include Mongoid::Document
  field :code, type: String
  field :name, type: String
  field :lat, type: Float
  field :lng, type: Float
end
