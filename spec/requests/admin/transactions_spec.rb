require 'rails_helper'

RSpec.describe "Admin::Transactions", type: :request do
  let!(:admin) {
    User.create!(
      email: "admin@example.com",
      password: "password123",
      username: "admin",
      first_name: "Admin",
      last_name: "User",
      balance: 1_000_000,
      status: true,
      is_admin: true,
      confirmed_at: Time.now
    )
  }

  let!(:transaction) {
    Transaction.create!(
      transaction_type: "buy",
      company_name: "Tesla",
      quantity: 10,
      stock_price: 200.5,
      total_price: 2005.0,
      user: admin
    )
  }

  it "renders the transactions index template" do
    sign_in admin

    get admin_transactions_path

    expect(response).to have_http_status(200)
    expect(response.body).to include("Tesla")
    expect(response.body).to include("Buy")
  end
end
