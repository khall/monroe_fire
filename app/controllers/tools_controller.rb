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

    old_tool = Tool.find(params[:id])
    if old_tool.compartment == Compartment.find(params[:answer])
      @results[:right] += 1
    else
      flash.now[:notice] = "The #{old_tool.name} is located in the #{old_tool.compartment.description} on #{old_tool.vehicle.name}"
    end
    render :quiz
  end

  private

  def prepare_question
    @tool = Tool.offset(rand(Tool.count)).limit(1).first
    @compartments = Compartment.where(vehicle_id: @tool.vehicle.id).order("random()").limit(ANSWER_CHOICES)
    # prevent duplicate compartments if the randomly selected one is the answer
    answer_index = @compartments.index(@tool.compartment)
    if answer_index
      @compartments[answer_index] = @tool.compartment
    else
      @compartments.pop
      @compartments << @tool.compartment
    end
    @compartments.shuffle!
    @results = {questions: 0, right: 0}
  end
end