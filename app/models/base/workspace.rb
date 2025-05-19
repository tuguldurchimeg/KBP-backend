class Base::Workspace < ApplicationRecord
  belongs_to :company, foreign_key: :company_id, class_name: 'Base::Company'
  belongs_to :user, foreign_key: :creator_id, class_name: 'Base::User'
  has_many :issues, dependent: :destroy, class_name: 'Document::Issue'
  has_many :categories, dependent: :destroy, class_name: 'Document::Category'
  has_many :documents, dependent: :destroy, class_name: 'Document::Document'
  has_many :tags, dependent: :destroy, class_name: 'Tool::Tag'
  has_many :glossaries, dependent: :destroy, class_name: 'Tool::Glossary'
  has_many :seos, dependent: :destroy, class_name: 'Tool::Seo'
  has_many :workspace_role_details, class_name: 'Base::WorkspaceRoleDetail'

  validates :name, presence: true, uniqueness: { scope: :company_id}
  validates :creator_id, presence: true

  default_scope { left_joins(:company).where(company: { uid: Current.current_company }) }

  def create_workspace_roles(current_user)
    Base::WorkspaceRoleDetail.create!(user_id: current_user.id, workspace_id: self.id, action: :admin)
    users = Base::User.where.not(id: current_user.id)

    users.each do |user|
      workspace_role = Base::WorkspaceRoleDetail.find_or_initialize_by(user_id: user.id, workspace_id: self.id)
      workspace_role.action = :read
      workspace_role.save!
    end
  end
end
