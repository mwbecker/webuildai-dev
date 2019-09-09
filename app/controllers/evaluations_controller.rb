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
        scenario_a_hash[:feat_min] = given_feature.data_range.lower_bound
        scenario_a_hash[:feat_max] = given_feature.data_range.upper_bound
        if given_feature.data_range.is_categorical
          scenario_a_hash[:possible_values] = given_feature.data_range.categorical_data_options.map {|opt| opt.option_value }
        end
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
        scenario_b_hash[:feat_min] = given_feature.data_range.lower_bound
        scenario_b_hash[:feat_max] = given_feature.data_range.upper_bound
        if given_feature.data_range.is_categorical
          scenario_b_hash[:possible_values] = given_feature.data_range.categorical_data_options.map {|opt| opt.option_value }
        end
        scenario_b_list << scenario_b_hash
      end

      comparison_hash[:scenario_2] = scenario_b_list
      comparison_hash[:choice] = comparison.choice
      overall_list << comparison_hash
    end

    return overall_list

    #return JSON.parse(comparisons.to_json(:except => :participant_id))
  end

  def get_comparisons_json(comparisons, prefix)
    result = Hash.new
    result[:participant_id] = current_user.id
    result[:comparisons] = retrieve_choices(comparisons)
    result[:request_type] = "pairwise"

    # result_hash = JSON.dump(result)
    # puts result_hash
    return result.to_json

    # # puts(result_hash)
    # begin_path = Rails.root.join("config/output_storage")
    # path_name = Rails.root.join("#{begin_path}/#{@participant_id}")
    # file_name = "#{prefix}-#{current_user.id}-#{DateTime.now}.json"

    # if !File.directory? begin_path
    #   Dir.mkdir begin_path
    # end

    # if !File.directory? path_name
    #   Dir.mkdir path_name
    # end

    # full_file_path = "#{path_name}/#{file_name}"
    # contents = JSON.pretty_generate(result)

    # File.open(full_file_path, "w") do |f|
    #   f.write(contents)
    # end
    # return full_file_path

  end

  def new
    puts current_user
    # this should be optimized later
    recent_scenarios = PairwiseComparison.where(participant_id: current_user.id).last(2*NUM_PAIRS)
    half = recent_scenarios.length / 2 - 1

    @individual_comparisons_json = get_comparisons_json(recent_scenarios[0..half], "individual")
    @social_comparisons_json = get_comparisons_json(recent_scenarios[half..recent_scenarios.length], "social")

  end

  def index
  end

  def store_info
    p = Participant.find(current_user.id)
    p.email = params[:email]
    p.name = params[:name]
    p.save!
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
    params.require(:evaluation).permit(:show, :how, :fairly, :correctly, :priorities, :previously, :situation, :resolve, :functions, :incorrect, :alert, :participant_id, :email, :name)
  end
end
