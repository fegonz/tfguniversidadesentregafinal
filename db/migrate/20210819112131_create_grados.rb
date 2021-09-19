class CreateGrados < ActiveRecord::Migration[6.1]
  def change
    create_table :grados do |t|
      t.string :nombre
      t.string :url
      t.references :universidad, null: false, foreign_key: true

      t.timestamps
    end
  end
end
