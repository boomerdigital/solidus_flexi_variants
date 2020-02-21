Spree::OrderContents.class_eval do

  private

  def add_to_line_item(variant, quantity, options = {})
    ### overrides existing Spree::OrderContents private method
    line_item = grab_line_item_by_variant(variant, false, options)

    line_item ||= order.line_items.new(
      quantity: 0,
      variant: variant,
    )

    #### separate options to standard, product_customizations, and add_hoc_option_values
    product_customizations_values = options[:product_customizations]
    ad_hoc_option_value_ids = options[:ad_hoc_option_values]
    standard_options = options.except(:product_customizations, :ad_hoc_option_values)
    ######

    line_item.quantity += quantity.to_i

    if standard_options.class == ActionController::Parameters
      line_item.options = standard_options.permit(Spree::PermittedAttributes.line_item_attributes).to_h
    else
      line_item.options = ActionController::Parameters.new(standard_options).permit(Spree::PermittedAttributes.line_item_attributes).to_h
    end

    ####### This line is added to make solidus_flexi_variants save customizations
    if product_customizations_values != nil || ad_hoc_option_value_ids != nil
      line_item = flexi_variants(variant, line_item, product_customizations_values, ad_hoc_option_value_ids)
    end
    ######

    if Spree.solidus_version < '2.5' && line_item.new_record?
      create_order_stock_locations(line_item, options[:stock_location_quantities])
    end

    line_item.target_shipment = options[:shipment]
    line_item.save!
    line_item
  end

  def flexi_variants(variant, line_item, product_customizations_values, ad_hoc_option_value_ids)
      product_customizations_values ||= []
      ad_hoc_option_value_ids ||= []
      customizations_offset_price = 0
      ad_hoc_options_offset_price = 0

      if product_customizations_values.count > 0
        customizations_offset_price = line_item.add_customizations(product_customizations_values)
      end

      # find, and add the configurations, if any.  these have not been fetched from the db yet.              line_items.first.variant_id
      # we postponed it (performance reasons) until we actually know we needed them
      if ad_hoc_option_value_ids.count > 0
        ad_hoc_options_offset_price = line_item.add_ad_hoc_option_values(ad_hoc_option_value_ids)
      end

      price_options = Spree::Config.pricing_options_class.new(currency: order.currency)
      line_item.price = variant.price_for(price_options).to_d + customizations_offset_price + ad_hoc_options_offset_price

      return line_item
  end

  # Bringing in since it was taken out of version 2.5
  def create_order_stock_locations(line_item, stock_location_quantities)
    return unless stock_location_quantities.present?
    order = line_item.order
    stock_location_quantities.each do |stock_location_id, quantity|
      order.order_stock_locations.create!(stock_location_id: stock_location_id, quantity: quantity, variant_id: line_item.variant_id) unless quantity.to_i.zero?
    end
  end
end
