class Transmutation < ApplicationRecord

  self.primary_key = 'name'

  enum category: %i[mind body]

  def self.Gratitude
    find_by_name('Gratitude')
  end

  def self.Values
    find_by_name('Values')
  end

  def self.Socialize
    find_by_name('Socialize')
  end

  def self.Affirmations
    find_by_name('Affirmations')
  end

  def self.Mindfulness
    find_by_name('Mindfulness')
  end

  def self.Soul_Fuel
    find_by_name('Soul Fuel')
  end

  def self.Envision
    find_by_name('Envision')
  end

  def self.Body_Scan
    find_by_name('Body Scan')
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

  def self.Sunlight
    find_by_name('Sunlight')
  end

  def self.Fitness
    find_by_name('Fitness')
  end

  def self.Nature
    find_by_name('Nature')
  end

  def self.Junk_Food
    find_by_name('Junk Food')
  end

  def self.Good_Food
    find_by_name('Good Food')
  end

  def self.Yoga
    find_by_name('Yoga')
  end

  def id
    name.gsub(' ', '').underscore
  end

end
