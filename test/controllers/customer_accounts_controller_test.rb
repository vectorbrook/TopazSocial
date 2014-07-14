require 'test_helper'

class CustomerAccountsControllerTest < ActionController::TestCase
  setup do
    @customer_account = customer_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_account" do
    assert_difference('CustomerAccount.count') do
      post :create, customer_account: { ac_type: @customer_account.ac_type, description: @customer_account.description, name: @customer_account.name }
    end

    assert_redirected_to customer_account_path(assigns(:customer_account))
  end

  test "should show customer_account" do
    get :show, id: @customer_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer_account
    assert_response :success
  end

  test "should update customer_account" do
    patch :update, id: @customer_account, customer_account: { ac_type: @customer_account.ac_type, description: @customer_account.description, name: @customer_account.name }
    assert_redirected_to customer_account_path(assigns(:customer_account))
  end

  test "should destroy customer_account" do
    assert_difference('CustomerAccount.count', -1) do
      delete :destroy, id: @customer_account
    end

    assert_redirected_to customer_accounts_path
  end
end
