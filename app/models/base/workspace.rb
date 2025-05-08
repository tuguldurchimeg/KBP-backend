class Base::Workspace < ApplicationRecord
  belongs_to :company, foreign_key: :company_id, class_name: 'Base::Company'
  belongs_to :user, foreign_key: :creator_id, class_name: 'Base::User'
  has_many :issues, dependent: :destroy, class_name: 'Document::Issue'
  has_many :categories, dependent: :destroy, class_name: 'Document::Category'
  has_many :tags, dependent: :destroy, class_name: 'Tool::Tag'
  has_many :glossaries, dependent: :destroy, class_name: 'Tool::Glossary'
  has_many :seos, dependent: :destroy, class_name: 'Tool::Seo'

  validates :name, presence: true, uniqueness: true
  validates :creator_id, presence: true

end
