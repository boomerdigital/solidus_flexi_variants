require 'spec_helper'

describe 'Ad Hoc Variant Exclusions', type: :feature, js: true do
  include IntegrationHelpers

  let(:test_product) { create(:product, name: 'Test Product', price: 12.99) }

  before do
    setup_option_types_plus_ad_hoc_option_type_color(test_product)
    setup_option_types_plus_ad_hoc_option_type_size(test_product)
    set_up_variant_exclusions(test_product)
    visit spree.root_path
    click_on('Test Product')
  end

  # Exclusion is the combination of Red and Small
  context 'Variant Exclusions' do
    it 'hides small when red is selected' do
      select('Red', from: 'ad_hoc_option_values[1]')
      expect(page).to_not have_select('ad_hoc_option_values[2]', options: ['Small'])
      expect(page).to have_select('ad_hoc_option_values[2]', options: ['None', 'Medium', 'Large'])

      select('Blue', from: 'ad_hoc_option_values[1]')
      expect(page).to have_select('ad_hoc_option_values[2]', options: ['None', 'Small', 'Medium', 'Large'])
    end
  end
end
