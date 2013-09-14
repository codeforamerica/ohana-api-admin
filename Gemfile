source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '3.2.13'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'figaro'
gem 'haml-rails'
gem 'mongoid'
gem 'unicorn'
gem 'rails_12factor' # Heroku recommended
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'html2haml'
  gem 'quiet_assets'
end
group :development, :test do
  gem 'rspec-rails'
end
group :test do
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'mongoid-rspec'
end

gem "ohanakapa", "~> 1.0"
gem 'faraday-http-cache'
gem 'newrelic_rpm'