require 'test_helper'
require 'helpers/model_helper'

class FulfillmentTest < ActiveSupport::TestCase
  include ModelHelper

  fixtures :users, :requests, :responses

  setup do
    # Generate random values meeting validation criteria
    @valid = build_valid_fields

    # Generate random values representing edge cases
    @invalid = build_invalid_fields

    # Create reusable valid model for isolation in edge cases
    @valid_model = sample_valid_model

    # Turn off observers subscribed by the model
    Wisper.clear

  end


  test 'is valid' do
    model = @valid_model
    assert model.valid?
  end

  test 'is invalid unless USER valid' do
    standard_validation :user
  end

  test 'is invalid unless REQUEST valid' do
    standard_validation :request
  end

  test 'is invalid unless RESPONSE valid' do
    standard_validation :response
  end

  private

  def build_valid_fields
    {
      user: [users(:one), users(:two)],
      request: [requests(:one), requests(:two)],
      response: [responses(:one), responses(:two)],
    }
  end

  def build_invalid_fields
    {
      user: [
          nil,
      ],
      request: [
          nil,
      ],
      response: [
          nil,
      ],
    }
  end

  def sample_valid_model
    Fulfillment.new(
      user: @valid[:user][rand(@valid[:user].length)],
      request: @valid[:request][rand(@valid[:request].length)],
      response: @valid[:response][rand(@valid[:response].length)],
    )
  end

end