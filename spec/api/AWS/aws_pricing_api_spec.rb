require_relative '../../../api/aws_pricing'

RSpec.describe AWSPricingAPI do

  it 'GET published API versions' do
    get '/meta/versions'
    expect(last_response).to be_ok
    versions = last_response.body

    expect(versions).to eql('["1.0"]')
  end

  it 'GET published offer codes' do
    get '/v1.0/offer_codes'
    expect(last_response).to be_ok
    offer_codes = last_response.body

    expected_offer_codes = '["AmazonEC2","AmazonRoute53","AmazonS3"]'
    expect(offer_codes).to eql(expected_offer_codes)
  end

end