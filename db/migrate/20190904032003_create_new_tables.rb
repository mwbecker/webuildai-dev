class CreateNewTables < ActiveRecord::Migration[5.2]
  def change

    create_table :ranklists do |t|
      t.references :participant
      t.integer :round, default: 0

    end

    create_table :individual_scenarios do |t|
      t.json :features

    end

    create_table :ranklist_element do |t|
      t.references :ranklist
      t.references :individual_scenario
      t.integer :model_rank
      t.integer :human_rank

    end

  end
end
