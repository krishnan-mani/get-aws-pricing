require 'yaml'
require_relative 'lib/save_S3_pricing'
require_relative 'lib/save_ec2_pricing'
require_relative 'lib/save_route53_pricing'

task :default => ["save_all"]

desc 'Saves all pricing'
task :save_all => [ :save_S3_pricing, :save_EC2_pricing, :save_Route53_pricing ] do
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