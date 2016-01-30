require 'json'
require 'mongo'

require_relative 'write_pricing'
require_relative 'offer_codes'

class WriteS3PricingToDB
  include WritePricing

  def initialize(uri, file)
    @client = Mongo::Client.new(uri)

    @s3_pricing = JSON.parse(file)

    @version = @s3_pricing['version']
    @format_version = @s3_pricing['formatVersion']
    @offer_code = @s3_pricing['offerCode']
    @publication_date = @s3_pricing['publicationDate']

    @products = @s3_pricing['products']
    @terms = @s3_pricing['terms']
  end

  def save_all
    save_products(S3_OFFER_CODE)
    save_term_types_term_codes_rate_codes(S3_OFFER_CODE)
  end

end
