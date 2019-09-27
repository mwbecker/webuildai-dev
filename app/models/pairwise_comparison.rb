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
    comparison_hash[:scenario_1] = scenario_a_list

    # scenario 2
    scenario_b_list = []
    Scenario.for_group_features(self.scenario_2).each do |s|
      scenario_b_list << s.scenario_to_json()
    end
    comparison_hash[:scenario_2] = scenario_b_list
    comparison_hash
  end

end
