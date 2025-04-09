class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.integer :status
      t.integer :priority
      t.bigint :created_by, index: true # FK
      t.bigint :assignee, index: true # FK
      t.bigint :document_id, index: true # FK
      t.bigint :workspace_id, index: true # FK

      t.timestamps
    end
  end
end
