require 'spec_helper'

describe 'Customizations', :js, type: :feature do
  include IntegrationHelpers

  let(:test_product) { create(:product, name: 'Test Product', price: 12.99) }
  let(:test_product2) { create(:product, name: 'Another Test Product', price: 99.99) }

  context 'With more than one customizable product on a page' do
    it 'will only apply customizations to the correct product price' do
      amount = 3
      prod_cust_type, cpos = setup_product_customization_type_and_options(test_product, "amount_times_constant")
      prod_cust_type2, cpos2 = setup_product_customization_type_and_options(test_product2, "amount_times_constant")
      visit spree.product_path(test_product)
      # add a fake price to a page to verify that it doesn't change when product is customized
      page.execute_script("$('body').append('<div class=\"price selling\">$1000</div>')");
      fill_in "amount_times_constant_input_#{cpos.first.id}", with: 3
      # set calculator factory to multiplier of 10
      expected_amount = amount * 10 + test_product.price
      expect(page).to have_content("$#{expected_amount}")
      # other fake price should not be changed
      expect(page).to have_content("$1000")
    end
  end

  context 'Cutomization types render correctly on product page' do

    it 'will add a text field as customization field by default' do
      prod_cust_type, cpos = setup_product_customization_type_and_options(test_product, "no_charge")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='text']#product_customizations_#{prod_cust_type.id}_#{cpos.first.id}")
      fill_in "product_customizations_#{prod_cust_type.id}_#{cpos.first.id}", with: "This is a comment"
      # give a little time to make sure the price doesn't change
      sleep(2)
      expect(page).to have_content("$#{test_product.price}")
    end

    it 'will add a file upload if customization image calculator is used' do
      prod_cust_type, cpos = setup_product_customization_type_and_options(test_product, "customization_image")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='file']#customization_image_#{prod_cust_type.id}")
    end

    it 'will add length and width fields if product area calculator is used' do
      length = 3
      width = 4
      prod_cust_type, cpos = setup_product_customization_type_and_options(test_product, "product_area")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='text']#product_area_input_#{cpos.first.id}")
      expect(page).to have_css("input[type='text']#product_area_input_#{cpos.last.id}")
      fill_in "product_area_input_#{cpos.first.id}", with: length.to_s
      fill_in "product_area_input_#{cpos.last.id}", with: width.to_s
      # set calculator factory to multiplier of 5
      expected_amount = length * width * 5 + test_product.price
      expect(page).to have_content("$#{expected_amount}")
    end

    it 'will add amount field if amount times constant calculator is used' do
      amount = 3
      prod_cust_type, cpos = setup_product_customization_type_and_options(test_product, "amount_times_constant")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='text']#amount_times_constant_input_#{cpos.first.id}")
      fill_in "amount_times_constant_input_#{cpos.first.id}", with: 3
      # set calculator factory to multiplier of 10
      expected_amount = amount * 10 + test_product.price
      expect(page).to have_content("$#{expected_amount}")
    end

    it 'will add text field if engraving calculator is used' do
      engraving_word = "This is my engraving"
      prod_cust_type, cpos = setup_product_customization_type_and_options(test_product, "engraving")
      visit spree.product_path(test_product)
      expect(page).to have_css("input[type='text']#engraving_input_#{cpos.first.id}")
      fill_in "engraving_input_#{cpos.first.id}", with: engraving_word
      # set calculator factory to multiplier of .03 per letter
      expected_amount = engraving_word.length * 0.03 + test_product.price
      expect(page).to have_content("$#{expected_amount}")
    end


  end
end
