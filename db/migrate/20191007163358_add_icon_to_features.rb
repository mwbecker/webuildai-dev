class AddIconToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :icon, :text
  end
end
