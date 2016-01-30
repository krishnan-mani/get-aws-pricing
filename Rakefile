require 'mongo'
require 'yaml'

require_relative 'lib/save_S3_pricing'
require_relative 'lib/save_ec2_pricing'
require_relative 'lib/save_route53_pricing'
require_relative 'lib/save_offer_pricing'


task :default => ["save_all"]

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
    uri = 'mongodb://127.0.0.1:27017/all_get_aws_pricing'
  end

  offer_index_files = Dir.entries("resources").select { |x| x.include?("offer-index") and x.end_with?(".json") }
  offer_index_files.each do |filename|
    offer_index_filename = File.join('resources', filename)
    SaveOfferPricing.new(uri, offer_index_filename).save
  end
end

desc 'Saves S3 pricing only'
task :save_S3_pricing do
  run_locally = ENV['RUN_LOCAL'] && ENV['RUN_LOCAL'].eql?('true') || false

  uri = ENV['MONGOLAB_URI']
  if run_locally
    uri = 'mongodb://127.0.0.1:27017/get_aws_pricing'
  end

  s3_offer_index_file = 'resources/AmazonS3_2015-12-09_offer-index.json'
  SaveS3Pricing.new(uri, s3_offer_index_file).save
end

desc 'Save EC2 pricing only'
task :save_EC2_pricing, [:run_local] do |t, args|
  run_locally = ENV['RUN_LOCAL'] && ENV['RUN_LOCAL'].eql?('true') || false

  uri = ENV['MONGOLAB_URI']
  if run_locally
    uri = 'mongodb://127.0.0.1:27017/get_aws_pricing'
  end

  ec2_offer_index_file = 'resources/AmazonEC2_2015-12-09_offer-index.json'
  SaveEC2Pricing.new(uri, ec2_offer_index_file).save
end

desc 'Save Route 53 pricing only'
task :save_Route53_pricing, [:run_local] do |t, args|
  run_locally = ENV['RUN_LOCAL'] && ENV['RUN_LOCAL'].eql?('true') || false

  uri = ENV['MONGOLAB_URI']
  if run_locally
    uri = 'mongodb://127.0.0.1:27017/get_aws_pricing'
  end

  route53_offer_index_file = 'resources/AmazonRoute53_2015-12-09_offer-index.json'
  SaveRoute53Pricing.new(uri, route53_offer_index_file).save
end