require 'test_helper'
require 'helpers/model_helper'

class MessageDispatchTest < ActiveSupport::TestCase
  include ModelHelper

  fixtures :users, :messages

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

  test 'is invalid unless MESSAGE valid' do
    standard_validation :message
  end

  test 'is invalid unless IS_READ valid' do
    standard_validation :is_read
  end

  private

  def build_valid_fields
    {
      user: [users(:one), users(:two)],
      message: [messages(:one), messages(:two)],
      is_read: [true, false],
    }
  end

  def build_invalid_fields
    {
      user: [
          nil,
      ],
      message: [
          nil,
      ],
      is_read: [
          nil,
      ],
    }
  end

  def sample_valid_model
    MessageDispatch.new(
      user: @valid[:user][rand(@valid[:user].length)],
      message: @valid[:message][rand(@valid[:message].length)],
      is_read: @valid[:is_read][rand(@valid[:is_read].length)],
    )
  end

end