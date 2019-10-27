# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :set_access_control_headers
  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

  private

  # Handling authentication

  def current_round
    @current_round = session[:round]
  end
  helper_method :current_round

  def human_ranks
    @human_ranks = session[:human_ranks]
  end
  helper_method :current_ranks

  def current_user
    @current_user ||= Participant.find(session[:participant_id]) if session[:participant_id]
  end
  helper_method :current_user
  def logged_in?
    current_user
  end
  helper_method :logged_in?
  def check_login
    redirect_to login_path, alert: 'You need to log in to view this page.' if current_user.nil?
  end
end
