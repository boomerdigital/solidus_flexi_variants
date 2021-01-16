module ProductDecorator
  def self.prepended(base)
    # These are the pool of POSSIBLE option values
    base.has_many :ad_hoc_option_types, after_add: :attach_option_values

    # Each exclusion represents a disallowed combination of ad_hoc_option_values
    base.has_many :ad_hoc_variant_exclusions, dependent: :destroy

    # allowed customizations
    base.has_many :product_customization_types_products, class_name: '::Spree::ProductCustomizationTypesProduct'
    base.has_many :product_customization_types, through: :product_customization_types_products
  end

  private

  def attach_option_values(ad_hoc_option_type)
    ad_hoc_option_type.option_type.option_values.each do |ov|
      ahot = Spree::AdHocOptionValue.new
      ahot.option_value_id = ov.id
      ahot.position = ov.position
      ahot.save
      ad_hoc_option_type.ad_hoc_option_values << ahot
    end
  end

  ::Spree::Product.prepend(self)
end
