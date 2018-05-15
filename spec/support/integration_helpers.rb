module IntegrationHelpers

  def login_user(user = nil, options = {})
    options[:password] ||= 'secret'
    user ||= create(:user)

    visit spree.root_path
    click_link 'Login'
    fill_in 'spree_user[email]', with: user.email
    fill_in 'spree_user[password]', with: options[:password]
    click_button 'Login'
    page.should_not have_content 'Login'
  end

  def go_to_product_page
    visit spree.admin_products_path
    within('#content-header') do
      expect(page).to have_content(/Products/i)
    end
    click_on 'Test Product'
    within('#content-header') do
      expect(page).to have_content(/Test Product/i)
    end
  end

  def go_to_edit_ad_hoc_option_type
    click_on 'Ad Hoc Option Types'
    expect(page).to have_content(/Add Option Types/i)
    find('.actions .fa.fa-edit', match: :first).click
    expect(page).to have_content(/Option Values/i)
  end

  def go_to_ad_hoc_variant_exclusions
    click_on 'Ad Hoc Variant Exclusions'
    expect(page).to have_content(/Ad Hoc Variant Exclusions/i)
  end

  def go_to_edit_ad_hoc_variant_exclusions
    click_on 'Ad Hoc Variant Exclusions'
    expect(page).to have_content(/Ad Hoc Variant Exclusions/i)
    find('.btn-primary .icon.icon-edit').click
    expect(page).to have_content(/Editing Option Type/i)
  end

  def accept_alert
    page.accept_confirm
    sleep 1.second
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop do
        active = page.evaluate_script('jQuery.active')
        break if active == 0
      end
    end
  end

  def setup_product_customization_type_and_options(product, calculator_name)
    cpos = []
    case calculator_name
    when "amount_times_constant"
      prod_cust_type = create(:product_customization_type, :amount_times_constant)
      cpos << create(:customizable_product_option, product_customization_type: prod_cust_type)
    when "customization_image"
      prod_cust_type = create(:product_customization_type, :customization_image)
      cpos << create(:customizable_product_option, product_customization_type: prod_cust_type)
    when "engraving"
      prod_cust_type = create(:product_customization_type, :engraving)
      cpos << create(:customizable_product_option, product_customization_type: prod_cust_type)
    when "product_area"
      prod_cust_type = create(:product_customization_type, :product_area)
      cpos << create(:customizable_product_option, product_customization_type: prod_cust_type)
      cpos << create(:customizable_product_option, product_customization_type: prod_cust_type)
    when "no_charge"
      prod_cust_type = create(:product_customization_type)
      cpos << create(:customizable_product_option, product_customization_type: prod_cust_type)
    else
      raise "unknown calculator_name"
    end

    product.product_customization_types << prod_cust_type
    return prod_cust_type, cpos
  end

  def setup_option_types_plus_ad_hoc_option_type_size(product)
    size_option_type = create(:option_type, name: 'size', presentation: 'Size')
    size_ad_hoc_option_type = create(:ad_hoc_option_type, option_type_id: size_option_type.id, product_id: product.id, position: 1)

    %w(Small Medium Large).each do |size|
      option_value = create(:option_value, name: size.downcase, presentation: size, option_type: size_option_type)
      size_ad_hoc_option_type.ad_hoc_option_values.create!(option_value_id: option_value.id)
    end
  end


  def setup_option_types_plus_ad_hoc_option_type_color(product)
    color_option_type = create(:option_type, name: 'color', presentation: 'Color')
    color_ad_hoc_option_type = create(:ad_hoc_option_type, option_type_id: color_option_type.id, product_id: product.id)

    %w(Red Green Blue).each do |color|
      option_value = create(:option_value, name: color.downcase, presentation: color, option_type: color_option_type)
      color_ad_hoc_option_type.ad_hoc_option_values.create!(option_value_id: option_value.id)
    end
  end

  def set_up_variant_exclusions(product)
    red = Spree::OptionValue.find_by(presentation: 'Red')
    small = Spree::OptionValue.find_by(presentation: 'Small')

    ad_hoc_variant_exclusion = create(:ad_hoc_variant_exclusion, product: product)
    create(:excluded_ad_hoc_option_value, ad_hoc_option_value: Spree::AdHocOptionValue.find_by(option_value: red), ad_hoc_variant_exclusion: ad_hoc_variant_exclusion)
    create(:excluded_ad_hoc_option_value, ad_hoc_option_value: Spree::AdHocOptionValue.find_by(option_value: small), ad_hoc_variant_exclusion: ad_hoc_variant_exclusion)
  end
end
