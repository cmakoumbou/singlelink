class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :user_subscribed?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # around_filter :user_time_zone, if: :current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => exception.message
  end

  def user_subscribed?
    subscription = Subscription.where(user_id: current_user.id).last
    if subscription.present?
      if subscription.end_date > Time.now
        return true
      else 
        return false
      end
    else
      return false
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, 
      :display_name, :bio, :country, :time_zone) }
  end

  # private

  # def user_time_zone(&block)
  #   time_zone = current_user.try(:time_zone) || 'UTC'
  #   Time.use_zone(time_zone, &block)
  # end
end
