class FixType < ActiveRecord::Migration[5.2]
  def change
        rename_column :participant_feature_weights, :type, :method
  end
end
