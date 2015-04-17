class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welome to the sample app, #{@user.name}!"
      redirect_to @user #same as redirect_to(user_url(@user))
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user && @user.update_attributes(user_params)
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      # error with new settings
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def destroy
    @user = User.find(params[:id])
    name = @user.name
    @user.destroy
    flash[:success] = "User '#{name}' deleted."
    redirect_to users_url
  end


  private

    # filter the params object from the request and only get what we wanted
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in before accessing that page."
        redirect_to login_url
        save_pre_login_redirect
      end
    end

    def correct_user
      user = User.find(params[:id])
      redirect_to root_url unless current_user?(user)
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
