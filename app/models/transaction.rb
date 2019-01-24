class Transaction < ApplicationRecord

  belongs_to :alchemist
  belongs_to :transmutation,
    foreign_key: 'transmutation_name',
    primary_key: 'name'

  def self.record(alchemist_id:, transmutation_name:, mana_earned:)
    self.create! do |transaction|
      transaction.alchemist_id       = alchemist_id
      transaction.transmutation_name = transmutation_name
      transaction.mana_earned        = mana_earned
    end
  end

end
