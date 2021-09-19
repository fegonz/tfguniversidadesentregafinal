class CreateAsignaturas < ActiveRecord::Migration[6.1]
  def change
    create_table :asignaturas do |t|
      t.string :nombre
      t.string :tipo
      t.integer :creditos
      t.references :grado, null: false, foreign_key: true

      t.timestamps
    end
  end
end
