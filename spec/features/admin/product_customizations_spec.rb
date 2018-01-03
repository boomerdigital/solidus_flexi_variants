require 'spec_helper'

describe 'Product Customizations', :js, type: :feature do
  describe 'test add links / remove links / add options values / remove options values/ update and cancel buttons' do
    extend Spree::TestingSupport::AuthorizationHelpers::Request
    include IntegrationHelpers
    stub_authorization!

    before do
      @test_product = create(:product, name: 'Test Product', price: 12.99)
    end

    def create_product_customization_type
      create(:product_customization_type, :no_charge_calculator, name: 'text', presentation: 'Text')
    end

    def go_to_product_customization
      click_on('Customization Types')
      expect(page).to have_content(/Add Product Customization Type/i)
    end

    it 'product customization add/remove existing customization types' do
      create_product_customization_type
      go_to_product_page
      go_to_product_customization

      click_on('Add One')
      wait_for_ajax
      expect(all('#available_product_customization_types tbody tr').length).to eq(1)
      find('.fa.fa-plus.icon_link', match: :first).click
      expect(all('#selected-customization-types tbody tr').length).to eq(1)
      #test remove
      find('.fa.fa-trash').click

      expect(page).to have_content(/Product Customization Type Removed/i)
      expect(page).to have_content(/No Product customization found/i)
    end

  end
end

# save_and_open_page
# save_and_open_screenshot
