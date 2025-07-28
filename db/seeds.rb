# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb
require 'securerandom'

# Create or find the demo client
client = Client.find_or_create_by!(name: "DemoClient") do |c|
    c.api_key = SecureRandom.base58(24)
end
puts "Seeded Client: #{client.name} (API key: #{client.api_key})"

# Create or find the demo user
user = User.find_or_create_by!(email: "test@example.com") do |u|
    u.password           = "password123"
    u.client             = client
    u.home_country_code  = "US"
    u.birthday           = Date.new(2000, 7, 1)
end
puts "Seeded User: #{user.email} (ID: #{user.id})"
