require 'rails_helper'

RSpec.describe 'Answers', type: :system do
  include LoginSupport

  describe "質問にコメントする" do
    before "ログインと質問登録" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @community = create(:community, user_id: @user.id)
      UserCommunity.create(user_id: @user.id, community_id: @community.id)
      sign_in_as @user
      @question = create(:question, user_id: @user.id, community_id: @community.id)
    end

    context "コメント出来るとき" do
      it "コメントを入力すると保存できて、コメント一覧エリアに表示される" do
        # チャットページに移動する
        visit "/communities/#{@community.id}/questions/#{@question.id}"
        expect {
          fill_in 'answer_text', with: '質問への回答'
          click_on '投稿'
          expect(page).to have_content '質問への回答'
        }.to change { Answer.count }.by(1)
      end
    end
    context "コメント出来ないとき" do
      it "コメントを入力していないと保存できず、質問詳細ページに戻る" do
        visit "/communities/#{@community.id}/questions/#{@question.id}"
        expect {
          click_on '投稿'
        }.to change { Answer.count }.by(0)
      end
    end
  end
end
