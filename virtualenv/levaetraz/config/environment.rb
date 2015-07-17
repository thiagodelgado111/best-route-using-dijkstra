require 'yaml'
require 'logger'

RACK_ENV ||= ENV["RACK_ENV"] || "development"
dbconfig = YAML.load(File.read('config/database.yml'))

ActiveRecord::Base.establish_connection dbconfig[RACK_ENV]

Dir.mkdir('log') if !File.exists?('log') || !File.directory?('log')
ActiveRecord::Base.logger = Logger.new(File.open("log/#{RACK_ENV}.log", "a+"))
