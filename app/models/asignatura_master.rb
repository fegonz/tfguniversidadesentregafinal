class AsignaturaMaster < ApplicationRecord
  belongs_to :master
 

  ThinkingSphinx::Callbacks.append(
    self, :behaviours => [:sql]
  )
end
