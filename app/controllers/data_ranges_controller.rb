class DataRangesController < ApplicationController
  before_action :set_data_range, only: [:show, :edit, :update, :destroy]

  # GET /data_ranges
  # GET /data_ranges.json
  def index
    @data_ranges = DataRange.all
  end

  # GET /data_ranges/1
  # GET /data_ranges/1.json
  def show
  end

  # GET /data_ranges/new
  def new
    @data_range = DataRange.new
  end

  # GET /data_ranges/1/edit
  def edit
  end

  # POST /data_ranges
  # POST /data_ranges.json
  def create
    @data_range = DataRange.new(data_range_params)

    respond_to do |format|
      if @data_range.save
        format.html { redirect_to @data_range, notice: 'Data range was successfully created.' }
        format.json { render :show, status: :created, location: @data_range }
      else
        format.html { render :new }
        format.json { render json: @data_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_ranges/1
  # PATCH/PUT /data_ranges/1.json
  def update
    respond_to do |format|
      if @data_range.update_attributes(data_range_params)
        format.html { redirect_to @data_range, notice: 'Data range was successfully updated.' }
        format.json { render :show, status: :ok, location: @data_range }
      else
        format.html { render :edit }
        format.json { render json: @data_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_ranges/1
  # DELETE /data_ranges/1.json
  def destroy
    @data_range.destroy
    respond_to do |format|
      format.html { redirect_to data_ranges_url, notice: 'Data range was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_range
      @data_range = DataRange.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_range_params
      params.require(:data_range).permit(:feature_id, :is_categorical, :lower_bound, :upper_bound)
    end
end
