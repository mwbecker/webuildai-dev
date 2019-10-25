namespace :move_scenario do
  desc "Add all Scenario group_ids into scenario_groups"

  task scen_to_group: :environment do
    Scenario.all.each do |scenario|
      group_id = scenario.group_id
      if !ScenarioGroup.exists?(group_id)
        ScenarioGroup.create(id: group_id)
      end
    end

  end
end