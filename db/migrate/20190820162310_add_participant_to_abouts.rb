class AddParticipantToAbouts < ActiveRecord::Migration[5.2]
  def change
    add_reference :abouts, :participant, foreign_key: true
  end
end
