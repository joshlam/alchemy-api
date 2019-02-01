class CreateAlchemists < ActiveRecord::Migration[5.2]
  def change
    create_table :alchemists do |t|
      t.string :name,            null: false
      t.string :email,           null: false
      t.string :password_digest, null: false

      t.integer :mana,          default: 0
      t.integer :lifetime_mana, default: 0

      t.boolean :mind_unlock, default: false
      t.boolean :body_unlock, default: false

      t.boolean :gratitude_unlocked,     default: true
      t.boolean :connect_unlocked,       default: false
      t.boolean :values_unlocked,        default: false
      t.boolean :affirmations_unlocked,  default: false
      t.boolean :mindfulness_unlocked,   default: false
      t.boolean :passion_unlocked,       default: false
      t.boolean :reading_unlocked,       default: false
      t.boolean :visualization_unlocked, default: false
      t.boolean :meditation_unlocked,    default: false

      t.boolean :hydration_unlocked,  default: true
      t.boolean :sleep_unlocked,      default: false
      t.boolean :supplement_unlocked, default: false
      t.boolean :fitness_unlocked,    default: false
      t.boolean :nature_unlocked,     default: false
      t.boolean :sunlight_unlocked,   default: false
      t.boolean :good_food_unlocked,  default: false
      t.boolean :junk_food_unlocked,  default: false
      t.boolean :yoga_unlocked,       default: false

      t.datetime :gratitude_ready_at
      t.datetime :connect_ready_at
      t.datetime :values_ready_at
      t.datetime :affirmations_ready_at
      t.datetime :mindfulness_ready_at
      t.datetime :passion_ready_at
      t.datetime :reading_ready_at
      t.datetime :visualization_ready_at
      t.datetime :meditation_ready_at

      t.datetime :hydration_ready_at
      t.datetime :sleep_ready_at
      t.datetime :supplement_ready_at
      t.datetime :fitness_ready_at
      t.datetime :nature_ready_at
      t.datetime :sunlight_ready_at
      t.datetime :good_food_ready_at
      t.datetime :junk_food_ready_at
      t.datetime :yoga_ready_at

      t.string :last_mind_unlock
      t.string :last_body_unlock

      t.integer :level, default: 1
      t.integer :rank,  default: 0

      t.integer :bronze, default: 0
      t.integer :silver, default: 0
      t.integer :gold,   default: 0

      t.timestamps
    end

    add_index :alchemists, :email, unique: true
  end
end
