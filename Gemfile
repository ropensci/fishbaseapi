source 'https://rubygems.org/'

gem 'redis', '~> 4.1', '>= 4.1.3'
gem 'mysql2', '~> 0.5.3'
gem 'activerecord', '~> 6.0', '>= 6.0.2.1', require: 'active_record'

group :manual do
  gem 'sinatra', '~> 2.0', '>= 2.0.8.1'
  gem 'unicorn', '~> 5.5', '>= 5.5.3'
  gem 'rake', '~> 12.3.3'
end

group :test do
  gem 'rack-test', '~> 0.7.0', require: 'rack/test'
  gem 'rspec', '~> 3.7.0'
  gem 'activerecord-nulldb-adapter', '~> 0.3.7'
end
