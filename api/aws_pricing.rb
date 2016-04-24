require 'sinatra'
require 'sinatra/json'
require 'docdsl'

class AWSPricingAPI < Sinatra::Base
  register Sinatra::DocDsl

  page do
    title "An API for AWS Price List"
    header "get-aws-pricing"
    introduction "
AWS now publishes pricing information for services via [AWS Price List](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/price-changes.html).
This API lets you query the same

- The API currently lets you query price information.
- Pull requests invited at [github](https://github.com/krishnan-mani/get-aws-pricing)
"
    footer "
- Contact km[AT]krishnanm[DOT]com
"
  end

  doc_endpoint "/doc"

  documentation "List Price List versions published by AWS"
  get "/meta/versions" do
    json ["1.0"]
  end

end