class CreateDataRanges < ActiveRecord::Migration[5.2]
  def change
    create_table :data_ranges do |t|
      t.references :feature, foreign_key: true
      t.boolean :is_categorical
      t.float :lower_bound
      t.float :upper_bound

      t.timestamps
    end
  end
end
