
helpers do

	def validates_map_data _map

		if _map.nil?
      		throw(:halt, [400, "Bad Request\n"])
		end

		unless _map.has_key?("name") and _map.has_key?("points") 
			throw(:halt, [400, "Bad Request\n"])
		end
	end

	def validates_general_data _data
		if _data.nil?
      		throw(:halt, [400, "Bad Request\n"])
		end

		unless _data.has_key?("map") and _data.has_key?("fuelCostPerLiter") and _data.has_key?("vehicleAutonomyPerKilometer") and _data.has_key?("origin") and _data.has_key?("destination")
			throw(:halt, [400, "Bad Request\n"])
		end
	end

	def get_unique_nodes mapNodes

		unless mapNodes.nil? or mapNodes.empty?
      		throw(:halt, [400, "Bad Request\n"])
		end

		unless mapNodes.has_key?("")

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