require 'sinatra'
require 'sinatra/json'

class Route53Pricing < Sinatra::Base

  get '/v1/AmazonRoute53/product_families' do
    json "Ok"
  end

end