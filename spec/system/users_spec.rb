require 'rails_helper'

RSpec.describe 'Users', type: :system do
  include LoginSupport
  describe "ユーザ新規登録" do
    context "新規登録できるとき" do
      it "正しく情報を入力すれば、新規登録できて、マイページに遷移する" do
        # ルートパスへ移動する
        visit "/"
        # 新規登録をクリックして、新規作成ページへ遷移する
        click_on '新規登録'
        # 必須事項を入力する
        fill_in 'user_name', with: 'ジョン・レノン'
        fill_in 'user_email', with: 'john@john.com'
        fill_in 'user_password', with: 'abc123'
        fill_in 'user_password_confirmation', with: 'abc123'

        expect {
          # 「登録」クリック
          click_on '登録'
          # 登録したユーザのマイページへ遷移する
          user = User.find_by(email: "john@john.com")
          expect(current_url).to include "/users/#{user.id}"
          # マイページのヘッダにログアウトボタンがある
          expect(page).to have_link 'ログアウト'
          # userのレコードが1上がる
        }.to change { User.count }.by(1)
      end
    end
    context "新規登録できないとき" do
      it "情報が正しくなければ、新規登録できず、新規登録画面に戻る" do
        # ルートパスへ移動する
        visit "/"
        # 新規登録をクリックして、新規作成ページへ遷移する
        click_on '新規登録'

        expect {
          # 入力せずに、「登録」をクリック
          click_on '登録'
          # 新規作成ページへ遷移し、文字とURLを確認
          expect(page).to have_content '新規登録'
          expect(current_url).to include '/users'
          # field_with_errorsがあることを確認する
          expect(page).to have_css '.field_with_errors'
          # userのレコードが変わらない
        }.to change { User.count }.by(0)
      end
    end
  end

  describe "ユーザログイン" do
    context "ログインできるとき" do
      it "正しく情報を入力すれば、ログインできて、マイページに遷移する" do
        user = create(:user)
        profie = create(:profile, user_id: user.id)
        sign_in_as user
        # マイページへ遷移する
        expect(current_url).to include "/users/#{user.id}"
        # マイページのヘッダにログアウトボタンがある
        expect(page).to have_link 'ログアウト'
      end
      it "ゲストログインのボタンをクリックすると、ログインしてマイページへ遷移する" do
        # ルートパスへ移動する
        visit "/"
        # ゲストログインをクリックする
        click_on 'ゲストログイン'
        # マイページへ遷移する
        user = User.find_by(name: 'ゲスト')
        expect(current_url).to include "/users/#{user.id}"
        # マイページのヘッダにログアウトボタンがある
        expect(page).to have_link 'ログアウト'
      end
    end
    context "ログインできないとき" do
      it "情報が正しくなければ、ログインできず、ログイン画面に戻る" do
        user = create(:user, email: 'correct_address@correct.com')
        profile = create(:profile, user_id: user.id)
        # ルートパスへ移動する
        visit "/"
        # フォームに入力せずに「ログイン」をクリック
        fill_in 'user_email', with: 'wrong_address@wrong.com'
        fill_in 'user_password', with: user.password
        click_on 'ログイン'
        # 遷移せずにログインページにとどまる
        expect(current_url).to include '/users/sign_in'
        # field_with_errorsがあることを確認する
        expect(page).to have_css '.login-flash-message'
      end
    end
  end

  describe "ユーザログアウト" do
    it "ログアウトボタンを押すと、ログアウトされて、ログイン画面に戻る" do
      # ログインする
      user = create(:user)
      profile = create(:profile, user_id: user.id)
      sign_in_as user
      # ヘッダーの「ログアウト」をクリックする
      click_on 'ログアウト'
      # ログアウトしてログイン画面へ遷移する
      expect(current_url).to include '/users/sign_in'
      # ログインボタンがあることを確認する
      expect(page).to have_button 'ログイン'
    end
  end

  describe "ユーザ編集" do
    context "編集できるとき" do
      it "正しく情報を入力すれば、更新できて、マイページに遷移する" do
        # ログインする
        user = create(:user)
        profile = create(:profile, user_id: user.id)
        sign_in_as user
        # 「編集する」をクリックしてユーザ編集ページへ遷移する
        click_link '編集する'
        # ユーザ情報が入力されていることを確認する
        expect(page).to have_field 'user_name', with: user.name
        users_occupation = Occupation.find(user.profile.occupation_id)
        expect(page).to have_select 'user_profile_attributes_occupation_id', selected: users_occupation.name
        expect(page).to have_field 'user_profile_attributes_text', with: user.profile.text
        # フォームに入力して「変更する」をクリックしてマイページへ遷移する
        revised_word = 'なまえを修正'
        fill_in 'user_name', with: revised_word
        click_on '変更する'
        # 入力した文字列が表示されていることを確認する
        expect(current_url).to include "/users/#{user.id}"
        expect(page).to have_content revised_word
      end
    end
    context "編集できないとき" do
      it "情報が正しくなければ、更新できず、編集画面に戻る" do
        # ログインする
        user = create(:user)
        profile = create(:profile, user_id: user.id)
        sign_in_as user
        # なまえを空にして「編集する」をクリックする
        click_link '編集する'
        find('#user_name').set ''
        click_on '変更する'
        # ページ遷移せずに、編集ページにとどまる
        expect(page).to have_content 'なまえを入力してください'
        # field_with_errorsがあることを確認する
        expect(page).to have_css '.field_with_errors'
      end
    end
  end
end
