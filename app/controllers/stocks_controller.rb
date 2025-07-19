class StocksController < ApplicationController
  def index
    @stocks = current_user.stocks
    @stocks.where(quantity: 0).delete_all
  end

  def show
    @stock = current_user.stocks.find(params[:id])
    data = StockPriceApi.get_stock_price(@stock.company_name)
    @stock_price = data.dig('Time Series (Daily)').values.first.dig('1. open')
    session[:stock_quantity] = @stock.quantity
  end
end
