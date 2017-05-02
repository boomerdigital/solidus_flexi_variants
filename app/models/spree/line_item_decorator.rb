module Spree
  LineItem.class_eval do
    has_many :ad_hoc_option_values_line_items, dependent: :destroy
    has_many :ad_hoc_option_values, through: :ad_hoc_option_values_line_items
    has_many :product_customizations, dependent: :destroy

    def options_text # REFACTOR
      if customized?
        str = Array.new

        ad_hoc_opt_values = ad_hoc_option_values.sort_by(&:position)
        ad_hoc_option_values.sort_by(&:position).each do |pov|
          str << "#{pov.option_value.option_type.presentation} = #{pov.option_value.presentation}"
        end

        product_customizations.each do |customization|
          price_adjustment = (customization.price == 0) ? "" : " (#{Spree::Money.new(customization.price).to_s})"
          customization_type_text = "#{customization.product_customization_type.presentation}#{price_adjustment}"
          opts_text = customization.customized_product_options.map { |opt| opt.display_text }.join(', ')
          str << customization_type_text + ": #{opts_text}"
        end

        str.join('\n')
      else
        variant.options_text
      end
    end

    def customized?
      product_customizations.present? || ad_hoc_option_values.present?
    end

    def cost_price
      (variant.cost_price || 0) + ad_hoc_option_values.map(&:cost_price).inject(0, :+)
    end

    def cost_money
      Spree::Money.new(cost_price, currency: currency)
    end
  end
end
