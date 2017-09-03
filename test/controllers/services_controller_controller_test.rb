require 'test_helper'

class ServicesControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get services_controller_new_url
    assert_response :success
  end

  test "should get create" do
    get services_controller_create_url
    assert_response :success
  end

end
