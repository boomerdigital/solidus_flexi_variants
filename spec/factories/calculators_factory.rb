FactoryBot.define do
  factory :amount_times_contstant_calculator, class: Spree::Calculator::AmountTimesConstant do
  end
  factory :customization_image_calculator, class: Spree::Calculator::CustomizationImage do
  end
  factory :engraving_calculator, class: Spree::Calculator::Engraving do
  end
  factory :no_charge_calculator, class: Spree::Calculator::NoCharge do
  end
  factory :product_area_calculator, class: Spree::Calculator::ProductArea do
  end
end
