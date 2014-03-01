class CertificationsController < ApplicationController
  def index
    @users = User.firefighters
    @courses = Course.all
  end
end