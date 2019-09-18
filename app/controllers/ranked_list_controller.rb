class RankedListController < ApplicationController
  require 'json'
  require 'date'

  def generate_samples
    category = params[:category]
    # Get all features user selected as important
    if category == "request"
      selectedFeats = Feature.request.active.added_by(current_user.id).for_user(current_user.id)
    else
      selectedFeats = Feature.driver.active.added_by(current_user.id).for_user(current_user.id)
    end
    # Size of the Ranked List 
    rankedListSize = 5
    counter = 0
    new_ranklist = Ranklist.create(participant_id: current_user.id, round: current_round)
    new_ranklist.save!
    all_feats = selectedFeats.sample(selectedFeats.size)

    # need to manually increment group_id
    last_group_id = Scenario.all.empty? ? 0 : Scenario.maximum("group_id")

    evaluations_json = Hash.new
    evaluations_json[:participant_id] = current_user.id
    evaluations_json[:request_type] = category # "request" # TODO for driver too
    evaluations_json[:feedback_round] = session[:round]
    evaluations_json[:scenarios] = Array.new

    category = nil
    # for each scenario to generate, generate features
    rankedListSize.times do
      last_group_id += 1

      new_scenario_features = Array.new
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
        new_scenario_features.push(create_scenario_feature_json(new_scenario_feature))
        category = new_scenario_feature.feature.category
      end

      new_indiv_scenario = IndividualScenario.create(participant_id: current_user.id,
                                                     features: create_feature_json(new_scenario_features),
                                                     category: category)

      scenario_json = Hash.new
      scenario_json[:id] = new_indiv_scenario.id
      scenario_json[:features] = new_scenario_features
      

      evaluations_json[:scenarios] << scenario_json

      new_ranklist_elem = RanklistElement.create(individual_scenario_id: new_indiv_scenario.id, model_rank: 0, human_rank: 0)
    end
    @generated_samples = evaluations_json.to_json
    render json: @generated_samples
  end

  def ranked_list

    @category = params[:category]
    @orderedList = params[:order]
    @ranklistElems = Array.new
    @orderedList.each.with_index do |indiv_id, i|
      # @ranklistElems << RanklistElement.where(individual_scenario_id: indiv_id).first
      @ranklistElems << IndividualScenario.where(id: indiv_id.to_i, participant_id: current_user.id).first
      elem = RanklistElement.where(individual_scenario_id: indiv_id).first
      elem.model_rank = i+1
      elem.save!
    end
    # invoke python model to rank everything and insert ranklist_element table
    # model_score = `python ./model_folder/ml_model_score.py -pid #{current_user.id} -fid 1 -type request`

    # ranks_hash = ____
    @rankedListSize = 5

    # ranklist_id = RanklistElement.last_ranklist(current_user.id).id

    # rle_sql = "select * from ranklist_element " \
    #           "join individual_scenarios as ind_scen on individual_scenarios.id = ranklist_element.individual_scenario_id " \
    #           "where ranklist_id = #{ranklist_id} " \
    #           "and ind_scen.participant_id = #{current_user.id} " \
    #           "order by ranklist_element.model_rank asc " \
    #           "limit #{@rankedListSize}"

    # @ranklistElems = RanklistElement.for_ranklist(ranklist_id, @rankedListSize)
    # @ranklistElems = ActiveRecord::Base.connection.execute(rle_sql).values
    displayElems = Array.new
    @ranklistElems.each do |elem|
      displayElem = Hash.new
      displayElem[:scenario_id] = elem.id
      features_hash =  JSON.parse(elem.features) # JSON.parse(elem[8])
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

    def update_human_ranks
      # TODO validate id's here
      ranklist_id = ActiveRecord::Base.connection.execute("select max(ranklist_element.ranklist_id) from ranklist_element").values[0][0]

      newRanking = params[:new_order].map {|id| id.to_i }
      initialOrder = params[:order].map {|id| id.to_i }

      initialOrder.each.with_index do |scenario_id, index|
        # index is 0-indexed
        # sql = "update ranklist_element as rle set human_rank = '#{index+1}' where rle.individual_scenario_id = #{scenario_id}"#" and rle.ranklist_id = #{ranklist_id}"
        # ActiveRecord::Base.connection.execute(sql)

        elem = RanklistElement.where(individual_scenario_id: scenario_id).first
        elem.human_rank = newRanking[index]
        elem.save!
      end
      session[:round] += 1 # update the round
      puts session[:round]
      generate_new_pairs(initialOrder, newRanking)
      # @scenarioIds = ActiveRecord::Base.connection.execute("select id from individual_scenarios order by id desc limit #{rankedListSize}").values
      render json: session[:round]
    end

  private

    def generate_new_pairs(initialOrder, newRanking)
      cache = Hash.new
      group_id = Scenario.maximum("group_id") + 1
      newRanking.each.with_index do |scen_1, i|
        scen1_init_order = i
        newRanking.each.with_index do |scen_2, j|
          scen2_init_order = j
          puts "order index: ", scen1_init_order, scen2_init_order
          # in old one scene 1 was worse but now it's better
          if scen1_init_order > scen2_init_order && scen_1 < scen_2
            if cache.has_key?(i)
              scenario_1 = cache[i]
            else
              indiv = IndividualScenario.find(initialOrder[i])
              features_hash = JSON.parse(indiv.features)
              features_hash.each do |fid, fval|
                Scenario.create(group_id: group_id,
                                feature_id: fid,
                                feature_value: fval)
              end
              cache[i] = group_id
              scenario_1 = group_id
              group_id += 1
            end

            if cache.has_key?(j)
              scenario_2 = cache[j]
            else
              indiv = IndividualScenario.find(initialOrder[j])
              features_hash = JSON.parse(indiv.features)
              features_hash.each do |fid, fval|
                Scenario.create(group_id: group_id,
                                feature_id: fid,
                                feature_value: fval)
              end
              cache[j] = group_id
              scenario_2 = group_id
              group_id += 1
            end
            puts "made new comp: ", i, j
            PairwiseComparison.create(participant_id: current_user.id,
                                      scenario_1: scenario_1,
                                      scenario_2: scenario_2,
                                      choice: 1,
                                      reason: "autogenerated by ordering")
          end
        end
      end
    end

    def create_feature_json(scenarios)
      all_features = Hash.new
      scenarios.each do |s|
        all_features[s[:feat_id]] = s[:feat_value]
      end

      all_features.to_json
    end

    def create_scenario_feature_json(scenario)
        result = Hash.new
        result[:feat_id] = scenario.feature_id
        result[:feat_name] = scenario.feature.name
        result[:feat_category] = 0 # IMPORTANT: WAIT FOR MICHAEL TO DO THIS.
        puts "feat value"
        puts scenario.feature_value
        result[:feat_value] = scenario.feature_value
        result[:feat_type] = scenario.feature.data_range.is_categorical ? "categorical" : "continuous"
        result[:feat_min] = scenario.feature.data_range.lower_bound
        result[:feat_max] = scenario.feature.data_range.upper_bound
        if scenario.feature.data_range.is_categorical
          result[:possible_values] = scenario.feature.data_range.categorical_data_options.map {|opt| opt.option_value }
        end
        return result
    end

end









