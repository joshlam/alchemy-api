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

  def transcend!
    return false if unlocking_transmutation?
    return false if alchemist? && max_level?
    return false unless sufficient_mana? && transmutation_requirements_met?

    self.mana -= mana_for_leveling

    if !alchemist? && max_level?
      self.level = 1
      self.rank  = rank_to_num + 1
    else
      self.level += 1
    end

    if apprentice? && level < 10
      self.mind_unlock = true
      self.body_unlock = true
    end

    save!
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
    ).uniq.count == 2
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

  def max_level?
    level == (alchemist? ? 11 : 10)
  end

  def sufficient_mana?
    mana >= mana_for_leveling
  end

  def mana_for_leveling
    level * 10
  end

  def transmutation_requirements_met?
    return true unless apprentice? && level < 10
    return true if level == 1

    Transmutation.joins(:transactions).where(
      'alchemist_id = ? AND name in (?)',
      id,
      [last_mind_unlock, last_body_unlock]
    ).uniq.count == 2
  end

  def rank_to_num
    self.class.ranks[rank]
  end

end
