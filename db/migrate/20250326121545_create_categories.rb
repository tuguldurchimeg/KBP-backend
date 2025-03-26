class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :type
      t.text :description
      t.bigint :workspace_id, index: true # FK

      t.timestamps
    end
  end
end
