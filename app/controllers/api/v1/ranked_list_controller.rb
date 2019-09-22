# frozen_string_literal: true

module Api
  module V1
    class RankedListController < ApplicationController
      # TODO: remove this
      skip_before_action :verify_authenticity_token

      def new
        category = params[:category] || 'request'
        session[:round] = params[:round] || 0
        if category == 'request'
          individual_comparisons = PairwiseComparison.where(participant_id: current_user.id, category: 'request')
          comparisons_json = get_comparisons_json(individual_comparisons, 'request')
        else
          social_comparisons = PairwiseComparison.where(participant_id: current_user.id, category: 'driver')
          comparisons_json = get_comparisons_json(social_comparisons, 'driver')
        end

        @server_url = Rails.env.production? ? 'https://webuildai-ml-server.herokuapp.com' : 'http://localhost:5000'

        render json: {
          pairwiseComparisons: comparisons_json,
          category: category,
          round: session[:round],
          serverUrl: @server_url
        }.to_json
      end

      def generate_samples
        category = params[:category]
        round = params[:round]
        # Get all features user selected as important
        if category == 'request'
          selectedFeats = Feature.request.active.added_by(current_user.id).for_user(current_user.id)
        else
          selectedFeats = Feature.driver.active.added_by(current_user.id).for_user(current_user.id)
        end
        # Size of the Ranked List
        rankedListSize = 5

        new_ranklist = Ranklist.create(participant_id: current_user.id, round: round)
        usableFeatures = selectedFeats.sample(selectedFeats.size)

        # need to manually increment group_id
        last_group_id = Scenario.all.empty? ? 0 : Scenario.maximum('group_id')

        evaluations_json = {}
        evaluations_json[:participant_id] = current_user.id
        evaluations_json[:request_type] = category
        evaluations_json[:feedback_round] = round
        evaluations_json[:scenarios] = []
        evaluations_json[:ranklistId] = new_ranklist.id

        # for each scenario to generate, generate features
        rankedListSize.times do
          last_group_id += 1

          new_indiv_scenario, new_scenario_features = make_random_scenario(usableFeatures, last_group_id, category)

          scenario_json = {}
          scenario_json[:id] = new_indiv_scenario.id
          scenario_json[:features] = new_scenario_features

          evaluations_json[:scenarios] << scenario_json

        end
        @generated_samples = evaluations_json.to_json
        render json: @generated_samples
      end

      def save_human_weights
        ranked_list = params[:rankedList]
        session[:round] = params[:round]
        ranklist_id = params[:ranklistId]
        category = params[:category]

        ranked_list.each do |rle|
          RanklistElement.create(
            ranklist_id: ranklist_id,
            individual_scenario_id: rle[:id],
            model_rank: rle[:model_rank],
            human_rank: rle[:human_rank])
        end
        generate_new_pairs(ranked_list, category)
        render json: { status: "ok" }
      end

      private

      def generate_new_pairs(ranked_list, category)
        cache = {}
        group_id = Scenario.maximum('group_id') + 1
        ranked_list.each.with_index do |scen_1, i|
          ranked_list.each.with_index do |scen_2, j|
            # in old one scene 1 was worse but now it's better
            if i <= j
              next
            end
            if scen_1[:model_rank] > scen_2[:model_rank] && scen_1[:human_rank] < scen_2[:human_rank]
              if cache.key?(scen_1[:id])
                scenario_1 = cache[scen_1[:id]]
              else
                scen_1[:features].each do |feature|
                  Scenario.create(group_id: group_id,
                                  feature_id: feature[:feat_id],
                                  feature_value: feature[:feat_value])
                end
                cache[scen_1[:id]] = group_id
                scenario_1 = group_id
                group_id += 1

              if cache.key?(scen_2[:id])
                scenario_2 = cache[scen_2[:id]]
              else
                scen_2[:features].each do |feature|
                  Scenario.create(group_id: group_id,
                                  feature_id: feature[:feat_id],
                                  feature_value: feature[:feat_value])
                end
                cache[scen_2[:id]] = group_id
                scenario_2 = group_id
                group_id += 1
              end

              PairwiseComparison.create(participant_id: current_user.id,
                                        scenario_1: scenario_1,
                                        scenario_2: scenario_2,
                                        choice: 1,
                                        category: category,
                                        reason: 'autogenerated by ordering')
              end
            end
          end
        end
        true
      end

      def make_random_scenario(features, group_id, category)
        new_scenario_features = []
        # Randomly generate values for features
        features.each do |feat|
          new_scenario_feature = nil
          if feat.data_range.is_categorical
            new_scenario_feature = Scenario.create(group_id: group_id,
                                                    feature_id: feat.id,
                                                    feature_value: feat.categorical_data_options.sample.option_value)
          else
            new_scenario_feature = Scenario.create(group_id: group_id,
                                                    feature_id: feat.id,
                                                    feature_value: ((rand(feat.data_range.lower_bound...feat.data_range.upper_bound) * 1).floor / 1.0).to_s)
          end
          new_scenario_features.push(scenario_to_json(new_scenario_feature))
        end

        new_indiv_scenario = IndividualScenario.create(participant_id: current_user.id,
                                                        features: create_feature_json(new_scenario_features),
                                                        category: category)
        return new_indiv_scenario, new_scenario_features
      end

      def create_feature_json(scenarios)
        all_features = {}
        scenarios.each do |s|
          all_features[s[:feat_id]] = s[:feat_value]
        end
        all_features.to_json
      end

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
          Scenario.for_group_features(comparison.scenario_1).each do |s|
            scenario_a_list << scenario_to_json(s)
          end
          comparison_hash[:scenario_1] = scenario_a_list

          # scenario 2
          scenario_b_list = []
          Scenario.for_group_features(comparison.scenario_2).each do |s|
            scenario_b_list << scenario_to_json(s)
          end
          comparison_hash[:scenario_2] = scenario_b_list
          overall_list << comparison_hash
        end
        overall_list
      end

      def scenario_to_json(scenario)
        result = {}
        result[:feat_id] = scenario.feature_id
        result[:feat_name] = scenario.feature.name
        result[:feat_category] = 0 # TODO: idk what this is
        result[:feat_value] = scenario.feature_value
        result[:feat_type] = scenario.feature.data_range.is_categorical ? 'categorical' : 'continuous'
        result[:feat_min] = scenario.feature.data_range.lower_bound
        result[:feat_max] = scenario.feature.data_range.upper_bound
        if scenario.feature.data_range.is_categorical
          result[:possible_values] = scenario.feature.data_range.categorical_data_options.map(&:option_value)
        end
        result
      end

    end
  end
end
