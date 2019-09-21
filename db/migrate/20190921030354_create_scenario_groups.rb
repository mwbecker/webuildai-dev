class CreateScenarioGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :scenario_groups do |t|

      t.timestamps
    end
  end
end
