require "test_helper"

class Admin::Users::TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_users_transactions_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_users_transactions_show_url
    assert_response :success
  end
end
