class Question < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_one_attached :image
  has_many :answers, dependent: :destroy
  has_many :me_toos

  validates :title, :content, presence: true
end
