require_relative 'write_pricing'

class OfferCodePricingWriter
  include WritePricing

  def initialize(pricing)
    @offer_code = pricing['offerCode']
    @version = pricing['version']
    @format_version = pricing['formatVersion']
    @publication_date = pricing['publicationDate']

    @products = pricing['products']
    @terms = pricing['terms']
  end

  def save_all
    save_products(@offer_code)
    save_term_types_term_codes_rate_codes(@offer_code)
  end

end