# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Sample stock and transaction data
companies = ["Apple", "Google", "Tesla", "Amazon", "Netflix"]
transaction_types = ["buy", "sell"]

user_ids = [3, 4, 8, 29, 30, 32, 41]

user_ids.each do |user_id|
  user = User.find_by(id: user_id)
  next unless user

  # Create 2 stock records per user
  2.times do
    company = companies.sample
    quantity = rand(5..50)

    Stock.create!(
      user: user,
      company_name: company,
      quantity: quantity
    )
  end

  # Create 3 transaction records per user
  3.times do
    company = companies.sample
    quantity = rand(1..10)
    price = rand(100.0..1000.0).round(2)
    total = (price * quantity).round(2)

    Transaction.create!(
      user: user,
      transaction_type: transaction_types.sample,
      company_name: company,
      quantity: quantity,
      stock_price: price,
      total_price: total
    )
  end
end

puts "Seeded stocks and transactions for users."
