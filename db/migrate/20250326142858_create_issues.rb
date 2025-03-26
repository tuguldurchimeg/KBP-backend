class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.string :status
      t.string :priority
      t.bigint :created_by, index: true # FK
      t.bigint :assignee, index: true # FK
      t.bigint :article_id, index: true # FK

      t.timestamps
    end
  end
end
