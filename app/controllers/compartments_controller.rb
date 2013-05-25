class CompartmentsController < ApplicationController
  before_filter :authenticate_user!
  load_resource only: [:index, :edit]
  authorize_resource

  def index
  end

  def edit
  end

  def update
    @compartment = Compartment.find(params[:id])
    if @compartment.update_attributes(params[:compartment])
      flash.now[:notice] = "Compartment updated"
    else
      flash.now[:alert] = "Compartment not updated"
    end
    redirect_to edit_compartment_path, id: @compartment.id
  end
end