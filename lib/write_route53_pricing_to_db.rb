require 'mongo'
require 'json'

require_relative 'offer_codes'
require_relative 'write_pricing'

class WriteRoute53PricingToDB
  include WritePricing

  def initialize(uri, file)
    @client = Mongo::Client.new(uri)

    @route53_pricing = JSON.parse(file)
    @version = @route53_pricing['version']
    @format_version = @route53_pricing['formatVersion']
    @offer_code = @route53_pricing['offerCode']
    @publication_date = @route53_pricing['publicationDate']

    @products = @route53_pricing['products']
    @terms = @route53_pricing['terms']
  end

  def save_all
    save_products(ROUTE53_OFFER_CODE)
    save_term_types_term_codes_rate_codes(ROUTE53_OFFER_CODE)
  end

end