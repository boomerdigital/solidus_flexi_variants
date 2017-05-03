require 'simplecov'
SimpleCov.start 'rails'

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'factory_girl'
require 'ffaker'
require 'shoulda-matchers'
require 'pry'
require 'capybara-screenshot/rspec'

require 'spree/testing_support/preferences'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/order_walkthrough'

Capybara.save_and_open_page_path = ENV['CIRCLE_ARTIFACTS'] if ENV['CIRCLE_ARTIFACTS']

if ENV['WEBDRIVER'] == 'accessible'
  require 'capybara/accessible'
  Capybara.javascript_driver = :accessible
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), 'factories/*.rb')].each { |f| require f }



RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::Preferences
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::ControllerRequests, type: :controller

  config.infer_spec_type_from_file_location!
  config.mock_with :rspec
  config.order = "random"
  config.color = true
  config.use_transactional_fixtures = false
  config.fail_fast = ENV['FAIL_FAST'] || false

  if ENV['WEBDRIVER'] == 'accessible'
    config.around(:each, :inaccessible => true) do |example|
      Capybara::Accessible.skip_audit { example.run }
    end
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
