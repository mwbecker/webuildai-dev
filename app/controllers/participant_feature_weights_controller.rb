# frozen_string_literal: true

class ParticipantFeatureWeightsController < ApplicationController
  # before_action :set_participant_feature_weight, only: [:show, :edit, :update, :destroy]

  # GET /participant_feature_weights
  # GET /participant_feature_weights.json
  def index
    @participant_feature_weights = ParticipantFeatureWeight.all
  end

  # GET /participant_feature_weights/1
  # GET /participant_feature_weights/1.json
  def show; end

  # GET /participant_feature_weights/new
  def new
    @participant_feature_weight = ParticipantFeatureWeight.new
  end

  # GET /participant_feature_weights/1/edit
  def edit; end

  # POST /participant_feature_weights
  # POST /participant_feature_weights.json
  def create; end

  def weighting
    pid = params[:participant_id].to_i
    fid = params[:feature_id].to_i
    w =  params[:weight].to_i
    puts pid, fid, w
    puts 'madeit'
    if ParticipantFeatureWeight.where('participant_id = ? AND feature_id = ? AND method = ?', pid, fid, params[:method]).empty?
      @participant_feature_weight = ParticipantFeatureWeight.new
      @participant_feature_weight.participant_id = pid
      @participant_feature_weight.feature_id = fid
      @participant_feature_weight.weight = w
      @participant_feature_weight.method = params[:method]
      @participant_feature_weight.save!

    else
      @participant_feature_weight = ParticipantFeatureWeight.where('participant_id = ? AND feature_id = ? AND method = ?', pid, fid, params[:method]).first
      @participant_feature_weight.weight = w
      @participant_feature_weight.method = params[:method]
      @participant_feature_weight.save!
    end
  end

  def new_how_ai
    pid = params[:participant_id].to_i
    fid = params[:feature_id].to_i
    w =  params[:weight].to_i
    puts pid, fid, w
    puts 'madeit'
    if ParticipantFeatureWeight.where('participant_id = ? AND feature_id = ? AND method = ?', pid, fid, params[:method]).empty?
      @participant_feature_weight = ParticipantFeatureWeight.new
      @participant_feature_weight.participant_id = pid
      @participant_feature_weight.feature_id = fid
      @participant_feature_weight.weight = w
      @participant_feature_weight.method = params[:method]
      @participant_feature_weight.save!

    else
      @participant_feature_weight = ParticipantFeatureWeight.where('participant_id = ? AND feature_id = ? AND method = ?', pid, fid, params[:method]).first
      @participant_feature_weight.weight = w
      @participant_feature_weight.method = params[:method]
      @participant_feature_weight.save!
    end
  end

  # PATCH/PUT /participant_feature_weights/1
  # PATCH/PUT /participant_feature_weights/1.json
  def update
    respond_to do |format|
      if @participant_feature_weight.update(participant_feature_weight_params)
        format.html { redirect_to @participant_feature_weight, notice: 'Participant feature weight was successfully updated.' }
        format.json { render :show, status: :ok, location: @participant_feature_weight }
      else
        format.html { render :edit }
        format.json { render json: @participant_feature_weight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participant_feature_weights/1
  # DELETE /participant_feature_weights/1.json
  def destroy
    @participant_feature_weight.destroy
    respond_to do |format|
      format.html { redirect_to participant_feature_weights_url, notice: 'Participant feature weight was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_participant_feature_weight
    @participant_feature_weight = ParticipantFeatureWeight.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def participant_feature_weight_params
    params.require(:participant_feature_weight).permit(:participant_id, :feature_id, :weight, :method)
  end
end
