require 'test_helper'

class KinmuControllerTest < ActionController::TestCase
  test "should get input" do
    get :input
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
