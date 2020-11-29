require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  include LoginSupport

  describe "タスク投稿機能" do
    before "ユーザ設定とログイン" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      sign_in_as @user
    end

    context "タスクを投稿できるとき" do
      it "タイトルを入力すれば、タスクを保存できて、マイページに表示される" do
        task_title = 'タスクのタイトル'
        fill_in 'task_title', with: task_title
        expect {
          click_on '登録'
          expect(page).to have_content task_title
        }.to change { Task.count }.by(1)
      end
    end
    context "タスクを投稿できないとき" do
      it "タイトルが入力されていないと、保存できずにマイページにリダイレクトされる" do
        # 入力せずにクリック
        expect {
          click_on '登録'
          expect(current_url).to include "/users/#{@user.id}"
        }.to change { Task.count }.by(0)
      end
      it "リダイレクトされたあと、タイトルを入力すれば保存できる" do
        click_on '登録'
        expect(current_url).to include "/users/#{@user.id}"

        task_title = 'タスクのタイトル'
        fill_in 'task_title', with: task_title
        expect {
          click_on '登録'
          expect(page).to have_content task_title
        }.to change { Task.count }.by(1)
      end
    end
  end

end
