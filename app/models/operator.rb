class Operator
  include Mongoid::Document
  attr_accessible :name, :code, :_id
  field :name, type: String
  field :code, type: String
end
