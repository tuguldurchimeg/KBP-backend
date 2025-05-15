class Base::WorkspaceRoleDetail < ApplicationRecord
  belongs_to :user, class_name: 'Base::User', foreign_key: :user_id
  belongs_to :workspace, class_name: 'Base::Workspace', foreign_key: :workspace_id

  validates :user_id, presence: true
  validates :workspace_id, presence: true
  enum :action, { admin: 99, read: 1, write: 2}
end
