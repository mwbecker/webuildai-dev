# frozen_string_literal: true

class AddCategoryToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :category, :string
  end
end
