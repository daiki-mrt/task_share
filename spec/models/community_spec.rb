require 'rails_helper'

RSpec.describe Community, type: :model do
  before do
    @community = build(:community)
  end

  context "communityを保存できる場合" do
    it "name、text、categoryが正しく入力されていれば登録できる" do
      expect(@community).to be_valid
    end
    it "categoryがなくても保存できる" do
      @community.category_id = nil
      expect(@community).to be_valid
    end
  end

  context "communityを保存できない場合" do
    it "nameが無いと保存できない" do
      @community.name = nil
      @community.valid?
      expect(@community.errors[:name]).to include("を入力してください")
    end
    it "textが無いと保存できない" do
      @community.text = nil
      @community.valid?
      expect(@community.errors[:text]).to include("を入力してください")
    end
    it "userが紐付いていないと保存できない" do
      @community.user = nil
      @community.valid?
      expect(@community.errors[:user]).to include("を入力してください")
    end
  end
end
