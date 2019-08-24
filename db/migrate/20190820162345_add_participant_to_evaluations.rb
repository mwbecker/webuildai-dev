class AddParticipantToEvaluations < ActiveRecord::Migration[5.2]
  def change
    add_reference :evaluations, :participant, foreign_key: true
  end
end
