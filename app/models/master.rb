class Master < ApplicationRecord
  belongs_to :universidad
  has_many :asignatura_masters, dependent: :destroy
end
