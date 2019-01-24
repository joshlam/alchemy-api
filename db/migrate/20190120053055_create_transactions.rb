class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :mana_earned, default: 0

      t.timestamps
    end

    add_reference :transactions, :alchemist, foreign_key: true

    add_column      :transactions, :transmutation_name, :string
    add_index       :transactions, :transmutation_name
    add_foreign_key :transactions, :transmutations, column: :transmutation_name, primary_key: :name
  end
end
