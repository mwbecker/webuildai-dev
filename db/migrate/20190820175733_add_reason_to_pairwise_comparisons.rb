# frozen_string_literal: true

class AddReasonToPairwiseComparisons < ActiveRecord::Migration[5.2]
  def change
    add_column :pairwise_comparisons, :reason, :string
  end
end
