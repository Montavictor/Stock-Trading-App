require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "test123",
      username: "testuser",
      first_name: "Test",
      last_name: "User",
      balance: 100000,
      status: true,
      is_admin: false,
      confirmed_at: Time.now
    )
  end

  before do
    sign_in user
    session[:company_name] = "AAPL"
    session[:stock_price] = 200
  end

  describe "GET #new" do
    it "renders new transaction page" do
      get :new, params: { transaction_type: "Buy", quantity: 5}
      expect(response).to have_http_status(200)
    end
    
    it "redirects to input_quantity#path if invalid quantity" do
      get :new, params: { transaction_type: "Buy", quantity: "invald"}
      expect(response).to have_http_status(302)
      expect(flash[:error]).to eq("Invalid quantity. Please input again")
    end

    it "computes total price if valid quantity" do
      get :new, params: { transaction_type: "Buy", quantity: 5}
      total_price = controller.instance_variable_get(:@total_price)
      expect(total_price).to eq(1000)
    end

    it "redirects to input_quantity#path if not enough balance" do
      user.update!(balance: 0)
      get :new, params: { transaction_type: "Buy", quantity: 5}
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq("Not enough balance")
    end

    it "redirects to input_quantity#path if not enough stocks during SELL transaction" do
      Stock.create!(company_name: "AAPL", quantity: 10, user: user)
      get :new, params: { transaction_type: "Sell", quantity: 11}
      expect(response).to have_http_status(302)
      expect(flash[:warning]).to eq("Not enough stocks.")
    end

    it "redirects to root_path if not valid transaction" do
      get :new, params: { transaction_type: "Invalid", quantity: 5}
      expect(response).to have_http_status(302)
      expect(flash[:error]).to eq("Invalid transaction. Please try again")
    end



  end
end