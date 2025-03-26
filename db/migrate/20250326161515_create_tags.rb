class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.text :description
      t.bigint :workspace_id, index: true # FK

      t.timestamps
    end
  end
end
