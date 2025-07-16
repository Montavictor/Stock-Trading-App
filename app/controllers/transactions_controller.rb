class TransactionsController < ApplicationController
  def index
    @transactions = current_user.transactions
  end

  def quantity
    data = StockPriceApi.get_stock_price(params[:symbol])

    if data['Error Message']
      redirect_to "/search", notice: "Please enter valid symbol"
    else
      @symbol = data['Meta Data'].dig('2. Symbol').upcase
      @stock_price = data.dig('Time Series (Daily)').values.first.dig('1. open')
      @transaction_type = params[:transaction_type]
    end
    @stock_quantity = params[:stock_quantity]
  end


  def new
    @transaction = Transaction.new
    @symbol = params[:company_name]
    @transaction_type = params[:transaction_type]
    @stock_price = params[:stock_price]
    @quantity = params[:quantity]
    @total_price = (@stock_price.to_f. * @quantity.to_i).round(2)

    if @transaction_type == "Buy"
      future_balance = current_user.balance - @total_price
      if future_balance < 0
        flash[:notice] = "Not enough balance"
        render :quantity
      end
    else
      stock = current_user.stocks.where(company_name: @symbol).first
      updated_stock = stock.quantity - @quantity.to_i

      if updated_stock < 0
        redirect_to stock_path(stock), notice: "Not enough stocks."
      end
    end
  end

  def create
    @transaction = current_user.transactions.create(transaction_params)

    if @transaction.save
      set_current_balance
      @stock = current_user.stocks.where(company_name: @transaction.company_name).first
      
      if @stock
        if @transaction.transaction_type == "Buy"
          @current_quantity = @stock.quantity + @transaction.quantity
        else
          @current_quantity = @stock.quantity - @transaction.quantity
        end

        @stock.update(quantity: @current_quantity)
      else
        current_user.stocks.create(company_name: @transaction.company_name, quantity: @transaction.quantity)
      end

      redirect_to transactions_path
    else
      flash[:notice] = "Failed"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:quantity, :transaction_type, :company_name, :stock_price, :total_price)
  end

  def set_current_balance
    if @transaction.transaction_type == "Buy"
      @current_balance = current_user.balance - @transaction.total_price
    else
      @current_balance = current_user.balance + @transaction.total_price
    end

    current_user.update(balance: @current_balance)  
  end
end
