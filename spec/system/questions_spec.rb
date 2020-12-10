require 'rails_helper'

RSpec.describe 'Questions', type: :system do
  include LoginSupport

  describe "質問を投稿する" do
    before "ユーザとコミュニティを作成し、ログイン" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @community = create(:community, user_id: @user.id)
      UserCommunity.create(user_id: @user.id, community_id: @community.id)
      sign_in_as @user
    end

    context "質問を投稿できるとき" do
      it "正しく情報を入力すると、保存できて質問詳細ページに遷移する" do
        visit "/communities/#{@community.id}"
        click_link '質問'
        expect(current_url).to include "/communities/#{@community.id}/questions"
        click_link '質問する'
        expect(current_url).to include "/communities/#{@community.id}/questions/new"
        expect {
          fill_in 'question_title', with: '質問のタイトル'
          fill_in 'question_content', with: '質問の内容'
          click_on '投稿'
          expect(page).to have_content '質問のタイトル'
        }.to change { Question.count }.by(1)
      end
    end
    context "質問を投稿できないとき" do
      it "情報が正しくないと、保存できずに質問作成ページに遷移する" do
        visit "/communities/#{@community.id}"
        click_link '質問'
        expect(current_url).to include "/communities/#{@community.id}/questions"
        click_link '質問する'
        expect(current_url).to include "/communities/#{@community.id}/questions/new"
        expect {
          click_on '投稿'
          expect(page).to have_css '.error-message'
        }.to change { Question.count }.by(0)
      end
    end
  end

  describe "質問を編集する" do
    before "ログインし、質問を登録" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @community = create(:community, user_id: @user.id)
      UserCommunity.create(user_id: @user.id, community_id: @community.id)
      sign_in_as @user
      @question = create(:question, user_id: @user.id, community_id: @community.id)
    end

    context "質問を編集できるとき" do
      it "正しく情報を入力すると、保存できて質問詳細ページに遷移する" do
        visit "/communities/#{@community.id}/questions"
        click_link @question.title
        expect(current_url).to include "communities/#{@community.id}/questions/#{@question.id}"
        click_link '編集する', href: "/communities/#{@community.id}/questions/#{@question.id}/edit"
        expect {
          fill_in 'question_title', with: '変更後のタイトル'
          fill_in 'question_content', with: '変更後の内容'
          click_on '投稿'
          expect(current_url).to_not include "edit"
          expect(page).to have_content '変更後のタイトル'
          expect(page).to have_content '変更後の内容'
        }.to change { Question.count }.by(0)
      end
    end

    context "質問を編集できないとき" do
      it "情報が正しくないと、保存できずに質問作成ページに遷移する" do
        visit "/communities/#{@community.id}/questions"
        click_link @question.title
        expect(current_url).to include "communities/#{@community.id}/questions/#{@question.id}"
        click_link '編集する', href: "/communities/#{@community.id}/questions/#{@question.id}/edit"
        expect {
          fill_in 'question_title', with: ''
          fill_in 'question_content', with: '変更後の内容'
          click_on '投稿'
          expect(page).to have_css '.error-message'
          expect(page).to have_content '変更後の内容'
        }.to change { Question.count }.by(0)
      end
    end
  end

  describe "質問を削除する" do
    before "ログインし、質問を登録" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @community = create(:community, user_id: @user.id)
      UserCommunity.create(user_id: @user.id, community_id: @community.id)
      sign_in_as @user
      @question = create(:question, user_id: @user.id, community_id: @community.id)
    end

    it "削除ボタンを押すと、削除できて質問一覧ページに遷移する" do
      visit "/communities/#{@community.id}/questions"
      click_link @question.title
      expect(current_url).to include "communities/#{@community.id}/questions/#{@question.id}"
      click_link '編集する', href: "/communities/#{@community.id}/questions/#{@question.id}/edit"
      expect {
        click_link '削除する'
        # 質問一覧ページに戻る(質問するボタンが有ることを確認)
        expect(page).to have_content '質問する'
      }.to change { Question.count }.by(-1)
    end
  end

  describe "質問を解決済みにする" do
    before "ログインし、質問を登録" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @community = create(:community, user_id: @user.id)
      UserCommunity.create(user_id: @user.id, community_id: @community.id)
      sign_in_as @user
      @question = create(:question, user_id: @user.id, community_id: @community.id)
    end

    context "切り替えできるとき" do
      it "受付中ボタンを押すと、解決済みに切り替わる" do
        visit "/communities/#{@community.id}/questions/#{@question.id}"
        click_link '受付中'
        expect(page).to have_content '解決済み'
        # @question.stateを参照するとtrueにならないため、questionで初期化
        question = Question.find(@question.id)
        expect(question.state).to eq true
      end
      it "解決済みボタンを押すと、受付中ボタンに切り替わる" do
        # @questionを解決済みに更新
        @question.update(state: 1)
        visit "/communities/#{@community.id}/questions/#{@question.id}"
        click_link '解決済み'
        expect(page).to have_content '受付中'
        # @question.stateを参照するとfalseにならないため、questionを初期化
        question = Question.find(@question.id)
        expect(question.state).to eq false
      end
    end

    context "切り替えできないとき" do
      it "別のユーザーの質問は解決済みに出来ない" do
        # 別のユーザーが質問を投稿
        other_user = create(:user)
        other_user_profile = create(:profile, user_id: other_user.id)
        UserCommunity.create(user_id: other_user.id, community_id: @community.id)
        other_user_question = create(:question, user_id: other_user.id, community_id: @community.id)

        visit "/communities/#{@community.id}/questions/#{other_user_question.id}"
        expect(page).to have_content other_user_question.title
        # @userが受付中ボタンを押す
        click_link '受付中'
        # 状態が変わらないことを確認する
        expect(page).to have_content '受付中'
        expect(other_user_question.state).to eq false
      end
    end
  end
end
