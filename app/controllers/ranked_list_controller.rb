class RankedListController < ApplicationController
  require 'json'
  require 'date'

  def ranked_list
    # Get all features user selected as important
    @selectedFeats = Feature.request.active.added_by(current_user.id).for_user(current_user.id)
    # Size of the Ranked List 
    @rankedListSize = 5
    @rankedListScenarios = Array.new
    @rankedListExamples = Array.new
    @scenarioIds = Array.new
    counter = 0
    # Since it's not a model, used raw sql... maybe should change this?
    create_rl_sql = "insert into ranklists (participant_id, round, created_at, updated_at) values (#{current_user.id}, 1, '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}', '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}');"
    ActiveRecord::Base.connection.execute(create_rl_sql)
    new_rankedlist_id = ActiveRecord::Base.connection.execute("select ranklists.id from ranklists where participant_id = #{current_user.id} order by ranklists.id desc limit 1").values[0][0]

    all_feats = @selectedFeats.sample(@selectedFeats.size)

    # need to manually increment group_id
    last_group_id = Scenario.all.empty? ? 0 : Scenario.all.last.group_id

    # for each scenario to generate, generate features
    @rankedListSize.times do
      last_group_id += 1

      # Randomly generate values for features 
      all_feats.each do |feat|
        new_scenario_feature = nil
        if feat.data_range.is_categorical  
          new_scenario_feature = Scenario.create(group_id: last_group_id,
                                                 feature_id: feat.id,
                                                 feature_value: feat.categorical_data_options.sample.option_value)
        else
          new_scenario_feature = Scenario.create(group_id: last_group_id,
                                                 feature_id: feat.id,
                                                 feature_value: ((rand(feat.data_range.lower_bound...feat.data_range.upper_bound) * 1).floor / 1.0).to_i.to_s)
        end
        @rankedListScenarios << new_scenario_feature
      end
      generated_scenario = Scenario.where(group_id: last_group_id)

      # insert the scenario into the database
      @rankedListExamples << generated_scenario
      scenario_type = generated_scenario.first.feature.category
      create_scenario_sql = "insert into individual_scenarios (features, created_at, updated_at, participant_id, category) values ('#{create_feature_json(generated_scenario)}', '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}', '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}', #{current_user.id}, '#{scenario_type}');"
      ActiveRecord::Base.connection.execute(create_scenario_sql)

      new_scenario = ActiveRecord::Base.connection.execute("select * from individual_scenarios order by individual_scenarios.created_at desc limit 1").values[0]
      new_scenario_id = new_scenario[0]
      @scenarioIds << new_scenario_id
      # create_rl_elem_sql = "insert into ranklist_element (ranklist_id, individual_scenario_id, model_rank, human_rank, created_at, updated_at) values (#{new_rankedlist_id}, #{new_scenario_id}, 0, 0, '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}', '#{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}');"
    end

    # invoke python model to rank everything and insert ranklist_element table
    model_score = `python ./model_folder/ml_model_score.py -pid #{current_user.id} -fid 1 -type request`

    ranklist_id = ActiveRecord::Base.connection.execute("select max(ranklist_element.ranklist_id) from ranklist_element").values[0][0]

    rle_sql = "select * from ranklist_element " \
              "join individual_scenarios on individual_scenarios.id = ranklist_element.individual_scenario_id " \
              "where ranklist_id = #{ranklist_id} " \
              "order by ranklist_element.model_rank asc " \
              "limit #{@rankedListSize}"

    @ranklistElems = ActiveRecord::Base.connection.execute(rle_sql).values

    displayElems = Array.new
    @ranklistElems.each do |elem|
      displayElem = Hash.new
      displayElem[:scenario_id] = elem[0]
      features_hash = JSON.parse(elem[8])
      features = Array.new
      features_hash.each do |key, value|
        one_feature = Hash.new
        one_feature[:name] = Feature.find(key).name
        one_feature[:value] = value
        features << one_feature
      end
      displayElem[:features] = features
      displayElems << displayElem
    end
    @displayElems = displayElems
  end

  def weights
  end

  def update_human_ranks
    # TODO validate id's here
    ranklist_id = ActiveRecord::Base.connection.execute("select max(ranklist_element.ranklist_id) from ranklist_element").values[0][0]

    ordering = params[:order]
    ordering.each.with_index do |scenario_id, index|
      # TODO figure out how to save
      # index is 0-indexed
      # sql = "update ranklist_element as rle set human_rank = '#{index+1}' where rle.individual_scenario_id = #{scenario_id}"#" and rle.ranklist_id = #{ranklist_id}"
      # ActiveRecord::Base.connection.execute(sql)
    end
    @scenarioIds = ActiveRecord::Base.connection.execute("select id from individual_scenarios order by id desc limit #{rankedListSize}").values
  end

  def create_feature_json(scenarios)
    all_features = Hash.new
    scenarios.each do |s|
      all_features[s.feature_id] = s.feature_value
    end

    all_features.to_json
  end

end









