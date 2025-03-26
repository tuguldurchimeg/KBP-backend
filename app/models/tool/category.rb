class Tool::Category < ApplicationRecord
  belongs_to :workspace
  has_many :documents

  validates :name, presence: true
  validates :type, presence: true
end
