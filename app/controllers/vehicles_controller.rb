class VehiclesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
  end

  def show
  end

  private

  def vehicle_params
    params.require(:vehicles).permit(:name)
  end
end