module WritePricing

  def save_products(offer_code)
    skus = @products.keys
    skus.each do |sku|
      product_doc = @products[sku].clone()
      product_doc['_id'] = "#{product_doc['sku']}:#{offer_code}"
      product_doc = decorate_doc_with_version(product_doc)

      @client[:skus].replace_one({'_id': product_doc['_id'], 'version': @version}, product_doc, {:upsert => true})
    end
  end

  def save_term_types_term_codes_rate_codes(offer_code)
    save_term_types(offer_code)
    if term_types_saved?(offer_code)
      save_term_types_for_skus(offer_code)
      save_offer_term_codes(offer_code)
    end
  end

  def save_term_types(offer_code)
    term_types = @terms.keys
    term_types.each do |term_type|
      term_doc = {'_id': "#{@version}:#{offer_code}:#{term_type}", 'termType': term_type}
      term_doc = decorate_doc_with_version(term_doc)

      @client[:term_types].replace_one(term_doc, term_doc, {:upsert => true})
    end
  end

  def term_types_saved?(offer_code)
    @client[:term_types].count({'offerCode': offer_code}) > 0
  end

  def save_term_types_for_skus(offer_code)
    term_types = get_term_types(offer_code)
    term_types.each do |term_type|
      @terms[term_type].keys.each do |sku|
        sku_and_term_type_doc = {"_id": "#{sku}:#{term_type}:#{offer_code}", "sku": sku, "termType": term_type, "offerCode": offer_code}
        sku_and_term_type_doc = decorate_doc_with_version(sku_and_term_type_doc)

        @client[:skus_and_term_types].replace_one(sku_and_term_type_doc, sku_and_term_type_doc, :upsert => true)
      end
    end
  end

  def save_offer_term_codes(offer_code)
    term_types = get_term_types(offer_code)
    term_types.each do |term_type|
      @terms[term_type].keys.each do |sku|
        offer_term_code_keys = @terms[term_type][sku].keys
        offer_term_code_keys.each do |offer_term_code_key|
          offer_term_code_data = @terms[term_type][sku][offer_term_code_key]
          offer_term_code_data['_id'] = "#{sku}:#{offer_term_code_key}"
          save_rate_codes(offer_term_code_key, offer_term_code_data['priceDimensions'])
          offer_term_code_data.delete('priceDimensions')

          @client[:offer_term_codes].replace_one({'_id': offer_term_code_data['_id']}, offer_term_code_data, :upsert => true)
        end
      end
    end
  end

  def save_rate_codes(offer_term_code_key, price_dimensions)
    rate_codes = price_dimensions.keys
    rate_codes.each do |rate_code|
      rate_code_doc = price_dimensions[rate_code]
      rate_code_doc['sku'] = offer_term_code_key.split('.').first
      rate_code_doc['offerTermCode'] = offer_term_code_key.split('.').last
      rate_code_doc['_id'] = rate_code

      @client[:rate_codes].replace_one({'_id': rate_code_doc['_id']}, rate_code_doc, :upsert => true)
    end
  end

  def get_term_types(offer_code)
    @client[:term_types].find({:offerCode => offer_code}).collect do |term_type_doc|
      term_type_doc['termType']
    end
  end

  def decorate_doc_with_version(doc)
    new_doc = doc.clone()
    new_doc['formatVersion'] = @format_version
    new_doc['offerCode'] = @offer_code
    new_doc['version'] = @version
    new_doc['publicationDate'] = @publication_date
    new_doc
  end

end