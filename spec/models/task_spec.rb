require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @task = build(:task)
  end

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
