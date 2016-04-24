require 'mongo'
require_relative '../../lib/get_S3_pricing'

RSpec.describe ReadS3PricingData do

uri = database_uri

  context "offer-index versions for offerCode" do
    it "responds with an offer-index versions for a specified offerCode when there are any" do
      client = Mongo::Client.new(uri)
      client[:offer_codes].insert_one({'offerCode': 'foo', 'version': '20160424102324'})

      reader = ReadS3PricingData.new(uri)
      foo_offer_index_versions = reader.get_offer_index_versions('foo')
      expect(foo_offer_index_versions).to eql(['20160424102324'])
      client[:offer_codes].delete_many({})
    end
  end

  context "it reads term types given offer code" do
    it "returns term types when some exist for the offer code" do
      client = Mongo::Client.new(uri)
      client[:term_types].insert_one({'offerCode': 'foo'})

      reader = ReadS3PricingData.new(uri)
      foo_term_types = reader.get_term_types('foo')
      expect(foo_term_types.length).to be > 0

      client[:term_types].delete_many({})
    end
  end

end
