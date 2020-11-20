class Question < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_one_attached :image
  has_many :answers, dependent: :destroy
  has_many :me_toos, dependent: :destroy
  has_many :goods, dependent: :destroy

  validates :title, :content, presence: true
  validates :state, inclusion: { in: [true, false] }
end
