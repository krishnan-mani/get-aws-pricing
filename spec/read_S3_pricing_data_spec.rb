require 'mongo'
require_relative '../lib/read_S3_pricing_data'

RSpec.describe ReadS3PricingData do

version = '20151209181126'
uri = 'mongodb://127.0.0.1:27017/get_aws_pricing_test'

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