# frozen_string_literal: true

class AddParticipantToIndividualScenarios < ActiveRecord::Migration[5.2]
  def change
    add_reference :individual_scenarios, :participant, foreign_key: true
  end
end
