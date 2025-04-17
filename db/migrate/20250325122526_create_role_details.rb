class CreateRoleDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :role_details do |t|
      t.bigint :role_id, index: true # FK
      t.bigint :module_id, index: true # FK
      t.integer :action, comment: '99: admin, 1: read, 2: write'

      t.timestamps
    end
  end
end
