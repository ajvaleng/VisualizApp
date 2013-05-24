class Character < ActiveRecord::Base
acts_as_gmappable :lat =>"latitude", :lng => "longitude"

attr_accessible :name, :adress, :longitude, :latitude, :gmaps
 def gmaps4rails_address
 adress
 end

end
