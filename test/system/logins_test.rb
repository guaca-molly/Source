require "application_system_test_case"

class LoginsTest < ApplicationSystemTestCase
   test "make sure the login page has the text" do 
      visit "/session/new"
      assert_selector "h1", text: "Log in"
   end 

end
