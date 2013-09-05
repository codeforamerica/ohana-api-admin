# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

if Rails.env.production? && ENV['SECRET_TOKEN'].blank?
  raise 'The SECRET_TOKEN environment variable is not set.\n
  To generate it, run "rake secret", then set it with "heroku config:set SECRET_TOKEN=the_token_you_generated"'
end

Hsa::Application.config.secret_token = ENV['SECRET_TOKEN'] || '7f5df2af31826553ca56e75c2890e802165249fc528a0c343fad14c604750be43c073ec41bad68e935d64f26a878d48a379d649e4ba2f7ff87fc08826924fce3'
