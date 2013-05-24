class ToolsController < ApplicationController
  before_filter :authenticate_user!
  load_resource only: [:show, :edit]
  authorize_resource

  def index
    @tools = if params[:search].blank?
      Tool.all
    else
      #Tool.all(conditions: ["name like ? or use like ?", "%#{params[:search]}%", "%#{params[:search]}%"])
      Tool.all(conditions: ["lower(name) like ?", "%#{params[:search].downcase}%"])
    end
  end

  def show
  end

  def edit
  end
end