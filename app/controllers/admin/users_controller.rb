class Admin::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::InvalidForeignKey, with: :render_internal_error
  # rescue_from ActionController::ParameterMissing, with: :render_internal_error

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "User Edited"
      redirect_to admin_users_path
    else
      flash.now[:error] = "Error: Validation Error"
      render :edit, status: :unprocessable_entity
    end 
  end
  
  def approve 
    @user = User.find(params[:id])
    if @user.update(status: true)
      flash[:success] = "User Approved"
    else
      flash[:error] = "Failed to approve user"
    end
    redirect_to admin_pending_path
  end

  def pending
    @users = User.where(status: false, is_admin: false)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User Created!"
      redirect_to admin_users_path
    else
      flash[:error] = "Error: Validation Error"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, warning: "User Deleted."
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :last_name, :first_name, :username, :is_admin, :balance, :status)
  end

  # def render_not_found
  #   render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  # end
  def record_not_found
    flash[:error] = "User not Found."
    redirect_to admin_users_path
  end
  # def render_internal_error
  #   redirect_to internal_server_error_path
  # end
end
