# frozen_string_literal: true

module Api
  module V1
    class PairwiseComparisonsController < ApplicationController
      # TODO: remove this
      skip_before_action :verify_authenticity_token

      NUM_PAIRS = Rails.env.development? ? 3 : 40
      ML_URL = Rails.env.production? ? 'https://webuildai-ml-server.herokuapp.com' : 'http://localhost:5000'

      def generate_pairwise_comparisons
        category = params[:category]
        # session[:pairwise_old_request] = nil
        # return

        if !session[:pairwise_old_request].nil?
          session[:pairwise_old_request].each do |id|
            pc = PairwiseComparison.find(id)
            if !pc.nil?
              pc.destroy
            end
          end
        end

        @pairwise_comparisons = []
        feats = Feature.active.where(category: category).added_by(current_user.id).for_user(current_user.id, category)
        @feats = feats
        @scenarios = []
        @num_pairs = NUM_PAIRS
        40.times do
          three_feats = feats.sample(feats.size)

          last_id = if !Scenario.all.empty?
                      Scenario.all.last.group_id + 1
                    else
                      1
                    end
          three_feats.each do |f|
            data_range = f.data_range
            if data_range.is_categorical
              @scenarios << Scenario.create(group_id: last_id, feature_id: f.id, feature_value: f.categorical_data_options.sample.option_value)
            else
              if f.name.downcase['distance'] || f.name.downcase['earning'] || f.name.downcase['cancel']# checks if distance/earning/cancel is in the name
                @scenarios << Scenario.create(group_id: last_id, feature_id: f.id, feature_value: ((rand(data_range.lower_bound..data_range.upper_bound) / 5).ceil * 5).to_s)
              elsif f.name.downcase['rating']
                @scenarios << Scenario.create(group_id: last_id, feature_id: f.id, feature_value: ((rand(data_range.lower_bound..data_range.upper_bound) * 4).round / 4.0).to_s)
              else
                @scenarios << Scenario.create(group_id: last_id, feature_id: f.id, feature_value: ((rand(data_range.lower_bound...data_range.upper_bound + 1) * 1).floor / 1.0).to_i.to_s)
              end
            end
          end
        end
        counter = 0
        while counter < NUM_PAIRS
          group_num = Scenario.all.last.group_id
          tote = @scenarios.size / feats.size
          start = group_num - tote
          group_ind_1 = rand(start...group_num + 1)
          group_ind_2 = rand(start...group_num + 1)
          ind1s = Scenario.where(group_id: group_ind_1)
          ind2s = Scenario.where(group_id: group_ind_2)
          if (ind1s != ind2s) && ind1s.map(&:feature_id).to_set == ind2s.map(&:feature_id).to_set
            @pairwise_comparisons << PairwiseComparison.create(participant_id: current_user.id, scenario_1: group_ind_1, scenario_2: group_ind_2, category: 'request')
            counter += 1
          end
        end
        session[:pairwise_old_request] = @pairwise_comparisons.map{|pc| pc["id"]}
        comparisons_json = @pairwise_comparisons.map{|pc| pc.pc_to_json()}
        puts current_user.inspect

        render json: {
          pairwiseComparisons: comparisons_json,
          mlServerUrl: ML_URL,
          participantId: current_user.id,
        }.to_json
      end

      def update_choice
        id = params[:pairwise_id]
        choice = params[:choice]
        reason = params[:reason]
        pwc = PairwiseComparison.find(id)
        pwc.choice = choice == -1 ? nil : choice
        pwc.reason = reason
        pwc.save
      end

    end
  end
end