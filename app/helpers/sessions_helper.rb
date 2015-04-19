module SessionsHelper
  # stores a session cookie on the user's browser (encrypted) to track their logged-in status.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id # encryped id stored in cookie
    cookies.permanent[:remember_token] = user.remember_token
  end


  # Returns the current logged-in user (if any) from any cookies that exist. caches the db lookup for future use.
  def current_user
    if (user_id = session[:user_id]) # temporary cookie
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) # permanent cookie
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget current_user
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    return user === current_user
  end

  def save_pre_login_redirect
    session[:forwarding_url] = request.url if request.get?
  end

  def use_pre_login_redirect(default)
    redirect_url = session[:forwarding_url] || default
    session.delete(:forwarding_url)
    redirect_to redirect_url
  end
end
