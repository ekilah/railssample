class AccountActivationsController < ApplicationController

  def edit
    email = params[:email]
    activation_token = params[:id]
    user = User.find_by(email: email)

    if user && !user.activated? && user.authenticated?(:activation, activation_token)
      user.activate
      log_in user
      flash[:success] = "Your account has been activated!"
      redirect_to user
    else
      flash[:danger] = (user && user.activated?) ? "Your account has already been activated." : "Invalid activation link. Please try again."
      redirect_to (user && user.activated?) ? user : root_url
    end
  end
end
