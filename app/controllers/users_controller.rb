class UsersController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(name: user_params[:name])
    Rails.logger.debug user_params[:name]
    if @user.nil?
      @user = User.new(user_params)
      if @user.save()
        session[:user_id] = @user.id
        Rails.logger.debug root_path
        redirect_to root_path
      else
        render :new, status: :unprocessable_entity
      end
    else
      session[:user_id] = @user.id
      redirect_to root_path
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_path
  end

  private
    def user_params
      params.require(:user).permit(:name)
    end
end
