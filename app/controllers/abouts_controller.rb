class AboutsController < ApplicationController

  def new
    @about = About.new
  end

  def index
  end

  def create
    puts "hello"
    @about = About.new
    @about.participant_id = params[:participant_id]
    @about.which = params[:which]
    @about.long = params[:long]
    @about.service = params[:service]
    @about.actively = params[:actively]
    @about.deactivated = params[:deactivated]
    @about.pending = params[:pending]
    @about.satisified = params[:satisified]
    session[:about] = true
    @about.save!
  end

  def about_params
    params.require(:about).permit(:which, :long, :service, :actively, :deactivated, :pending, :satisified, :participant_id)
  end
end
