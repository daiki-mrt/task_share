class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates :password, format: { with: PASSWORD_REGEX, message: "は半角英数字で入力してください" }, on: :create

  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile, update_only: true
  has_many :tasks, dependent: :destroy

  has_many :user_rooms, dependent: :destroy
  has_many :rooms, through: :user_rooms
  has_many :messages, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :own_communities, class_name: "Community", dependent: :destroy
  has_many :user_communities, dependent: :destroy
  has_many :communities, through: :user_communities
  has_many :chats, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :me_toos, dependent: :destroy
  has_many :goods, dependent: :destroy

  # フォロー側
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :follower
  # フォロワー側
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :following

  # 引数のユーザが既にフォローしているかどうかの確認
  def follow?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end

  # 引数のtaskにいいね済みかどうかの確認
  def already_liked?(task)
    likes.where(task_id: task.id).exists?
  end

  # 引数のcommunityに参加済みかどうかの確認
  def already_joined?(community)
    user_communities.where(community_id: community.id).exists?
  end

  # 引数のquestionに「知りたい！」済みかどうかの確認
  def already_me_too?(question)
    me_toos.where(question_id: question.id).exists?
  end

  # 引数のquestionに「役に立った！」済みかどうかの確認
  def already_good?(question)
    goods.where(question_id: question.id).exists?
  end

  # ユーザ検索
  scope :search, -> (search_params) do
    # search_paramsが無かったら実行しない
    return if search_params.blank?

    # userのnameが一致したuser
    users_name_match = User.where("name LIKE ?", "%#{search_params[:text]}%")
    # profileのtextが一致したuser
    profiles_text_match = Profile.text_like(search_params[:text])
    # profileのoccupationが一致したuser
    profiles_occupation_match = Profile.occupation_is(search_params[:occupation_id])

    # nameまたはprofileで取得したuser、かつ、occupationで取得したuser
    where("name LIKE ?", "%#{search_params[:text]}%")
      .or(where(id: profiles_text_match.pluck(:user_id)))
      .where(id: profiles_occupation_match.pluck(:user_id))
  end

  # ゲストユーザログイン時に「ゲスト」を検索or作成
  def self.guest
    find_or_create_by!(email: "guest@guest.com") do |user|
      user.name = "ゲスト"
      user.password = SecureRandom.hex(10)
    end
  end
end
