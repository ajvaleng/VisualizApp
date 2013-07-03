class Role
  include Mongoid::Document

  scope :not_administrable, where(:name.in => [ "Operador", "AdminOperador" ])

  has_and_belongs_to_many :users
  belongs_to :resource, :polymorphic => true
  
  field :name, :type => String
  index({ :name => 1 }, { :unique => true })


  index({
    :name => 1,
    :resource_type => 1,
    :resource_id => 1
  },
  { :unique => true})
  



end
