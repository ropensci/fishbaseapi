source 'https://rubygems.org/'

gem 'redis', '~> 4.2', '>= 4.2.1'
gem 'mysql2', '~> 0.5.3'
gem 'activerecord', '~> 6.0', require: 'active_record'

group :manual do
  gem 'sinatra', '~> 2.0', '>= 2.0.8.1'
  gem 'unicorn', '~> 5.5', '>= 5.5.5'
  gem 'rake', '~> 13.0', '>= 13.0.1'
end

group :test do
  gem 'rack-test', '~> 1.1', require: 'rack/test'
  gem 'rspec', '~> 3.9'
  gem 'activerecord-nulldb-adapter', '~> 0.4.0'
end
