# frozen_string_literal: true

class CreateAbouts < ActiveRecord::Migration[5.2]
  def change
    create_table :abouts do |t|
      t.string :which
      t.string :long
      t.string :service
      t.string :actively
      t.string :deactivated
      t.string :pending
      t.string :satisified

      t.timestamps
    end
  end
end
