require 'rails_helper'

RSpec.describe "Stocks", type: :request do
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

  let!(:admin) {admin = User.create!(
    email: "admin@example.com",
    password: "password123",
    username: "admin",
    first_name: "Admin",
    last_name: "User",
    balance: 1_000_000,
    status: true,
    is_admin: true,
    confirmed_at: Time.now
  )}

  describe "GET /stocks" do
    context "when user is an admin" do
      it "displays not allowed to access stock index" do
        sign_in admin
        get stocks_path
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:warning]).to eq("Page not accessible as Admin")
      end
    end

    context "when user is a trader" do
      it "returns the index page (user portfolio)" do
        sign_in user
        get stocks_path
        expect(response).to have_http_status(200)
      end

      it "filters stocks by company name" do
        sign_in user
        Stock.create!(company_name: "META", quantity: 10, user: user)
        Stock.create!(company_name: "MSFT", quantity: 5, user: user)

        get stocks_path, params: { q: { company_name_cont: "META" } }

        expect(response.body).to include("META")
        expect(response.body).not_to include("MSFT")
      end
    end
  end
end
