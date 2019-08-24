class Scenario < ApplicationRecord
  belongs_to :feature
  validate :check_feature_value



def self.for_group(group_id)
  return Scenario.all.where(group_id: group_id).map{|s| [s.feature_id, s.feature_value] }.to_h
end

private
  def check_feature_value
    if self.feature.data_range.is_categorical
     if !self.feature.categorical_data_options.map{|n| n.option_value}.include?(self.feature_value)
       errors.add(:scenario, "Feature value is not valid")
       return false
     end
    else
     if self.feature_value.to_i < self.feature.data_range.lower_bound || self.feature_value.to_i > self.feature.data_range.upper_bound
        errors.add(:scenario, "Feature value is out of range")
        return false
     end
    end
    return true
  end

end
