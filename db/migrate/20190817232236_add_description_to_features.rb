# frozen_string_literal: true

class AddDescriptionToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :description, :string
  end
end
