require_relative 'read_EC2_pricing_data'

class GetEC2Pricing

  def initialize(uri)
    @reader = ReadEC2PricingData.new(uri)
  end

  def get_product_families(version)
    @reader.get_product_families(version)
  end

end