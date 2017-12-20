require 'spec_helper'

describe 'Customizations', :js, type: :feature do
  include IntegrationHelpers

  let(:test_product) { create(:product, name: 'Test Product', price: 12.99) }

  context 'Ad Hoc Option Types' do
    before do
      setup_customization_type_and_options(test_product)
      visit spree.product_path(test_product)
    end

    it 'has all ad hoc option values listed', focus: true do
      expect(page).to have_content("Jehosaphat")
    end


    it 'selecting Red changes price' do
      expect(find('.price.selling').has_content?('$12.99')).to be_truthy

      select('Red', from: color_select)

      expect(find('.price.selling').has_content?('$17.99')).to be_truthy
    end
  end
end
