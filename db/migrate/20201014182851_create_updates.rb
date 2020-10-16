class CreateUpdates < ActiveRecord::Migration[6.0]
  def change
    create_table :updates do |t|
      t.string :titulo
      t.string :cuerpo
      t.string :clase

      t.timestamps
    end
  end
end
