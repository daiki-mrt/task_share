class Community < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category

  belongs_to :user
  has_many :user_communities
  has_many :users, through: :user_communities
  has_many :chats

  validates :name, presence: true
  validates :category_id, numericality: { other_than: 0 }
end
