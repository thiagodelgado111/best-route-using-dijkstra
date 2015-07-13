
class InitialDatabase < ActiveRecord::Migration

	def self.up

		create_table :maps do |m|
			m.string :name
			m.timestamps
		end

		create_table :nodes do |m|
			m.string :departure
			m.string :destination
			m.decimal :distanceInKilometer
			m.timestamps
		end
	end

	def self.down
		drop_table :nodes
		drop_table :maps
	end
end