require 'mongo'
require_relative '../../lib/get_S3_pricing'

RSpec.describe ReadS3PricingData do

version = '20151209181126'
uri = database_uri

  context "it reads term types given offer code" do
    it "returns term types when some exist for the offer code" do
      client = Mongo::Client.new(uri)
      client[:term_types].insert_one({'offerCode': 'foo'})

      reader = ReadS3PricingData.new(version, uri)
      foo_term_types = reader.get_term_types('foo')
      expect(foo_term_types.length).to be > 0

      client[:term_types].delete_many({})
    end
  end

end
