require 'json'
require 'mongo'

require_relative 'write_pricing'
require_relative 'offer_codes'
require_relative 'read_S3_pricing_data'

class WriteS3PricingToDB
  include WritePricing

  def initialize(uri, file)
    @client = Mongo::Client.new(uri)

    @s3_pricing = JSON.parse(file)
    @version = @s3_pricing['version']
    @reader = ReadS3PricingData.new(@version, uri)

    @format_version = @s3_pricing['formatVersion']
    @offer_code = @s3_pricing['offerCode']
    @publication_date = @s3_pricing['publicationDate']

    @products = @s3_pricing['products']
    @terms = @s3_pricing['terms']
  end

  def save_all
    save_products
    save_term_types
    if term_types_saved?
      save_term_types_for_skus
      save_offer_term_codes
    end
  end

  def save_term_types
    term_types = @terms.keys
    term_types.each do |term_type|
      product_doc = decorate_doc_with_version({'_id': "#{S3_OFFER_CODE}:#{term_type}", 'termType': term_type})
      @client[:term_types].insert_one(product_doc)
    end
  end

  def term_types_saved?
    @client[:term_types].count > 0
  end

  def save_term_types_for_skus
    term_types = @reader.get_term_types(S3_OFFER_CODE)
    term_types.each do |term_type|
      @terms[term_type].keys.each do |sku|
        @client[:skus_and_term_types].insert_one(decorate_doc_with_version({"sku": sku, "termType": term_type}))
      end
    end
  end

  def save_offer_term_codes
    term_types = @reader.get_term_types(S3_OFFER_CODE)
    term_types.each do |term_type|
      @terms[term_type].keys.each do |sku|
        offer_term_code_keys = @terms[term_type][sku].keys
        offer_term_code_keys.each do |offer_term_code_key|
          offer_term_code_data = @terms[term_type][sku][offer_term_code_key]
          save_rate_codes(offer_term_code_key, offer_term_code_data['priceDimensions'])
          offer_term_code_data.delete('priceDimensions')
          @client[:offer_term_codes].insert_one(offer_term_code_data)
        end
      end
    end
  end

  def save_rate_codes(offer_term_code_key, price_dimensions)
    rate_codes = price_dimensions.keys
    rate_codes.each do |rate_code|
      rate_code_data = price_dimensions[rate_code]
      rate_code_data['sku'] = offer_term_code_key.split('.').first
      rate_code_data['offerTermCode'] = offer_term_code_key.split('.').last
      @client[:rate_codes].insert_one(rate_code_data)
    end
  end

end
