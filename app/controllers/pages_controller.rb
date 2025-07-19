class PagesController < ApplicationController
  def index
    if current_user.status? 
      redirect_to transactions_path
    end
  end
end
