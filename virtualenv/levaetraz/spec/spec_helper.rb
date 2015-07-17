require 'rubygems'
require 'bundler'
Bundler.require

require 'rack/test'
require 'rspec'


require File.expand_path '../../config/environment.rb', __FILE__
require File.expand_path '../../app.rb', __FILE__

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() ItineraryService end
end

# For RSpec 2.x
RSpec.configure { |c| c.include RSpecMixin }