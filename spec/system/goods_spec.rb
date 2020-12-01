require 'rails_helper'

RSpec.describe 'Goods', type: :system do
  include LoginSupport
  
  describe "質問に役に立った！する" do
    before "ログインと質問登録" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @community = create(:community, user_id: @user.id)
      UserCommunity.create(user_id: @user.id, community_id: @community.id)
      sign_in_as @user
      @question = create(:question, user_id: @user.id, community_id: @community.id)
    end

    it "役に立った！ボタンを押すと、役に立った！が保存されて役に立った！済みのアイコンに変わる" do
      # 質問詳細ページへ移動する
      visit "/communities/#{@community.id}/questions/#{@question.id}"
      expect {
        click_link '役に立った!'
        # 非同期通信で反映されるまで待つため
        sleep 1
      }.to change { Good.count }.by(1)      
    end
    it "役に立った！解除ボタンを押すと、役に立った！を解除して、役に立った！前のアイコンに変わる" do
      already_good_question = create(:question, user_id: @user.id, community_id: @community.id)
      Good.create(user_id: @user.id, question_id: already_good_question.id)
      visit "/communities/#{@community.id}/questions/#{already_good_question.id}"
      expect {
        click_link '役に立った!'
        sleep 1
      }.to change { Good.count }.by(-1)
    end
  end
end