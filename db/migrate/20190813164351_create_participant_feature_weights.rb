# frozen_string_literal: true

class CreateParticipantFeatureWeights < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_feature_weights do |t|
      t.references :participant, foreign_key: true
      t.references :feature, foreign_key: true
      t.integer :weight

      t.timestamps
    end
  end
end
