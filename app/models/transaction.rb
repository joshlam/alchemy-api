class Transaction < ApplicationRecord

  belongs_to :alchemist
  belongs_to :transmutation,
    foreign_key: 'transmutation_name',
    primary_key: 'name'

end
