FactoryBot.define do
  factory :ad_hoc_variant_exclusion, class: Spree::AdHocVariantExclusion do
    product
  end

  factory :excluded_ad_hoc_option_value, class: Spree::ExcludedAdHocOptionValue do
    ad_hoc_variant_exclusion
    ad_hoc_option_value
  end
end
