class AddParticipantToScenarios < ActiveRecord::Migration[5.2]
  def change
    add_reference :scenarios, :participant, foreign_key: true
  end
end
