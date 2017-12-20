module ProductCustomizations

  # given params[:customizations], return a non-persisted array of ProductCustomization objects

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
          product_customization.customized_product_options << build_customized_product_option(customized_option_id, user_input)
        end
        customizations << product_customization
      end if params[:product_customizations]
      customizations
    end

  private

    def build_customized_product_option(customizable_product_option_id, value_from_params)
      cpo = Spree::CustomizedProductOption.new(customizable_product_option_id: customizable_product_option_id)
      cpo.set_value_for_type(value_from_params)
      return cpo
    end

end
