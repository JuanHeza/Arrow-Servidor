class CreateAlerts < ActiveRecord::Migration[6.0]
  def change
    create_table :alerts do |t|
      t.string :titulo
      t.integer :secuencia, array: true#, default: [
      #   ['red','white','blue','green'],
      #   ['green','red','white','blue'],
      #   ['blue','green','red','white'],
      #   ['white','blue','green','red']
      # ].to_yaml

      t.timestamps
    end
  end
end
