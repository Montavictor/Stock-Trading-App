class StocksController < ApplicationController
  before_action :check_if_admin

  def index
    @stocks = current_user.stocks
    @stocks.where(quantity: 0).delete_all
  end
end
