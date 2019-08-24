class CreateEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|
      t.boolean :show
      t.string :how
      t.string :fairly
      t.string :correctly
      t.string :priorities
      t.string :previously
      t.string :situation
      t.string :resolve
      t.string :functions
      t.string :incorrect
      t.string :alert

      t.timestamps
    end
  end
end
