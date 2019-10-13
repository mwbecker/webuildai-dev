# frozen_string_literal: true

module Api
  module V1
    class RankedListController < ApplicationController
      # TODO: remove this
      skip_before_action :verify_authenticity_token
      require 'set'
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
          selectedFeats = Feature.request.active.added_by(current_user.id).for_user(current_user.id, "request")
        else
          selectedFeats = Feature.driver.active.added_by(current_user.id).for_user(current_user.id, "driver")
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
          scenario_json[:model_rank] = 0
          scenario_json[:human_rank] = 0
          scenario_json[:score] = 0

          evaluations_json[:scenarios] << scenario_json

        end
        @generated_samples = evaluations_json.to_json
        render json: @generated_samples
      end

      # weights_hash = {
      #     featureWeights: { ... }
      # }
      # The featureWeights maps the id of a feature to the weight, if > 0.
      def obtain_weights
        category = params[:category]
        weights = Hash.new
        if category == 'request'
          weights[:featureWeights] = Feature.request.active.added_by(current_user.id).features_and_weights(current_user.id, "request")
        else
          weights[:featureWeights] = Feature.driver.active.added_by(current_user.id).features_and_weights(current_user.id, "driver")
        end
        @featureWeights = weights

        render json: @featureWeights
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
        pwc = generate_new_pairs(ranked_list, category)
        render json: { pairwiseComparisons: pwc }.to_json
      end

      private

      def generate_new_pairs(ranked_list, category)
        cache = {}
        group_id = Scenario.maximum('group_id') + 1
        all_comps = Array.new
        ranked_list.each.with_index do |scen_1, i|
          ranked_list.each.with_index do |scen_2, j|
            # in old one scene 1 was worse but now it's better
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

              pwc = PairwiseComparison.create(participant_id: current_user.id,
                                        scenario_1: scenario_1,
                                        scenario_2: scenario_2,
                                        choice: 1,
                                        category: category,
                                        reason: 'autogenerated by ordering')
              all_comps << pwc.pc_to_json
              end
            end
          end
        end
        all_comps
      end

      def make_random_scenario(features, group_id, category)
        new_scenario_features = []
        # Randomly generate values for features
        features.each do |feat|
          new_scenario_feature = nil
          data_range = feat.data_range
          if data_range.is_categorical
            new_scenario_feature = Scenario.create(group_id: group_id, feature_id: feat.id, feature_value: feat.categorical_data_options.sample.option_value)
          else
            if feat.name.downcase['distance'] || feat.name.downcase['earning'] || feat.name.downcase['cancel']# checks if distance/earning/cancel is in the name
              new_scenario_feature = Scenario.create(group_id: group_id,
                                                      feature_id: feat.id,
                                                      feature_value: ((rand(data_range.lower_bound..data_range.upper_bound) / 5).ceil * 5))
            elsif feat.name.downcase['rating'] && feat.name.downcase['driver']
              fval = (data_range.lower_bound + 0.25 * (rand(((data_range.upper_bound.to_f - data_range.lower_bound.to_f)/0.25)+1)))
              new_scenario_feature = Scenario.create(group_id: group_id, feature_id: feat.id, feature_value: fval)
            elsif feat.name.downcase['rating'] && feat.name.downcase['customer']
              fval = (data_range.lower_bound + 0.1 * (rand(((data_range.upper_bound.to_f - data_range.lower_bound.to_f)/0.1)+1)))
              new_scenario_feature = Scenario.create(group_id: group_id, feature_id: feat.id, feature_value: fval)
            else
              puts data_range.inspect
              new_scenario_feature = Scenario.create(group_id: group_id, feature_id: feat.id,
                                                      feature_value: ((rand(data_range.lower_bound...data_range.upper_bound + 1) * 1).floor / 1.0).to_i.to_s)
            end
          end
          new_scenario_features.push(new_scenario_feature.scenario_to_json())
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
          overall_list << comparison.pc_to_json()
        end
        overall_list
      end

    end
  end
end
