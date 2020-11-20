class Community < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category

  belongs_to :user
  has_many :user_communities
  has_many :users, through: :user_communities
  has_many :chats
  has_many :questions

  validates :name, presence: true
  validates :text, presence: true

  # 検索
  scope :search, -> (search_params) do
    return if search_params.blank?

    self.category_is(search_params[:category_id]).text_like(search_params[:text])
  end
  scope :category_is, -> (category_id) { where(category_id: category_id) if category_id.present? }
  scope :text_like, -> (text) { where("text LIKE ?", "%#{text}%") if text.present? }

  def joined_users
    user_ids = self.user_communities.pluck(:user_id)
    users = User.where(id: user_ids)
  end
end
