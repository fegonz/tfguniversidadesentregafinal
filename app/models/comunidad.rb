class Comunidad < ApplicationRecord
    has_many :universidads, dependent: :destroy
    validates :nombre, uniqueness: true
end
