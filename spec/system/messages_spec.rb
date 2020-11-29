require 'rails_helper'

RSpec.describe 'Messages', type: :system do
  include LoginSupport
  describe "ユーザにメッセージを送る" do
    before "ユーザ登録とログインを行い、メッセージページまで遷移する" do
        # ユーザ登録
        user = create(:user)
        profile_user = create(:profile, user_id: user.id)
        # メッセージ相手用のユーザを登録
        another_user = create(:user)
        profile_another_user = create(:profile, user_id: another_user.id)
        # ログインする
        sign_in_as user

        # ユーザ検索ページに移動
        click_on 'ユーザー検索'
        # メッセージ相手用ユーザのリンクをクリック
        click_on "#{another_user.name}"
        # 相手ユーザの詳細ページに遷移したことを確認する
        expect(current_url).to include "users/#{another_user.id}"
        # メッセージを送るボタンをクリック
        click_on 'メッセージを送る'
        # メッセージページに遷移したことを確認する
        expect(current_url).to include "/rooms/"
    end
    
    context "メッセージを送れるとき" do
      it "テキストを入力すれば、送信できて、テキストが表示される" do
        message_text = 'メッセージのテキスト'
        expect {
          # テキストボックスにテキストを入力
          fill_in 'message_text', with: message_text
          # 投稿ボタンを押す
          click_on '投稿'
          # 送信したメッセージが表示される
          expect(page).to have_content message_text
          # messageのレコードが1上がることを確認する
        }.to change { Message.count }.by(1)
      end
      it "送信エラーになったあと、テキストを入力すれば、送信できる" do
        message_text = 'メッセージのテキスト'
        expect {
          # 入力せずに送信ボタンを押す
          click_on '投稿'
          # メッセージページに戻ることを確認する
          expect(page).to_not have_content message_text
        }.to change { Message.count }.by(0)
        expect {
          # テキストボックスにテキストを入力
          fill_in 'message_text', with: message_text
          # 送信ボタンを押す
          click_on '投稿'
          # 送信したメッセージが表示される
          expect(page).to have_content message_text
          # messageのレコードが1上がることを確認する
        }.to change { Message.count }.by(1)
      end
    end

    context "メッセージを送れないとき" do
      it "テキストが入力されていないと、何も起きずリダイレクトされる" do
        message_text = 'メッセージのテキスト'
        expect {
          # 入力せずに送信ボタンを押す
          click_on '投稿'
          # メッセージページに戻ることを確認する
          expect(page).to_not have_content message_text
        }.to change { Message.count }.by(0)
      end
    end
  end
end
