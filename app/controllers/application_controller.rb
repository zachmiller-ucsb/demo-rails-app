class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :require_login

  private
    def require_login
      unless logged_in?
        flash[:alert] = "You must be logged in to access that page."
        redirect_to login_path
      end
    end

    def logged_in?
      !!session[:user_id]
    end
end
