module Spree
  module FlexiOrderDecorator
    private

    # produces a list of [customizable_product_option.id,value] pairs for subsequent comparison
    def customization_pairs(product_customizations)
      pairs = product_customizations.map(&:customized_product_options).flatten.map do |m|
        [m.customizable_product_option.id, m.value.present? ? m.value : m.customization_image.to_s ]
      end

      Set.new pairs
    end

    def product_customizations_match(line_item, options)
      existing_customizations = line_item.product_customizations
      new_customizations = options[:product_customizations]

      return true if existing_customizations.empty? && new_customizations.empty?

      return false unless existing_customizations.pluck(:product_customization_type_id).sort == new_customizations.pluck(:product_customization_type_id).sort

      existing_vals = customization_pairs(existing_customizations)
      new_vals = customization_pairs(new_customizations)

      # do a set-compare here
      existing_vals == new_vals
    end

    def ad_hoc_option_values_match(line_item, options)
      existing_ad_hoc_opt_vals = line_item.ad_hoc_option_values || []
      new_ad_hoc_opt_vals = options[:ad_hoc_option_values] || []

      existing_ad_hoc_opt_vals.pluck(:id).sort == new_ad_hoc_opt_vals.map(&:to_i).sort
    end

    ::Spree::Order.prepend(self) unless ::Spree::Order.ancestors.include?(self)
  end
end
