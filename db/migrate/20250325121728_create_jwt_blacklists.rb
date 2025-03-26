class CreateJwtBlacklists < ActiveRecord::Migration[7.0]
  def change
    create_table :jwt_blacklists do |t|
      t.bigint :user_id, null: false, index: true
      t.string :jwt, limit: 300, null: false
      t.integer :exp
      t.string :token_at, index: true, limit: 15
      t.timestamps
    end
  end
end
