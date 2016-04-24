require_relative 'api/aws_pricing'
require_relative 'api/s3_pricing'
require_relative 'api/ec2_pricing'

run Rack::Cascade.new [AWSPricingAPI, S3Pricing, EC2Pricing]