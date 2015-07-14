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



get '/' do
	Node.all.inspect
end

post '/map' do
	data = JSON.parse(request.body.read).to_hash	
	validates_general_data data

	map = data['map']
	validates_map_data map

	mapName = map['name']
	mapNodes = map['points']


	if mapNodes.empty?
		throw(:halt, [400, "Invalid map\n"])
	end

	map = Map.find_by name: mapName
	if map.nil?

		map = Map.new
		map.name = mapName
		



		
		distinctNodes = get_unique_nodes mapNodes
		
		graph = DijkstraGraph.new
		distinctNodes.each do |k,v|

			children = {}
			v.each do |_child|
				children[_child[:destination]] = _child[:distanceInKilometers]
			end
			graph.add_node(k, children)
		end

		graph.calculate_optimal_route(data['origin'], data['destination'])		
	end
end

delete "/map" do

	if Map.where(name: params["name"]).any?
		Map.destroy_all(name: params["name"])
		"Map removed successfully!"
	else
		"Map not found!"		
	end
end