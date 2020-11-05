# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  def new
    @user = User.new
    @profile = @user.build_profile
  end

  def create
    @user = User.new(sign_up_params)
    @profile = @user.build_profile(sign_up_params[:profile_attributes])
    if @user.valid?
      @user.save
      @profile.save
      sign_in(:user, @user)
      redirect_to root_path
    else
      render action: :new
    end
  end

  def edit
    @user = current_user
    @profile = @user.profile
  end

  def update
    @user = User.find(current_user.id)
    @profile = @user.profile
    if @user.update(account_update_params)
      @user.profile.update(account_update_params[:profile_attributes])
      sign_in(:user, @user)
      redirect_to root_path
    else
      render action: :edit
    end    
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
