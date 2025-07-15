class TransactionsController < ApplicationController
  def index
    @transactions = current_user.transactions
  end

  def quantity
    data = StockPriceApi.get_stock_price(params[:symbol])
    @symbol = data['Meta Data'].dig('2. Symbol')
    @stock_price = data.dig('Time Series (Daily)').values.first.dig('1. open')
  end

  def new
    @transaction = Transaction.new
    @balance = current_user.balance
    @symbol = params[:company_name]
    @stock_price = params[:stock_price]
    @quantity = params[:quantity]
    @total_price = (@stock_price.to_f. * @quantity.to_i).round(2)
    @current_balance = current_user.balance - @total_price
    if @current_balance < 0
      flash[:notice] = "Not enough balance"
    end
  end


  def create
      @transaction = current_user.transactions.create(transaction_params)
      if @transaction.save
        @current_balance = current_user.balance - @transaction.total_price
        current_user.update(balance: @current_balance)
        redirect_to transactions_path
      else
        render :new, status: :unprocessable_entity, notice: "failed"
      end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:quantity, :transaction_type, :company_name, :stock_price, :total_price)
  end
end
