source 'https://rubygems.org'
ruby '2.1.5'
gem 'rails', '3.2.17'

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem 'sass-rails',   '~> 3.2.3'
gem 'bootstrap-sass', '~> 2.3.2'
gem 'figaro'
gem 'haml-rails'
gem 'mongoid'
gem 'unicorn'

group :production do
  gem 'rails_12factor' # Heroku recommended
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'html2haml'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec-rails'
  gem "factory_girl_rails", ">= 4.2.0"
end

group :test do
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'mongoid-rspec'
  gem "capybara"
  gem 'poltergeist'
  gem 'vcr', '>= 2.9.0'
  gem 'webmock', '>= 1.17.4'
end

gem 'ohanakapa', '~> 1.1.0'
gem 'faraday', '~> 0.8.8'

gem 'newrelic_rpm'

gem 'devise' # for authentication
gem 'cancan' # for authorization
