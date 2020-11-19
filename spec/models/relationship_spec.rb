require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @user1 = create(:user)
    @user2 = create(:user)
  end

  context "フォローできる場合" do
    it "自分以外のユーザーをフォローできる" do
      relationship = Relationship.create(following_id: @user1.id, follower_id: @user2.id)
      expect(relationship).to be_valid
    end
  end

  context "フォローできない時" do
    it "following_idが空だと保存できない" do
      relationship = Relationship.new(follower_id: @user2.id)
      relationship.valid?
      expect(relationship.errors[:following]).to include("を入力してください")
    end
    it "follower_idが空だと保存できない" do
      relationship = Relationship.new(following_id: @user1.id)
      relationship.valid?
      expect(relationship.errors[:follower]).to include("を入力してください")
    end
    it "すでにフォローしたユーザーをフォローすることは出来ない" do
      user3 = create(:user)
      relationship1 = Relationship.create(following_id: @user1.id, follower_id: @user2.id)
      relationship2 = Relationship.create(following_id: @user1.id, follower_id: user3.id)
      relationship2.follower_id = @user2.id
      relationship2.valid?
      expect(relationship2.errors[:follower_id]).to include("はすでに存在します")
    end
  end
end
