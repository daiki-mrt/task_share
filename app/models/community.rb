class Community < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category

  belongs_to :user
  has_many :user_communities, dependent: :destroy
  has_many :users, through: :user_communities
  has_many :chats, dependent: :destroy
  has_many :questions, dependent: :destroy

  validates :name, presence: true
  validates :text, presence: true

  # 検索
  scope :search, -> (search_params) do
    return if search_params.blank?

    category_is(search_params[:category_id])
      .text_like(search_params[:text])
  end
  scope :category_is, -> (category_id) { where(category_id: category_id) if category_id.present? }
  scope :text_like, -> (text) { where("text LIKE ?", "%#{text}%").or(where("name LIKE ?", "%#{text}%")) if text.present? }

  def joined_users
    user_ids = user_communities.pluck(:user_id)
    User.where(id: user_ids)
  end
end
