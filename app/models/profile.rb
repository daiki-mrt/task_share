class Profile < ApplicationRecord  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :occupation

  belongs_to :user
  has_one_attached :image
end
