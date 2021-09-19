class Universidad < ApplicationRecord
  validates :nombre, uniqueness: true
  belongs_to :comunidad
  has_many :grados, dependent: :destroy
  has_many :masters, dependent: :destroy
  
end
