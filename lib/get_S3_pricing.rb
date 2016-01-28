require_relative 'read_S3_pricing_data'
require_relative 'offer_codes'

class GetS3Pricing

  def initialize(version, uri)
    @version = version
    @reader = ReadS3PricingData.new(@version, uri)
  end

  def get_fee_pricing(options)
    find_options = {:offerCode => "AmazonS3"}
    find_options[:productFamily] = "Fee"

    fee_code = options[:feeCode]
    raise ArgumentError, "Missing fee code" unless fee_code
    find_options[:feeCode] = fee_code

    location = options[:location]
    raise ArgumentError, "Missing location" unless location
    find_options[:location] = location

    @reader.get_fee_pricing(find_options)
  end

  def get_storage_pricing(options)
    find_options = {:offerCode => "AmazonS3"}
    find_options[:productFamily] = "Storage"

    location = options[:location]
    raise ArgumentError, "Missing location" unless location
    find_options[:location] = options[:location]

    volume_type = options[:volumeType]
    raise ArgumentError, "Missing volume type" unless volume_type
    find_options[:volumeType] = options[:volumeType]

    @reader.get_storage_pricing(find_options)
  end

  def get_api_request_pricing(options)
    find_options = {:offerCode => "AmazonS3"}
    find_options[:productFamily] = "API Request"

    group = options[:group]
    raise ArgumentError, "Missing group" unless group
    find_options[:group] = group

    location = options[:location]
    raise ArgumentError, "Missing location" unless location
    find_options[:location] = location

    @reader.get_api_request_pricing(find_options)
  end

  def get_data_transfer_pricing(options)
    find_options = {:offerCode => "AmazonS3"}
    find_options[:productFamily] = "Data Transfer"

    fromLocation = options[:fromLocation]
    raise ArgumentError, "Missing from location" unless fromLocation
    find_options[:fromLocation] = fromLocation

    toLocation = options[:toLocation]
    raise ArgumentError, "Missing to location" unless toLocation
    find_options[:toLocation] = toLocation

    @reader.get_data_transfer_pricing(find_options)
  end

  def get_product_families
    @reader.get_product_families
  end

  def list_storage_volume_types
    @reader.list_storage_volume_types(S3_OFFER_CODE)
  end

  def list_data_transfer_from_locations
    @reader.list_data_transfer_from_locations
  end

  def list_data_transfer_to_locations
    @reader.list_data_transfer_to_locations
  end

  def get_fee_codes
    @reader.get_fee_codes
  end

  def get_api_request_groups
    @reader.get_api_request_groups
  end

end
