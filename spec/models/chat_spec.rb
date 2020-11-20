require 'rails_helper'

RSpec.describe Chat, type: :model do
  before do
    @chat = build(:chat)
  end

  context "chatを保存できる場合" do
    it "textが正しく入力されていれば保存できる" do
      expect(@chat).to be_valid
    end
  end

  context "chatを保存できない場合" do
    it "textが無いと保存できない" do
      @chat.text = nil
      @chat.valid?
      expect(@chat.errors[:text]).to include("を入力してください")
    end
    it "userが紐付いていないと登録できない" do
      @chat.user = nil
      @chat.valid?
      expect(@chat.errors[:user]).to include("を入力してください")
    end
    it "communityが紐付いていないと登録できない" do
      @chat.community = nil
      @chat.valid?
      expect(@chat.errors[:community]).to include("を入力してください")
    end
  end
end
