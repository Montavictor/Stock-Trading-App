class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!  
  #addition of ne fields in registration form
  before_action :configure_permitted_parameters, if: :devise_controller?
  # layout :layout_by_resource

  private

  # def layout_by_resource
  #   if devise_controller?
  #     # use `app/views/layouts/devise.html.erb`
  #     "devise" 
  #   else
  #     # use default layout
  #     "application" 
  #   end
  # end

  private

  def check_if_admin
    if current_user.is_admin?
      redirect_to admin_root_path, notice: "Page not accessible as Admin"
    end
  end

  def check_if_user
    if !current_user.is_admin?
      redirect_to root_path, notice: "Page not accessible to User"
    end
  end

  protected
  
  def after_sign_in_path_for(user)
    user.is_admin? ? admin_root_path : root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name])
  end
end
