class CreateIssueDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :issue_documents do |t|
      t.bigint :issue_id, null: false
      t.bigint :document_id, null: false

      t.timestamps
    end
  end
end
