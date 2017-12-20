unless !defined?(Spree::ProductsController)
  Spree::OrdersController.class_eval do

    include ProductCustomizations
    include AdHocUtils

    # is there a better way to make sure options are passed into add order contents?
    def populate
      #format ad_hoc_options, product_customizations, and customization_price
      order    = current_order(create_order_if_necessary: true)
      variant  = Spree::Variant.find(params[:variant_id])
      quantity = params[:quantity].to_i
      # 2,147,483,647 is crazy. See issue https://github.com/spree/spree/issues/2695.
      if quantity.between?(1, 2_147_483_647)
        begin
          order.contents.add(variant, quantity, format_options(params[:options], params[:customization_price]))
        rescue ActiveRecord::RecordInvalid => e
          error = e.record.errors.full_messages.join(", ")
        end
      else
        error = Spree.t(:please_enter_reasonable_quantity)
      end

      if error
        flash[:error] = error
        redirect_back_or_default(spree.root_path)
      else
        respond_with(order) do |format|
          format.html { redirect_to cart_path }
        end
      end
    end

    private

    def format_options(opts_params, customization_price = nil)
      options_hash = opts_params || {}
      options_hash[:ad_hoc_option_values] = ad_hoc_option_value_ids
      if options_hash[:product_customizations]
        options_hash[:product_customizations] = product_customizations(options_hash[:product_customizations])
      end
      if customization_price
        options_hash[:customization_price] = customization_price
      end
      return options_hash
    end

  end
end