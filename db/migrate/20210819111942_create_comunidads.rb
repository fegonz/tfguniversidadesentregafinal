class CreateComunidads < ActiveRecord::Migration[6.1]
  def change
    create_table :comunidads do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
