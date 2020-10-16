class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.bigint :chat_id
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :token

      t.timestamps
    end
  end
end
