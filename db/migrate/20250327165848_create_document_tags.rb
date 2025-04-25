class CreateDocumentTags < ActiveRecord::Migration[6.1]
  def change
    create_table :document_tags do |t|
      t.bigint :document_id, null: false
      t.bigint :tag_id, null: false

      t.timestamps
    end
  end
end
