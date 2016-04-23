require 'sinatra'
require 'sinatra/json'
require "sinatra/config_file"
require 'docdsl'

require_relative 'constants'
require_relative '../resources/versions'
require_relative '../resources/published_services'
require_relative '../lib/get_S3_pricing'


class S3Pricing < Sinatra::Base
  register Sinatra::ConfigFile
  register Sinatra::DocDsl

  configured_uri = ENV['MONGOLAB_URI']
  begin
    config_file 'config/config.yml'
    configured_uri = settings.database_uri
  end

  raise 'No URI was configured' unless configured_uri
  set :uri, configured_uri

  s3_pricing = GetS3Pricing.new("#{VERSION_ONE}", settings.uri)


  page do
    title "An API for AWS Price List"
    header "get-aws-pricing"
    introduction "
AWS now publishes pricing information for services via [AWS Price List](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/price-changes.html).
This API lets you query the same

- The API currently lets you query S3 price information. More 'offer code's are being added, one at a time
- The API will be versioned once it is stable
- Pull requests invited at [github](https://github.com/krishnan-mani/get-aws-pricing)
"

    footer "
- Contact km[AT]krishnanm[DOT]com
"
  end

  documentation "List Price List versions published by AWS"
  get "/meta/versions" do
    json VERSIONS
  end

  documentation "List Amazon S3 'offer code's. An offer code (like 'AmazonS3') is an AWS service that has pricing published via Price List."
  get "/meta/#{VERSION_ONE}/offer_codes_published" do
    json PUBLISHED_SERVICES.sort
  end

  documentation "List Amazon S3 'product families'. A product family (like 'Storage') is one form of pricing on S3"

  get "/v1.0/AmazonS3/product_families" do
    json s3_pricing.get_product_families
  end

  documentation "List Amazon S3 'volume type's for the 'Storage' product family"
  get "/#{VERSION_ONE}/AmazonS3/Storage/volume_types" do
    json s3_pricing.list_storage_volume_types
  end

  documentation "Get Amazon S3 pricing for 'Storage' product family, by volume type and location" do
    query_param :volumeType, "A volume type in S3 from at GET /#{VERSION_ONE}/AmazonS3/Storage/volume_types"
    query_param :location, "An AWS region"
  end
  get "/#{VERSION_ONE}/AmazonS3/Storage/pricing" do
    volumeType = params['volumeType']
    location = PricingAPIConstants::REGIONS_AND_LOCATIONS[params['location']]

    json s3_pricing.get_storage_pricing(
        :location => location,
        :volumeType => volumeType
    )
  end

  documentation "List Amazon S3 'fee code's for the 'Fee' product family"
  get "/#{VERSION_ONE}/AmazonS3/Fee/fee_codes" do
    json s3_pricing.get_fee_codes
  end

  documentation "Get Amazon S3 pricing for the 'Fee' product family, by fee code and location" do
    query_param :feeCode, "One of the fee codes from GET /#{VERSION_ONE}/AmazonS3/Fee/fee_codes"
    query_param :location, "An AWS region"
  end
  get "/#{VERSION_ONE}/AmazonS3/Fee/pricing" do
    feeCode = params['feeCode']
    location = PricingAPIConstants::REGIONS_AND_LOCATIONS[params['location']]

    json s3_pricing.get_fee_pricing(
        :feeCode => feeCode,
        :location => location
    )
  end

  documentation "Get Amazon S3 'group's for the 'API Request' product family"
  get "/#{VERSION_ONE}/AmazonS3/API Request/groups" do
    json s3_pricing.get_api_request_groups
  end

  documentation "Get Amazon S3 pricing for 'API Request' product family, by group and location" do
    query_param :group, "One of the groups from GET /#{VERSION_ONE}/AmazonS3/API Request/groups"
    query_param :location, "An AWS region"
  end
  get "/#{VERSION_ONE}/AmazonS3/API Request/pricing" do
    group = params['group']
    location = PricingAPIConstants::REGIONS_AND_LOCATIONS[params['location']]

    json s3_pricing.get_api_request_pricing(
        :group => group,
        :location => location
    )
  end

  documentation "List locations for 'from location' with the Amazon S3 'Data Transfer' product family"
  get "/#{VERSION_ONE}/AmazonS3/Data Transfer/from_locations" do
    published_from_locations = s3_pricing.list_data_transfer_from_locations
    api_from_locations = {}
    published_from_locations.each do |location|
      api_from_locations[location] = PricingAPIConstants::LOCATIONS_AND_REGIONS[location]
    end
    json api_from_locations
  end

  documentation "List locations for 'to location' for the Amazon S3 'Data Transfer' product family"
  get "/#{VERSION_ONE}/AmazonS3/Data Transfer/to_locations" do
    published_to_locations = s3_pricing.list_data_transfer_to_locations
    api_to_locations = {}
    published_to_locations.each do |location|
      api_to_locations[location] = PricingAPIConstants::LOCATIONS_AND_REGIONS[location]
    end
    json api_to_locations
  end

  documentation "Get Amazon S3 pricing for 'Data Transfer' product family, by from location and to location" do
    query_param :fromLocation, "An AWS region or other location from GET /#{VERSION_ONE}/AmazonS3/Data Transfer/from_locations"
    query_param :toLocation, "An AWS region or other location from listed at GET /#{VERSION_ONE}/AmazonS3/Data Transfer/to_locations"
  end
  get "/#{VERSION_ONE}/AmazonS3/Data Transfer/pricing" do
    fromLocation = PricingAPIConstants::REGIONS_AND_LOCATIONS[params['fromLocation']]
    halt 404, "Invalid from location, see GET /#{VERSION_ONE}/AmazonS3/Data Transfer/from_locations" unless valid_from_location?(fromLocation)

    toLocation = PricingAPIConstants::REGIONS_AND_LOCATIONS[params['toLocation']]
    halt 404, "Invalid to location, see GET /#{VERSION_ONE}/AmazonS3/Data Transfer/to_locations" unless valid_to_location?(toLocation)

    json s3_pricing.get_data_transfer_pricing(
        :fromLocation => fromLocation,
        :toLocation => toLocation
    )
  end

  doc_endpoint "/doc"

  documentation "Nothing under /. Go look at /doc"
  get "/" do
    redirect "/doc"
  end

  private

  def valid_from_location?(location)
    GetS3Pricing.new("#{VERSION_ONE}", settings.uri).list_data_transfer_from_locations.include?(location)
  end

  def valid_to_location?(location)
    GetS3Pricing.new("#{VERSION_ONE}", settings.uri).list_data_transfer_to_locations.include?(location)
  end

end
