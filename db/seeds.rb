# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



admin_email = ENV['ADMIN_EMAIL']
admin_password = ENV['ADMIN_PASSWORD']

unless User.exists?(email: admin_email)
  User.create!(
    email: admin_email,
    password: admin_password,
    username: "admin",
    first_name: "Admin",
    last_name: "Admin",
    is_admin: true,
    balance: 0,
    status: true
  )
end

sample_users = [
  { email: "user1@example.com", username: "user1", first_name: "Alice", last_name: "Smith", balance: 5000.0 },
  { email: "user2@example.com", username: "user2", first_name: "Bob", last_name: "Johnson", balance: 3000.0 },
  { email: "user3@example.com", username: "user3", first_name: "Charlie", last_name: "Lee", balance: 7000.0 }
]

sample_users.each do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |user|
    user.password = "password123"
    user.username = user_data[:username]
    user.first_name = user_data[:first_name]
    user.last_name = user_data[:last_name]
    user.is_admin = false
    user.status = true
    user.balance = user_data[:balance]
  end
end

# Create Sample Stocks
users = User.where(is_admin: false)

stock_data = [
  { company_name: "Apple", quantity: 10 },
  { company_name: "Google", quantity: 5 },
  { company_name: "Tesla", quantity: 15 }
]

users.each do |user|
  stock_data.each do |stock|
    Stock.find_or_create_by!(user: user, company_name: stock[:company_name]) do |s|
      s.quantity = stock[:quantity]
    end
  end
end

# Create Sample Transactions
transaction_types = ["Buy", "Sell"]
if Transaction.count == 0
  users.each do |user|
    3.times do
      Transaction.create!(
        user: user,
        transaction_type: transaction_types.sample,
        company_name: ["Apple", "Google", "Tesla"].sample,
        quantity: rand(1..5),
        stock_price: rand(100.0..1000.0).round(2),
        total_price: -> (t) { (t[:stock_price] * t[:quantity]).round(2) }.call(
          { stock_price: rand(100.0..1000.0).round(2), quantity: rand(1..5) }
        )
      )
    end
  end
end