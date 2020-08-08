# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

newuser = User.new(
  email: 'admin@example.com',
  password: '123@qwe',
  password_confirmation: '123@qwe',
  admin: true
)
newuser.skip_confirmation!
newuser.save!
