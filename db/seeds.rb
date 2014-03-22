# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

puts '===> Setting up first test user...'
user = User.create! :name => 'User with custom domain name',
                    :email => 'ohana@samaritanhouse.com',
                    :password => 'ohanatest',
                    :password_confirmation => 'ohanatest'
user.confirm!

puts '===> Setting up second test user...'
user2 = User.create! :name => 'User with generic email',
                     :email => 'ohana@gmail.com',
                     :password => 'ohanatest',
                     :password_confirmation => 'ohanatest'
user2.confirm!

puts '===> Setting up admin user...'
user3 = User.create! :name => 'Master Admin',
                     :email => 'masteradmin@ohanapi.org',
                     :password => 'ohanatest',
                     :password_confirmation => 'ohanatest'
user3.confirm!