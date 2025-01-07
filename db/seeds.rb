# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Create Users
user1 = User.create!(
  email: 'user1@example.com',
  password: 'password',
  password_confirmation: 'password'
)

user2 = User.create!(
  email: 'user2@example.com',
  password: 'password',
  password_confirmation: 'password'
)

# Create Movies
Movie.create!([
  { title: 'Inception', publishing_year: 2010, status: :processed },
  { title: 'The Matrix', publishing_year: 1999, status: :processed },
  { title: 'Interstellar', publishing_year: 2014, status: :processed },
  { title: 'The Dark Knight', publishing_year: 2008, status: :processed },
  { title: 'Fight Club', publishing_year: 1999, status: :processed }
])

puts "Seed data created successfully!"
