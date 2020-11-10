class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :community

  validates :text, presence: true
end
