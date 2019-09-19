# frozen_string_literal: true

class CreatePairwiseComparisons < ActiveRecord::Migration[5.2]
  def change
    create_table :pairwise_comparisons do |t|
      t.references :participant, foreign_key: true
      t.integer :scenario_1
      t.integer :scenario_2
      t.integer :choice

      t.timestamps
    end
  end
end
