class CreateCategoricalDataOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :categorical_data_options do |t|
      t.references :data_range, foreign_key: true
      t.string :option_value

      t.timestamps
    end
  end
end
