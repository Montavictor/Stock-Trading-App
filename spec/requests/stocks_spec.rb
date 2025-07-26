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

  describe "GET /stocks" do
    it "returns the index page (user portfolio)" do
      sign_in user
      get stocks_path
      expect(response).to have_http_status(200)
    end
  end
end
