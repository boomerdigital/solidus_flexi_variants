Capybara.register_driver(:poltergeist) do |app|
  app_options = {
    phantomjs_options: %w[--ssl-protocol=any --ignore-ssl-errors=true --load-images=false],
    timeout: 90
  }
  Capybara::Poltergeist::Driver.new app, app_options
end

Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 10
