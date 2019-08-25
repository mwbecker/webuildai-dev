class AddRoleToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :role, :string
  end
end
