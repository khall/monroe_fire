class CompartmentsController < ApplicationController
  before_filter :authenticate_user!
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
end