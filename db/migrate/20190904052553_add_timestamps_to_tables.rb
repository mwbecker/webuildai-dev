class AddTimestampsToTables < ActiveRecord::Migration[5.2]
  def change
    change_table(:individual_scenarios) { |t| t.timestamps }
    change_table(:ranklists) { |t| t.timestamps }
    change_table(:ranklist_element) { |t| t.timestamps }
  end
end
