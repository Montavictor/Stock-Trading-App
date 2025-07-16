class StocksController < ApplicationController
  def index
    @stocks = current_user.stocks
  end

  def show
    @stock = current_user.stocks.find(params[:id])
    data = StockPriceApi.get_stock_price(@stock.company_name)
    @stock_price = data.dig('Time Series (Daily)').values.first.dig('1. open')
  end
end
