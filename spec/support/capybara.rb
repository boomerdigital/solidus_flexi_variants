require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'selenium/webdriver'
require 'webdrivers'

Webdrivers::Chromedriver.update

Capybara.register_driver(:big_chrome_headless) do |app|
  Capybara::Selenium::Driver.load_selenium

  options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.args << '--headless'
    opts.args << '--window-size=1280x1024'
  end

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara.javascript_driver = :big_chrome_headless
Capybara.default_max_wait_time = 10
