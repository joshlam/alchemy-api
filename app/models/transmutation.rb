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

end
