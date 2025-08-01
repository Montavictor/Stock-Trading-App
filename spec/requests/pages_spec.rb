require 'rails_helper'

RSpec.describe "Pages", type: :request do
  let!(:user) { User.create!(
    email: "test@test.com",
    password: "test123",
    username: "testuser",
    first_name: "Test",
    last_name: "Test",
    balance: 1000000,
    status: false,
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

  describe "GET /pages" do
    context "when user is an admin" do
      it "redirects to admin dashboard" do
        sign_in admin
        get pages_path
        expect(response).to redirect_to(admin_root_path)
      end
    end

    context "when user is a trader" do
      before(:each) do |test|
        sign_in user
        if test.metadata[:approved]
          user.update!(status: true)
        end
        get root_path
      end

      it "redirects to user dashboard/pending page" do
        expect(response).to have_http_status(200)
      end

      it "displays pending page when user is not approved" do
        expect(response.body).to include('Account Pending')
      end

      it "displays dashboard if user is approved", :approved do
        expect(response.body).to include('Dashboard')
      end
    end
  end
end 
