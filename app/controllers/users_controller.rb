class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.firefighters
  end

  private

  def user_params
    params.require(:users).permit(:email, :password, :password_confirmation, :remember_me)
  end
end