require 'test_helper'
require 'helpers/model_helper'

class MessageTest < ActiveSupport::TestCase
  include ModelHelper

  fixtures :users

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

  test 'is invalid unless SUBJECT valid' do
    standard_validation :subject
  end

  test 'is invalid unless BODY valid' do
    standard_validation :body
  end

  private

  def build_valid_fields
    {
      user: [users(:one), users(:two)],
      subject: [string_of_max(255)],
      body: [string_of_max(500)],
    }
  end

  def build_invalid_fields
    {
      user: [
          nil,
      ],
      subject: [
          nil,
          string_of(256)
      ],
      body: [
          nil,
          string_of(501)
      ],
    }
  end

  def sample_valid_model
    Message.new(
      user: @valid[:user][rand(@valid[:user].length)],
      subject: @valid[:subject][rand(@valid[:subject].length)],
      body: @valid[:body][rand(@valid[:body].length)],
    )
  end

end