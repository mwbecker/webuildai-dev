# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token
      def new; end

      def get_id
        render json: { participantId: current_user.id }.to_json
      end

      def login
        id = params[:auth][:id]
        pwd = params[:auth][:password]
        participant = Participant.authenticate(id, pwd)
        if participant
          session[:participant_id] = participant.id
          session[:round] = 0
          session[:human_ranks] = []
          session[:pairwise_old_driver] = nil
          session[:pairwise_old_request] = nil
          # redirect_to "/react/work_preference_overview", notice: 'Logged in!'
          return render json: { status: "ok" }.to_json
        else
          return render json: { status: "error" }.to_json
        end
      end

      def logout
        session[:participant_id] = nil
        session[:round] = 0
        session[:human_ranks] = []
        session[:about] = false
        session[:pairwise_old_driver] = nil
        session[:pairwise_old_request] = nil
        # redirect_to login_path, notice: 'Logged out!'
      end
    end
  end
end