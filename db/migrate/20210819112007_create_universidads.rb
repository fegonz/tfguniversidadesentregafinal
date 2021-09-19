class CreateUniversidads < ActiveRecord::Migration[6.1]
  def change
    create_table :universidads do |t|
      t.string :nombre
      t.string :tipo
      t.string :url
      t.references :comunidad, null: false, foreign_key: true

      t.timestamps
    end
  end
end
