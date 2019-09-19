# frozen_string_literal: true

class AddCategoryToPairwiseComparisons < ActiveRecord::Migration[5.2]
  def change
    add_column :pairwise_comparisons, :category, :string
  end
end
