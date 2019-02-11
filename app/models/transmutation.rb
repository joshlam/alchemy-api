class Transmutation < ApplicationRecord

  self.primary_key = 'name'

  has_many :transactions, foreign_key: 'transmutation_name'

  enum category: %i[mind body]

  def self.Gratitude
    find_by_name('Gratitude')
  end

  def self.Connect
    find_by_name('Connect')
  end

  def self.Values
    find_by_name('Values')
  end

  def self.Affirmations
    find_by_name('Affirmations')
  end

  def self.Reading
    find_by_name('Reading')
  end

  def self.Passion
    find_by_name('Passion')
  end

  def self.Mindfulness
    find_by_name('Mindfulness')
  end

  def self.Visualization
    find_by_name('Visualization')
  end

  def self.Meditation
    find_by_name('Meditation')
  end

  def self.Hydration
    find_by_name('Hydration')
  end

  def self.Sleep
    find_by_name('Sleep')
  end

  def self.Supplement
    find_by_name('Supplement')
  end

  def self.Fitness
    find_by_name('Fitness')
  end

  def self.Nature
    find_by_name('Nature')
  end

  def self.Sunlight
    find_by_name('Sunlight')
  end

  def self.Good_Food
    find_by_name('Good Food')
  end

  def self.Junk_Food
    find_by_name('Junk Food')
  end

  def self.Yoga
    find_by_name('Yoga')
  end

  def id
    name.gsub(' ', '').underscore
  end

  def instructions_for(alchemist)
    return instructions unless varies_by_level?

    return hydration_instructions_for(alchemist) if name == 'Hydration'
    return meditation_instructions_for(alchemist) if name == 'Meditation'
  end

  def mana_for(alchemist)
    return mana unless varies_by_level?

    return hydration_mana_for(alchemist) if name == 'Hydration'
    return meditation_mana_for(alchemist) if name == 'Meditation'
  end

  private

  def varies_by_level?
    name == 'Hydration' || name == 'Meditation'
  end

  def hydration_instructions_for(alchemist)
    return 'Drink 1.25 liters of water today' if alchemist.acolyte?
    return 'Drink 1.5 liters of water today' if alchemist.alchemist?

    return instructions
  end

  def meditation_instructions_for(alchemist)
    if alchemist.apprentice? || alchemist.acolyte? && alchemist.level == 1
      return instructions
    end

    return "Meditate for #{meditation_minutes_for(alchemist)} minutes"
  end

  def meditation_minutes_for(alchemist)
    minutes = alchemist.level
    minutes += 10 if alchemist.alchemist?

    minutes
  end

  def hydration_mana_for(alchemist)
    return 3 if alchemist.acolyte?
    return 4 if alchemist.alchemist?

    return mana
  end

  def meditation_mana_for(alchemist)
    return mana if alchemist.apprentice?

    mana_earned = 6

    if alchemist.acolyte?
      mana_earned = begin
        case alchemist.level
        when 3..4
          6
        when 5..6
          7
        when 7..8
          8
        when 9..10
          9
        else
          mana
        end
      end
    end

    if alchemist.alchemist?
      mana_earned = begin
        case alchemist.level
        when 1..2
          10
        when 3..4
          11
        when 5..6
          12
        when 7..8
          13
        when 9
          14
        when 10
          15
        end
      end
    end

    mana_earned
  end

end
