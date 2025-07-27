require 'rails_helper'

RSpec.describe "Transactions", type: :request do

  before do
    @stock_price = 202.5
    @quantity = 5
  end

  let!(:user) { User.create!(
  email: "test@test.com",
  password: "test123",
  username: "testuser",
  first_name: "Test",
  last_name: "Test",
  balance: 1000000,
  status: true,
  is_admin: false,
  confirmed_at: Time.now
  )} 

  let!(:transaction) {
    Transaction.create!(
      transaction_type: "buy",
      company_name: "META",
      quantity: 10,
      stock_price: 200.5,
      total_price: 2005.0,
      user: user
    )
  }

  describe "GET /transactions" do
    it "returns transaction index page" do
      sign_in user
      get transactions_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /search" do
    it "returns search company name page" do
      sign_in user
      get search_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /input_quantity" do
    it "returns to /search without valid symbol and displays watning" do
      sign_in user
      get input_quantity_path()
      expect(response).to have_http_status(302)
      expect(flash[:warning]).to eq("Please enter valid symbol")
    end

    it "returns /input_quantity with valid symbol" do
      sign_in user
      get input_quantity_path, params: {symbol: "META", transaction_type: "Buy", commit: "Search"}
      expect(response).to have_http_status(200)
    end
  end

  # describe "GET /transactions/new" do
  #   it "returns new transaction page" do
  #     sign_in user
  #     get new_transaction_path, params: transaction
  #     expect(response).to have_http_status(200)
  #   end
  # end

   describe "GET /transactions/new" do
    it "create new transaction" do
      sign_in user
      post transactions_path, params: {transaction: {transaction_type: "buy", company_name: "META", quantity: "10", stock_price: 200.5, total_price: 2005.0}}
      expect(response).to redirect_to("/stocks")
      expect(flash[:notice]).to eq("#{transaction.transaction_type}ing #{transaction.company_name} stocks transaction successful.")
    end
  end
end