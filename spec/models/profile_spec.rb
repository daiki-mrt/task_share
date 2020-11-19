require 'rails_helper'

RSpec.describe Profile, type: :model do
  before do
    @profile = build(:profile)
  end

  context "プロフィールが保存できる場合" do  
    it "職種、テキスト、画像を入力すると保存できる" do
      expect(@profile).to be_valid
    end
    it "職種が空でも保存できる" do
      @profile.occupation_id = nil
      expect(@profile).to be_valid
    end
    it "テキストが空でも保存できる" do
      @profile.text = nil
      expect(@profile).to be_valid
    end
    it "画像が空でも保存できる" do
      @profile.image = nil
      expect(@profile).to be_valid
    end
  end
  
  context "プロフィールが保存できない場合" do
    it "ユーザが紐付いていないと保存できない" do
      @profile.user = nil
      @profile.valid?
      expect(@profile.errors[:user]).to include("を入力してください")
    end
  end
end
