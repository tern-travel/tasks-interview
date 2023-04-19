class ApplicationController < ActionController::Base
  def authenticate_user
    if current_user.blank? && session[:user_id].blank?
      redirect_to new_session_path
    else
      @current_user = User.find(session[:user_id])
    end
  end

  private

  def current_user
    @current_user
  end
  helper_method :current_user
end
