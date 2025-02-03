# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Transaction.destroy_all
BuyOrder.destroy_all
Business.destroy_all
User.destroy_all

user1 = User.create!(username: "test1", password: "password1")
user2 = User.create!(username: "test2", password: "password2")
user3 = User.create!(username: "test3", password: "password3")

business1 = Business.create!(name: "Test Business", owner: user1, total_shares: 100, available_shares: 100)
business2 = Business.create!(name: "Test Business", owner: user2, total_shares: 100, available_shares: 100)
business3 = Business.create!(name: "Test Business", owner: user2, total_shares: 100, available_shares: 100)

BuyOrder.create!(business: business1, buyer: user2, quantity: 10, price: 100, status: 'approved')
Transaction.create!(user: user2, business: business1, quantity: 10, price: 100)
BuyOrder.create!(business: business2, buyer: user1, quantity: 19, price: 119, status: 'approved')
Transaction.create!(user: user1, business: business2, quantity: 19, price: 119)
BuyOrder.create!(business: business2, buyer: user1, quantity: 1, price: 99, status: 'rejected')

buy_order1 = BuyOrder.create!(business: business1, buyer: user3, quantity: 1, price: 100, status: 'pending')
buy_order2 = BuyOrder.create!(business: business1, buyer: user3, quantity: 2, price: 101, status: 'pending')
buy_order3 = BuyOrder.create!(business: business1, buyer: user3, quantity: 3, price: 102, status: 'pending')
buy_order4 = BuyOrder.create!(business: business1, buyer: user3, quantity: 4, price: 103, status: 'pending')
