class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.string :title
      t.integer :status
      t.integer :priority
      t.string :description
      t.bigint :created_by, index: true # FK
      t.bigint :workspace_id, index: true # FK
      # need issue assignees
      # and table issue_docs -> many to many

      t.timestamps
    end
  end
end
