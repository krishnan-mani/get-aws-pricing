require 'sinatra'
require 'sinatra/json'
require 'sinatra/config_file'
require 'docdsl'

require_relative '../lib/version_agnostic_pricing_data_reader'

class AWSPricingAPI < Sinatra::Base
  register Sinatra::ConfigFile
  register Sinatra::DocDsl

  # Mongo::Logger.logger       = ::Logger.new('mongo.log')
  # Mongo::Logger.logger.level = ::Logger::INFO

  configured_uri = ENV['MONGOLAB_URI']
  begin
    config_file 'config/config.yml'
    configured_uri = settings.database_uri
  end

  raise 'No URI was configured' unless configured_uri
  set :uri, configured_uri

  reader = VersionAgnosticPricingDataReader.new(settings.uri)

  page do
    title "An API for AWS Price List"
    header "get-aws-pricing"
    introduction "
AWS now publishes pricing information for services via [AWS Price List](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/price-changes.html).
This API lets you query the same

- The API currently lets you query price information.
- Pull requests invited at [github](https://github.com/krishnan-mani/get-aws-pricing)
"
    footer "
- Contact km[AT]krishnanm[DOT]com
"
  end

  doc_endpoint "/doc"

  documentation "List versions for this API"
  get "/meta/versions" do
    json ["1.0"]
  end

  documentation "List offer codes published"
  get '/v1.0/offer_codes' do
    json reader.list_all_offer_codes
  end

end