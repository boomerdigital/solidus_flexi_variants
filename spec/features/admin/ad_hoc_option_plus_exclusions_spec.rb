require 'spec_helper'

describe 'Ad Hoc Option Values / Ad Hoc Variant Exclusions ', js: true do
  describe 'test add links / remove links / add options values / remove options values/ update and cancel buttons' do
    extend Spree::TestingSupport::AuthorizationHelpers::Request
    include IntegrationHelpers
    stub_authorization!

    before do
      @test_product = create(:product, name: 'Test Product', price: 12.99)
    end

    it 'ad hoc option types add/removes the associated option value when clicked' do
      setup_option_types_plus_ad_hoc_option_type
      go_to_product_page
      go_to_edit_ad_hoc_option_type

      expect(all('#option_values tr').length).to eq(3)

      find('.fa.fa-trash', match: :first).click

      accept_alert

      expect(page).to_not have_content('No route matches')

      expect(all('#option_values tr').length).to eq(2)

      go_to_product_page

      go_to_edit_ad_hoc_option_type

      expect(all('#option_values tr').length).to eq(2)
      #add
      within('#available_option-values') do
        find('.fa.fa-plus', match: :first).click
      end

      expect(all('#option_values tr').length).to eq(3)

      #check the update
      check 'ad_hoc_option_type_is_required'
      within('#spree_ad_hoc_option_value_2') do
        fill_in 'ad_hoc_option_type_ad_hoc_option_values_attributes_0_price_modifier', with: '1'
        check 'ad_hoc_option_type_ad_hoc_option_values_attributes_0_selected'
      end
      click_on('Update')
      expect(page).to have_content('Ad hoc option type "color" has been successfully updated!')
      find('.fa.fa-edit', match: :first).click
      expect find('#ad_hoc_option_type_is_required').should be_checked
      within('#spree_ad_hoc_option_value_2') do
        expect(page).to have_selector("input[value='1.0']")
        expect find('#ad_hoc_option_type_ad_hoc_option_values_attributes_0_selected').should be_checked
      end
      click_on('Cancel')
      expect(page).to have_content('Add Option Types')
      #test deleting a option type
      find('.fa.fa-trash').click

      accept_alert
      expect(page).to have_content('Ad Hoc Option Type Deleted')
      expect(all('#ad_hoc_option_types tbody tr').length).to eq(0)

      #test adding an option type
      click_on('Add Ad Hoc Option Type')
      find('.fa.fa-plus', match: :first).click
      click_on('Update')
      expect(all('#ad_hoc_option_types tr').length).to eq(2)
    end

    ### ad hoc variant exclusions
    it 'ad hoc variant exclusions add/removes the associated option value when clicked' do
      setup_option_types_plus_ad_hoc_option_type
      go_to_product_page
      go_to_ad_hoc_variant_exclusions
      expect(page).to have_content('You only need to configure exclusions when you have more than one ad hoc option type')
      setup_option_types_plus_ad_hoc_option_type_number_two
      go_to_product_page
      go_to_ad_hoc_variant_exclusions
      expect(page).to have_content('No Ad hoc variant exclusion found')
      click_on('Add One')
      select "red", from: 'ad_hoc_option_type_1'
      select "small", from: 'ad_hoc_option_type_2'
      click_on('Create')
      expect(all('#listing_ad_hoc_variant_exclusions tr').length).to eq(2)
      find('.fa.fa-trash').click

      accept_alert

      expect(page).to have_content('Exclusion Removed')
    end

    def setup_option_types_plus_ad_hoc_option_type
      color_option_type = create(:option_type, name: 'color', presentation: 'Color')
      color_ad_hoc_option_type = create(:ad_hoc_option_type, option_type_id: color_option_type.id, product_id: @test_product.id)

      %w(Red Green Blue).each do |color|
        option_value = create(:option_value, name: color.downcase, presentation: color, option_type: color_option_type)
        color_ad_hoc_option_type.ad_hoc_option_values.create!(option_value_id: option_value.id)
      end
    end

    def setup_option_types_plus_ad_hoc_option_type_number_two
      size_option_type = create(:option_type, name: 'size', presentation: 'Size')
      size_ad_hoc_option_type = create(:ad_hoc_option_type, option_type_id: size_option_type.id, product_id: @test_product.id)

      %w(Small Medium Large).each do |size|
        option_value = create(:option_value, name: size.downcase, presentation: size, option_type: size_option_type)
        size_ad_hoc_option_type.ad_hoc_option_values.create!(option_value_id: option_value.id)
      end
    end
  end
end
