require 'webdrivers'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'selenium/webdriver'

Webdrivers::Chromedriver.update

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.load_selenium
  driver_options = Selenium::WebDriver::Chrome::Options.new(
    args: %w(headless disable-gpu)
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 options: driver_options
end

Capybara.default_driver = :headless_chrome
Capybara.javascript_driver = :headless_chrome

Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.default_max_wait_time = 10
