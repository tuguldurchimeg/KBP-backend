class CreateWorkspaceRoleDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :workspace_role_details do |t|
      t.bigint :user_id, index: true # FK
      t.bigint :workspace_id, index: true # FK
      t.integer :action, comment: '99: admin, 1: read, 2: write'

      t.timestamps
    end
  end
end
