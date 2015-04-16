class UsersController < ApplicationController
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


  private

    # filter the params object from the request and only get what we wanted
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
