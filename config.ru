require_relative 'api/s3_pricing'
require_relative 'api/ec2_pricing'

run Rack::Cascade.new [S3Pricing, EC2Pricing]