class Transmutation < ApplicationRecord

  self.primary_key = 'name'

  enum category: %i[mind body]

  def id
    name.gsub(' ', '').underscore
  end

end
