require 'rails_helper'

RSpec.describe "Transactions", type: :request do
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
      transaction_type: "Buy",
      company_name: "META",
      quantity: 10,
      stock_price: 200.5,
      total_price: 2005.0,
      user: user
    )
  }

  let!(:stock) {
    Stock.create!(
      company_name: "META",
      quantity: 10,
      user: user
    )
  }

  let(:transaction_type) { "Buy" }
  let(:company_name) { "META" }

  let(:valid_transaction_params) do
    {
      transaction_type: transaction_type,
      company_name: company_name,
      quantity: "5",
      stock_price: 200.5,
      total_price: 2005.0
    }
  end

  before do
    sign_in user
  end

  describe "GET /transactions" do
    it "returns transaction index page" do
      get transactions_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /search" do
    it "returns search company name page" do
      get search_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /input_quantity" do
    it "fetches and displays stock price with valid parameters" do
      test_data = { 
        "Meta Data" => {"2. Symbol" => "MSFT"}, 
        "Time Series (Daily)"=> { "2025-07-31"=> {"1. open"=>"555.23"}}
      }
      allow(StockPriceApi).to receive(:get_stock_price).and_return(test_data)
      get input_quantity_path, params: {symbol: "MSFT", transaction_type: "Buy"}

      expect(response).to have_http_status(200)
      expect(response.body).to include("MSFT")
      expect(response.body).to include("$555.23")
    end

    it "redirects to root_path if API call failed" do
      test_data = { "Meta Data" => nil}
      allow(StockPriceApi).to receive(:get_stock_price).and_return(test_data)
      get input_quantity_path, params: {symbol: "MSFT", transaction_type: "Buy"}

      expect(response).to have_http_status(302)
      expect(flash[:warning]).to eq("Our server is currently experiencing an issue. Please try again in a while.")
    end

    it "redirects with flash for invalid symbol" do
      get input_quantity_path, params: {symbol: "invalid"}

      expect(response).to have_http_status(302)
      expect(flash[:warning]).to eq("Please enter valid symbol")
    end

    it "redirects with flash for invalid transaction type" do
      get input_quantity_path, params: {symbol: "MSFT", transaction_type: "Invalid"}

      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq("Invalid transaction. Please try again")
    end

    it "Displays stock quantity if sell transaction" do
      Stock.create!(company_name: "AAPL", quantity: 10, user: user)
      get input_quantity_path, params: {symbol: "AAPL", transaction_type: "Sell"}

      expect(response).to have_http_status(200)
      expect(response.body).to include("10")
    end
  end
   
  describe "POST /transactions" do
    subject do
      post transactions_path, params: { transaction: valid_transaction_params }
    end

    it "creates new transaction and updates table" do
      expect { subject }.to change(Transaction, :count).by(1)
    end

    it "redirects with flash to portfolio after successful transaction" do
      subject
      expect(response).to redirect_to("/stocks")
      expect(flash[:notice]).to eq("#{transaction.transaction_type}ing #{transaction.company_name} stocks transaction successful.")
    end

    context "new stock" do
      let(:company_name) {"AAPL"}

      it "updates stock table" do
        expect { subject }.to change(Stock, :count).by(1)

        stock = Stock.last
        expect(stock.company_name).to eq("AAPL")
        expect(stock.quantity).to eq(5)
      end
    end

    context "buy transaction" do
      let(:transaction_type) { "Buy" }

      it "deducts total price user balance after buy transaction" do
        expect { subject }.to change { user.reload.balance }.by(-2005.0)
      end

      it "adds quantity to stock portfolio on existing record" do
        expect { subject }.to change { stock.reload.quantity }.by(5)
      end
    end

    context "sell transaction" do
      let(:transaction_type) { "Sell" }

      it "adds total price to user balance after sell transaction" do      
        expect { subject }.to change { user.reload.balance }.by(2005.0)
      end

      it "deducts quantity to stock portfolio  on existing record" do
        expect { subject }.to change { stock.reload.quantity }.by(-5)
      end
    end
  end
end
