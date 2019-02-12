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

ActiveRecord::Schema.define(version: 2019_02_12_024902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alchemists", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.integer "mana", default: 0
    t.integer "lifetime_mana", default: 0
    t.boolean "mind_unlock", default: false
    t.boolean "body_unlock", default: false
    t.boolean "gratitude_unlocked", default: true
    t.boolean "values_unlocked", default: false
    t.boolean "socialize_unlocked", default: false
    t.boolean "affirmations_unlocked", default: false
    t.boolean "mindfulness_unlocked", default: false
    t.boolean "soul_fuel_unlocked", default: false
    t.boolean "envision_unlocked", default: false
    t.boolean "body_scan_unlocked", default: false
    t.boolean "meditation_unlocked", default: false
    t.boolean "hydration_unlocked", default: true
    t.boolean "sleep_unlocked", default: false
    t.boolean "supplement_unlocked", default: false
    t.boolean "sunlight_unlocked", default: false
    t.boolean "fitness_unlocked", default: false
    t.boolean "nature_unlocked", default: false
    t.boolean "junk_food_unlocked", default: false
    t.boolean "good_food_unlocked", default: false
    t.boolean "yoga_unlocked", default: false
    t.datetime "gratitude_ready_at"
    t.datetime "values_ready_at"
    t.datetime "socialize_ready_at"
    t.datetime "affirmations_ready_at"
    t.datetime "mindfulness_ready_at"
    t.datetime "soul_fuel_ready_at"
    t.datetime "envision_ready_at"
    t.datetime "body_scan_ready_at"
    t.datetime "meditation_ready_at"
    t.datetime "hydration_ready_at"
    t.datetime "sleep_ready_at"
    t.datetime "supplement_ready_at"
    t.datetime "sunlight_ready_at"
    t.datetime "fitness_ready_at"
    t.datetime "nature_ready_at"
    t.datetime "junk_food_ready_at"
    t.datetime "good_food_ready_at"
    t.datetime "yoga_ready_at"
    t.string "last_mind_unlock"
    t.string "last_body_unlock"
    t.integer "level", default: 1
    t.integer "rank", default: 0
    t.integer "bronze", default: 0
    t.integer "silver", default: 0
    t.integer "gold", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_alchemists_on_username", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "mana_earned", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "alchemist_id"
    t.string "transmutation_name"
    t.index ["alchemist_id"], name: "index_transactions_on_alchemist_id"
    t.index ["transmutation_name"], name: "index_transactions_on_transmutation_name"
  end

  create_table "transmutations", primary_key: "name", id: :string, force: :cascade do |t|
    t.integer "category", null: false
    t.integer "level", null: false
    t.integer "tier", null: false
    t.integer "mana", default: 0
    t.text "instructions"
    t.text "explanation"
    t.text "tips"
    t.text "more"
    t.text "references"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "transactions", "alchemists"
  add_foreign_key "transactions", "transmutations", column: "transmutation_name", primary_key: "name"
end
