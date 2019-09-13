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
    @new_ranklist = Ranklist.create(participant_id: current_user.id, round: current_round)
    @new_ranklist.save!
    @rank_elements = Array.new
    session[:round] += 1 # update the round
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
      new_scenario = IndividualScenario.create(participant_id: current_user.id, features: create_feature_json(generated_scenario), category: scenario_type)
      new_scenario.save!
      new_ranklist_elem = RanklistElement.create(ranklist_id: @new_ranklist.id, individual_scenario_id: new_scenario.id, model_rank: 0, human_rank: 0)
      new_ranklist_elem.save!
      @rank_elements << new_ranklist_elem
      @scenarioIds << new_scenario.id
    end
    
    
    # invoke python model to rank everything and insert ranklist_element table
    # model_score = `python ./model_folder/ml_model_score.py -pid #{current_user.id} -fid 1 -type request`

    # ranks_hash = ____

    ranklist_id = RanklistElement.last_ranklist.id

    rle_sql = "select * from ranklist_element " \
              "join individual_scenarios on individual_scenarios.id = ranklist_element.individual_scenario_id " \
              "where ranklist_id = #{ranklist_id} " \
              "order by ranklist_element.model_rank asc " \
              "limit #{@rankedListSize}"

    @ranklistElems = RanklistElement.for_ranklist(ranklist_id, @rankedListSize)
    # @ranklistElems = ActiveRecord::Base.connection.execute(rle_sql).values
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

  def reload
    create_pairwise_from_ranks
    update_with_human_ranks

  end

  def create_pairwise_from_ranks
    all_pairwises = Array.new
    current_elems = params[:ranklist].ranklist_elements
    elem_combos = current_elems.to_a.combination(2)
    elem_combos.each do |elem1, elem2|
      choice = elem1.human_rank < elem2.human_rank ? 1 : 2
      scenario_1 = elem1.individual_scenario.id
      scenario_2 = elem2.individual_scenario.id
      category = scenario_1.category
      
      # Create the pairwise:
      all_pairwises << {choice: choice, scenario_1: scenario_1, scenario_2: scenario_2, category: category}

    end

    @json_for_pairwise = {scenarios: all_pairwises}.to_json;

  end

  private

    # def set_ranked_list_elems
    #   @categorical_data_option = CategoricalDataOption.find(params[:id])
    # end

    # def ranked_list_param
    #   params.require(:ranklist).permit(:, :human_ranks)
    # end

    def update_with_human_ranks
      ordering = params[:order]
      ordering.each.with_index do |scenario_id, i|
        rank = i + 1
        s = IndividualScenario.find(id: scenario_id)
        s.human_rank = rank
        s.save!
      end

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









