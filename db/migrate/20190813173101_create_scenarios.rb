class CreateScenarios < ActiveRecord::Migration[5.2]
  def change
    create_table :scenarios do |t|
      t.integer :group_id
      t.references :feature, foreign_key: true
      t.string :feature_value

      t.timestamps
    end
  end
end
