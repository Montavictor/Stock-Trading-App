class PagesController < ApplicationController
  def index
    if current_user.is_admin? 
      redirect_to admin_root_path
    end
    @transactions = current_user.transactions
    @stocks = current_user.stocks
  end
end
          