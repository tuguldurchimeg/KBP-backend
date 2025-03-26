class CreateSeos < ActiveRecord::Migration[7.0]
  def change
    create_table :seos do |t|
      t.string :title
      t.text :content
      t.bigint :document_id, index: true # FK

      t.timestamps
    end
  end
end
