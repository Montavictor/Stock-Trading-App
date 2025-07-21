class PagesController < ApplicationController
  def index
    if current_user.status? && !current_user.is_admin?
      redirect_to transactions_path
    elsif current_user.is_admin? 
      redirect_to admin_root_path
    end
  end
end
          