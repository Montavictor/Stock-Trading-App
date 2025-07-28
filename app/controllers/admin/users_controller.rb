class Admin::UsersController < ApplicationController
  before_action :check_if_user
  before_action :set_user, only: [:show, :edit, :update, :approve, :destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_missing_params
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record 

  def index
    @users = User.order(:id)
  end
  
  def show; end
  
  def edit; end
  
  def update
    if @user.update(user_params)
      flash[:success] = "User Edited"
      redirect_to admin_users_path
    else
      flash.now[:error] = "Error: Validation Error"
      render :edit, status: :unprocessable_entity
    end 
  end
  
  def approve 
    if @user.update(status: true)
      AdminMailer.account_approved(@user).deliver_now
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
      flash[:notice] = "User Created!"
      redirect_to admin_users_path
    else
      flash[:error] = "Error: Validation Error"
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    @user.destroy
    if params[:from] == "pending"
      AdminMailer.account_declined(@user).deliver_now
      flash[:warning] = "User Declined."
      redirect_to admin_pending_path
    else
      flash[:error] = "User Deleted."
      redirect_to admin_users_path
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :last_name, :first_name, :username, :is_admin, :balance, :status)
  end

  def record_not_found
    flash[:error] = "User not Found."
    redirect_to admin_users_path
  end

  def handle_missing_params
    flash[:error] = "Required parameters are missing."
    redirect_back fallback_location: admin_users_path
  end

  def handle_invalid_record
    flash[:error] = "Invalid data provided."
    redirect_back fallback_location: admin_users_path
  end
end
