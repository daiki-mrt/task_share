class Task < ApplicationRecord
  belongs_to :user
  has_many :likes

  validates :title, presence: true
end
