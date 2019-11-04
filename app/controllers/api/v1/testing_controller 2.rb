# frozen_string_literal: true

module Api
  module V1
    class TestingController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :check_login

      def reset
        id = current_user.id
        if [1,2,3,4,5,6,7,8,9,10].include? id
          About.where(participant_id: id).destroy_all
          Evaluation.where(participant_id: id).destroy_all
          IndividualScenario.where(participant_id: id).destroy_all
          PairwiseComparison.where(participant_id: id).destroy_all
          ParticipantFeatureWeight.where(participant_id: id).destroy_all
          Ranklist.where(participant_id: id).destroy_all
          associatedFeatures = Feature.strictly_added_by(id)
          associatedFeatures.each do |f|
            Scenario.where(feature_id: f.id).destroy_all
            if f.data_range
              f.data_range.categorical_data_options.each do |cdo|
                cdo.destroy
              end
              f.data_range.destroy
            end
            f.destroy
          end
        end
        render json: { success: "ok" }.to_json
      end

    end
  end
end