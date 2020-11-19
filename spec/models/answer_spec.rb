require 'rails_helper'

RSpec.describe Answer, type: :model do
  before do
    @answer = build(:answer)
  end

  context "回答を保存できる場合" do
    it "textが正しく入力されていれば保存できる" do
      expect(@answer).to be_valid
    end
  end
  context "回答を保存できない場合" do
    it "textが無いと保存できない" do
      @answer.text = nil
      @answer.valid?
      expect(@answer.errors[:text]).to include("を入力してください")
    end
    it "userが紐付いていないと保存できない" do
      @answer.user = nil
      @answer.valid?
      expect(@answer.errors[:user]).to include("を入力してください")
    end
    it "questionが紐付いていないと保存できない" do
      @answer.question = nil
      @answer.valid?
      expect(@answer.errors[:question]).to include("を入力してください")
    end
  end
end
