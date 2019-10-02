# frozen_string_literal: true

class Scenario < ApplicationRecord
  belongs_to :feature
  validate :check_feature_value

  def self.for_group(group_id)
    Scenario.all.where(group_id: group_id).map { |s| [s.feature_id, s.feature_value] }.to_h
  end

  def self.for_group_features(group_id)
    Scenario.where(group_id: group_id).order(id: :asc)
  end

  def scenario_to_json
    feature = self.feature
    data_range = feature.data_range
    is_categorical = data_range.is_categorical
    result = {}
    result[:feat_id] = self.feature_id
    result[:feat_name] = feature.name
    result[:feat_unit] = feature.unit
    result[:feat_category] = 0 # TODO: idk what this is
    result[:feat_value] = self.feature_value
    result[:feat_type] = is_categorical ? 'categorical' : 'continuous'
    result[:feat_min] = data_range.lower_bound
    result[:feat_max] = data_range.upper_bound
    if is_categorical
      result[:possible_values] = data_range.categorical_data_options.map(&:option_value)
    end
    result
  end

  private

  def check_feature_value
    if feature.data_range.is_categorical
      unless feature.categorical_data_options.map(&:option_value).include?(feature_value)
        errors.add(:scenario, 'Feature value is not valid')
        return false
      end
    else
      if feature_value.to_f < feature.data_range.lower_bound.to_f || feature_value.to_f > feature.data_range.upper_bound.to_f
        errors.add(:scenario, 'Feature value is out of range')
        return false
      end
    end
    true
  end
end
