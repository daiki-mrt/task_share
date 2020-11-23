class Like < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :task_id, uniqueness: { scope: :user_id }
end
