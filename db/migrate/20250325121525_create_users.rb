class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :uid, null: false, index: { unique: true, name: 'users_uid' }, limit: 50
      t.string :email, null: false, index: { unique: true, name: 'users_email' }, limit: 100
      t.string :firstname, null: false, limit: 50, index: true
      t.string :lastname, null: false, limit: 50, index: true
      t.string :avatar
      t.bigint :role_id, index: true # FK
      t.bigint :company_id, index: true # FK
      t.string :password_digest, limit: 255
      t.integer :login_count, default: 0
      t.boolean :password_change_required, default: false
      t.timestamps
    end
  end
end
