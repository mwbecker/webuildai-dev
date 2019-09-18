class AddUnitToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :unit, :string
  end
end
