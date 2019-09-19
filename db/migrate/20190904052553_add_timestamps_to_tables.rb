# frozen_string_literal: true

class AddTimestampsToTables < ActiveRecord::Migration[5.2]
  def change
    change_table(:individual_scenarios, &:timestamps)
    change_table(:ranklists, &:timestamps)
    change_table(:ranklist_element, &:timestamps)
  end
end
