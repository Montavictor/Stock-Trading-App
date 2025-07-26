class TransactionsController < ApplicationController
  before_action :check_if_admin
  before_action :get_stock_data, only: [:new]
  
  def index
    @transactions = current_user.transactions
  end

  def input_quantity
    data = StockPriceApi.get_stock_price(params[:symbol])

    if data['Error Message']
      flash[:warning] = "Please enter valid symbol"
      redirect_to "/search"
    else
      @symbol = data['Meta Data'].dig('2. Symbol').upcase
      @stock_price = data.dig('Time Series (Daily)').values.first.dig('1. open').to_f.round(2)
      @transaction_type = params[:transaction_type]
      
      check_if_valid_transaction_type
      
      session[:company_name] = @symbol
      session[:stock_price] = @stock_price
    end
    
    if @transaction_type == "Sell"
      stock = current_user.stocks.where(company_name: @symbol).first
      if !stock.nil?
        @stock_quantity = stock.quantity
      end
    end
  end

  def new
    @transaction = Transaction.new
    @transaction_type = params[:transaction_type]
    @quantity = params[:quantity]
    @total_price = (@stock_price * @quantity.to_i).round(2)

    check_transaction_validity
  end

  def create
    @transaction = current_user.transactions.create(transaction_params)

    if @transaction.save
      set_current_balance
      update_stock
      flash[:notice] = "#{@transaction.transaction_type}ing #{@transaction.company_name} stocks transaction successful."
      redirect_to stocks_path
    else
      flash[:error] = "Transaction failed. Please try again."
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:quantity, :transaction_type, :company_name, :stock_price, :total_price)
  end

  def get_stock_data
    @symbol = session[:company_name]
    @stock_price = session[:stock_price]
  end

  def set_current_balance
    if @transaction.transaction_type == "Buy"
      current_user.update(balance: current_user.balance - @transaction.total_price)
    else
      current_user.update(balance: current_user.balance + @transaction.total_price)
    end
  end

  def check_if_valid_transaction_type
    if @transaction_type != "Buy" &&  @transaction_type != "Sell"
      flash[:error] = "Invalid transaction. Please try again"
      redirect_to root_path
    end
  end

  def update_stock
    @stock = current_user.stocks.where(company_name: @transaction.company_name).first
    if @stock
      if @transaction.transaction_type == "Buy"
        @stock.update(quantity: @stock.quantity + @transaction.quantity)
      end
      if @transaction.transaction_type == "Sell"
        @stock.update(quantity: @stock.quantity - @transaction.quantity)
      end
    else
      current_user.stocks.create(company_name: @transaction.company_name, quantity: @transaction.quantity)
    end
  end

  def check_transaction_validity
    if @transaction_type == "Buy"
      future_balance = current_user.balance - @total_price
      if future_balance < 0
        flash[:notice] = "Not enough balance"
        render :quantity
      end
    elsif @transaction_type == "Sell"
      stock = current_user.stocks.where(company_name: @symbol).first
      updated_stock = stock.quantity - @quantity.to_i

      if updated_stock < 0
        flash[:warning] = "Not enough stocks."
        redirect_to "/input_quantity?symbol=#{@symbol}&transaction_type=#{@transaction_type}"
      end
    else
      flash[:error] = "Invalid transaction. Please try again"
      redirect_to root_path
    end
  end
end
