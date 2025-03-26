class CreateGlossaries < ActiveRecord::Migration[7.0]
  def change
    create_table :glossaries do |t|
      t.string :name
      t.text :content
      t.bigint :workspace_id, index: true # FK

      t.timestamps
    end
  end
end
