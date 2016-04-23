require 'sinatra'
require 'sinatra/json'
require 'sinatra/config_file'
require 'docdsl'

require_relative '../lib/get_ec2_pricing'

class EC2Pricing < Sinatra::Base
  register Sinatra::ConfigFile
  register Sinatra::DocDsl

  configured_uri = ENV['MONGOLAB_URI']
  begin
    config_file 'config/config.yml'
    configured_uri = settings.database_uri
  end

  raise 'No URI was configured' unless configured_uri
  set :uri, configured_uri

  ec2_pricing = GetEC2Pricing.new(settings.uri)

  page do
    title "An API for AWS Price List"
    header "AWS pricing for Amazon EC2"
    footer "
- Contact km[AT]krishnanm[DOT]com
"
  end

  get "/v1.0/AmazonEC2/:version/product_families" do
    version = params[:version]
    json ec2_pricing.get_product_families(version)
  end

end