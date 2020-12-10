require 'rails_helper'

RSpec.describe 'MeToos', type: :system do
  include LoginSupport

  describe "質問に知りたい！する" do
    before "ログインと質問登録" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @community = create(:community, user_id: @user.id)
      UserCommunity.create(user_id: @user.id, community_id: @community.id)
      sign_in_as @user
      @question = create(:question, user_id: @user.id, community_id: @community.id)
    end

    it "知りたい！ボタンを押すと、知りたい！が保存されて知りたい！済みのアイコンに変わる" do
      # 質問詳細ページへ移動する
      visit "/communities/#{@community.id}/questions/#{@question.id}"
      expect {
        click_link '知りたい!'
        # 非同期通信で反映されるまで待つため
        sleep 1
      }.to change { MeToo.count }.by(1)
    end
    it "知りたい！解除ボタンを押すと、知りたい！を解除して、知りたい！前のアイコンに変わる" do
      already_me_too_question = create(:question, user_id: @user.id, community_id: @community.id)
      MeToo.create(user_id: @user.id, question_id: already_me_too_question.id)
      visit "/communities/#{@community.id}/questions/#{already_me_too_question.id}"
      expect {
        click_link '知りたい!'
        sleep 1
      }.to change { MeToo.count }.by(-1)
    end
  end
end
