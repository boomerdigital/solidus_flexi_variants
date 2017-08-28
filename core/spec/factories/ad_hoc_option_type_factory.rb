FactoryGirl.define do
  factory :ad_hoc_option_type, class: Spree::AdHocOptionType do
    product
    option_type

    before :create do |ahot|
      ahot.option_type.option_values << create(:option_value)
    end
  end
end