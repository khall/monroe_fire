class CompartmentsController < ApplicationController
  before_action :authenticate_user!
  load_resource only: [:edit]
  authorize_resource

  def index
    @compartments = Compartment.includes(:vehicle).order('vehicles.name, compartments.description')
  end

  def edit
  end

  def update
    @compartment = Compartment.find(params[:id])
    @compartment.description = @compartment.description.strip
    if @compartment.update_attributes(params[:compartment])
      flash[:notice] = "Compartment updated"
    else
      flash[:alert] = "Compartment not updated"
    end
    redirect_to edit_compartment_path, id: @compartment.id
  end

  private

  def compartment_params
    params.require(:tools).permit(:description, :vehicle_id)
  end
end