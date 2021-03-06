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
        fill_in 'taskTitle', with: task_title
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
        fill_in 'taskTitle', with: task_title
        expect {
          click_on '登録'
          expect(page).to have_content task_title
        }.to change { Task.count }.by(1)
      end
    end
  end

  describe "タスクを完了にする" do
    before "ユーザ設定とログイン" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      sign_in_as @user
    end

    it "完了ボタンをクリックすると、タスクが完了になり、マイページに表示されなくなる" do
      task_title = 'タスクのタイトル'
      fill_in 'taskTitle', with: task_title
      click_on '登録'
      expect(page).to have_content task_title
      # 完了ボタンを押すと、そのタスクは表示されなくなり、stateカラムがtrueになる
      click_on '完了!!'
      expect(page).to_not have_content task_title
      task = Task.find_by(title: 'タスクのタイトル')
      expect(task.state).to eq true
    end
  end

  describe "タスクを編集する" do
    before "ログインし、タスク投稿する" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      sign_in_as @user

      # タスクを投稿
      @task_title = 'タスクのタイトル'
      fill_in 'taskTitle', with: @task_title
      click_on '登録'
      sleep 1
      @task = Task.find_by(title: @task_title)
    end

    context "タスクを編集できるとき" do
      it "タイトルを入力すれば、タスクを保存できてマイページに遷移し、タスクがマイページに表示される" do
        # 編集ページヘ遷移する
        click_link '編集', href: "/users/#{@user.id}/tasks/#{@task.id}/edit"
        expect(current_url).to include "/tasks/#{@task.id}/edit"
        revised_task_title = '編集後のタイトル'
        fill_in 'taskTitle', with: revised_task_title
        click_on '登録'
        # マイページに遷移し、投稿したタスクがあることを確認する
        expect(page).to have_content revised_task_title
      end
    end

    context "タスクを編集できないとき" do
      it "タイトルが入力されていないと、保存できずに編集画面に戻る" do
        # 編集ページへ遷移
        click_link '編集', href: "/users/#{@user.id}/tasks/#{@task.id}/edit"
        expect(current_url).to include "/tasks/#{@task.id}/edit"
        find('#taskTitle').set ''
        click_on '登録'
        # 保存されず、編集ページに戻ることを確認する
        expect(current_url).to include "/tasks/#{@task.id}"
        # レコードが更新されていないことを確認する
        expect(@task.title).to eq @task_title
      end
    end
  end

  describe "タスクを削除する" do
    before "ログインし、タスク投稿する" do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      sign_in_as @user

      # タスクを投稿
      @task_title = 'タスクのタイトル'
      fill_in 'taskTitle', with: @task_title
      click_on '登録'
      @task = Task.find_by(title: @task_title)
    end

    it "削除ボタンをクリックするとタスクが削除され、マイページに表示されなくなる" do
      # 削除ボタンクリックで、Taskのレコードが1減ることを確認
      sleep 1
      expect {
        # 削除ボタンをクリック
        find('.delete-btn').click
      }.to change { Task.count }.by(-1)
    end
  end

  describe "タスクの一覧表示" do
    before do
      @user = create(:user)
      user_profile = create(:profile, user_id: @user.id)
      @user_task = create(:not_completed_task, user_id: @user.id, title: "@userのタスク")
      sign_in_as @user

      # @userがフォローしたユーザ
      @followed_user = create(:user)
      followed_profile = create(:profile, user_id: @followed_user.id)
      Relationship.create(following_id: @user.id, follower_id: @followed_user.id)
      @followed_user_task = create(:not_completed_task, user_id: @followed_user.id, title: "@followed_userのタスク")
    end
    it "「マイタスク」ナビゲーションでは、投稿フォームと自分が登録したタスクが表示される" do
      expect(current_url).to include "/users/#{@user.id}"
      # 投稿フォーム(投稿ボタン)があることを確認
      expect(page).to have_css '.task-submit'

      expect(page).to have_content @user_task.title
      expect(page).to_not have_content @followed_user_task.title
    end

    it "「仲間のタスク」ナビゲーションでは、フォローしたユーザのタスクが表示される" do
      visit "/users/#{@user.id}/follow_tasks"
      # 投稿フォーム(投稿ボタン)が無いことを確認
      expect(page).to_not have_css '.task-submit'

      expect(page).to have_content @followed_user_task.title
      expect(page).to_not have_content @user_task.title
    end
  end
end
