require 'spec_helper'

describe 'Ad Hoc Variant Exclusions', :js, type: :feature do
  include IntegrationHelpers

  let(:test_product) { create(:product, name: 'Test Product', price: 12.99) }
  let(:color_select) { "ad_hoc_option_values[#{test_product.ad_hoc_option_types.first.id}]" }
  let(:size_select) { "ad_hoc_option_values[#{test_product.ad_hoc_option_types.last.id}]" }


  # Exclusion is the combination of Red and Small
  context 'Variant Exclusions' do
    before do
      setup_option_types_plus_ad_hoc_option_type_color(test_product)
      setup_option_types_plus_ad_hoc_option_type_size(test_product)
      set_up_variant_exclusions(test_product)
      visit spree.product_path(test_product)
    end

    it 'hides small when red is selected' do
      wait_for_ajax

      select('Red', from: color_select)
      expect(page).to_not have_select(size_select, options: ['Small'])
      expect(page).to have_select(size_select, options: ['None', 'Medium', 'Large'])

      select('Blue', from: color_select)
      expect(page).to have_select(size_select, options: ['None', 'Small', 'Medium', 'Large'])
    end
  end

  context 'Ad Hoc Option Types' do
    before do
      setup_option_types_plus_ad_hoc_option_type_color(test_product)
      setup_option_types_plus_ad_hoc_option_type_size(test_product)
      ad_hoc_red = Spree::OptionValue.find_by(presentation: 'Red').ad_hoc_option_values.first
      ad_hoc_red.update_attributes(price_modifier: 5.00)
      visit spree.product_path(test_product)
    end

    it 'has all ad hoc option values listed' do
      expect(page).to have_select(color_select, options: ['None', 'Red  (Add $5.00)', 'Green', 'Blue'])
      expect(page).to have_select(size_select, options: ['None', 'Small', 'Medium', 'Large'])
    end


    it 'selecting Red changes price' do
      expect(find('.price.selling').has_content?('$12.99')).to be_truthy

      select('Red', from: color_select)

      expect(find('.price.selling').has_content?('$17.99')).to be_truthy
    end
  end
end
