class Task < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  validates :title, presence: true
  validates :state, inclusion: { in: [true, false] }

  # 特定のユーザーのタスクを取得
  scope :user_is, -> (user_id) { where(user_id: user_id) if user_id.present? }

  # 未完了のタスクを取得
  scope :not_completed, -> { where(state: false) }
  # 完了したタスクを取得
  scope :completed, -> { where(state: true) }
end
