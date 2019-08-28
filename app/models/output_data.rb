class OutputData
  require 'json'
  require 'date'

  def initialize(participant_id)
    @participant_id = participant_id
    @participant = Participant.find(@participant_id)

  end

  def retrieve_choices
    overall_list = Array.new
    comparisons = @participant.pairwise_comparisons.last(50)
    comparisons.each do |comparison|
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
        scenario_b_list << scenario_b_hash
      end

      comparison_hash[:scenario_2] = scenario_b_list
      comparison_hash[:choice] = comparison.choice
      overall_list << comparison_hash
    end

    return overall_list

    #return JSON.parse(comparisons.to_json(:except => :participant_id))
  end

  def retrieve_weights
    weights = @participant.participant_feature_weights
    return JSON.parse(weights.to_json(:except => :participant_id))
  end

  def output

    result = Hash.new
    result[:part_id] = @participant_id
    result[:comparisons] = retrieve_choices
    result[:weights] = retrieve_weights

    # Could be useful?
    result[:current_timestamp] = DateTime.now

    result_hash = JSON.dump(result)
    # puts(result_hash)
    path_name = Rails.root.join("config/output_storage/#{@participant_id}")
    file_name = "#{@participant_id}-#{DateTime.now}.json"

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





end








