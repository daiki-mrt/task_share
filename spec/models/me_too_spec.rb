require 'rails_helper'

RSpec.describe MeToo, type: :model do
  before do
    @user = create(:user)
    @question = create(:question)
    @me_too = MeToo.new(user_id: @user.id, question_id: @question.id)
  end

  context "保存できる場合" do
    it "user_idとtask_idがあれば保存できる" do
      expect(@me_too).to be_valid
    end
  end
  context "保存できない場合" do
    it "user_idが無いと保存できない" do
      @me_too.user = nil
      @me_too.valid?
      expect(@me_too.errors[:user]).to include("を入力してください")
    end
    it "question_idが無いと保存できない" do
      @me_too.question = nil
      @me_too.valid?
      expect(@me_too.errors[:question]).to include("を入力してください")
    end
    it "userは同じ質問に複数回知りたい!できない" do
      @me_too.save
      another_me_too = MeToo.new(user_id: @me_too.user.id, question_id: @me_too.question.id)
      another_me_too.valid?
      expect(another_me_too.errors[:question_id]).to include("はすでに存在します")
    end
  end
end
