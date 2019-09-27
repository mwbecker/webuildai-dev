# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    participant = Participant.authenticate(params[:id], params[:password])
    if participant
      session[:participant_id] = participant.id
      session[:round] = 0
      session[:human_ranks] = []
      session[:pairwise_old_driver] = nil
      session[:pairwise_old_request] = nil
      redirect_to new_pairwise_comparison_path, notice: 'Logged in!'
    else
      flash.now.alert = 'Username and/or password is invalid'
      render 'new'
    end
  end

  def destroy
    session[:participant_id] = nil
    session[:round] = 0
    session[:human_ranks] = []
    session[:about] = false
    session[:pairwise_old_driver] = nil
    session[:pairwise_old_request] = nil
    redirect_to login_path, notice: 'Logged out!'
  end
end
