
module NodeHelpers

	def validates_map_data( data )

		unless data.has_key?('map')
			throw(:halt, [400, "Map doens't have a name or is empty\n"])
		end

		_map = data['map']
		unless _map.has_key?("name") and _map.has_key?("points")
			throw(:halt, [400, "Map doens't have a name or is empty\n"])
		end

		if _map["name"].blank?
			throw(:halt, [400, "Map doens't have a name\n"])
		end
	end

	def validates_route_data( _data )
		
		unless _data.has_key?("name") and _data.has_key?("fuelCostPerLiter") and _data.has_key?("vehicleAutonomyPerKilometer") and _data.has_key?("origin") and _data.has_key?("destination")
			throw(:halt, [400, "Map not found or invalid\n"])
		end
	end

	def get_unique_nodes( mapNodes )

		if mapNodes.nil? or mapNodes.empty?
			throw(:halt, [400, "Map dont have any point to calculate the distance\n"])
		end

		departures = mapNodes.map do |node|
			{
				departure: node['departure'],
				destination: node['destination'],
				distanceInKilometers: node['distanceInKilometers']
			}
		end

		destinations = mapNodes.map do |node|
			{
				departure: node['destination'],
				destination: node['departure'],
				distanceInKilometers: node['distanceInKilometers']
			}
		end

		distinctNodes = departures.concat(destinations).group_by { |_node| _node[:departure] }
		distinctNodes
	end
	
end