require_relative '../../api/ec2_pricing'

RSpec.describe EC2Pricing do

  it 'GET product families' do

    get '/v1.0/AmazonEC2/20151209144527/product_families'
    expect(last_response).to be_ok
    product_families = last_response.body

    expected_product_families = '["Compute Instance","Data Transfer","Dedicated Host","Fee","IP Address","Load Balancer","Storage","Storage Snapshot","System Operation"]'
    expect(product_families).to eql(expected_product_families)
  end

end