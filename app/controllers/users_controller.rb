class UsersController < Devise::RegistrationsController
  before_filter :authenticate_user!, [:signup, :create]
  load_and_authorize_resource

  def signup

  end
end