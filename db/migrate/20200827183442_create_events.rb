class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :titulo
      t.text :cuerpo
      t.boolean :estado
      t.string :fecha
      t.string :hora
      t.string :repeticion
      t.references :alert, null: false, foreign_key: true
      t.bigint :users_id, array: true

      t.timestamps
    end
  end
end
