require 'spec_helper'

describe 'Ad Hoc Variant Exclusions', type: :feature, js: true do
  include IntegrationHelpers

  let(:test_product) { create(:product, name: 'Test Product', price: 12.99) }


  # Exclusion is the combination of Red and Small
  context 'Variant Exclusions' do
    before do
      setup_option_types_plus_ad_hoc_option_type_color(test_product)
      setup_option_types_plus_ad_hoc_option_type_size(test_product)
      set_up_variant_exclusions(test_product)
      visit spree.root_path
      click_on('Test Product')
    end

    it 'hides small when red is selected' do
      select('Red', from: 'ad_hoc_option_values[1]')
      expect(page).to_not have_select('ad_hoc_option_values[2]', options: ['Small'])
      expect(page).to have_select('ad_hoc_option_values[2]', options: ['None', 'Medium', 'Large'])

      select('Blue', from: 'ad_hoc_option_values[1]')
      expect(page).to have_select('ad_hoc_option_values[2]', options: ['None', 'Small', 'Medium', 'Large'])
    end
  end

  context 'Ad Hoc Option Types' do
    before do
      setup_option_types_plus_ad_hoc_option_type_color(test_product)
      setup_option_types_plus_ad_hoc_option_type_size(test_product)
      ad_hoc_red = Spree::OptionValue.find_by(presentation: 'Red').ad_hoc_option_values.first
      ad_hoc_red.update_attributes(price_modifier: 5.00)
      visit spree.root_path
      click_on('Test Product')
    end

    it 'has all ad hoc option values listed' do
      expect(page).to have_content('Red')
      expect(page).to have_content('Blue')
      expect(page).to have_content('Green')
      expect(page).to have_content('Small')
      expect(page).to have_content('Medium')
      expect(page).to have_content('Large')
    end

    it 'selecting Red changes price' do
      expect(find('.price.selling').has_content?('$12.99')).to be_truthy

      select('Red', from: 'ad_hoc_option_values[1]')

      expect(find('.price.selling').has_content?('$17.99')).to be_truthy
    end
  end
end
