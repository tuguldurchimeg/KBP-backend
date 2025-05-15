class ChangeDefaultContentInDocuments < ActiveRecord::Migration[7.0]
  def change
    change_column_default :documents, :content, {
      type: 'doc',
      content: [
        {
          type: 'paragraph',
          content: []
        }
      ]
    }
  end
end
