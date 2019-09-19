# frozen_string_literal: true

class AddAddedByToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :added_by, :string
  end
end
