require 'sinatra'
require 'sinatra/json'

require_relative '../lib/get_route53_pricing'

class Route53Pricing < Sinatra::Base

  db_url = ENV["DATABASE_URL"]
  raise "Database configuration not supplied as environment variable DATABASE_URL" unless db_url

  route53_pricing = GetRoute53Pricing.new(db_url)

  get '/v1/AmazonRoute53/product_families' do
    json route53_pricing.get_product_families
  end

end