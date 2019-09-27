class FixTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :rank_list_samples
    drop_table :rank_lists
  end
end
