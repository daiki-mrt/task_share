require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "メッセージの保存" do
    before do
      @message = build(:message)
    end

    it "テキストがあれば保存できる" do
      expect(@message).to be_valid
    end
    it "テキストが無いと保存できない" do
      @message.text = nil
      @message.valid?
      binding.pry
      expect(@message.errors[:text]).to include("を入力してください")
    end
    it "userが紐付いていないと保存できない" do
      @message.user = nil
      @message.valid?
      expect(@message.errors[:user]).to include("を入力してください")
    end
    it "roomが紐付いていないと保存できない" do
      @message.room = nil
      @message.valid?
      expect(@message.errors[:room]).to include("を入力してください")
    end
  end
end
