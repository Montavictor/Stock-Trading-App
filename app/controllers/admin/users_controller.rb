class Admin::UsersController < ApplicationController
  before_action :require_admin
  def index
    @users = Users.all
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def require_admin
    redirect_to root_path, alert:"Page does not Exist" unless current_user&.admin?
  end
end

