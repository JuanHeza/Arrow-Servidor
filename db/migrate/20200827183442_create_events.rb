class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :titulo
      t.string :cuerpo
      t.string :estado
      t.string :fecha
      t.string :hora
      t.string :repeticion
      t.references :alert, null: false, foreign_key: true

      t.timestamps
    end
  end
end
