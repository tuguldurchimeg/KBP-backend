class CreateTagDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_documents do |t|
      t.bigint :document_id, null: false
      t.bigint :tag_id, null: false

      t.timestamps
    end
  end
end
