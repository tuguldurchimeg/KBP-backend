class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.bigint :parent_id, index: true
      t.bigint :workspace_id, index: true # FK

      t.timestamps
    end
  end
end
