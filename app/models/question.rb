class Question < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_one_attached :image
  has_many :answers, dependent: :destroy

  validates :title, :content, presence: true
end
