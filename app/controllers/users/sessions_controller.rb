# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # ログイン後にマイページに遷移する
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  # ログアウト後にログイン画面に遷移する
  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  # ゲストユーザーログイン
  def guest_sign_in
    user = User.guest
    # プロフィール登録
    profile = user.build_profile(occupation_id: 1, text: "ゲストユーザーです。よろしくお願いします", user_id: user.id)
    profile.image.attach(io: File.open('app/assets/images/default_user_image.png'), filename: 'default_user_image.png')
    profile.save

    sign_in(user)
    redirect_to '/'
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
