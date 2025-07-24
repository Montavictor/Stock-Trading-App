# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Sample Users
# Create Users with balance
users = User.create!([
  {
    email: "john@example.com",
    password: "password",
    username: "john123",
    first_name: "John",
    last_name: "Doe"
  },
  {
    email: "jane@example.com",
    password: "password",
    username: "jane456",
    first_name: "Jane",
    last_name: "Smith"
  },
  {
    email: "alice@example.com",
    password: "password",
    username: "alice789",
    first_name: "Alice",
    last_name: "Jones"
  },
  {
    email: "bob@example.com",
    password: "password",
    username: "bob321",
    first_name: "Bob",
    last_name: "Brown"
  }
])



# Sample Transactions
Transaction.create!([
  { transaction_type: "buy", company_name: "Tesla", quantity: 10, stock_price: 200.5, total_price: 2005.0, user: users[1] },
  { transaction_type: "sell", company_name: "Apple", quantity: 5, stock_price: 150.0, total_price: 750.0, user: users[2] },
  { transaction_type: "buy", company_name: "Amazon", quantity: 3, stock_price: 3000.0, total_price: 9000.0, user: users[3] },
  { transaction_type: "sell", company_name: "Netflix", quantity: 8, stock_price: 500.0, total_price: 4000.0, user: users[3] },
  { transaction_type: "buy", company_name: "Google", quantity: 6, stock_price: 1800.0, total_price: 10800.0, user: users[3] },
])

# Sample Stocks
Stock.create!([
  { company_name: "Tesla", quantity: 10, user: users[1] },
  { company_name: "Apple", quantity: 5, user: users[1] },
  { company_name: "Amazon", quantity: 3, user: users[3] },
  { company_name: "Netflix", quantity: 8, user: users[3] },
  { company_name: "Google", quantity: 6, user: users[2] },
])
