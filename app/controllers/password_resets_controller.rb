class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    email = params[:password_reset][:email]
    @user = User.find_by(email: email)
    if @user
      @user.create_password_reset_digest
      @user.send_password_reset_email
    end

    flash[:info] = "A password reset email was sent to the Sample App user with email address #{email}"
    redirect_to root_url
  end

  def edit

  end

  def update
    if password_blank?
      flash.now[:danger] = "New password can't be blank."
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password reset!"
      redirect_to @user
    else
      render 'edit' #show errors
    end
  end

  private
    def get_user
      @user = User.find_by email: params[:email]
    end

    def valid_user
      redirect_to root_url unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset link has expired. Please try again."
        redirect_to new_password_reset_url
      end
    end

    def password_blank?
      params[:user][:password].blank?
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
