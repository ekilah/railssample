require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # from test/fixtures/users.yml
  end

  test "bad edit should not work" do
    log_in_as @user
    get edit_user_path @user
    assert_template "users/edit"
    assert_no_difference "@user.email.length", "email should not change" do
      patch user_path @user, user: { name:  "",
                                    email: "user@bad",
                                    password:              "foo",
                                    password_confirmation: "bar" }
      assert_template 'users/edit', "should stay on edit page after bad edit"
      assert_select "#error_explanation", 1, "should have visible errors after bad edit"
    end
  end


  test "good edit should work with only name change, testing friendly forwarding" do
    get edit_user_path @user
    log_in_as @user
    assert_redirected_to edit_user_path(@user), "friendly forwarding post login should bring user back to edit page"
    follow_redirect!
    assert_template "users/edit"
    newname = "monroe"
    assert_no_difference "@user.email.length", "email should not change" do
      patch user_path @user, user: { name:  newname,
                                     email: @user.email,
                                     password:              "",
                                     password_confirmation: "" }
      assert_not flash.empty?, "flash should confirm successful change"
      assert_redirected_to @user
      @user.reload
    end
    assert @user.name == newname
  end

end
