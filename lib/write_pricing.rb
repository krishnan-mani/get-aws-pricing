module WritePricing

  def save_products
    skus = @products.keys
    skus.each do |sku|
      product_doc = @products[sku].clone()
      product_doc['_id'] = @products[sku]['sku']
      product_doc = decorate_doc_with_version(product_doc)
      @client[:skus].insert_one(product_doc)
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