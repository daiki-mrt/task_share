require 'rails_helper'

RSpec.describe 'Likes', type: :system do
  include LoginSupport

  describe "タスクにいいねする" do
    before "ログインし、タスクを投稿する" do
      # ログイン
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      sign_in_as @user

      # タスクを投稿
      @task_title = 'タスクのタイトル'
      fill_in 'task_title', with: @task_title
      click_on '登録'
      @task = Task.find_by(title: @task_title)
    end

    it "いいねボタンを押すと、いいねが保存されていいね済みのアイコンに変わる" do
      expect {
        find('.like-btn').click
        expect(page).to have_css '.unlike-btn'
      }.to change { Like.count }.by(1)
    end
    
    it "いいねボタンを押すと、いいねを解除して、いいね前のアイコンに変わる" do
      # いいねを押す
      find('.like-btn').click
      # Ajaxが反映されるまで待つ処理
      sleep 0.5
      # いいねを解除する
      expect {
        find('.unlike-btn').click
        expect(page).to have_css '.like-btn'
        # Ajaxが反映されるまで待つ処理
        sleep 0.5
      }.to change { Like.count }.by(-1)
    end
  end
end
