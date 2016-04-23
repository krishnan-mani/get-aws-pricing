require_relative '../lib/get_S3_pricing'

RSpec.describe GetS3Pricing do

  version = '20151209181126'
  uri = database_uri(true)

  context "for S3 Storage for the version 20151209181126" do
    it "returns the pricing for the specified region for the specified volume type" do

=begin
  Storage pricing for S3 in the Asia Pacific (Singapore) region for Standard Storage:
  - First 1 TB/month costs $0.03 per GB
  - Next 49 TB/month costs $0.0295 per GB
  - Next 450 TB/month costs $0.0290 per GB
  - Next 500 TB/month costs $0.0285 per GB
  - Next 4000 TB/month costs $0.0280 per GB
  - Over 5000 TB/month costs $0.0275 per GB
=end

      get_s3_pricing = GetS3Pricing.new(version, uri)
      got_pricing = get_s3_pricing.get_storage_pricing(
          :location => 'Asia Pacific (Singapore)',
          :productFamily => 'Storage',
          :volumeType => 'Standard'
      )

      expected_pricing = [
          {
              "description": "$0.0300 per GB - first 1 TB / month of storage used",
              "beginRange": "0",
              "endRange": "1024",
              "unit": "GB-Mo",
              "pricePerUnit": {
                  "USD": "0.0300000000"
              }
          },
          {
              "description": "$0.0295 per GB - next 49 TB / month of storage used",
              "beginRange": "1024",
              "endRange": "51200",
              "unit": "GB-Mo",
              "pricePerUnit": {
                  "USD": "0.0295000000"
              }
          },
          {
              "description": "$0.0285 per GB - next 500 TB / month of storage used",
              "beginRange": "512000",
              "endRange": "1024000",
              "unit": "GB-Mo",
              "pricePerUnit": {
                  "USD": "0.0285000000"
              }
          },
          {
              "description": "$0.0280 per GB - next 4000 TB / month of storage used",
              "beginRange": "1024000",
              "endRange": "5120000",
              "unit": "GB-Mo",
              "pricePerUnit": {
                  "USD": "0.0280000000"
              }
          },
          {
              "description": "$0.0290 per GB - next 450 TB / month of storage used",
              "beginRange": "51200",
              "endRange": "512000",
              "unit": "GB-Mo",
              "pricePerUnit": {
                  "USD": "0.0290000000"
              }
          },
          {
              "description": "$0.0275 per GB - storage used /  month over 5000 TB",
              "beginRange": "5120000",
              "endRange": "Inf",
              "unit": "GB-Mo",
              "pricePerUnit": {
                  "USD": "0.0275000000"
              }
          }
      ]

      expect(got_pricing.length).to eq(expected_pricing.length)
    end
  end

=begin
  Request pricing for S3 in the Asia Pacific (Singapore) region:
  - PUT, COPY, POST or LIST requests cost $0.005 per 1,000 requests
  - GET and all other requests cost $0.004 per 10,000 requests
  - Delete requests cost nothing
=end

=begin
  Request pricing for S3 in the Asia Pacific (Singapore) region for Standard- Infrequent Access:
  - PUT, COPY or POST requests cost $0.01 per 1,000 requests
  - GET and all other requests cost $0.01 per 10,000 requests
  - Lifecycle Transition Requests into Standard-Infrequent Access cost $0.01 per 1,000 requests
  - Data retrievals costs $0.01 per GB
=end

end
