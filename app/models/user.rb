class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  validates :password, format: { with: PASSWORD_REGEX, message: "は半角英数字で入力してください" }

  has_one :profile, dependent: :destroy
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
  has_many :answers
  has_many :me_toos
  has_many :goods

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

  # questionに「知りたい！」済みかどうかの確認
  def already_me_too?(question)
    self.me_toos.where(question_id: question.id).exists?
  end

  # questionに「役に立った！」済みかどうかの確認
  def already_good?(question)
    self.goods.where(question_id: question.id).exists?
  end

  # 検索
  scope :search, -> (search_params) do
    # search_paramsが無かったら実行しない
    return if search_params.blank?

    # 検索条件に合うprofileを取得
    profiles = Profile.occupation_is(search_params[:occupation_id]).text_like(search_params[:text])

    # 取得したprofileのuser_idからuserを検索
    self.where(id: profiles.pluck(:user_id))
  end

  def self.guest
    find_or_create_by!(email: "guest@guest.com") do |user|
      user.name = "ゲスト"
      user.password = SecureRandom.urlsafe_base64
    end
  end
end
