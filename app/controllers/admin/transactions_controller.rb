class Admin::TransactionsController < ApplicationController
  before_action :check_if_user

# TRANSACTION CONTROLLER FOR ADMIN

  def index
    @q = Transaction.ransack(params[:q])
    @transactions = @q.result.includes(:user)
                      .order(created_at: :desc)
                      .page(params[:page]).per(6)
  end
end
