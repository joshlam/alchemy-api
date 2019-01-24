class Alchemist < ApplicationRecord

  enum rank: %i[apprentice acolyte alchemist]

  has_secure_password

  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true

end
