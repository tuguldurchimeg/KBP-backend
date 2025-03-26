class CreateRoleDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :role_details do |t|
      t.bigint :role_id, index: true # FK
      t.bigint :module_id, index: true # FK

      t.timestamps
    end
  end
end
