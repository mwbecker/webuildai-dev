class CategoricalDataOptionsController < ApplicationController
  before_action :set_categorical_data_option, only: [:show, :edit, :update, :destroy]

  # GET /categorical_data_options
  # GET /categorical_data_options.json
  def index
    @categorical_data_options = CategoricalDataOption.all
  end

  # GET /categorical_data_options/1
  # GET /categorical_data_options/1.json
  def show
  end

  # GET /categorical_data_options/new
  def new
    @categorical_data_option = CategoricalDataOption.new
  end

  # GET /categorical_data_options/1/edit
  def edit
  end

  # POST /categorical_data_options
  # POST /categorical_data_options.json
  def create
    @categorical_data_option = CategoricalDataOption.new(categorical_data_option_params)

    respond_to do |format|
      if @categorical_data_option.save
        format.html { redirect_to @categorical_data_option, notice: 'Categorical data option was successfully created.' }
        format.json { render :show, status: :created, location: @categorical_data_option }
      else
        format.html { render :new }
        format.json { render json: @categorical_data_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categorical_data_options/1
  # PATCH/PUT /categorical_data_options/1.json
  def update
    respond_to do |format|
      if @categorical_data_option.update(categorical_data_option_params)
        format.html { redirect_to @categorical_data_option, notice: 'Categorical data option was successfully updated.' }
        format.json { render :show, status: :ok, location: @categorical_data_option }
      else
        format.html { render :edit }
        format.json { render json: @categorical_data_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categorical_data_options/1
  # DELETE /categorical_data_options/1.json
  def destroy
    @categorical_data_option.destroy
    respond_to do |format|
      format.html { redirect_to categorical_data_options_url, notice: 'Categorical data option was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_categorical_data_option
      @categorical_data_option = CategoricalDataOption.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def categorical_data_option_params
      params.require(:categorical_data_option).permit(:data_range_id, :option_value)
    end
end
