require 'json'
require 'mongo'

require_relative 'write_pricing'

class WritePricingToDB
  include WritePricing

  def initialize(uri, file)
    @client = Mongo::Client.new(uri)

    @pricing = JSON.parse(file)

    @format_version = @pricing['formatVersion']
    @disclaimer = @pricing['disclaimer']
    @offer_code = @pricing['offerCode']
    @version = @pricing['version']
    @publication_date = @pricing['publicationDate']

    @products = @pricing['products']
    @terms = @pricing['terms']
  end

  def save_all
    save_offer_code
    save_products(@offer_code)
    save_term_types_term_codes_rate_codes(@offer_code)
  end

  def save_offer_code
    offer_code_doc = {'_id': "#{@offer_code}:#{@version}",
                      'formatVersion': @format_version,
                      'disclaimer': @disclaimer,
                      'offerCode': @offer_code,
                      'version': @version,
                      'publicationDate': @publication_date
    }
    @client[:offer_codes].replace_one({'offerCode': @offer_code, 'version': @version}, offer_code_doc, {:upsert => true})
  end

end