class AddCompanyToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :company, :boolean, default: false
  end
end
