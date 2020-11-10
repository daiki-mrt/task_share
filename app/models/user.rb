class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  has_one :profile
  accepts_nested_attributes_for :profile, update_only: true
  has_many :tasks

  has_many :user_rooms
  has_many :rooms, through: :user_rooms
  has_many :messages
  has_many :likes
  has_many :own_communities, class_name: "Community"
  has_many :user_communities
  has_many :communities, through: :user_communities
  has_many :chats
  has_many :questions

  # フォロー側
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :follower
  # フォロワー側
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :following

  # フォロー済みかどうかの確認
  def follow?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end

  # taskいいね済みかどうかの確認
  def already_liked?(task)
    likes.where(task_id: task.id).exists?
  end

  # communityに参加済みかどうかの確認
  def already_joined?(community)
    self.user_communities.where(community_id: community.id).exists?
  end
end