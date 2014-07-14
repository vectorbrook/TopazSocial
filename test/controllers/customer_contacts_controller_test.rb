require 'test_helper'

class CustomerContactsControllerTest < ActionController::TestCase
  setup do
    @customer_contact = customer_contacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_contact" do
    assert_difference('CustomerContact.count') do
      post :create, customer_contact: { bill_to: @customer_contact.bill_to, email_addr: @customer_contact.email_addr, fax_number: @customer_contact.fax_number, first_name: @customer_contact.first_name, last_name: @customer_contact.last_name, phone_number1: @customer_contact.phone_number1, phone_number2: @customer_contact.phone_number2, phone_number3: @customer_contact.phone_number3, sell_to: @customer_contact.sell_to, ship_to: @customer_contact.ship_to, user_id: @customer_contact.user_id }
    end

    assert_redirected_to customer_contact_path(assigns(:customer_contact))
  end

  test "should show customer_contact" do
    get :show, id: @customer_contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer_contact
    assert_response :success
  end

  test "should update customer_contact" do
    patch :update, id: @customer_contact, customer_contact: { bill_to: @customer_contact.bill_to, email_addr: @customer_contact.email_addr, fax_number: @customer_contact.fax_number, first_name: @customer_contact.first_name, last_name: @customer_contact.last_name, phone_number1: @customer_contact.phone_number1, phone_number2: @customer_contact.phone_number2, phone_number3: @customer_contact.phone_number3, sell_to: @customer_contact.sell_to, ship_to: @customer_contact.ship_to, user_id: @customer_contact.user_id }
    assert_redirected_to customer_contact_path(assigns(:customer_contact))
  end

  test "should destroy customer_contact" do
    assert_difference('CustomerContact.count', -1) do
      delete :destroy, id: @customer_contact
    end

    assert_redirected_to customer_contacts_path
  end
end
