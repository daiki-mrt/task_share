require 'rails_helper'

RSpec.describe Profile, type: :model do
  before do
    @profile = build(:profile)
  end

  describe "profileの登録" do
    context "profileが保存できる場合" do
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

    context "profileが保存できない場合" do
      it "ユーザが紐付いていないと保存できない" do
        @profile.user = nil
        @profile.valid?
        expect(@profile.errors[:user]).to include("を入力してください")
      end
    end
  end

  describe "profileの検索" do
    context "一致するデータが見つかるとき" do
      before do
        @profile_with_occupation1 = create(:profile_with_occupation1)
        @profile_with_occupation2 = create(:profile_with_occupation2)
        @profile_with_other_introduction = create(:profile_with_other_introduction)
      end

      it "選択occupationが一致するprofileを返すこと" do
        expect(Profile.occupation_is(1)).to include(@profile_with_occupation1, @profile_with_other_introduction)
      end
      it "検索文字列が一致する紹介文を持つprofileを返すこと" do
        expect(Profile.text_like("introduction")).to include(@profile_with_other_introduction)
      end
    end

    context "一致するデータが1件も見つからないとき" do
      it "選択occupationが一致しなければ空のコレクションを返すこと" do
        expect(Profile.occupation_is(99)).to be_empty
      end
      it "検索文字列が一致しなければ空のコレクションを返すこと" do
        expect(Profile.text_like("イントロダクション")).to be_empty
      end
    end
  end
end
