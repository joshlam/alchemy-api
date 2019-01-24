class CreateTransmutations < ActiveRecord::Migration[5.2]
  def change
    create_table :transmutations, id: false do |t|
      t.string  :name,     null: false, primary_key: true
      t.integer :category, null: false
      t.integer :level,    null: false
      t.integer :tier,     null: false
      t.integer :mana,     default: 0

      t.text :instructions
      t.text :explanation
      t.text :tips
      t.text :more
      t.text :references

      t.timestamps
    end
  end
end
