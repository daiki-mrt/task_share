module LoginSupport
  def sign_in_as(user)
    # ルートパスへ移動する
    visit "/"
    # フォームに正しい情報を入力する
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    # 「ログイン」をクリック
    click_on 'ログイン'
  end
end
