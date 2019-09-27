# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_21_210249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abouts", force: :cascade do |t|
    t.string "which"
    t.string "long"
    t.string "service"
    t.string "actively"
    t.string "deactivated"
    t.string "pending"
    t.string "satisified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "participant_id"
    t.index ["participant_id"], name: "index_abouts_on_participant_id"
  end

  create_table "categorical_data_options", force: :cascade do |t|
    t.bigint "data_range_id"
    t.string "option_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_range_id"], name: "index_categorical_data_options_on_data_range_id"
  end

  create_table "data_ranges", force: :cascade do |t|
    t.bigint "feature_id"
    t.boolean "is_categorical"
    t.float "lower_bound"
    t.float "upper_bound"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id"], name: "index_data_ranges_on_feature_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.boolean "show"
    t.string "how"
    t.string "fairly"
    t.string "correctly"
    t.string "priorities"
    t.string "previously"
    t.string "situation"
    t.string "resolve"
    t.string "functions"
    t.string "incorrect"
    t.string "alert"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "participant_id"
    t.index ["participant_id"], name: "index_evaluations_on_participant_id"
  end

  create_table "features", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "category"
    t.boolean "active", default: true
    t.string "added_by"
    t.boolean "company", default: false
    t.string "unit"
  end

  create_table "individual_scenarios", force: :cascade do |t|
    t.json "features"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "participant_id"
    t.string "category"
    t.index ["participant_id"], name: "index_individual_scenarios_on_participant_id"
  end

  create_table "pairwise_comparisons", force: :cascade do |t|
    t.bigint "participant_id"
    t.integer "scenario_1"
    t.integer "scenario_2"
    t.integer "choice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reason"
    t.string "category"
    t.index ["participant_id"], name: "index_pairwise_comparisons_on_participant_id"
  end

  create_table "participant_feature_weights", force: :cascade do |t|
    t.bigint "participant_id"
    t.bigint "feature_id"
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "method"
    t.index ["feature_id"], name: "index_participant_feature_weights_on_feature_id"
    t.index ["participant_id"], name: "index_participant_feature_weights_on_participant_id"
  end

  create_table "participants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "role"
    t.string "name"
    t.string "email"
  end

  create_table "ranklist_element", force: :cascade do |t|
    t.bigint "ranklist_id"
    t.bigint "individual_scenario_id"
    t.integer "model_rank"
    t.integer "human_rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["individual_scenario_id"], name: "index_ranklist_element_on_individual_scenario_id"
    t.index ["ranklist_id"], name: "index_ranklist_element_on_ranklist_id"
  end

  create_table "ranklists", force: :cascade do |t|
    t.bigint "participant_id"
    t.integer "round", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_ranklists_on_participant_id"
  end

  create_table "scenario_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scenarios", force: :cascade do |t|
    t.integer "group_id"
    t.bigint "feature_id"
    t.string "feature_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "participant_id"
    t.index ["feature_id"], name: "index_scenarios_on_feature_id"
    t.index ["participant_id"], name: "index_scenarios_on_participant_id"
  end

  add_foreign_key "abouts", "participants"
  add_foreign_key "categorical_data_options", "data_ranges"
  add_foreign_key "data_ranges", "features"
  add_foreign_key "evaluations", "participants"
  add_foreign_key "individual_scenarios", "participants"
  add_foreign_key "pairwise_comparisons", "participants"
  add_foreign_key "participant_feature_weights", "features"
  add_foreign_key "participant_feature_weights", "participants"
  add_foreign_key "scenarios", "features"
  add_foreign_key "scenarios", "participants"
end
