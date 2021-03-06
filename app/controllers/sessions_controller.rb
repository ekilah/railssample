class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        # login
        log_in user
        #remember the user if they wanted us to on this computer
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # redirect to logged-in user's page
        use_pre_login_redirect user_url(user)
      else
        flash[:warning] = "Account not activated. Please check your email for the activation link."
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
