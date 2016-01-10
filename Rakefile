require 'yaml'
require_relative 'lib/save_S3_pricing'
require_relative 'lib/save_ec2_pricing'

task :default => :save_S3_pricing

task :save_S3_pricing do
  uri = ENV['MONGOLAB_URI']
  # uri = 'mongodb://127.0.0.1:27017/get_aws_pricing'
  s3_offer_index_file = 'resources/AmazonS3_2015-12-09_offer-index.json'
  SaveS3Pricing.new(uri, s3_offer_index_file).save
end

task :save_EC2_pricing do
  uri = ENV['MONGOLAB_URI']
  # uri = 'mongodb://127.0.0.1:27017/get_aws_pricing'
  ec2_offer_index_file = 'resources/AmazonEC2_2015-12-09_offer-index.json'
  SaveEC2Pricing.new(uri, ec2_offer_index_file).save
end
