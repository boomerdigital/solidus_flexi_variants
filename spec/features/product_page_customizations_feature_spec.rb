require 'spec_helper'

describe 'Customizations', :js, type: :feature do
  include IntegrationHelpers

  let(:test_product) { create(:product, name: 'Test Product', price: 12.99) }

  context 'Cutomization types render correctly on product page' do

    it 'string type has text input element' do
      type, option = setup_customization_type_and_options(test_product, "string")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='text']#customization-option-#{option.id}")
    end

    it 'integer type has number input element' do
      type, option = setup_customization_type_and_options(test_product, "integer")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='number']#customization-option-#{option.id}")
    end

    it 'float type has number input element' do
      type, option = setup_customization_type_and_options(test_product, "float")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='number']#customization-option-#{option.id}")
    end

    it 'file type has file input element' do
      type, option = setup_customization_type_and_options(test_product, "file")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='file']#customization-option-#{option.id}")
    end

    it 'multi-select type has checkboxes' do
      type, option = setup_customization_type_and_options(test_product, "multi-select")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='checkbox']#customization-option-#{option.id}-0")
      expect(page).to have_css("input[type='checkbox']#customization-option-#{option.id}-1")
    end

    it 'single-select type has select dropdown' do
      type, option = setup_customization_type_and_options(test_product, "single-select")
      visit spree.product_path(test_product)
      expect(page).to have_css("select#customization-option-#{option.id}")
    end

    it 'boolean type has checkbox' do
      type, option = setup_customization_type_and_options(test_product, "boolean")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='checkbox']#customization-option-#{option.id}")
    end

  end
end
