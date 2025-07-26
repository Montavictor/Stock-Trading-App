require 'rails_helper'
RSpec.describe Admin::UsersController, type: :request do
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

  let!(:user) { User.create!(
    email: "user@example.com",
    password: "password123",
    username: "testuser",
    first_name: "Test",
    last_name: "User",
    balance: 5000,
    status: false,
    is_admin: false,
    confirmed_at: Time.now
    )} 

  describe "GET #index" do
    it "returns http success" do
      sign_in admin
      get admin_users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      sign_in admin
      get edit_admin_user_path(user)
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH #update" do
    it "updates the user" do
      sign_in admin
      patch admin_user_path(user), params: { user: { status: true } }
      expect(user.reload.status).to eq(true)
      expect(flash[:success]).to eq("User Edited")
    end
  end
  
  describe "PATCH #approve" do
    it "approves a user" do
      sign_in admin
      patch approve_admin_user_path(user)
      user.reload
      expect(user.reload.status).to eq(true)
      expect(flash[:success]).to eq("User Approved")
    end
  end
  
  describe "GET admin/pending" do
    it "lists unapproved users" do
      sign_in admin
      get admin_pending_path
      expect(response.body).to include(user.email)
    end
  end
  
  describe "DELETE #destroy" do
    it "deletes the user" do
      sign_in admin
      expect {
        delete admin_user_path(user)
      }.to change(User, :count).by(-1)
      expect(flash[:error]).to eq("User Deleted.")
    end
  end

  describe "GET #show with invalid id" do
    it "redirects and flashes error" do
      sign_in admin
      get admin_user_path(546)
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:error]).to eq("User not Found.")
    end
  end
end
