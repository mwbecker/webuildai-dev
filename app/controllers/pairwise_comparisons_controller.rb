# frozen_string_literal: true

require 'set'
class PairwiseComparisonsController < ApplicationController
  before_action :set_pairwise_comparison, only: %i[show edit update destroy]
  before_action :check_login

  NUM_PAIRS = Rails.env.development? ? 2 : 40
  # GET /pairwise_comparisons
  # GET /pairwise_comparisons.json
  def index
    @pairwise_comparisons = Array.new
    @feats = Feature.active.added_by(current_user.id).for_user(current_user.id, "request")
    @scenarios = Array.new
    @num_pairs = NUM_PAIRS

    @num_pairs.times do 
      group_id_1 = ScenarioGroup.create().id
      group_id_2 = ScenarioGroup.create().id

      create_scenario(@feats, group_id_1)
      create_scenario(@feats, group_id_2)

      new_pairwise = PairwiseComparison.create(participant_id: current_user.id,
                                               scenario_1: group_id_1,
                                               scenario_2: group_id_2,
                                               category: "request")
      @pairwise_comparisons << new_pairwise
    end
  end
  
  def index_driver
    @pairwise_comparisons_1 = Array.new
    @feats_1 = Feature.active.added_by(current_user.id).for_user(current_user.id, "driver")
    @scenarios_1 = Array.new
    @num_pairs = NUM_PAIRS

    @num_pairs.times do 
      group_id_1 = ScenarioGroup.create().id
      group_id_2 = ScenarioGroup.create().id

      create_scenario(@feats_1, group_id_1)
      create_scenario(@feats_1, group_id_2)

      new_pairwise = PairwiseComparison.create(participant_id: current_user.id,
                                               scenario_1: group_id_1,
                                               scenario_2: group_id_2,
                                               category: "request")
      @pairwise_comparisons_1 << new_pairwise
    end

  end

  # GET /pairwise_comparisons/1
  # GET /pairwise_comparisons/1.jsond
  def show; end

  # GET /pairwise_comparisons/new
  def new
    @pairwise_comparison = PairwiseComparison.new
    @features_all = Feature.all.active.added_by(current_user.id).order(:description)
    @survey_complete = false

    @features_by_category = Hash.new # in order to randomize
    @features_all.each do |feat|
      if @features_by_category[feat.description]
        @features_by_category[feat.description] << feat
      else
        @features_by_category[feat.description] = [feat]
      end
    end
  end

  def new_how
    @pairwise_comparison = PairwiseComparison.new
    @features_all = Feature.all.active.added_by(current_user.id).order(:description)
    @survey_complete = false

    @features_by_category = Hash.new # in order to randomize
    @features_all.each do |feat|
      if @features_by_category[feat.description]
        @features_by_category[feat.description] << feat
      else
        @features_by_category[feat.description] = [feat]
      end
    end
  end

  # GET /pairwise_comparisons/1/edit
  def edit; end

  # POST /pairwise_comparisons
  # POST /pairwise_comparisons.json
  def create
    @pairwise_comparison = PairwiseComparison.new(pairwise_comparison_params)

    respond_to do |format|
      if @pairwise_comparison.save
        format.html { redirect_to @pairwise_comparison, notice: 'Pairwise comparison was successfully created.' }
        format.json { render :show, status: :created, location: @pairwise_comparison }
      else
        format.html { render :new }
        format.json { render json: @pairwise_comparison.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pairwise_comparisons/1
  # PATCH/PUT /pairwise_comparisons/1.json
  def update
    if params[:reason] != 'nope'
      a = PairwiseComparison.find(params[:id].to_i)
      a.reason = params[:reason]
      a.save!
    else
      a = PairwiseComparison.find(params[:id].to_i)
      dec = params[:choice].to_i
      dec = nil if dec == 0 # shouldn't happen anymore, it's equal to 3.
      a.choice = dec
      a.save!
   end
  end

  # DELETE /pairwise_comparisons/1
  # DELETE /pairwise_comparisons/1.json
  def destroy
    @pairwise_comparison.destroy
    respond_to do |format|
      format.html { redirect_to pairwise_comparisons_url, notice: 'Pairwise comparison was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def create_scenario(features, group_id)
    scenarios = Array.new
    features.each do |f|
      if f.data_range.is_categorical
        random_feature_value = f.categorical_data_options.sample.option_value
      else
        if f.name.downcase['distance']
          random_feature_value = ((rand(f.data_range.lower_bound..f.data_range.upper_bound) / 5).ceil * 5).to_s
        elsif f.name.downcase['rating'] && f.name != "The rating the customer gave to their most recent driver" 
          random_feature_value = (rand(f.data_range.lower_bound..f.data_range.upper_bound).round(2)).to_s
        else
          random_feature_value = (((rand(f.data_range.lower_bound..f.data_range.upper_bound + 1) * 1).floor / 1.0).to_i).to_s
        end
      end
      new_scenario = Scenario.create(participant_id: current_user.id,
                                     group_id: group_id,
                                     feature_id: f.id,
                                     feature_value: random_feature_value)
      scenarios << new_scenario
    end
    scenarios
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_pairwise_comparison
    @pairwise_comparison = PairwiseComparison.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pairwise_comparison_params
    params.require(:pairwise_comparison).permit(:participant_id, :scenario_1, :scenario_2, :choice, :reason)
  end


end
