class Admin::DashboardController < ApplicationController
  before_action :check_if_user
  
  def index
    @transactions = Transaction.where(created_at: Date.today.all_day)
    @total = User.sum(:balance)
    @users = User.where(is_admin: false)
    @pending = User.where(status: false)
  end
end
