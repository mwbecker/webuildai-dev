class AddActiveToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :active, :boolean, default: true
  end
end
