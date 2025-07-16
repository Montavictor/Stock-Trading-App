class Admin::TransactionsController < ApplicationController

# TRANSACTION CONTROLLER FOR ADMIN

  def index
    @transactions = Transaction.includes(:user).all
  end

  def show
  end
end
