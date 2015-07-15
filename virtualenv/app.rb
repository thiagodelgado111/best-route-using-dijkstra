require 'bundler'
Bundler.require

require 'logger'
require './helpers/node_helper.rb'
require './dijkstra_graph.rb'
require './models/map.rb'
require './models/node.rb'


dbconfig = YAML.load(File.read("config/database.yml"))
RACK_ENV ||= ENV["RACK_ENV"] || "development"
ActiveRecord::Base.establish_connection dbconfig[RACK_ENV]
Dir.mkdir('log') if !File.exists?('log') || !File.directory?('log')
ActiveRecord::Base.logger = Logger.new(File.open("log/#{RACK_ENV}.log", "a+"))


configure do
	set :port, 8000
	set :bind, '0.0.0.0'
end

post '/map' do

	data = JSON.parse(request.body.read).to_hash	
	validates_general_data data

	map = data['map']
	validates_map_data map

	mapName = map['name']
	mapNodes = map['points']
	fuelCostPerLiter = data['fuelCostPerLiter']
	vehicleAutonomyPerKilometer = data['vehicleAutonomyPerKilometer']
	destination = data['destination']
	origin = data['origin']
	
	if mapNodes.nil? or mapNodes.empty?
		throw(:halt, [400, "Map dont have any point to calculate the distance\n"])
	end

	map = Map.find_by name: mapName
	graph = DijkstraGraph.new
	if map.nil?

		map = Map.new
		map.name = mapName
		map.nodes |= []

		# parse map nodes, get unique nodes and pre-process it to generate the graph
		distinctNodes = get_unique_nodes mapNodes
		distinctNodes.each do |nodeId, subNodes|

			children = {}
			subNodes.each do |_child|
				children[_child[:destination]] = _child[:distanceInKilometers]

				node = Node.new
				node.departure = nodeId
				node.destination = _child[:destination]
				node.distanceInKilometer = _child[:distanceInKilometers]

				map.nodes.push(node)
			end
			graph.add_node(nodeId, children)
		end	

		map.save!
	else
		# parse map nodes, get unique nodes and pre-process it to generate the graph
		distinctNodes = get_unique_nodes mapNodes
		distinctNodes.each do |nodeId, subNodes|

			children = {}
			subNodes.each do |_child|
				children[_child[:destination]] = _child[:distanceInKilometers]
			end
			graph.add_node(nodeId, children)
		end	
	end

	# calculate distance between nodes and find the best route
	path, distance = graph.calculate_optimal_route(data['origin'], data['destination'])
	if vehicleAutonomyPerKilometer == 0
		throw(:halt, [400, "Invalid vehicle autonomy\n"])
	end

	# print out the route that best fits
	maxDistance = distance[destination].fdiv(vehicleAutonomyPerKilometer) * fuelCostPerLiter
	"Best path: #{path.join(', ')}; Distance: #{distance[destination]}km(s), Cost: $ #{maxDistance};"
end

delete "/map" do

	if Map.where(name: params["name"]).any?
		Map.destroy_all(name: params["name"])
		"Map removed successfully!"
	else
		"Map not found!"		
	end
end