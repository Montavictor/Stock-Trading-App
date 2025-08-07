class CreateSampleUser < ActiveRecord::Migration[7.2]
  def up
    sample_users = [
      { email: "user1@example.com", username: "user1", first_name: "Alice", last_name: "Smith", balance: 5000.0 },
      { email: "user2@example.com", username: "user2", first_name: "Bob", last_name: "Johnson", balance: 3000.0 },
      { email: "user3@example.com", username: "user3", first_name: "Charlie", last_name: "Lee", balance: 7000.0 }
    ]

    sample_users.each do |user_data|
      user = User.find_or_initialize_by(email: user_data[:email], username: user_data[:username])
      user.password = "password123"
      user.first_name = user_data[:first_name]
      user.last_name = user_data[:last_name]
      user.is_admin = false
      user.status = true
      user.balance = user_data[:balance]
      user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
      user.save!
    end

    users = User.where(is_admin: false)

    stock_data = [
      { company_name: "Apple", quantity: 10 },
      { company_name: "Google", quantity: 5 },
      { company_name: "Tesla", quantity: 15 }
    ]

    users.each do |user|
      stock_data.each do |stock|
        s = Stock.find_or_initialize_by(user: user, company_name: stock[:company_name])
        s.quantity ||= stock[:quantity]
        s.save!
      end
    end

    if Transaction.count == 0
      transaction_types = ["Buy", "Sell"]
      users.each do |user|
        3.times do
          quantity = rand(1..5)
          stock_price = rand(100.0..1000.0).round(2)
          Transaction.create!(
            user: user,
            transaction_type: transaction_types.sample,
            company_name: ["Apple", "Google", "Tesla"].sample,
            quantity: quantity,
            stock_price: stock_price,
            total_price: (stock_price * quantity).round(2)
          )
        end
      end
    end
  end

  def down
    User.where(email: ["user1@example.com", "user2@example.com", "user3@example.com"]).destroy_all
    Stock.where(company_name: ["Apple", "Google", "Tesla"]).destroy_all
    Transaction.delete_all
  end
end