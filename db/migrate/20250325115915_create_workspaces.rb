class CreateWorkspaces < ActiveRecord::Migration[7.0]
  def change
    create_table :workspaces do |t|
      t.string :name
      t.string :description, limit: 255
      t.bigint :creator_id, index: true # FK
      t.bigint :company_id, index: true # FK
      t.string :image_url
      t.timestamps
    end
  end
end
