class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.text :content
      t.bigint :tag_id, index: true # FK
      t.bigint :category_id, index: true # FK
      t.bigint :user_id, index: true # FK (author)

      t.timestamps
    end
  end
end
