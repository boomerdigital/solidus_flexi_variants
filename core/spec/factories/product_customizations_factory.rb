FactoryGirl.define do
  factory :product_customization, class: Spree::ProductCustomization do
    product_customization_type { |p| p.association(:product_customization_type) }
    line_item { |p| p.association(:line_item) }


    trait :with_customization_image do
      customized_product_options { [create(:customized_product_option, product_option_name: 'customization_image')] }
    end

    trait :with_engraving do
      customized_product_options { [create(:customized_product_option, product_option_name: 'inscription')] }
    end

    trait :with_amount_times_constant do
      customized_product_options { [create(:customized_product_option, product_option_name: 'amount')] }
    end

    trait :with_product_area do
      customized_product_options { [create(:customized_product_option, product_option_name: 'width'), create(:customized_product_option, product_option_name: 'height')] }
    end
  end

  factory :customized_product_option, class: Spree::CustomizedProductOption do
    transient do
      product_option_name 'inscription'
    end

    product_customization { |p| p.association(:product_customization) }
    sequence(:value) { |n| "Customized Product Option Value ##{n} - #{Kernel.rand(9999)}" }

    before :create do |customized_opt, evaluator|
      customized_opt.customizable_product_option = create(:customizable_product_option, name: evaluator.product_option_name)

      if evaluator.product_option_name == 'customization_image'
        File.open("./spec/fixtures/thinking-cat.jpg") {|f| customized_opt.customization_image.store!(f)}
      end
    end
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
