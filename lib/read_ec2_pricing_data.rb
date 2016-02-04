require 'mongo'

class ReadEC2PricingData

  def initialize(uri)
    @client = Mongo::Client.new(uri)
  end

  def get_product_families(version)
    @client[:skus].find({"offerCode": "AmazonEC2", "version": version}).distinct("productFamily").sort
  end

end