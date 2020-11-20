require 'rails_helper'

RSpec.describe User, type: :model do
  describe "新規登録のバリデーション" do
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
end
