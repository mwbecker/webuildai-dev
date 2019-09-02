class EvaluationsController < ApplicationController
  NUM_PAIRS =  Rails.env.development? ? 25 : 25

  def retrieve_choices(comparisons)
    overall_list = Array.new
    comparisons.each do |comparison|
      # filter out 'neithers'
      if comparison.choice == 'nil'
        next
      end
      comparison_hash = Hash.new
      # scenario 1
      scenario_a_list = Array.new
      Scenario.for_group(comparison.scenario_1).each do |s|
        scenario_a_hash = Hash.new
        f_id = s[0]
        given_feature = Feature.all.where(id: f_id).first
        scenario_a_hash[:feat_id] = f_id
        scenario_a_hash[:feat_name] = given_feature.name
        scenario_a_hash[:feat_category] = 0 # IMPORTANT: WAIT FOR MICHAEL TO DO THIS.
        scenario_a_hash[:feat_value] = s[1]
        scenario_a_hash[:feat_type] = given_feature.data_range.is_categorical ? "categorical" : "continuous"
        all_possible_values = Array.new
        dr = given_feature.data_range # data_range id for given feature
        if dr.is_categorical
          dr.categorical_data_options.each do |c|
            all_possible_values << c.option_value
          end
          scenario_a_hash[:possible_values] = all_possible_values
        end
        
        scenario_a_hash[:feat_min] = given_feature.data_range.lower_bound
        scenario_a_hash[:feat_max] = given_feature.data_range.upper_bound
        scenario_a_list << scenario_a_hash
      end

      comparison_hash[:scenario_1] = scenario_a_list

      # scenario 2
      scenario_b_list = Array.new

      Scenario.for_group(comparison.scenario_2).each do |s|
        scenario_b_hash = Hash.new
        f_id = s[0]
        given_feature = Feature.all.where(id: f_id).first
        scenario_b_hash[:feat_id] = f_id
        scenario_b_hash[:feat_name] = given_feature.name
        scenario_b_hash[:feat_category] = 0 # IMPORTANT: WAIT FOR MICHAEL TO DO THIS.
        scenario_b_hash[:feat_value] = s[1]
        scenario_b_hash[:feat_type] = given_feature.data_range.is_categorical ? "categorical" : "continuous"
        all_possible_values = Array.new
        dr = given_feature.data_range # data_range id for given feature
        if dr.is_categorical
          dr.categorical_data_options.each do |c|
            all_possible_values << c.option_value
          end
          scenario_b_hash[:possible_values] = all_possible_values
        end
        scenario_b_hash[:feat_min] = given_feature.data_range.lower_bound
        scenario_b_hash[:feat_max] = given_feature.data_range.upper_bound
        scenario_b_list << scenario_b_hash
      end

      comparison_hash[:scenario_2] = scenario_b_list
      comparison_hash[:choice] = comparison.choice
      overall_list << comparison_hash
    end

    return overall_list

    #return JSON.parse(comparisons.to_json(:except => :participant_id))
  end

  def write_comparisons_file(comparisons, prefix)
    result = Hash.new
    result[:part_id] = current_user.id
    result[:comparisons] = retrieve_choices(comparisons)

    result_hash = JSON.dump(result)
    # puts(result_hash)
    begin_path = Rails.root.join("config/output_storage")
    path_name = Rails.root.join("#{begin_path}/#{@participant_id}")
    file_name = "#{prefix}-#{current_user.id}-#{DateTime.now}.json"

    if !File.directory? begin_path
      Dir.mkdir begin_path
    end

    if !File.directory? path_name
      Dir.mkdir path_name
    end

    full_file_path = "#{path_name}/#{file_name}"
    contents = JSON.pretty_generate(result)
    File.open(full_file_path, "w") do |f|     
      f.write(contents)
    end
    return full_file_path

  end

  def new
    # this should be optimized later
    recent_scenarios = PairwiseComparison.chronological.where(participant_id: current_user.id).last(2*NUM_PAIRS)
    half = recent_scenarios.length / 2

    full_path = write_comparisons_file(recent_scenarios[0..half], "individual")
    i = full_path.index("config")
    path = full_path[i..full_path.length]
    # this executes whatever's in the tics as a shell process, result = stdout
    @individual_weights = `python3 ./model_folder/single_experiment.py -file ./#{path}`
    puts @individual_weights


    full_path = write_comparisons_file(recent_scenarios[half..recent_scenarios.length], "social")
    i = full_path.index("config")
    path = full_path[i..full_path.length]
    # this executes whatever's in the tics as a shell process, result = stdout
    @social_weights = `python ./model_folder/single_experiment.py -file ./#{path}`
    puts @social_weights
  end

  def index
  end

  def create
    @evaluation = Evaluation.new
    @evaluation.show = params[:show]
    @evaluation.participant_id = params[:participant_id]
    @evaluation.how = params[:how]
    @evaluation.fairly = params[:fairly]
    @evaluation.correctly = params[:correctly]
    @evaluation.priorities = params[:priorities]
    @evaluation.previously = params[:previously]
    @evaluation.situation = params[:situation]
    @evaluation.resolve = params[:resolve]
    @evaluation.functions = params[:functions]
    @evaluation.incorrect = params[:incorrect]
    @evaluation.alert = params[:alert]
    @evaluation.save!
  end

  def evaluation_params
    params.require(:evaluation).permit(:show, :how, :fairly, :correctly, :priorities, :previously, :situation, :resolve, :functions, :incorrect, :alert, :participant_id)
  end
end
