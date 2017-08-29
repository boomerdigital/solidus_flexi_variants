require 'spec_helper'

describe 'Ad Hoc Option Values / Ad Hoc Variant Exclusions ', :js, type: :feature do
  describe 'test add links / remove links / add options values / remove options values/ update and cancel buttons' do
    extend Spree::TestingSupport::AuthorizationHelpers::Request
    include IntegrationHelpers
    stub_authorization!

    let!(:test_product) { create(:product, name: 'Test Product', price: 12.99) }
    let(:color_select) { "ad_hoc_option_type[#{test_product.ad_hoc_option_types.first.id}]" }
    let(:size_select) { "ad_hoc_option_type[#{test_product.ad_hoc_option_types.last.id}]" }

    it 'ad hoc option types add/removes the associated option value when clicked' do
      setup_option_types_plus_ad_hoc_option_type_color(test_product)
      go_to_product_page
      go_to_edit_ad_hoc_option_type

      expect(all('#option_values tr').length).to eq(3)

      find('.fa.fa-trash', match: :first).click

      accept_alert

      expect(page).to have_content(/Ad Hoc Option Value Deleted/i)

      expect(all('#option_values tr').length).to eq(2)

      go_to_product_page

      go_to_edit_ad_hoc_option_type

      expect(all('#option_values tr').length).to eq(2)
      #add
      within('#available_option-values') do
        find('.fa.fa-plus', match: :first).click
      end

      wait_for_ajax

      expect(all('#option_values tr').length).to eq(3)

      #check the update
      check 'ad_hoc_option_type_is_required'
      within("#ad_hoc_option_type .option_value", match: :first) do
        fill_in 'ad_hoc_option_type_ad_hoc_option_values_attributes_0_price_modifier', with: '1'
        check 'ad_hoc_option_type_ad_hoc_option_values_attributes_0_selected'
      end
      click_on('Update')
      expect(page).to have_content(/Ad hoc option type "color" has been successfully updated!/i)
      find('#ad_hoc_option_types .fa.fa-edit', match: :first).click


      expect find('#ad_hoc_option_type_is_required').should be_checked
      within("#ad_hoc_option_type .option_value", match: :first) do
        expect(page).to have_selector("input[value='1.0']")
        expect find('#ad_hoc_option_type_ad_hoc_option_values_attributes_0_selected').should be_checked
      end
      click_on('Cancel')
      expect(page).to have_content(/Add Option Types/i)
      #test deleting a option type
      find('.fa.fa-trash').click

      accept_alert
      expect(page).to have_content(/Ad Hoc Option Type Deleted/i)

      wait_for_ajax

      expect(all('#ad_hoc_option_types tbody tr').length).to eq(0)

      #test adding an option type
      click_on('Add Ad Hoc Option Type')
      find('.fa.fa-plus', match: :first).click
      click_on('Update')
      expect(all('#ad_hoc_option_types tr').length).to eq(2)
    end

    ### ad hoc variant exclusions
    it 'ad hoc variant exclusions add/removes the associated option value when clicked' do
      setup_option_types_plus_ad_hoc_option_type_color(test_product)
      go_to_product_page
      go_to_ad_hoc_variant_exclusions
      expect(page).to have_content(/You only need to configure exclusions when you have more than one ad hoc option type/i)
      setup_option_types_plus_ad_hoc_option_type_size(test_product)
      go_to_product_page
      go_to_ad_hoc_variant_exclusions
      expect(page).to have_content(/No Ad hoc variant exclusion found/i)
      click_on('Add One')

      wait_for_ajax

      select "red", from: color_select
      select "small", from: size_select
      click_on('Create')
      expect(all('#listing_ad_hoc_variant_exclusions tr').length).to eq(2)
      find('.fa.fa-trash').click

      accept_alert

      expect(page).to have_content(/Exclusion Removed/i)
    end
  end
end
