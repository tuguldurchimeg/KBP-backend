class CreateIssueComments < ActiveRecord::Migration[7.0]
  def change
    create_table :issue_comments do |t|
      t.text :comment
      t.bigint :issue_id, index: true # FK
      t.bigint :user_id, index: true # FK
      t.bigint :parent_id, index: true

      t.timestamps
    end
  end
end
