class AddCategoryToIndividualScenarios < ActiveRecord::Migration[5.2]
  def change
    add_column :individual_scenarios, :category, :string
  end
end
