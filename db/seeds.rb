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
user = User.create! :name => 'First User',
                    :email => 'moncef@legalaidsmc.org',
                    :password => 'mong01dtest',
                    :password_confirmation => 'mong01dtest'
user.confirm!

puts '===> Setting up second test user...'
user2 = User.create! :name => 'Second User',
                     :email => 'moncef@ivsn.org',
                     :password => 'mong01dtest',
                     :password_confirmation => 'mong01dtest'
user2.confirm!

puts '===> Setting up admin user...'
user3 = User.create! :name => 'Admin User',
                     :email => 'moncef@codeforamerica.org',
                     :password => 'mong01dtest',
                     :password_confirmation => 'mong01dtest'
user3.confirm!