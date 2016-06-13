require 'mongo'


class GetRoute53Pricing

  def initialize(db_url)
    @client = Mongo::Client.new(db_url)
  end

  def get_product_families
    @client[:skus].distinct("productFamily").sort
  end


end