FactoryBot.define do
  factory :product_customization, class: Spree::ProductCustomization do
    product_customization_type { |p| p.association(:product_customization_type) }
    line_item { |p| p.association(:line_item) }


    trait :with_customization_image do
      customized_product_options { [create(:customized_product_option, product_option_name: 'customization_image', data_type: 'file')] }
    end

    trait :with_engraving do
      customized_product_options { [create(:customized_product_option, product_option_name: 'inscription', data_type: 'string')] }
    end

    trait :with_amount_times_constant do
      customized_product_options { [create(:customized_product_option, product_option_name: 'amount', data_type: 'float')] }
    end

    trait :with_product_area do
      customized_product_options { [create(:customized_product_option, product_option_name: 'width', data_type: 'float'), create(:customized_product_option, product_option_name: 'height', data_type: 'float')] }
    end
  end

  factory :customized_product_option, class: Spree::CustomizedProductOption do
    transient do
      product_option_name 'inscription'
    end

    product_customization { |p| p.association(:product_customization) }
    sequence(:value) { |n| "Customized Product Option Value ##{n} - #{Kernel.rand(9999)}" }

    before :create do |customized_opt, evaluator|
      customized_opt.customizable_product_option = create(:customizable_product_option, name: evaluator.product_option_name, data_type: evaluator.data_type)

      if evaluator.product_option_name == 'customization_image'
        File.open("./spec/fixtures/thinking-cat.jpg") {|f| customized_opt.customization_image.store!(f)}
      end
    end
  end


  factory :customizable_product_option, class: Spree::CustomizableProductOption do
    sequence(:name) { |n| "Customizable Product Option ##{n} - #{Kernel.rand(9999)}" }
    sequence(:presentation) { |n| "Customizable Product Option Presentation ##{n} - #{Kernel.rand(9999)}" }
    sequence(:description) { |n| "Customizable Product Option Description ##{n} - #{Kernel.rand(9999)}" }

    trait :string_type do
      data_type "string"
    end

    trait :integer_type do
      data_type "integer"
    end

    trait :float_type do
      data_type "float"
    end

    trait :single_select_type do
      data_type "single-select"
      selectable_options ({"Either" => "1", "Or" => "2"}.to_json)
    end

    trait :multi_select_type do
      data_type "multi-select"
      selectable_options ({"Both" => "1", "And" => "2"}.to_json)
    end

    trait :boolean_type do
      data_type "boolean"
    end

    trait :file_type do
      data_type "file"
    end

    product_customization_type
  end

  factory :product_customization_type, class: Spree::ProductCustomizationType do
    sequence(:name) { |n| "Product Customization Type ##{n} - #{Kernel.rand(9999)}" }
    sequence(:presentation) { |n| "Product Customization Type Presentation ##{n} - #{Kernel.rand(9999)}" }
    trait :no_charge_calculator do
      calculator { |p| p.association(:no_charge_calculator) }
    end
    trait :engraving_calculator do
      calculator { |p| p.association(:engraving_calculator) }
    end
  end
end
