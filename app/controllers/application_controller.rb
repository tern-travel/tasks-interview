class ApplicationController < ActionController::Base
  def authenticate_user
    if current_user.blank? && session[:user_id].blank?
      redirect_to new_session_path
    else
      @current_user = User.find(session[:user_id])
    end
  end

  private

  attr_reader :current_user
  helper_method :current_user
end
