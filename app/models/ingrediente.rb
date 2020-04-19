class Ingrediente < ApplicationRecord
    has_and_belongs_to_many :hamburguesas
end
