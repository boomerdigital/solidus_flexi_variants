Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_flexi_variants'
  s.version     = '0.1.0'
  s.summary     = 'This is a solidus extension that solves two use cases related to variants.'
  s.description = 'Solidus extension to create product variants as-needed'
  s.required_ruby_version = '>= 2.1'

  # s.original_author            = 'Jeff Squires'
  s.authors            = ['Quintin Adam', 'Allison Reilly']
  s.email             = 'acreilly3@gmail.com'
  s.homepage          = 'https://github.com/boomerdigital/solidus_flexi_variants'

  #s.files       = `git ls-files`.split("\n")
  s.files = Dir['README.md', 'lib/**/*']
  s.test_files  = `git ls-files -- {spec}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  solidus_version = '>= 1.0.0', '< 2.3.0'

  s.add_dependency 'solidus_core', solidus_version
  s.add_dependency 'solidus_flexi_variants_core', s.version
  s.add_dependency 'solidus_flexi_variants_frontend', s.version
  s.add_dependency 'solidus_flexi_variants_backend', s.version

end
