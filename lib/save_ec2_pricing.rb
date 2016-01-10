require_relative 'write_ec2_pricing_to_db'

class SaveEC2Pricing

  def initialize(uri, ec2_offer_index_file)
    @uri = uri
    @ec2_offer_index_file = ec2_offer_index_file
  end

  def save
    ec2_offer_index = File.read(@ec2_offer_index_file)
    WriteEC2PricingToDB.new(@uri, ec2_offer_index).save_all
  end

end