require 'rails_helper'

RSpec.describe Question, type: :model do
  before do
    @question = build(:question)
  end

  context "questionを保存できる場合" do
    it "title、content、state、imageが正しく入力されていれば保存できる" do
      expect(@question).to be_valid
    end
    it "imageが無くても保存できる" do
      @question.image = nil
      expect(@question).to be_valid
    end
  end

  context "questionを保存できない場合" do
    it "titleが無いと保存できない" do
      @question.title = nil
      @question.valid?
      expect(@question.errors[:title]).to include("を入力してください")
    end
    it "contentが無いと保存できない" do
      @question.content = nil
      @question.valid?
      expect(@question.errors[:content]).to include("を入力してください")
    end
    it "statetが無いと保存できない" do
      @question.state = nil
      @question.valid?
      expect(@question.errors[:state]).to include("は一覧にありません")
    end
    it "userが紐付いていないと保存できない" do
      @question.user = nil
      @question.valid?
      expect(@question.errors[:user]).to include("を入力してください")
    end
    it "communityが紐付いていないと保存できない" do
      @question.community = nil
      @question.valid?
      expect(@question.errors[:community]).to include("を入力してください")
    end
  end
end
