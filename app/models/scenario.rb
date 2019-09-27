# frozen_string_literal: true

class Scenario < ApplicationRecord
  belongs_to :feature
  belongs_to :participant
  belongs_to :scenairo_group, class_name: 'ScenarioGroup', :foreign_key => "group_id"
  # validate :check_feature_value

  scope :by_user, -> (participant_id) {where participant_id: participant_id}

  def self.for_group(group_id)
    Scenario.all.where(group_id: group_id).map { |s| [s.feature_id, s.feature_value] }.to_h
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
