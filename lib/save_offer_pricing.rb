require_relative 'write_pricing_to_db'

class SaveOfferPricing

  def initialize(uri, offer_index_file)
    @uri = uri
    @offer_index_file = offer_index_file
  end

  def save
    offer_index = File.read(@offer_index_file)
    WritePricingToDB.new(@uri, offer_index).save_all
  end

end