require 'test_helper'

class FulfillmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fulfillment = fulfillments(:one)
  end

  test "should get index" do
    get fulfillments_url, as: :json
    assert_response :success
  end

  test "should create fulfillment" do
    assert_difference('Fulfillment.count') do
      post fulfillments_url, params: { fulfillment: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show fulfillment" do
    get fulfillment_url(@fulfillment), as: :json
    assert_response :success
  end

  test "should update fulfillment" do
    patch fulfillment_url(@fulfillment), params: { fulfillment: {  } }, as: :json
    assert_response 200
  end

  test "should destroy fulfillment" do
    assert_difference('Fulfillment.count', -1) do
      delete fulfillment_url(@fulfillment), as: :json
    end

    assert_response 204
  end
end
