# frozen_string_literal: true

module Api
  module V1
    class RankedListController < ApplicationController
      def new
        @category = params[:category] || 'request'
        session[:round] = 0 if params[:reset]
        if @category == 'request'
          individual_comparisons = PairwiseComparison.where(participant_id: current_user.id, category: 'request')
          @comparisons_json = get_comparisons_json(individual_comparisons, 'request')
        else
          social_comparisons = PairwiseComparison.where(participant_id: current_user.id, category: 'driver')
          @comparisons_json = get_comparisons_json(social_comparisons, 'driver')
        end

        @server_url = Rails.env.production? ? 'https://webuildai-ml-server.herokuapp.com' : 'http://localhost:5000'

        render json: {
          pairwiseComparisons: @comparisons_json,
          category: @category,
          round: session[:round],
        }.to_json
      end

      private

      def get_comparisons_json(comparisons, type)
        result = {}
        result[:participant_id] = current_user.id
        result[:comparisons] = retrieve_choices(comparisons)
        result[:request_type] = type
        result[:feedback_round] = session[:round]

        result.to_json
      end

      def retrieve_choices(comparisons)
        overall_list = []
        comparisons.each do |comparison|
          # filter out 'neithers'
          next if comparison.choice == 'nil'

          comparison_hash = {}
          comparison_hash[:choice] = comparison.choice

          # scenario 1
          scenario_a_list = []
          Scenario.for_group(comparison.scenario_1).each do |s|
            scenario_a_list << scenario_to_json(s)
          end
          comparison_hash[:scenario_1] = scenario_a_list

          # scenario 2
          scenario_b_list = []
          Scenario.for_group(comparison.scenario_2).each do |s|
            scenario_b_list << scenario_to_json(s)
          end
          comparison_hash[:scenario_2] = scenario_b_list
          overall_list << comparison_hash
        end
        overall_list
      end

      def scenario_to_json(s)
        scenario_hash = {}
        f_id = s[0]
        given_feature = Feature.find(f_id)
        scenario_hash[:feat_id] = f_id
        scenario_hash[:feat_name] = given_feature.name
        scenario_hash[:feat_category] = 0 # IMPORTANT: WAIT FOR MICHAEL TO DO THIS.
        scenario_hash[:feat_value] = s[1]
        scenario_hash[:feat_type] = given_feature.data_range.is_categorical ? 'categorical' : 'continuous'
        scenario_hash[:feat_min] = given_feature.data_range.lower_bound
        scenario_hash[:feat_max] = given_feature.data_range.upper_bound
        if given_feature.data_range.is_categorical
          scenario_hash[:possible_values] = given_feature.data_range.categorical_data_options.map(&:option_value)
        end
        scenario_hash
      end
    end
  end
end
