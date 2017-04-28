FactoryGirl.define do
  factory :ad_hoc_option_type, class: Spree::AdHocOptionType do
    product
    option_type
  end
end
