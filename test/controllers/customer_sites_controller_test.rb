require 'test_helper'

class CustomerSitesControllerTest < ActionController::TestCase
  setup do
    @customer_site = customer_sites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_site" do
    assert_difference('CustomerSite.count') do
      post :create, customer_site: { address_line1: @customer_site.address_line1, address_line2: @customer_site.address_line2, city: @customer_site.city, country: @customer_site.country, customer_account_id: @customer_site.customer_account_id, description: @customer_site.description, name: @customer_site.name, state: @customer_site.state, zipcode: @customer_site.zipcode }
    end

    assert_redirected_to customer_site_path(assigns(:customer_site))
  end

  test "should show customer_site" do
    get :show, id: @customer_site
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer_site
    assert_response :success
  end

  test "should update customer_site" do
    patch :update, id: @customer_site, customer_site: { address_line1: @customer_site.address_line1, address_line2: @customer_site.address_line2, city: @customer_site.city, country: @customer_site.country, customer_account_id: @customer_site.customer_account_id, description: @customer_site.description, name: @customer_site.name, state: @customer_site.state, zipcode: @customer_site.zipcode }
    assert_redirected_to customer_site_path(assigns(:customer_site))
  end

  test "should destroy customer_site" do
    assert_difference('CustomerSite.count', -1) do
      delete :destroy, id: @customer_site
    end

    assert_redirected_to customer_sites_path
  end
end
