class AddForeignKeyToPairwise < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :pairwise_comparisons, :scenario_groups, column: :scenario_1
    add_foreign_key :pairwise_comparisons, :scenario_groups, column: :scenario_2
  end
end
