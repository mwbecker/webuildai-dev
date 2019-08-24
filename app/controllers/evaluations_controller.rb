class EvaluationsController < ApplicationController
  def new
    
  end

  def index
  end

  def create
    puts "hello"
    @evaluation = Evaluation.new
    @evaluation.show = params[:show]
    @evaluation.participant_id = params[:participant_id]
    @evaluation.how = params[:how]
    @evaluation.fairly = params[:fairly]
    @evaluation.correctly = params[:correctly]
    @evaluation.priorities = params[:priorities]
    @evaluation.previously = params[:previously]
    @evaluation.situation = params[:situation]
    @evaluation.resolve = params[:resolve]
    @evaluation.functions = params[:functions]
    @evaluation.incorrect = params[:incorrect]
    @evaluation.alert = params[:alert]
    @evaluation.save!
  end

  def evaluation_params
    params.require(:evaluation).permit(:show, :how, :fairly, :correctly, :priorities, :previously, :situation, :resolve, :functions, :incorrect, :alert, :participant_id)
  end
end
