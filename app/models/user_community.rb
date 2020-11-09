class UserCommunity < ApplicationRecord
  belongs_to :user
  belongs_to :community
end
