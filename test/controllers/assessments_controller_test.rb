require "test_helper"

class AssessmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get assessments_new_url
    assert_response :success
  end

  test "should get create" do
    get assessments_create_url
    assert_response :success
  end

  test "should get show" do
    get assessments_show_url
    assert_response :success
  end

  test "should get result" do
    get assessments_result_url
    assert_response :success
  end
end
