class CreateAsignaturaMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :asignatura_masters do |t|
      t.string :nombre
      t.string :curso
      t.string :tipo
      t.integer :creditos
      t.references :master, null: false, foreign_key: true

      t.timestamps
    end
  end
end
