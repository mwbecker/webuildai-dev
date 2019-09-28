# frozen_string_literal: true

class PairwiseComparison < ApplicationRecord
  belongs_to :participant

  def pc_to_json
    comparison_hash = {}
    comparison_hash[:choice] = self.choice

    # scenario 1
    scenario_a_list = []
    Scenario.for_group_features(self.scenario_1).each do |s|
      scenario_a_list << s.scenario_to_json()
    end
    comparison_hash[:scenario_1] = {features: scenario_a_list, group_id: self.scenario_1}

    # scenario 2
    scenario_b_list = []
    Scenario.for_group_features(self.scenario_2).each do |s|
      scenario_b_list << s.scenario_to_json()
    end
    comparison_hash[:scenario_2] = {features: scenario_b_list, group_id: self.scenario_2}
    comparison_hash[:id] = self.id
    comparison_hash
  end

end
