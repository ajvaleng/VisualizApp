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
Role.delete_all
Role.create({ :name => "Administrador" }, :without_protection => true)
Role.create({ :name => "Colaborador" }, :without_protection => true)
Role.create({ :name => "AdminOperador" }, :without_protection => true)
Role.create({ :name => "Operador" }, :without_protection => true)

puts 'DEFAULT USERS'
User.delete_all
user = User.create! :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
user.add_role 'Administrador'

