class CreateUpdates < ActiveRecord::Migration[6.0]
  def change
    create_table :updates do |t|
      t.string :titulo
      t.string :cuerpo
      t.string :clase
      # t.references :alert, null: false, foreign_key: true
      # t.boolean :status

      t.timestamps
    end
  end
end
