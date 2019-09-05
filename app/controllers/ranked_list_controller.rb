class RankedListController < ApplicationController
  require 'json'
  require 'date'

  def run_model
    file_name = "" # to fill in later
    @individual_weights = `python ./model_folder/#{file_name}.py`
  end

  # Randomly generate examples for ranked list
  def ranked_list
    # Get all features user selected as important
    selectedFeats = Feature.request.active.added_by(current_user.id).for_user(current_user.id)
    @selectedFeats = selectedFeats
    # Size of the Ranked List 
    rankedListSize = 5
    @rankedListScenarios = Array.new
    @rankedListExamples = Array.new
    counter = 0
    # Since it's not a model, used raw sql... maybe should change this?
    create_rl_sql = "insert into ranklists (participant_id, round, created_at, updated_at) values (#{current_user.id}, 1, '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}', '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}');"
    ActiveRecord::Base.connection.execute(create_rl_sql)
    new_rankedlist_id = ActiveRecord::Base.connection.execute("select ranklists.id from ranklists where participant_id = #{current_user.id} order by ranklists.id desc limit 1").values[0][0]

    # Randomly generate values for features 
    rankedListSize.times do
      all_feats = selectedFeats.sample(selectedFeats.size) # can this go outside the loop?
      if !Scenario.all.empty?
        last_id = Scenario.all.last.group_id + 1
      else
        last_id = 1
      end

      all_feats.each do |feat|
        if feat.data_range == nil 
        end
        if feat.data_range.is_categorical  
          @rankedListScenarios << Scenario.create(group_id: last_id, feature_id: feat.id, feature_value: feat.categorical_data_options.sample.option_value)
        
        else
          @rankedListScenarios << Scenario.create(group_id: last_id, feature_id: feat.id, feature_value: ((rand(feat.data_range.lower_bound...feat.data_range.upper_bound) * 1).floor / 1.0).to_i.to_s)
        end
      end
      generated_scenario = Scenario.where(group_id: last_id)

      create_scenario_sql = "insert into individual_scenarios (features, created_at, updated_at) values ('#{create_feature_json(generated_scenario)}', '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}', '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}');"
      ActiveRecord::Base.connection.execute(create_scenario_sql)
      new_scenario_id = ActiveRecord::Base.connection.execute("select individual_scenarios.id from individual_scenarios order by individual_scenarios.created_at desc limit 1").values[0][0]
      @rankedListExamples << generated_scenario

      create_rl_elem_sql = "insert into ranklist_element (ranklist_id, individual_scenario_id, model_rank, human_rank, created_at, updated_at) values (#{new_rankedlist_id}, #{new_scenario_id}, 0, 0, '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}', '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}');"
    end
  end

  def create_feature_json(scenarios)
    all_features = Hash.new
    scenarios.each do |s|
      all_features[s.feature_id] = s.feature_value
    end

    all_features.to_json
  end

end









