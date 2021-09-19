class Asignatura < ApplicationRecord
  belongs_to :grado

  ThinkingSphinx::Callbacks.append(
    self, :behaviours => [:sql]
  )

  def self.createAsignatura(item2)

    

    Asignatura.where(item2).create
                  
    
  end
end
