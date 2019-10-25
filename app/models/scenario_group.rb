class ScenarioGroup < ApplicationRecord
  has_many :groups, class_name: 'Scenario', foreign_key: :group_id
  has_many :scenario_1s, class_name: "PairwiseComparison", foreign_key: :scenario_1
  has_many :scenario_2s, class_name: "PairwiseComparison", foreign_key: :scenario_2
end