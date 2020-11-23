class Relationship < ApplicationRecord
  belongs_to :following, class_name: "User"
  belongs_to :follower, class_name: "User"
  validates :follower_id, uniqueness: { scope: :following_id }
end
