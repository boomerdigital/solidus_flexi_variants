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
      expect(page).to have_content('Products')
    end
    click_on 'Test Product'
    within('#content-header') do
      expect(page).to have_content('Test Product')
    end
  end

  def go_to_edit_ad_hoc_option_type
    click_on 'Ad Hoc Option Types'
    expect(page).to have_content('Add Option Types')
    find('.fa.fa-edit', match: :first).click
    expect(page).to have_content('Option Values')
  end

  def go_to_ad_hoc_variant_exclusions
    click_on 'Ad Hoc Variant Exclusions'
    expect(page).to have_content('Ad Hoc Variant Exclusions')
  end

  def go_to_edit_ad_hoc_variant_exclusions
    click_on 'Ad Hoc Variant Exclusions'
    expect(page).to have_content('Ad Hoc Variant Exclusions')
    find('.btn-primary .icon.icon-edit').click
    expect(page).to have_content('Editing Option Type')
  end

  def accept_alert
    page.driver.browser.switch_to.alert.accept
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop do
        active = page.evaluate_script('jQuery.active')
        break if active == 0
      end
    end
  end
end
