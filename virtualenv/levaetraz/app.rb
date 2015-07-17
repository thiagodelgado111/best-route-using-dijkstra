
require 'sinatra/base'

require './helpers/node_helper.rb'
require './dijkstra_graph.rb'
require './models/map.rb'
require './models/node.rb'


class ItineraryService < Sinatra::Base

	helpers NodeHelpers
	configure do
		set :port, 8000
		set :bind, '0.0.0.0'
	end

	get "/get" do

		content_type :json

		map = Map.find_by(name: params['name'])
		if map.nil?
			"Map not found!"
		else
			{ :map => map, :points=> map.nodes }.to_json
		end
	end

	post '/best_route' do

		data = JSON.parse(request.body.read).to_hash
		if data.nil?
			throw(:halt, [400, "Request is invalid\n"])
		end

		validates_route_data data

		mapName = data['name']
		fuelCostPerLiter = data['fuelCostPerLiter']
		vehicleAutonomyPerKilometer = data['vehicleAutonomyPerKilometer']
		destination = data['destination']
		origin = data['origin']


		map = Map.find_by(name: mapName)
		if map.nil?
			throw(:halt, [400, "Map not found\n"])
		end

		graph = DijkstraGraph.new
		nodes = get_unique_nodes map.nodes.to_a

		# parse map nodes, get unique nodes and pre-process it to store and futurely generate the graph
		nodes.each do |nodeId, subNodes|

			children = {}
			subNodes.each do |_child|
				children[_child[:destination]] = _child[:distanceInKilometers]
			end
			graph.add_node(nodeId, children)
		end

		# calculate distance between nodes and find the best route
		path, distance = graph.calculate_optimal_route(origin, destination)
		if vehicleAutonomyPerKilometer <= 0
			throw(:halt, [400, "Invalid vehicle autonomy\n"])
		end

		if fuelCostPerLiter <= 0
			throw(:halt, [400, "Invalid cost per liter\n"])
		end

		# print out the route that best fits
		maxDistance = distance[destination].fdiv(vehicleAutonomyPerKilometer) * fuelCostPerLiter
		"Best path: #{path.join(', ')}; Distance: #{distance[destination]}km(s), Cost: $ #{maxDistance};"
	end


	post '/map' do

		data = JSON.parse(request.body.read).to_hash
		if data.nil?
			throw(:halt, [400, "Request is invalid\n"])
		end

		validates_map_data data

		map = data['map']

		mapName = map['name']
		mapNodes = map['points']
		if mapNodes.nil? or mapNodes.empty?
			throw(:halt, [400, "Map dont have any point to calculate the distance\n"])
		end

		map = Map.find_or_initialize_by(name: mapName)
		map.nodes = []
		# parse map nodes, get unique nodes and pre-process it to store and futurely generate the graph
		nodes = get_unique_nodes mapNodes
		nodes.each do |nodeId, children|

			children.each do |_child|
				map.nodes.build(:departure=> nodeId, :destination=> _child[:destination], :distanceInKilometers=>_child[:distanceInKilometers])
			end
		end

		unless map.valid?
			return map.errors
		end
		map.save!
		"Map '#{mapName}' data persisted!"
	end

	delete "/map" do

		if Map.where(name: params["name"]).any?
			Map.destroy_all(name: params["name"])
			"Map removed successfully!"
		else
			"Map not found!"
		end
	end
end
