require 'rails_helper'

RSpec.describe 'Chats', type: :system do
  include LoginSupport

  describe "コミュニティでチャットをする" do
    before "ユーザーとコミュニティ作成し、ログイン" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @community = create(:community, user_id: @user.id)
      UserCommunity.create(user_id: @user.id, community_id: @community.id)
      sign_in_as @user
    end

    context "投稿できるとき" do
      it "テキストを入力すると投稿できて、テキストがコメントエリアに表示される" do
        visit "/communities/#{@community.id}"
        click_on 'チャット'
        expect {
          fill_in 'chat_text', with: '投稿したテキスト'
          click_on '投稿'
          expect(page).to have_content '投稿したテキスト'
        }.to change { Chat.count }.by(1)
      end
    end
    context "投稿できないとき" do
      it "テキストが入力されていないと投稿できず、チャットページに戻る" do
        visit "/communities/#{@community.id}"
        click_on 'チャット'
        expect {
          click_on '投稿'
        }.to change { Chat.count }.by(0)
      end
    end
  end
end
