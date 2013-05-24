class CreateCreateCities < ActiveRecord::Migration
  def change
    create_table :create_cities do |t|
      t.string :name
      t.string :state
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      t.integer :population

      t.timestamps
    end
  end
end
