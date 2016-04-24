require_relative '../../../api/aws_pricing'

RSpec.describe AWSPricingAPI do

  it 'GET published API versions' do
    get '/meta/versions'
    expect(last_response).to be_ok
    versions = last_response.body

    expect(versions).to eql('["1.0"]')
  end

end