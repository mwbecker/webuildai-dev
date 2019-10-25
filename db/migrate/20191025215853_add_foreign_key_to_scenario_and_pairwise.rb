class AddForeignKeyToScenarioAndPairwise < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :scenarios, :scenario_groups, column: :group_id

  end
end
