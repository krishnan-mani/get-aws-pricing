require_relative '../../../api/route53_pricing'

RSpec.describe Route53Pricing do

  it 'GET product families' do
    get '/v1/AmazonRoute53/product_families'
    expect(last_response).to be_ok
  end

end