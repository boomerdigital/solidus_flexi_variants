FactoryBot.define do
  factory :no_charge_calculator, class: Spree::Calculator::NoCharge do
  end
  factory :customization_image_calculator, class: Spree::Calculator::CustomizationImage do
  end
  factory :product_area_calculator, class: Spree::Calculator::ProductArea do
    preferred_multiplier 5
    preferred_min_pricing_area 1
  end
  factory :amount_times_constant_calculator, class: Spree::Calculator::AmountTimesConstant do
    preferred_multiplier 10
  end
  factory :engraving_calculator, class: Spree::Calculator::Engraving do
    preferred_price_per_letter 0.03
  end
end
