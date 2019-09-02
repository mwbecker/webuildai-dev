class AddRankedlistTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :rank_lists
    drop_table :rank_list_samples
    
    create_table :rank_lists do |t|
      t.references :participant
      t.integer :rank
      t.integer :round, default: 0

      t.timestamps
    end

    create_table :rank_list_samples do |t|
      t.references :participant
      t.references :rank_list
      t.integer :round, default: 0
      t.string :type
      t.references :feature
      t.string :feature_value
      t.integer :group_id

      t.timestamps
    end

  end
end