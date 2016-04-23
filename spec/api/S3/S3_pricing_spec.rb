require_relative '../../../api/s3_pricing'

RSpec.describe S3Pricing do

  it 'GET product families' do
    get '/v1.0/AmazonS3/product_families'
    expect(last_response).to be_ok
    product_families = last_response.body

    expected_product_families = '["API Request","Data Transfer","Fee","Storage"]'
    expect(product_families).to eql(expected_product_families)
  end

end