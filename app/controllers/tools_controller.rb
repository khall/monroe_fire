class ToolsController < ApplicationController
  before_action :authenticate_user!
  load_resource only: [:show, :edit]
  authorize_resource except: [:quiz, :quiz_answer]

  def index
    @tools = if params[:search].blank?
      Tool.includes(compartment: [:vehicle]).order('vehicles.name, compartments.description, tools.name')
    else
      #Tool.all(conditions: ["name like ? or use like ?", "%#{params[:search]}%", "%#{params[:search]}%"])
      Tool.where("lower(tools.name) like ?", "%#{params[:search].downcase}%").includes(compartment: [:vehicle]).order('vehicles.name, compartments.description, tools.name')
    end
  end

  def show
  end

  def edit
  end

  def update
    @tool = Tool.find(params[:id])
    if @tool.update(tool_params)
      flash.now[:notice] = "Tool updated"
    else
      flash.now[:alert] = "Tool not updated"
    end
    redirect_to edit_tool_path, id: @tool.id
  end

  def quiz
    prepare_question
    authorize! :read, @tool
    authorize! :read, @compartments
  end

  def quiz_answer
    prepare_question
    @results[:questions] = params[:results][:questions].to_i + 1
    @results[:right] = params[:results][:right].to_i

    old_tool = Tool.find(params[:id])
    correct = old_tool.compartment == Compartment.find(params[:answer])
    Answer.create(user_id: current_user.id, question_type: "tool_quiz", question_id: old_tool.id, correct: correct)
    if correct
      @results[:right] += 1
      flash.now[:notice] = "Correct!"
    else
      flash.now[:alert] = "The #{old_tool.name} is located in the #{old_tool.compartment.description} on #{old_tool.vehicle.name}"
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

  def tool_params
    params.require(:tool).permit(:compartment_id, :name, :quantity, :use)
  end

  def answer_params
    params.require(:answers).permit(:correct, :question_id, :question_type, :user_id)
  end
end