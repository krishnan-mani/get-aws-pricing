require 'mongo'

class ReadS3PricingData

  def initialize(uri)
    @client = Mongo::Client.new(uri)
  end

  def get_offer_index_versions(offer_code)
    @client[:offer_codes].find({'offerCode': offer_code}).distinct("version").sort
  end

  def list_storage_volume_types(offer_code)
    @client[:skus].find({"offerCode": offer_code}).distinct("attributes.volumeType").sort
  end

  def get_product_families(offer_code)
    @client[:skus].find({"offerCode": offer_code}).distinct("productFamily").sort
  end

  def list_data_transfer_from_locations
    @client[:skus].find.distinct("attributes.fromLocation").sort
  end

  def list_data_transfer_to_locations
    @client[:skus].find.distinct("attributes.toLocation").sort
  end

  def get_fee_codes
    fee_codes = @client[:skus].find.distinct("attributes.feeCode")
    fee_descriptions = []
    fee_codes.each do |code|
      @client[:skus].find({"attributes.feeCode": code}).limit(1).each do |doc|
        fee_descriptions << {"feeCode" => code, "feeDescription" => doc['attributes']['feeDescription']}
      end
    end

    fee_descriptions
  end

  def get_api_request_groups(offer_code)
    groups = @client[:skus].find({"offerCode": offer_code}).distinct("attributes.group")
    group_descriptions = []
    groups.each do |group|
      @client[:skus].find({"attributes.group": group}).limit(1).each do |doc|
        group_descriptions << {"group" => group, "groupDescription" => doc['attributes']['groupDescription']}
      end
    end

    group_descriptions
  end

  def get_fee_pricing(options)
    sku_doc = find_sku({
                           "offerCode": options[:offerCode],
                           "productFamily": options[:productFamily],
                           "attributes.feeCode": options[:feeCode],
                           "attributes.location": options[:location]
                       })
    find_rate_codes_for_sku(sku_doc)
  end

  def find_rate_codes_for_sku(sku_doc)
    sku = sku_doc['sku']

    offer_term_code_doc = find_offer_term_code(sku)
    offer_term_code = offer_term_code_doc['offerTermCode']

    find_rate_codes(sku, offer_term_code)
  end

  def get_api_request_pricing(options)
    sku_doc = find_sku({
                           "offerCode": options[:offerCode],
                           "productFamily": options[:productFamily],
                           "attributes.group": options[:group],
                           "attributes.location": options[:location]
                       })
    find_rate_codes_for_sku(sku_doc)
  end

  def get_data_transfer_pricing(options)
    sku_doc = find_sku({
                           "offerCode": options[:offerCode],
                           "productFamily": options[:productFamily],
                           "attributes.fromLocation": options[:fromLocation],
                           "attributes.toLocation": options[:toLocation]
                       })
    find_rate_codes_for_sku(sku_doc)
  end

  def get_storage_pricing(options)
    sku_doc = find_sku({
                           "offerCode": options[:offerCode],
                           "productFamily": options[:productFamily],
                           "attributes.location": options[:location],
                           "attributes.volumeType": options[:volumeType]
                       })
    find_rate_codes_for_sku(sku_doc)
  end

  def find_rate_codes(sku, offer_term_code)
    @client[:rate_codes].find({"sku": sku, "offerTermCode": offer_term_code}).collect do |rate_code|
      rate_code.delete("_id")
      rate_code
    end
  end

  def find_sku(options)
    @client[:skus].find(options).limit(1).first
  end

  def find_offer_term_code(sku)
    @client[:offer_term_codes].find({"sku": sku}).limit(1).first
  end

  def get_term_types(offer_code)
    @client[:term_types].find({:offerCode => offer_code}).collect do |term_type_doc|
      term_type_doc['termType']
    end
  end

end
