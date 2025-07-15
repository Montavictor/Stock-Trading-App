class StocksController < ApplicationController
  def index
    @stocks = current_user.stocks
  end

  def new
    @stock = Stock.new
  end
end
