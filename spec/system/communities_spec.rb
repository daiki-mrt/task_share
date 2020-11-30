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

  describe "コミュニティ編集" do
    before "ユーザ設定とログイン" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @community = create(:community, user_id: @user.id)
      sign_in_as @user
    end

    context "編集できるとき" do
      it "正しく情報を入力すると、コミュニティが保存され、コミュニティ詳細ページに遷移する" do
        # コミュニティ詳細ページへ移動する
        visit "/communities/#{@community.id}"
        # コミュニティ編集ページへ遷移する
        click_link '編集する'
        expect(current_url).to include "/communities/#{@community.id}/edit"
        expect(page).to have_content @community.name
        # 名前を変更するして更新ボタンを押す
        revised_community_name = '編集後のタイトル'
        fill_in 'community_name', with: revised_community_name
        click_on '更新'
        expect(page).to have_content revised_community_name
      end
    end
    context "編集できないとき" do
      it "情報が正しくないと、コミュニティが保存されず、新規作成画面に戻る" do
        # コミュニティ詳細ページへ移動する
        visit "/communities/#{@community.id}"
        # コミュニティ編集ページへ遷移する
        click_link '編集する'
        expect(current_url).to include "/communities/#{@community.id}/edit"
        expect(page).to have_content @community.name
        fill_in 'community_name', with: ''
        click_on '更新'
        expect(page).to have_css '.error-message'
      end
    end
  end

  describe "コミュニティ参加" do
    before "ユーザ設定とログイン" do
      @owner_user = create(:user)
      owner_user_profile = create(:profile, user_id: @owner_user.id)
      @owner_community = create(:community, user_id: @owner_user.id)
      @joining_user = create(:user)
      joining_user_profile = create(:profile, user_id: @joining_user.id)
      sign_in_as @joining_user
    end

    it "参加ボタンをクリックすると、コミュニティに参加することができる" do
      visit '/communities'
      expect(page).to have_content @owner_community.name
      click_link @owner_community.name
      expect(current_url).to include "/communities/#{@owner_community.id}"

      expect {
        click_on '参加する'
        expect(page).to have_content '脱退する'
      }.to change { UserCommunity.count }.by(1)
    end
    it "脱退ボタンをクリックすると、コミュニティから抜けることが出来る" do
      UserCommunity.create(user_id: @joining_user.id, community_id: @owner_community.id)
      visit '/communities'
      expect(page).to have_content @owner_community.name
      click_link @owner_community.name
      expect(current_url).to include "/communities/#{@owner_community.id}"
      expect(page).to have_content '脱退する'

      expect {
        click_on '脱退する'
        expect(page).to have_content '参加する'
      }.to change { UserCommunity.count }.by(-1)
    end
  end
end