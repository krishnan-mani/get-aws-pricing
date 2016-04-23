require 'mongo'
require 'yaml'

require_relative 'lib/save_offer_pricing'


task :default => ["clear_data", "save_all"]

desc 'Clear database'
task :clear_data do
  run_locally = ENV['RUN_LOCAL'] && ENV['RUN_LOCAL'].eql?('true') || false

  uri = ENV['MONGOLAB_URI']
  if run_locally
    uri = 'mongodb://127.0.0.1:27017/get_aws_pricing'
  end
  db = Mongo::Client.new(uri).database
  db.drop
end

desc 'Saves all pricing'
task :save_all do
  run_locally = ENV['RUN_LOCAL'] && ENV['RUN_LOCAL'].eql?('true') || false

  uri = ENV['MONGOLAB_URI']
  if run_locally
    uri = 'mongodb://127.0.0.1:27017/get_aws_pricing'
  end

  offer_index_files = Dir.entries("resources").select { |x| x.include?("offer-index") and x.end_with?(".json") }
  offer_index_files.each do |filename|
    offer_index_filename = File.join('resources', filename)
    SaveOfferPricing.new(uri, offer_index_filename).save
  end
end
