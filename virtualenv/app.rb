require 'bundler'
Bundler.require
require 'logger'
require './models/map.rb'
require './models/node.rb'


dbconfig = YAML.load(File.read("config/database.yml"))
RACK_ENV ||= ENV["RACK_ENV"] || "development"
ActiveRecord::Base.establish_connection dbconfig[RACK_ENV]
Dir.mkdir('log') if !File.exists?('log') || !File.directory?('log')
ActiveRecord::Base.logger = Logger.new(File.open("log/#{RACK_ENV}.log", "a+"))


configure do
	set :port, 5000
	set :bind, '0.0.0.0'
end


get '/' do
	Node.all.inspect
end


post '/map' do
	data = JSON.parse(request.body.read).to_hash
	
	map = data["map"]
	mapName = map["name"]
	mapNodes = map["points"]

	map = Map.find_by name: mapName
	
	if map.nil?

		map = Map.new
		map.name = mapName

		mapNodes.each do |_node|

			node = Node.new
			node.departure = _node["departure"]
			node.destination = _node["destination"]
			node.distanceInKilometer = _node["distanceInKilometer"]

			map.nodes.push(node)
		end

		map.save!
	end

	@foundMap = map
	@foundMap.inspect
end


delete "/map" do

	if Map.where(name: params["name"]).any?
		Map.destroy_all(name: params["name"])
		"Map removed successfully!"
	else
		"Map not found!"		
	end
end