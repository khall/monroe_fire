class ToolsController < ApplicationController
  before_filter :authenticate_user!
  load_resource only: [:show, :edit]
  authorize_resource except: [:quiz, :quiz_answer]

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

  def update
    @tool = Tool.find(params[:id])
    if @tool.update_attributes(params[:tool])
      flash.now[:notice] = "Tool updated"
    else
      flash.now[:alert] = "Tool not updated"
    end
    redirect_to edit_tool_path, id: @tool.id
  end

  def quiz
    prepare_question

  end

  def quiz_answer
    prepare_question
    @results[:questions] = params[:results][:questions].to_i + 1
    @results[:right] = params[:results][:right].to_i
    begin
      @results[:right] += 1 if Tool.find(params[:id]).compartment == Compartment.find(params[:answer])
    rescue
    end
    render :quiz
  end

  private

  def prepare_question
    @tool = Tool.offset(rand(Tool.count)).limit(1).first
    @compartments = Compartment.where(vehicle_id: @tool.vehicle.id).order("random()").limit(ANSWER_CHOICES)
    @results = {questions: 0, right: 0}
  end
end