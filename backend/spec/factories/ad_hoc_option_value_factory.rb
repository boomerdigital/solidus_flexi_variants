FactoryGirl.define do
  factory :ad_hoc_option_value, class: Spree::AdHocOptionValue do
    ad_hoc_option_type { |p| p.association(:ad_hoc_option_type) }
    option_value { |p| p.association(:option_value) }
  end
end