require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  include LoginSupport  
  describe "ユーザをフォローする" do
    before "ユーザ設定とログイン" do
      @following_user = create(:user)
      following_user_profile = create(:profile, user_id: @following_user.id)
      @followed_user = create(:user)
      followed_profile = create(:profile, user_id: @followed_user.id)
      sign_in_as @following_user
    end
    
    context "フォローできるとき" do
      it "フォローするボタンをクリックすると、フォローできる" do
        # フォローしたいユーザのページへ遷移
        click_on 'ユーザー検索'
        click_on "#{@followed_user.name}"
        # フォローボタンを押すと、relationshipのレコードが1上がる
        expect {
          click_on 'フォローする'
          expect(page).to have_content 'フォロー済み'
        }.to change { Relationship.count }.by(1)
      end
    end
    context "フォローできないとき" do
      it "フォロー済みのユーザにはフォローするボタンがない" do
        # フォロー済みのデータを登録
        Relationship.create(following_id: @following_user.id, follower_id: @followed_user.id)
        
        click_on 'ユーザー検索'
        click_on "#{@followed_user.name}"
        expect(page).to_not have_content 'フォローする'
      end
    end
  end

  describe "ユーザフォローを解除する" do
    before "ユーザ設定とログイン" do
      @following_user = create(:user)
      following_user_profile = create(:profile, user_id: @following_user.id)
      @followed_user = create(:user)
      followed_profile = create(:profile, user_id: @followed_user.id)
      sign_in_as @following_user
    end

    context "フォロー解除できるとき" do
      it "フォロー済みボタンをクリックすると、フォロー解除できる" do
        # フォロー済みのデータを登録
        Relationship.create(following_id: @following_user.id, follower_id: @followed_user.id)

        click_on 'ユーザー検索'
        click_on "#{@followed_user.name}"
        # フォロー解除ボタンを押すと、relationshipのレコードが1下がる
        expect {
          click_on 'フォロー済み'
          expect(page).to have_content 'フォローする'
        }.to change { Relationship.count }.by(-1)
      end
    end
    context "フォロー解除できないとき" do
      it "フォローしていないユーザにはフォロー解除ボタンがない" do
        click_on 'ユーザー検索'
        click_on "#{@followed_user.name}"
        expect(page).to_not have_content 'フォロー済み'
      end
    end
  end
end