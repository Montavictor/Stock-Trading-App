require 'rails_helper'

RSpec.describe "Admin::Dashboard", type: :request do
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
  describe "GET /admin" do
    it "Returns Dashboard index page for admin" do
      sign_in admin

      get admin_root_path
      expect(response).to have_http_status(200)
    end
  end
end
