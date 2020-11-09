class Community < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category

  belongs_to :user

  validates :name, presence: true
  validates :category_id, numericality: { other_than: 0 }
end
