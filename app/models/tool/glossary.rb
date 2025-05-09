class Tool::Glossary < ApplicationRecord
  belongs_to :workspace, class_name: 'Base::Workspace', foreign_key: :workspace_id

  validates :name, presence: true
  validates :content, presence: true
end
