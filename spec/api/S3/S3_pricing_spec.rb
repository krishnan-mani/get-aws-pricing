require_relative '../../../api/s3_pricing'

RSpec.describe S3Pricing do

  it 'GET versions of S3 offer-index available via this API' do
    get '/v1.0/AmazonS3/offer-index_versions'
    expect(last_response).to be_ok
    offer_index_versions = last_response.body

    expect(offer_index_versions).to eql('["20160107021538"]')
  end

  it 'GET product families' do
    get '/v1.0/AmazonS3/product_families'
    expect(last_response).to be_ok
    product_families = last_response.body

    expected_product_families = '["API Request","Data Transfer","Fee","Storage"]'
    expect(product_families).to eql(expected_product_families)
  end

end