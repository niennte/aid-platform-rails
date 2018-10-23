require 'test_helper'

class MessageDispatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @message_dispatch = message_dispatches(:one)
  end

  test "should get index" do
    get message_dispatches_url, as: :json
    assert_response :success
  end

  test "should create message_dispatch" do
    assert_difference('MessageDispatch.count') do
      post message_dispatches_url, params: { message_dispatch: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show message_dispatch" do
    get message_dispatch_url(@message_dispatch), as: :json
    assert_response :success
  end

  test "should update message_dispatch" do
    patch message_dispatch_url(@message_dispatch), params: { message_dispatch: {  } }, as: :json
    assert_response 200
  end

  test "should destroy message_dispatch" do
    assert_difference('MessageDispatch.count', -1) do
      delete message_dispatch_url(@message_dispatch), as: :json
    end

    assert_response 204
  end
end
