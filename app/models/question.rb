class Question < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_one_attached :image

  validates :title, :content, presence: true
end
