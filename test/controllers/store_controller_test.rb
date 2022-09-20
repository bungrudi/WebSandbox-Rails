require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get items" do
    get store_items_url
    assert_response :success
  end
end
