FactoryGirl.define do
  factory :excluded_ad_hoc_option_value, class: Spree::ExcludedAdHocOptionValue do
    ad_hoc_variant_exclusion
    ad_hoc_option_value
  end
end
