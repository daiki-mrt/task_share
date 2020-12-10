require 'rails_helper'

RSpec.describe User, type: :model do
  describe "userの登録" do
    before do
      @user = build(:user)
    end

    it "なまえ、Eメール、パスワード、パスワード(確認)が正しく入力されていれば保存される" do
      expect(@user).to be_valid
    end
    it "なまえが入力されていないと保存できない" do
      @user.name = nil
      @user.valid?
      expect(@user.errors[:name]).to include("を入力してください")
    end
    it "Eメールが入力されていないと保存できない" do
      @user.email = nil
      @user.valid?
      expect(@user.errors[:email]).to include("を入力してください")
    end
    it "Eメールに@が含まれていないと保存できない" do
      @user.email = "address"
      @user.valid?
      expect(@user.errors[:email]).to include("は無効な値です")
    end
    it "すでに保存されているEメールは保存できない" do
      @user.save
      another_user = FactoryBot.build(:user)
      another_user.email = @user.email
      another_user.valid?
      expect(another_user.errors[:email]).to include("はすでに存在します")
    end
    it "パスワードが入力されていないと保存できない" do
      @user.password = nil
      @user.valid?
      expect(@user.errors[:password]).to include("を入力してください")
    end
    it "パスワードが数字のみだと保存できない" do
      @user.password = "123456"
      @user.valid?
      expect(@user.errors[:password]).to include("は半角英数字で入力してください")
    end
    it "パスワードが英字のみだと保存できない" do
      @user.password = "abcdef"
      @user.valid?
      expect(@user.errors[:password]).to include("は半角英数字で入力してください")
    end
    it "パスワードが6桁以下だと保存できない" do
      @user.password = "abc12"
      @user.valid?
      expect(@user.errors[:password]).to include("は6文字以上で入力してください")
    end
    it "パスワード(確認)がパスワードと一致しないと保存できない" do
      @user.password = "abc123"
      @user.password_confirmation = "abc1234"
      @user.valid?
      expect(@user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
    it "パスワード(確認)がパスワードと異なっていると保存できない" do
    end
  end

  describe "フォロー済みかどうか判定する" do
    before do
      @user_following = create(:user)
      @user_followed_by_user_following = create(:user)
      @user_not_followed_by = create(:user)
      Relationship.create(following_id: @user_following.id, follower_id: @user_followed_by_user_following.id)
    end

    context "フォロー済みのとき" do
      it "trueを返す" do
        expect(@user_followed_by_user_following.follow?(@user_following)).to be true
      end
    end
    context "フォローしていないとき" do
      it "falseを返す" do
        expect(@user_not_followed_by.follow?(@user_following)).to be false
      end
    end
  end

  describe "taskにいいねをしているか判定する" do
    before do
      @user = create(:user)
      @task_liked = create(:task)
      @task_not_liked = create(:task)
      Like.create(user_id: @user.id, task_id: @task_liked.id)
    end

    context "いいねしているとき" do
      it "trueを返す" do
        expect(@user.already_liked?(@task_liked)).to be true
      end
    end
    context "いいねしていないとき" do
      it "falseを返す" do
        expect(@user.already_liked?(@task_not_liked)).to be false
      end
    end
  end

  describe "対象のcommunityに参加しているかどうかを判定" do
    before do
      @user = create(:user)
      @community_joined = create(:community)
      @community_not_joined = create(:community)
      UserCommunity.create(user_id: @user.id, community_id: @community_joined.id)
    end

    context "参加しているとき" do
      it "trueを返す" do
        expect(@user.already_joined?(@community_joined)).to be true
      end
    end
    context "参加していないとき" do
      it "falseを返す" do
        expect(@user.already_joined?(@community_not_joined)).to be false
      end
    end
  end

  describe "対象のquestionに「知りたい！」しているかどうかを判定" do
    before do
      @user = create(:user)
      @question_me_too = create(:question)
      @question_not_me_too = create(:question)
      MeToo.create(user_id: @user.id, question_id: @question_me_too.id)
    end

    context "知りたい！しているとき" do
      it "trueを返す" do
        expect(@user.already_me_too?(@question_me_too)).to be true
      end
    end
    context "知りたい！していないとき" do
      it "falseを返す" do
        expect(@user.already_me_too?(@question_not_me_too)).to be false
      end
    end
  end

  describe "対象のquestionに「役に立った！」しているかどうかを判定" do
    before do
      @user = create(:user)
      @question_good = create(:question)
      @question_not_good = create(:question)
      Good.create(user_id: @user.id, question_id: @question_good.id)
    end

    context "役に立った！しているとき" do
      it "trueを返す" do
        expect(@user.already_good?(@question_good)).to be true
      end
    end
    context "役に立った！していないとき" do
      it "falseを返す" do
        expect(@user.already_good?(@question_not_good)).to be false
      end
    end
  end

  # scope :search
  # warningあり
  # (Class level methods will no longer inherit scoping from `search` in Rails 6.1.
  # To continue using the scoped relation, pass it into the block directly.
  # To instead access the full set of models, as Rails 6.1 will, use `User.default_scoped`.)
  describe "文字列とカテゴリーに一致するuserを検索する" do
    before do
      password = "abc123"
      password_confirmation = "abc123"
      @user_steve = User.create(name: "Steve", email: "steve@steve.com", password: password, password_confirmation: password_confirmation)
      @profile_steve = Profile.create(occupation_id: 1, text: "Apple", user_id: @user_steve.id)
      @user_bill = User.create(name: "Bill", email: "bill@bill.com", password: password, password_confirmation: password_confirmation)
      @profile_bill = Profile.create(occupation_id: 1, text: "Microsoft", user_id: @user_bill.id)
    end

    context "一致するデータが見つかるとき" do
      it "検索文字列が一致するuserを返すこと" do
        search_params = { text: "Steve" }
        expect(User.search(search_params)).to include(@user_steve)
      end
      it "検索文字列が一致するprofileを持つuserを返すこと" do
        search_params = { text: "Apple" }
        expect(User.search(search_params)).to include(@user_steve)
      end
      it "検索occupationが一致するprofileを持つuserを返すこと" do
        search_params = { occupation_id: 1 }
        expect(User.search(search_params)).to include(@user_steve, @user_bill)
      end
      it "検索文字列(name or text)と検索occupationが一致するuserを返すこと" do
        search_params = { text: "Steve", occupation_id: 1 }
        expect(User.search(search_params)).to include(@user_steve)
      end
    end

    context "一致するデータが1件も見つからないとき" do
      it "空のコレクションを返すこと" do
        search_params = { text: "Mask" }
        expect(User.search(search_params)).to be_empty
      end
    end
  end
end
