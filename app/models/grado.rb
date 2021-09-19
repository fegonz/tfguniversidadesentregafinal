class Grado < ApplicationRecord
  belongs_to :universidad
  has_many :asignaturas, dependent: :destroy

  ThinkingSphinx::Callbacks.append(
    self, :behaviours => [:sql]
  )

    
end
