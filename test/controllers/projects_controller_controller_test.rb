require 'test_helper'

class ProjectsControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get projects_controller_index_url
    assert_response :success
  end

end
