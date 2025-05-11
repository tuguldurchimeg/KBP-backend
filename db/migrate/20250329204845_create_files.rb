class CreateFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :files do |t|
      t.string :name, null: false
      t.string :file_type
      t.float :size
      t.string :url, null: false
      t.bigint :user_id, null: false, index: true #uploader
      t.bigint :workspace_id, null: false, index: true

      t.timestamps
    end
  end
end
