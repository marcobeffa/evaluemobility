require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get intro" do
    get pages_intro_url
    assert_response :success
  end

  test "should get instruction" do
    get pages_instruction_url
    assert_response :success
  end

  test "should get start" do
    get pages_start_url
    assert_response :success
  end

  test "should get help" do
    get pages_help_url
    assert_response :success
  end

  test "should get about" do
    get pages_about_url
    assert_response :success
  end

  test "should get professionisti" do
    get pages_professionisti_url
    assert_response :success
  end

  test "should get privacy" do
    get pages_privacy_url
    assert_response :success
  end

  test "should get terms" do
    get pages_terms_url
    assert_response :success
  end

  test "should get contact" do
    get pages_contact_url
    assert_response :success
  end
end
