class ScenarioGroup < ApplicationRecord
  has_many :scenarios, class_name: 'Scenario', :foreign_key => "group_id", :dependent => :destroy
end
