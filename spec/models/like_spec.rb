require 'rails_helper'

RSpec.describe Like, type: :model do
  before do
    @user = create(:user)
    @task = create(:task)
    @like = Like.new(user_id: @user.id, task_id: @task.id)
  end

  context "いいね出来る場合" do
    it "user_idとtask_idがあれば保存できる" do
      expect(@like).to be_valid
    end
  end
  context "いいね出来ない場合" do
    it "user_idが空だと保存できない" do
      @like.user = nil
      @like.valid?
      expect(@like.errors[:user]).to include("を入力してください")
    end
    it "task_idが空だと保存できない" do
      @like.task = nil
      @like.valid?
      expect(@like.errors[:task]).to include("を入力してください")
    end
    it "userがすでにいいねしたtaskにはいいね出来ない" do
      @like.save
      another_like = Like.new(user_id: @user.id, task_id: @task.id)
      another_like.valid?
      expect(another_like.errors[:task_id]).to include("はすでに存在します")
    end
  end
end
