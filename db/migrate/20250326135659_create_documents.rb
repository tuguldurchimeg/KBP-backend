class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.bigint :category_id, index: true # FK
      t.bigint :user_id, index: true # FK (author)
      t.jsonb :content, default: {}, null: false
      t.boolean :is_template, default: false
      t.integer :view_count
      t.bigint :workspace_id, index: true

      t.timestamps
    end
  end
end
