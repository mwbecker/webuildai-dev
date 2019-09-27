# frozen_string_literal: true

class EvaluationsController < ApplicationController
  def retrieve_choices(comparisons)
    overall_list = []
    comparisons.each do |comparison|
      # filter out 'neithers'
      next if comparison.choice == 3 # Shouldn't happen now as it's not nil

      comparison_hash = {}

      # scenario 1
      scenario_a_list = []
      Scenario.for_group(comparison.scenario_1).each do |s|
        scenario_a_hash = {}
        f_id = s[0]
        given_feature = Feature.find(f_id)
        scenario_a_hash[:feat_id] = f_id
        scenario_a_hash[:feat_name] = given_feature.name
        scenario_a_hash[:feat_category] = 0 # IMPORTANT: WAIT FOR MICHAEL TO DO THIS.
        scenario_a_hash[:feat_value] = s[1]
        scenario_a_hash[:feat_type] = given_feature.data_range.is_categorical ? 'categorical' : 'continuous'
        scenario_a_hash[:feat_min] = given_feature.data_range.lower_bound
        scenario_a_hash[:feat_max] = given_feature.data_range.upper_bound
        if given_feature.data_range.is_categorical
          scenario_a_hash[:possible_values] = given_feature.data_range.categorical_data_options.map(&:option_value)
        end
        scenario_a_list << scenario_a_hash
      end

      comparison_hash[:scenario_1] = scenario_a_list

      # scenario 2
      scenario_b_list = []

      Scenario.for_group(comparison.scenario_2).each do |s|
        scenario_b_hash = {}
        f_id = s[0]
        given_feature = Feature.find(f_id)
        scenario_b_hash[:feat_id] = f_id
        scenario_b_hash[:feat_name] = given_feature.name
        scenario_b_hash[:feat_category] = 0 # IMPORTANT: WAIT FOR MICHAEL TO DO THIS.
        scenario_b_hash[:feat_value] = s[1]
        scenario_b_hash[:feat_type] = given_feature.data_range.is_categorical ? 'categorical' : 'continuous'
        scenario_b_hash[:feat_min] = given_feature.data_range.lower_bound
        scenario_b_hash[:feat_max] = given_feature.data_range.upper_bound
        if given_feature.data_range.is_categorical
          scenario_b_hash[:possible_values] = given_feature.data_range.categorical_data_options.map(&:option_value)
        end
        scenario_b_list << scenario_b_hash
      end

      comparison_hash[:scenario_2] = scenario_b_list
      comparison_hash[:choice] = comparison.choice
      overall_list << comparison_hash
    end

    overall_list

    # return JSON.parse(comparisons.to_json(:except => :participant_id))
  end

  def get_comparisons_json(comparisons, type)
    result = {}
    result[:participant_id] = current_user.id
    result[:comparisons] = retrieve_choices(comparisons)
    result[:request_type] = type
    result[:feedback_round] = session[:round]

    # result_hash = JSON.dump(result)
    # puts result_hash
    result.to_json

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
    @category = params[:category]
    session[:round] = 0 if params[:reset]
    if @category == 'request'
      # get the last pairwise id from the person:
      pairwise_id = PairwiseComparison.where(participant_id: current_user.id).order(id: :desc).first.id
      individual_comparisons = PairwiseComparison.where(id: pairwise_id, participant_id: current_user.id, category: 'request')
      @comparisons_json = get_comparisons_json(individual_comparisons, 'request')
    else
      social_comparisons = PairwiseComparison.where(participant_id: current_user.id, category: 'driver')
      @comparisons_json = get_comparisons_json(social_comparisons, 'driver')
    end

    @server_url = Rails.env.production? ? 'https://webuildai-ml-server.herokuapp.com' : 'http://localhost:5000'
  end

  def index; end

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
