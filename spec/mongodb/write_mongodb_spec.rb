require 'rspec'
require 'mongo'

RSpec.describe 'replace_one' do

  it 'should insert a document in upsert mode when there are no matching documents' do
    @client = Mongo::Client.new(database_uri)
    doc = {'_id': 'abc', 'foo': 'bar'}
    @client[:test].delete_many({})

    @client[:test].replace_one({'_id': 'abc'}, doc, :upsert => true)
    expect(@client[:test].count).to eq 1

    results = @client[:test].find({'_id': 'abc'}).limit(1).collect do |found|
      found
    end

    expect(results.length).to eq 1
    expect(results.first['foo']).to eql 'bar'
  end

  it 'should update a document in upsert mode when there is a matching document' do
    @client = Mongo::Client.new(database_uri)
    old_doc = {'_id': 'abc', 'zak': 'klu'}
    @client[:test].delete_many({})
    @client[:test].insert_one(old_doc)

    doc = {'_id': 'abc', 'foo': 'bar'}
    @client[:test].replace_one({'_id': 'abc'}, doc, :upsert => true)
    expect(@client[:test].count).to eq 1

    results = @client[:test].find({'_id': 'abc'}).limit(1).collect do |found|
      found
    end

    expect(results.length).to eq 1
    expect(results.first['foo']).to eql 'bar'
  end
end