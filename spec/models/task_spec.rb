require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @task = build(:task)
  end

  describe "taskの保存" do
    context "taskを保存できる場合" do
      it "title、text、stateがあれば保存できる" do
        expect(@task).to be_valid
      end
      it "textが無くても保存できる" do
        @task.text = nil
        expect(@task).to be_valid
      end
    end
    context "taskを保存できない場合" do
      it "titleが無いと保存できない" do
        @task.title = nil
        @task.valid?
        expect(@task.errors[:title]).to include("を入力してください")
      end
      it "stateが無いと保存できない" do
        @task.state = nil
        @task.valid?
        expect(@task.errors[:state]).to include("は一覧にありません")
      end
      it "userが紐付いていないと保存できない" do
        @task.user = nil
        @task.valid?
        expect(@task.errors[:user]).to include("を入力してください")
      end
    end
  end

  describe "特定のuserのtaskを取得" do
    before do
      @target_user = create(:user)
      @target_user_task1 = Task.create(user_id: @target_user.id, title: "タスクタイトル1", state: 0)
      @target_user_task2 = Task.create(user_id: @target_user.id, title: "タスクタイトル2", state: 0)
      @not_target_user = create(:user)
    end

    context "一致するデータが見つかるとき" do
      it "検索対象にしたuserが投稿したtaskを返す" do
        expect(Task.user_is(@target_user.id)).to include(@target_user_task1, @target_user_task2)
      end
    end
    context "一致するデータが1件も見つからないとき" do
      it "空のコレクションを返す" do
        expect(Task.user_is(@not_target_user.id)).to be_empty
      end
    end
  end

  describe "状態を指定してtaskを検索" do
    context "一致するデータが見つかるとき" do
      before do
        @completed_task1 = create(:completed_task)
        @completed_task2 = create(:completed_task)
        @not_completed_task1 = create(:not_completed_task)
        @not_completed_task2 = create(:not_completed_task)
      end

      it "完了状態のtaskを返す" do
        expect(Task.completed).to include(@completed_task1, @completed_task2)
      end
      it "未完了状態のtaskを返す" do
        expect(Task.not_completed).to include(@not_completed_task1, @not_completed_task2)
      end
    end

    context "一致するデータが1件も見つからないとき" do
      it "完了状態のtaskがなければ、空のコレクションを返す" do
        expect(Task.completed).to be_empty
      end
      it "未完了状態のtaskがなければ、空のコレクションを返す" do
        expect(Task.not_completed).to be_empty
      end
    end
  end
end
