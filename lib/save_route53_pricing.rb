require_relative 'write_route53_pricing_to_db'

class SaveRoute53Pricing

  def initialize(uri, route53_offer_index_file)
    @uri = uri
    @route53_offer_index_file = route53_offer_index_file
  end

  def save
    route53_offer_index = File.read(@route53_offer_index_file)
    WriteRoute53PricingToDB.new(@uri, route53_offer_index).save_all
  end

end