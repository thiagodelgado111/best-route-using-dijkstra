class ChangeNodeDistanceColumn < ActiveRecord::Migration
   def self.up
  	remove_column :nodes, :distanceInKilometer
  	add_column :nodes, :distanceInKilometers, :decimal
  end
end
