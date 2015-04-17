require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Sign up | Ruby on Rails Tutorial Sample App"
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user.id #@user would work here, too... rails magic would access it's id for us (see next test)!
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect to root when trying to edit not self" do
    log_in_as @user
    get :edit, id: @other_user
    assert flash.empty?, "should not flash an error when editing not self"
    assert_redirected_to root_url
  end

  test "should redirect to root when trying to update not self" do
    log_in_as @user
    get :update, id: @other_user, user: {name: @other_user.name, email: @other_user.email}
    assert flash.empty?,
    assert_redirected_to(root_url, "should redirect to root and not succeed in update when updating not self")
  end

  test "should redirect non-logged-in users away from users index to login page" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

end
