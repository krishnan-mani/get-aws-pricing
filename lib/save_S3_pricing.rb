require_relative 'write_S3_pricing_to_db'

class SaveS3Pricing

  def initialize(uri, s3_offer_index_file)
    @uri = uri
    @s3_offer_index_file = s3_offer_index_file
  end

  def save
    s3_offer_index = File.read(@s3_offer_index_file)
    WriteS3PricingToDB.new(@uri, s3_offer_index).save_all
  end

end
