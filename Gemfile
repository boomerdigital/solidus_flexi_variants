source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem "solidus", github: "solidusio/solidus", branch: branch
# gem "solidus_auth_devise", github: "solidusio/solidus_auth_devise"

group :test, :development do
  gem "pry"
end

if branch == 'master' || branch >= "v2.0"
  gem "rails", '< 6.0.0'
  gem 'sprockets', '< 4.0.0'
  gem "rails-controller-testing", group: :test
else
  gem "rails", '~> 4.2.7' # workaround for bundler resolution issue
  gem "rails_test_params_backport", group: :test
end

gem 'pg', '~> 0.21'
gem 'mysql2', '~> 0.4.10'

gemspec
