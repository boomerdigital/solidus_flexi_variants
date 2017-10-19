Spree::OrderContents.class_eval do

  private
  #this whole thing needs a refactor!

  def add_to_line_item(variant, quantity, options = {})
    puts "--- using Spree::OrderContents.add_to_line_item defined in Solidus Flexi Variants core"

    #options (customization options must be the same to add to previous line item)
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

      #get all option values ids from params
      ad_hoc_option_value_ids = ( options[:ad_hoc_option_values].present? ? options[:ad_hoc_option_values] : [] )

      #retrieve ad_hoc_option_values with associated option type
      product_option_values = ad_hoc_option_value_ids.map do |cid|
        Spree::AdHocOptionValue.includes(:ad_hoc_option_type).find(cid) if cid.present?
      end.compact

      multiplicative_price_ratio = 1
      additive_price = 0
      i = 0
      product_option_values.each do |pov|
        if pov.ad_hoc_option_type.price_modifier_type
          #signifies that this is a multiplier ratio acting on the line item
          if i == 0
            #reset multiplicative price ratio on first appearance of ratio type
            multiplicative_price_ratio = 0
            i = 1
          end
          multiplicative_price_ratio += pov.price_modifier
        else
          #signifies that this is an additive amount acting on the line item
          additive_price += pov.price_modifier
        end
      end


      line_item.ad_hoc_option_values = product_option_values

      #price calculation for additive
      offset_price = additive_price + product_customizations_values.map {|product_customization| product_customization.price(variant)}.compact.sum

      #price for line item (normal price + offset for additive) * multiplicative price ratio
      line_item.price = (variant.price_in(order.currency).amount + offset_price) * multiplicative_price_ratio
    end

    if line_item.new_record?
      create_order_stock_locations(line_item, options[:stock_location_quantities])
    end

    line_item.target_shipment = options[:shipment]
    line_item.save!
    line_item
  end
end
