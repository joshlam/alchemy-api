class Transaction < ApplicationRecord

  belongs_to :alchemist
  belongs_to :transmutation,
    foreign_key: 'transmutation_name',
    primary_key: 'name'

  scope :since, ->(date) { where('created_at >= ?', date) }

  def self.record(alchemist_id:, transmutation_name:, mana_earned:)
    self.create! do |transaction|
      transaction.alchemist_id       = alchemist_id
      transaction.transmutation_name = transmutation_name
      transaction.mana_earned        = mana_earned
    end
  end

  def self.summary(start_date = 1.day.ago,
                   time_zone = 'Pacific Time (US & Canada)')
    since(start_date).map do |transaction|
      datetime = transaction.created_at.in_time_zone(time_zone)

      [
        transaction.alchemist.username,
        transaction.transmutation_name,
        "#{datetime.month}/#{datetime.day} #{datetime.hour}:#{datetime.min}"
      ]
    end
  end

end
