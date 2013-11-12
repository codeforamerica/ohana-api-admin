# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'capybara/poltergeist'
#Capybara.javascript_driver = :webkit
#Capybara.ignore_hidden_elements = true
#require 'email_spec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.include Features::SessionHelpers, type: :feature
  config.include Features::AdminHelper, type: :feature
  #config.include(EmailSpec::Helpers)
  #config.include(EmailSpec::Matchers)

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end
end

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
  c.ignore_hosts '127.0.0.1', 'localhost'
  #c.default_cassette_options = { :record => ENV['TRAVIS'] ? :none : :once, :allow_playback_repeats => true }
  c.cassette_library_dir  = "spec/cassettes"
  c.hook_into :webmock
  c.filter_sensitive_data("<API_TOKEN>") do
    ENV['OHANA_API_TOKEN']
  end
end
