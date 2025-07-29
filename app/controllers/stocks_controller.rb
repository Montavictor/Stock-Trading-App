class StocksController < ApplicationController
  before_action :check_if_admin

  def index
    @q = current_user.stocks.ransack(params[:q])
    @stocks = @q.result.page(params[:page]).per(5)
    @stocks_total = current_user.stocks
    @stocks_total.where(quantity: 0).delete_all
  end
end
