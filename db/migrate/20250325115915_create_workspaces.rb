class CreateWorkspaces < ActiveRecord::Migration[7.0]
  def change
    create_table :workspaces do |t|
      t.string :name
      t.bigint :creator_id, index: true # FK
      t.bigint :company_id, index: true # FK

      t.timestamps
    end
  end
end
