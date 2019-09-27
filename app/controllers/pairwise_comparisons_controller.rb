# frozen_string_literal: true

require 'set'
class PairwiseComparisonsController < ApplicationController
  before_action :set_pairwise_comparison, only: %i[show edit update destroy]
  before_action :check_login

  NUM_PAIRS = Rails.env.development? ? 3 : 40
  # GET /pairwise_comparisons
  # GET /pairwise_comparisons.json
  def index
    if !session[:pairwise_old_request].nil?
      session[:pairwise_old_request].each do |pc|
        PairwiseComparison.find(pc["id"]).destroy
      end
    end

    @pairwise_comparisons = []
    feats = Feature.request.active.added_by(current_user.id).for_user(current_user.id, "request")
    @feats = feats
    @scenarios = []
    @num_pairs = NUM_PAIRS
    30.times do
      three_feats = feats.sample(feats.size)

      last_id = if !Scenario.all.empty?
                  Scenario.all.last.group_id + 1
                else
                  1
                end
      three_feats.each do |f|
        if f.data_range.nil?
        end
        if f.data_range.is_categorical
          @scenarios << Scenario.create(group_id: last_id, feature_id: f.id, feature_value: f.categorical_data_options.sample.option_value)
        else
          if f.name.downcase['distance'] # checks if distance is in the name
            @scenarios << Scenario.create(group_id: last_id, feature_id: f.id, feature_value: ((rand(f.data_range.lower_bound..f.data_range.upper_bound) / 5).ceil * 5).to_s)
          elsif f.name.downcase['rating'] && f.name != 'The rating the customer gave to their most recent driver' # checks if rating is in the name
            @scenarios << Scenario.create(group_id: last_id, feature_id: f.id, feature_value: ((rand * (f.data_range.upper_bound-f.data_range.lower_bound) + f.data_range.lower_bound).round(2)).to_s)
          else
            @scenarios << Scenario.create(group_id: last_id, feature_id: f.id, feature_value: ((rand(f.data_range.lower_bound...f.data_range.upper_bound + 1) * 1).floor / 1.0).to_i.to_s)
          end
        end
      end
    end
    counter = 0
    while counter < NUM_PAIRS
      group_num = Scenario.all.last.group_id
      tote = @scenarios.size / feats.size
      start = group_num - tote
      group_ind_1 = rand(start...group_num + 1)
      group_ind_2 = rand(start...group_num + 1)
      ind1s = Scenario.where(group_id: group_ind_1)
      ind2s = Scenario.where(group_id: group_ind_2)
      if (ind1s != ind2s) && ind1s.map(&:feature_id).to_set == ind2s.map(&:feature_id).to_set
        @pairwise_comparisons << PairwiseComparison.create(participant_id: current_user.id, scenario_1: group_ind_1, scenario_2: group_ind_2, category: 'request')
        counter += 1
      end
    end

    session[:pairwise_old_request] = @pairwise_comparisons

  end

  def index_driver
    if !session[:pairwise_old_driver].nil?
      session[:pairwise_old_driver].each do |pc|
        PairwiseComparison.find(pc["id"]).destroy
      end
    end
    @pairwise_comparisons_1 = []

    @feats_1 = Feature.driver.active.added_by(current_user.id).for_user(current_user.id, "driver")
    @scenarios_1 = []
    @num_pairs = NUM_PAIRS

    30.times do
      three_feats = feats.sample(feats.size)

      last_id = if !Scenario.all.empty?
                  Scenario.all.last.group_id + 1
                else
                  1
                end
      three_feats.each do |f|
        if f.data_range.is_categorical
          @scenarios_1 << Scenario.create(group_id: last_id, feature_id: f.id, feature_value: f.categorical_data_options.sample.option_value)
        else
          @scenarios_1 << Scenario.create(group_id: last_id, feature_id: f.id, feature_value: ((rand(f.data_range.lower_bound...f.data_range.upper_bound) * 1).floor / 1.0).to_i.to_s)
        end
      end
    end
    counter = 0
    while counter < NUM_PAIRS
      group_num = Scenario.all.last.group_id
      tote = @scenarios_1.size / feats.size
      start = group_num - tote
      group_ind_1 = rand(start...group_num + 1)
      group_ind_2 = rand(start...group_num + 1)
      ind1s = Scenario.where(group_id: group_ind_1)
      ind2s = Scenario.where(group_id: group_ind_2)
      if (ind1s != ind2s) && ind1s.map(&:feature_id).to_set == ind2s.map(&:feature_id).to_set
        @pairwise_comparisons_1 << PairwiseComparison.create(participant_id: current_user.id, scenario_1: group_ind_1, scenario_2: group_ind_2, category: 'driver')
        counter += 1
      end
    end
    session[:pairwise_old_driver] = @pairwise_comparisons_1
  end

  # GET /pairwise_comparisons/1
  # GET /pairwise_comparisons/1.json
  def show; end

  # GET /pairwise_comparisons/new
  def new
    @pairwise_comparison = PairwiseComparison.new
    @features_all = Feature.all.active.added_by(current_user.id).order(:description)
    @survey_complete = false

    @features_by_category = Hash.new # in order to randomize
    Feature.request.active.added_by(current_user.id).for_user(current_user.id, "request").each do |feat|
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
    Feature.request.active.added_by(current_user.id).for_user(current_user.id, "request").each do |feat|
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

  # Use callbacks to share common setup or constraints between actions.
  def set_pairwise_comparison
    @pairwise_comparison = PairwiseComparison.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pairwise_comparison_params
    params.require(:pairwise_comparison).permit(:participant_id, :scenario_1, :scenario_2, :choice, :reason)
  end
end
