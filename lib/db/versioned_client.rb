require 'mongo'

class VersionedClient < Mongo::Collection

  def initialize(version, uri)
    @version = version
    @client = Mongo::Client.new(uri)
  end

  def find(collection, filter = nil, options = {})
    filter_with_version = {"version": @version}
    if filter
      filter_with_version = filter.merge(filter_with_version)
    end

    resp = @client[collection].find(filter_with_version, options)
    resp
  end

end