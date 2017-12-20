Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_flexi_variants'
  s.version     = '1.0.0'
  s.summary     = 'This is a solidus extension that solves two use cases related to variants.'
  s.description = 'Solidus extension to create product variants as-needed'
  s.required_ruby_version = '>= 2.1'

  # s.original_author            = 'Jeff Squires'
  s.authors            = ['Quintin Adam', 'Allison Reilly']
  s.email             = 'acreilly3@gmail.com'
  s.homepage          = 'https://github.com/boomerdigital/solidus_flexi_variants'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {spec}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  solidus_version = '>= 1.0.0', '< 3'

  s.add_dependency('carrierwave')
  s.add_dependency('mini_magick')
  s.add_dependency 'solidus_core', solidus_version
  s.add_dependency 'solidus_support'
  s.add_dependency 'deface'

  s.add_development_dependency 'rspec-rails', '~> 3.2'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'poltergeist', '~> 1.9'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner',   '~> 1.2'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'shoulda-matchers', '~> 2.7'
  s.add_development_dependency 'simplecov'#, '~> 0.9.0'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'xray-rails'
  s.add_development_dependency 'jazz_fingers'
end
