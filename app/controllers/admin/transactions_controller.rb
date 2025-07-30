class Admin::TransactionsController < ApplicationController
  before_action :check_if_user

# TRANSACTION CONTROLLER FOR ADMIN

  def index
    @q = Transaction.ransack(params[:q])
    @transactions = @q.result.includes(:user).page(params[:page]).per(8)
  end
  
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    redirect_to admin_transactions_path, notice: "Transaction deleted successfully."
  end
end
