require 'json'
require 'mongo'

require_relative 'offer_codes'
require_relative 'offer_code_pricing_writer'

class WriteOfferPricingToDB

  def initialize(version, uri)
    @client = Mongo::Client.new(uri)

    @offer_codes_and_pricing = {}
    OFFER_CODES_AT_VERSION[version].collect do |offer_code|
      offer_index_file = File.read(File.join('resources', "#{offer_code}_#{VERSION_PUBLISHING_DATES[version]}_offer-index.json"))

      pricing_json = JSON.parse(offer_index_file)
      pricing = {}
      pricing['offerCode'] = pricing_json['offerCode']
      pricing['version'] = pricing_json['version']
      pricing['formatVersion'] = pricing_json['formatVersion']
      pricing['publicationDate'] = pricing_json['publicationDate']

      pricing['products'] = pricing_json['products']
      pricing['terms'] = pricing_json['terms']
      @offer_codes_and_pricing[offer_code] = pricing
    end
  end

  def save_pricing_for_offer_codes
    @offer_codes_and_pricing.each do |offer_code, pricing|
      OfferCodePricingWriter.new(pricing).save_all
    end
  end

end