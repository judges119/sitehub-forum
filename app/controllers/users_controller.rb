class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'User was successfully updated.'
    else
      render :show
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:admin, :moderator)
    end
end