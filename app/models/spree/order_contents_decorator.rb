Spree::OrderContents.class_eval do

  private
  #this whole thing needs a refactor!

  def add_to_line_item(variant, quantity, options = {})
    line_item = grab_line_item_by_variant(variant, false, options)

    line_item ||= order.line_items.new(
      quantity: 0,
      variant: variant,
      currency: order.currency
    )
    line_item.quantity += quantity.to_i
    line_item.options = ActionController::Parameters.new(options).permit(Spree::PermittedAttributes.line_item_attributes).to_h

    unless options.empty?
      product_customizations_values = options[:product_customizations] || []
      line_item.product_customizations = product_customizations_values
      product_customizations_values.each { |product_customization| product_customization.line_item = line_item }
      product_customizations_values.map(&:save) # it is now safe to save the customizations we built

      # find, and add the configurations, if any.  these have not been fetched from the db yet.              line_items.first.variant_id
      # we postponed it (performance reasons) until we actually know we needed them
      ad_hoc_option_value_ids = ( options[:ad_hoc_option_values].any? ? options[:ad_hoc_option_values] : [] )
      product_option_values = ad_hoc_option_value_ids.map do |cid|
        Spree::AdHocOptionValue.find(cid) if cid.present?
      end.compact
      line_item.ad_hoc_option_values = product_option_values

      offset_price = product_option_values.map(&:price_modifier).compact.sum + product_customizations_values.map {|product_customization| product_customization.price(variant)}.compact.sum

      line_item.price = variant.price_in(order.currency).amount + offset_price
    end

    if line_item.new_record?
      create_order_stock_locations(line_item, options[:stock_location_quantities])
    end

    line_item.target_shipment = options[:shipment]
    line_item.save!
    line_item
  end
end
