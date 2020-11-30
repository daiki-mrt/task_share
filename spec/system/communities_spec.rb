require 'rails_helper'

RSpec.describe 'Communities', type: :system do
  include LoginSupport

  describe "コミュニティ作成" do
    before "ユーザ設定とログイン" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      sign_in_as @user
    end
    
    context "コミュニティを作成できるとき" do
      it "正しく情報を入力すると、コミュニティが保存され、コミュニティ詳細ページに遷移する" do
        visit '/communities'
        click_link '作成する'
        # コミュニティ作成ページに遷移したことを確認する
        expect(current_url).to include '/communities/new'

        # 登録できるとCommunityのレコードが1上がることを確認する
        expect {
          # 名前と説明を入力する
          fill_in 'community_name', with: 'コミュニティの名前'
          fill_in 'community_text', with: 'コミュニティの説明'
          click_on '作成'
          # コミュニティ詳細ページに遷移することを確認する
          community = Community.find_by(name: 'コミュニティの名前')
          expect(current_url).to include "/communities/#{community.id}"
        }.to change { Community.count }.by(1)
      end
    end
    context "コミュニティを作成できないとき" do
      it "情報が正しくないと、コミュニティが保存されず、新規作成画面に戻る" do
        visit '/communities'
        click_link '作成する'
        # コミュニティ作成ページに遷移したことを確認する
        expect(current_url).to include '/communities/new'

        fill_in 'community_name', with: ''
        fill_in 'community_text', with: ''
        click_on '作成'
        expect(page).to have_css '.error-message'
      end
    end
  end

end