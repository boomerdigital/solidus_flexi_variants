unless !defined?(Spree::ProductsController)
  Spree::OrdersController.class_eval do

    include ProductCustomizations
    include AdHocUtils

    # is there a better way to make sure options are passed into add order contents?
    def populate
      #format ad_hoc_options, product_customizations, and customization_price
      set_option_params_values
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

    def product_customizations(customizations_hash)
      customizations = []
      # do we have any customizations?
      customizations_hash.each do |customization_type_id, customization_pair_value|  # customization_type_id =>
        # {customized_product_option_id => <user input>,  etc.}
        next if customization_pair_value.empty? || customization_pair_value.values.all? {|value| value.empty?}
        # create a product_customization based on customization_type_id
        product_customization = Spree::ProductCustomization.new(product_customization_type_id: customization_type_id)
        customization_pair_value.each_pair do |customized_option_id, user_input|
          # create a customized_product_option based on customized_option_id
          customized_product_option = build_customized_product_option(customized_option_id, user_input)
          # attach to its customization
          product_customization.customized_product_options << customized_product_option
        end
        customizations << product_customization
      end if params[:product_customizations]
      customizations
    end

    def build_customized_product_option(customizable_product_option_id, value_from_params)
      cpo = Spree::CustomizedProductOption.new(customizable_product_option_id: customizable_product_option_id)
      cpo.set_value_for_type(value_from_params)
      return cpo
    end

  end
end