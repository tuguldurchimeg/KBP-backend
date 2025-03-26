class Tool::Tag < ApplicationRecord
  belongs_to :workspace

  validates :name, presence: true
  validates :description, presence: true
end
