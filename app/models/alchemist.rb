class Alchemist < ApplicationRecord

  has_many :transactions

  enum rank: %i[apprentice acolyte alchemist]

  has_secure_password

  validates :username, presence: true, uniqueness: true

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
      mana_earned = transmutation.mana_for(self)

      add_mana(mana_earned)

      self.send(
        "#{transmutation.id}_ready_at=",
        (DateTime.now() + 16.hours).midnight() + 8.hours
      )

      save!

      Transaction.record(
        alchemist_id:       id,
        transmutation_name: transmutation.name,
        mana_earned:        mana_earned
      )
    end
  end

  def transcend!
    return false unless can_transcend?

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

  def reset!
    self.class.transaction do
      self.mana          = 0
      self.lifetime_mana = 0
      self.level         = 1
      self.rank          = 0

      self.bronze = 0
      self.silver = 0
      self.gold   = 0

      self.mind_unlock = false
      self.body_unlock = false

      self.connect_unlocked       = false
      self.values_unlocked        = false
      self.affirmations_unlocked  = false
      self.mindfulness_unlocked   = false
      self.passion_unlocked       = false
      self.reading_unlocked       = false
      self.visualization_unlocked = false
      self.meditation_unlocked    = false
      self.sleep_unlocked         = false
      self.supplement_unlocked    = false
      self.fitness_unlocked       = false
      self.nature_unlocked        = false
      self.sunlight_unlocked      = false
      self.good_food_unlocked     = false
      self.junk_food_unlocked     = false
      self.yoga_unlocked          = false

      self.gratitude_ready_at     = nil
      self.connect_ready_at       = nil
      self.values_ready_at        = nil
      self.affirmations_ready_at  = nil
      self.mindfulness_ready_at   = nil
      self.passion_ready_at       = nil
      self.reading_ready_at       = nil
      self.visualization_ready_at = nil
      self.meditation_ready_at    = nil
      self.hydration_ready_at     = nil
      self.sleep_ready_at         = nil
      self.supplement_ready_at    = nil
      self.fitness_ready_at       = nil
      self.nature_ready_at        = nil
      self.sunlight_ready_at      = nil
      self.good_food_ready_at     = nil
      self.junk_food_ready_at     = nil
      self.yoga_ready_at          = nil

      self.last_mind_unlock = nil
      self.last_body_unlock = nil

      save!

      transactions.destroy_all
    end
  end

  def present
    {
      rank:          rank,
      level:         level,
      mana:          mana,
      mind_unlock:   mind_unlock,
      body_unlock:   body_unlock,
      can_transcend: can_transcend?,
      can_ascend:    can_ascend?
    }
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
      Transmutation.categories[category]
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

  def can_transcend?
    return false if unlocking_transmutation?
    return false if alchemist? && max_level?

    sufficient_mana? && transmutation_requirements_met?
  end

  def can_ascend?
    can_transcend? && max_level? && !alchemist?
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
