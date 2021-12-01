require "test_helper"

class UserTest < ActiveSupport::TestCase
    test "Should not save if the user is blank" do
      assert_equal User.new.save, false
  end
  test "Should save if user is full" do
    @user = users(:rik)
    assert_equal @user.save, true
  end 
  test "should save and subscribe" do 
    @user = users(:rik)
    assert_equal @user.save_and_subscribe, true
  end 
  test "should save and subscribe with invalid plan" do 
    @user = users(:rik)
    @user.subscription_plan = "fakeplan"
    assert_equal @user.save_and_subscribe, false
  end 
end
