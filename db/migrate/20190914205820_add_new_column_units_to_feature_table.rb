class AddNewColumnUnitsToFeatureTable < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :unit, :string
  end
end
