require 'json'
require 'mongo'

require_relative 'write_pricing'

class WritePricingToDB
  include WritePricing

  def initialize(uri, file)
    @client = Mongo::Client.new(uri)

    @pricing = JSON.parse(file)
    @offer_code = @pricing['offerCode']

    @version = @pricing['version']
    @format_version = @pricing['formatVersion']
    @publication_date = @pricing['publicationDate']

    @products = @pricing['products']
    @terms = @pricing['terms']
  end

  def save_all
    save_products(@offer_code)
    save_term_types_term_codes_rate_codes(@offer_code)
  end

end