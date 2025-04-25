class CreateIssueAssignees < ActiveRecord::Migration[6.1]
  def change
    create_table :issue_assignees do |t|
      t.bigint :issue_id, null: false
      t.bigint :user_id, null: false

      t.timestamps
    end
  end
end
