require 'rails_helper'

RSpec.describe Community, type: :model do  
  describe "communityの登録" do
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

  describe "communityの検索" do
    before do
      @community = create(:community)
      @community_category2 = create(:community_category2)
      @community_category3 = create(:community_category3)
      @community_with_other_name = create(:community_with_other_name)
      @community_with_other_introduction = create(:community_with_other_introduction)
    end

    # scope :text_like, :text_like
    describe "文字列に一致するcommunityを検索する" do
      context "一致するデータが見つかるとき" do
        it "検索文字列に一致する名前を持つcommunityを返すこと" do
          expect(Community.text_like("name")).to include(@community_with_other_name)
        end
        it "検索文字列に一致する紹介文を持つcommunityを返すこと" do
          expect(Community.text_like("introduction")).to include(@community_with_other_introduction)
        end
      end
      context "一致するデータが1件も見つからないとき" do
        it "検索文字列に一致する名前が含まれていなければ、空のコレクションを返すこと" do
          expect(Community.text_like("Apple")).to be_empty
        end
        it "検索文字列に一致する紹介文が含まれていなければ、空のコレクションを返すこと" do
          expect(Community.text_like("iPhone")).to be_empty
        end
      end
    end

    # scope :category_is
    describe "カテゴリーに一致するcommunityを検索する" do
      context "一致するデータが見つかるとき" do
        it "検索カテゴリーが一致するcommunityを返すこと" do
          expect(Community.category_is(1)).to include(@community, @community_with_other_introduction)
        end
      end

      context "一致するデータが1件も見つからないとき" do
        it "空のコレクションを返すこと" do
          expect(Community.category_is(99)).to be_empty
        end
      end
    end

    # scope :search
    describe "文字列とカテゴリーに一致するcommunityを検索する" do
      context "一致するデータが見つかるとき" do
        it "検索文字列(名前)と検索カテゴリーが一致するcommunityを返すこと" do
          search_params = { text: "name", category_id: 1 }
          expect(Community.search(search_params)).to include(@community_with_other_name)
        end
        it "検索文字列(紹介文)と検索カテゴリーが一致するcommunityを返すこと" do
          search_params = { text: "introduction", category_id: 1 }
          expect(Community.search(search_params)).to include(@community_with_other_introduction)
        end
      end

      context "一致するデータが1件も見つからないとき" do
        it "名前が一致しなければ空のコレクションを返すこと" do
          search_params = { text: "Apple" }
          expect(Community.search(search_params)).to be_empty
        end
        it "紹介文が一致しなければ空のコレクションを返すこと" do
          search_params = { text: "iPhone" }
          expect(Community.search(search_params)).to be_empty
        end
        it "カテゴリーが一致しなければ空のコレクションを返すこと" do
          search_params = { category_id: 99 }
          expect(Community.search(search_params)).to be_empty
        end
      end
    end
  end
end
