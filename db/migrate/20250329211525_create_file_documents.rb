class CreateFileDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :file_documents do |t|
      t.bigint :file_id, null: false
      t.bigint :document_id, null: false

      t.timestamps
    end
  end
end
