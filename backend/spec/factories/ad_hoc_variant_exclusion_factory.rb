FactoryGirl.define do
  factory :ad_hoc_variant_exclusion, class: Spree::AdHocVariantExclusion do
    product { |p| p.association(:product) }
  end
end
