require 'spec_helper'

describe 'Customizations', :js, type: :feature do
  include IntegrationHelpers

  let(:test_product) { create(:product, name: 'Test Product', price: 12.99) }

  context 'Cutomization types appear on product page' do

    it 'string type has input field' do
      type, option = setup_customization_type_and_options(test_product, "string")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='text']#product_customizations_#{type.id}_#{option.id}")
    end

    it 'integer type has input field', focus: true do
      type, option = setup_customization_type_and_options(test_product, "integer")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='number']#product_customizations_#{type.id}_#{option.id}")
    end

  end
end
