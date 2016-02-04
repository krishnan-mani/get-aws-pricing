require 'mongo'

class VersionAgnosticPricingDataReader

  def initialize(uri)
    @client = Mongo::Client.new(uri)
  end

  def list_published_price_list_versions
    @client[:skus].find.distinct("version").sort
  end

  def list_published_price_list_versions_by_offer_code
    offer_codes = @client[:skus].find.distinct("offerCode").sort

    offer_codes_and_published_versions = {}
    offer_codes.each do |offer_code|
      offer_codes_and_published_versions[offer_code] = @client[:skus].find({"offerCode": offer_code}).distinct("version").sort
    end

    offer_codes_and_published_versions
  end

  def list_all_offer_codes
    @client[:skus].find.distinct("offerCode").sort
  end


end