class Alchemist < ApplicationRecord

  has_many :transactions

  enum rank: %i[apprentice acolyte alchemist]

  has_secure_password

  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true

  def unlock!(transmutation)
    return false if unlocked?(transmutation)
    return false unless unlockable?(transmutation)

    self.send("#{transmutation.id}_unlocked=", true)
    self.send("#{transmutation.category}_unlock=", false)
    self.send("last_#{transmutation.category}_unlock=", transmutation.name)

    save!
  end

  def transmute!(transmutation)
    return false if unlocking_transmutation?
    return false unless transmutable?(transmutation)

    self.class.transaction do
      add_mana(transmutation.mana)

      self.send("#{transmutation.id}_ready_at=", 24.hours.from_now)

      save!

      Transaction.record(
        alchemist_id:       id,
        transmutation_name: transmutation.name,
        mana_earned:        transmutation.mana
      )
    end
  end

  def statuses
    Transmutation.all.each_with_object({}) do |transmutation, statuses|
      statuses[transmutation.name] = status_for(transmutation)
    end
  end

  def status_for(transmutation)
    unless unlocked?(transmutation)
      return unlockable?(transmutation) ? :UNLOCKABLE : :LOCKED
    end

    ready_for?(transmutation) ? :READY : :COMPLETE
  end

  private

  def unlocked?(transmutation)
    return true unless apprentice?

    self.send("#{transmutation.id}_unlocked?")
  end

  def unlockable?(transmutation)
    return false unless self.send("#{transmutation.category}_unlock?")
    return false unless level >= transmutation.level
    return true unless level == 4 && transmutation.tier != 2

    tier_two_complete?(transmutation.category)
  end

  def tier_two_complete?(category)
    Transmutation.joins(:transactions).where(
      'tier = 2 AND alchemist_id = ? AND category = ?',
      id,
      category
    ).count == 2
  end

  def unlocking_transmutation?
    mind_unlock? || body_unlock?
  end

  def transmutable?(transmutation)
    unlocked?(transmutation) && ready_for?(transmutation)
  end

  def ready_for?(transmutation)
    ready_at = self.send("#{transmutation.id}_ready_at")

    return true if ready_at.nil?

    ready_at <= Time.now
  end

  def add_mana(mana)
    self.mana          += mana
    self.lifetime_mana += mana
  end

end
