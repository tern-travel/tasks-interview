class SessionsController < ApplicationController
  before_action :authenticate_user, only: [:destroy]

  def new
  end

  def create
    @user = User.find_by(email: session_params[:email])

    if @user && @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      redirect_to tasks_path
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
