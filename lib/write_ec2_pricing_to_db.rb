require 'mongo'
require 'json'

require_relative 'offer_codes'
require_relative 'write_pricing'

class WriteEC2PricingToDB
  include WritePricing

  def initialize(uri, file)
    @client = Mongo::Client.new(uri)

    @ec2_pricing = JSON.parse(file)
    @version = @ec2_pricing['version']
    @format_version = @ec2_pricing['formatVersion']
    @offer_code = @ec2_pricing['offerCode']
    @publication_date = @ec2_pricing['publicationDate']

    @products = @ec2_pricing['products']
  end

  def save_all
    save_products
  end

end