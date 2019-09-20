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

  private

  def check_feature_value
    if feature.data_range.is_categorical
      unless feature.categorical_data_options.map(&:option_value).include?(feature_value)
        errors.add(:scenario, 'Feature value is not valid')
        return false
      end
    else
      if feature_value.to_i < feature.data_range.lower_bound || feature_value.to_i > feature.data_range.upper_bound
        errors.add(:scenario, 'Feature value is out of range')
        return false
      end
    end
    true
  end
end
