FactoryGirl.define do
  factory :product_customization, class: Spree::ProductCustomization do
    product_customization_type
    line_item
  end

  factory :customized_product_option, class: Spree::CustomizedProductOption do
    product_customization
    customizable_product_option
    sequence(:value) { |n| "Customized Product Option Value ##{n} - #{Kernel.rand(9999)}" }
    customization_image nil #TODO
  end

  factory :customizable_product_option, class: Spree::CustomizableProductOption do
    sequence(:name) { |n| "Customizable Product Option ##{n} - #{Kernel.rand(9999)}" }
    sequence(:presentation) { |n| "Customizable Product Option Presentation ##{n} - #{Kernel.rand(9999)}" }
    sequence(:description) { |n| "Customizable Product Option Description ##{n} - #{Kernel.rand(9999)}" }

    product_customization_type
  end

  factory :product_customization_type, class: Spree::ProductCustomizationType do
    sequence(:name) { |n| "Product Customization Type ##{n} - #{Kernel.rand(9999)}" }
    sequence(:presentation) { |n| "Product Customization Type Presentation ##{n} - #{Kernel.rand(9999)}" }

    calculator { |p| p.association(:no_charge_calculator) }
  end
end
