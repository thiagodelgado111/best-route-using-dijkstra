require 'rubygems'
require 'bundler'
Bundler.require

require File.join(File.dirname(__FILE__), 'config/environment.rb')
require File.join(File.dirname(__FILE__), 'app')


run ItineraryService
