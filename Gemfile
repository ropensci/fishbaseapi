source 'https://rubygems.org/'

gem 'redis', '~> 4.2', '>= 4.2.5'
gem 'mysql2', '~> 0.5.3'
gem 'activerecord', '~> 6.1', require: 'active_record'

group :manual do
  gem 'sinatra', '~> 2.1'
  gem 'unicorn', '~> 5.8'
  gem 'rake', '~> 13.0', '>= 13.0.3'
end

group :test do
  gem 'rack-test', '~> 1.1', require: 'rack/test'
  gem 'rspec', '~> 3.9'
  gem 'activerecord-nulldb-adapter', '~> 0.4.0'
end
