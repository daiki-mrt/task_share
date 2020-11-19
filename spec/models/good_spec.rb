require 'rails_helper'

RSpec.describe Good, type: :model do
  before do
    @user = create(:user)
    @question = create(:question)
    @good = Good.new(user_id: @user.id, question_id: @question.id)
  end

  context "保存できる場合" do
    it "user_idとquestion_idがあれば保存できる" do
      expect(@good).to be_valid
    end
  end
  context "保存できない場合" do
    it "user_idが無いと保存できない" do
      @good.user = nil
      @good.valid?
      expect(@good.errors[:user]).to include("を入力してください")
    end
    it "question_idが無いと保存できない" do
      @good.question = nil
      @good.valid?
      expect(@good.errors[:question]).to include("を入力してください")
    end
    it "userは同じ質問に複数回役に立った!できない" do
      @good.save
      another_good = Good.new(user_id: @good.user.id, question_id: @good.question.id)
      another_good.valid?
      expect(another_good.errors[:question_id]).to include("はすでに存在します")
    end
  end
end
