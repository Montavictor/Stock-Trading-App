class Admin::TransactionsController < ApplicationController
  before_action :check_if_user

# TRANSACTION CONTROLLER FOR ADMIN

  def index
    @transactions = Transaction.includes(:user).all
  end

  def show
  end
end
