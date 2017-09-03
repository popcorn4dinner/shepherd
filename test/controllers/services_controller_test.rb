require 'test_helper'

class ServicesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get services_new_url
    assert_response :success
  end

  test "should get create" do
    get services_create_url
    assert_response :success
  end

end
