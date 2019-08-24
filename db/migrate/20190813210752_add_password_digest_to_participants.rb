class AddPasswordDigestToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :password_digest, :string
  end
end
