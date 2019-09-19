# frozen_string_literal: true

class AddTypeToParticipantFeatureWeights < ActiveRecord::Migration[5.2]
  def change
    add_column :participant_feature_weights, :type, :string
  end
end
