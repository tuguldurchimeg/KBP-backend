class Tool::Glossary < ApplicationRecord
  belongs_to :workspace

  validates :name, presence: true
  validates :content, presence: true
end
