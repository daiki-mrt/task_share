class Profile < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :occupation

  belongs_to :user
  has_one_attached :image

  # User検索用スコープ
  scope :occupation_is, -> (occupation_id) { where(occupation_id: occupation_id) if occupation_id.present? }
  scope :text_like, -> (text) { where("text LIKE ?", "%#{text}%") if text.present? }

  def occupation_name(user)
    occupation_id = user.profile.occupation_id
    return if occupation_id.blank?

    Occupation.find(occupation_id).name
  end

  # 新規登録時にプロフィール画像が指定されているかどうか
  def image_added?
    unless image.attached?
      image.attach(io: File.open('app/assets/images/default_user_image.png'), filename: 'default_user_image.png')
    end
  end
end
