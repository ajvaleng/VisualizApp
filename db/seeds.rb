# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

puts 'ROLES'
Role.destroy_all
Role.create({ :name => "Superadmin" }, :without_protection => true)
Role.create({ :name => "OperadorAdmin" }, :without_protection => true)
Role.create({ :name => "Operador" }, :without_protection => true)

puts 'DEFAULT USERS'
User.destroy_all
user1 = User.create! :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
user2 = User.create! :name => "Operador Admin", :email => "operadoradmin@example.com", :password => "12345678", :password_confirmation => "12345678"
user3 = User.create! :name => "Operador", :email => "operador@example.com", :password => "12345678", :password_confirmation => "12345678"

user1.add_role :Superadmin
user2.add_role :OperadorAdmin
user3.add_role :Operador
